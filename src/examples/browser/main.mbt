// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The one function the page imports. `op` names the operation and `args` is a
/// JSON object; the answer is a JSON object with `ok` and either `value` or
/// `error`. Strings are the only thing that crosses the boundary, which keeps
/// the binding to one function however many methods grow behind it.
pub fn engine_call(op : String, args : String) -> String {
  let input = match read(args) {
    Some(json) => json
    None => return fail("args", "the arguments were not a JSON object")
  }
  match op {
    "compose" => compose(input)
    "parse" => parse(input)
    "jmap.session" => session(input)
    "jmap.request" => request(input)
    "jmap.read" => read_response(input)
    _ => fail("op", "there is no operation called " + op)
  }
}

///|
fn main {
  ()
}

///|
fn read(text : String) -> Json? {
  Some(@json.parse(text[:])) catch {
    _ => None
  }
}

///|
fn ok(value : Json) -> String {
  object([("ok", Json::boolean(true)), ("value", value)]).stringify()
}

///|
fn fail(kind : String, message : String) -> String {
  object([
    ("ok", Json::boolean(false)),
    (
      "error",
      object([("kind", Json::string(kind)), ("message", Json::string(message))]),
    ),
  ]).stringify()
}

///|
fn object(pairs : Array[(String, Json)]) -> Json {
  let map : Map[String, Json] = Map([])
  for pair in pairs {
    map[pair.0] = pair.1
  }
  Json::object(map)
}

///|
fn strings(values : Array[String]) -> Json {
  Json::array(values.map(fn(value) { Json::string(value) }))
}

///|
fn text(input : Json, name : String) -> String? {
  match input {
    Json::Object(map) =>
      match map.get(name) {
        Some(Json::String(value)) => Some(value)
        _ => None
      }
    _ => None
  }
}

///|
fn flag(input : Json, name : String) -> Bool {
  match input {
    Json::Object(map) =>
      match map.get(name) {
        Some(Json::True) => true
        _ => false
      }
    _ => false
  }
}

///|
fn field(input : Json, name : String) -> Json? {
  match input {
    Json::Object(map) => map.get(name)
    _ => None
  }
}

///|
fn list(input : Json, name : String) -> Array[String] {
  let out : Array[String] = []
  match input {
    Json::Object(map) =>
      match map.get(name) {
        Some(Json::Array(values)) =>
          for value in values {
            match value {
              Json::String(item) => out.push(item)
              _ => ()
            }
          }
        _ => ()
      }
    _ => ()
  }
  out
}

///|
fn int(input : Json, name : String, fallback : Int32) -> Int32 {
  match input {
    Json::Object(map) =>
      match map.get(name) {
        Some(Json::Number(value, ..)) => value.to_int()
        _ => fallback
      }
    _ => fallback
  }
}

///|
fn addresses(
  values : Array[String],
) -> Array[@moonmail.Address] raise @moonmail.Refused {
  let out : Array[@moonmail.Address] = []
  for value in values {
    out.push(@moonmail.parse_address(value[:]))
  }
  out
}

///|
/// Build a letter out of the fields the page holds. The message is written by
/// `Message::encode`, so the text is UTF-8 with the transfer encoding, the
/// boundaries and the folding that the library already decided on.
fn compose(input : Json) -> String {
  let from = text(input, "from").unwrap_or("")
  if from == "" {
    return fail("compose", "a letter needs a From address")
  }
  try {
    let sender = @moonmail.parse_address(from[:])
    let body_text = text(input, "text")
    let body_html = text(input, "html")
    // The card the reader picked travels with the letter: an inline part the
    // HTML body shows by `cid:`, so the photograph arrives as part of the
    // message rather than as a link that a client may refuse to load.
    let attachments : Array[@moonmail.Attachment] = []
    match field(input, "image") {
      Some(image) => {
        let carried = Some(@base64.decode(text(image, "data").unwrap_or(""))) catch {
          _ => None
        }
        match carried {
          Some(data) =>
            if data.length() > 0 {
              attachments.push(
                @moonmail.Attachment::new(
                  text(image, "name").unwrap_or("card.jpg"),
                  data,
                  media_type=text(image, "type").unwrap_or("image/jpeg"),
                  inline=true,
                  id=text(image, "cid").unwrap_or("card"),
                ),
              )
            }
          None => ()
        }
      }
      None => ()
    }
    // Files the page hands over: an inline picture shown by `cid:`, or a plain
    // attachment such as the Markdown the card could not hold.
    match field(input, "attachments") {
      Some(Json::Array(items)) =>
        for item in items {
          let bytes = Some(@base64.decode(text(item, "data").unwrap_or(""))) catch {
            _ => None
          }
          match bytes {
            Some(data) =>
              if data.length() > 0 {
                let name = text(item, "name").unwrap_or("attachment")
                let kind = text(item, "type").unwrap_or(
                  "application/octet-stream",
                )
                // `id` is what makes a part inline: give it one and the picture
                // is shown by `cid:`; leave it out and the file is an attachment.
                match text(item, "cid") {
                  Some(cid) =>
                    attachments.push(
                      @moonmail.Attachment::new(
                        name,
                        data,
                        media_type=kind,
                        inline=true,
                        id=cid,
                      ),
                    )
                  None =>
                    attachments.push(
                      @moonmail.Attachment::new(
                        name,
                        data,
                        media_type=kind,
                        inline=flag(item, "inline"),
                      ),
                    )
                }
              }
            None => ()
          }
        }
      _ => ()
    }
    let carried : Array[@moonmail.Attachment]? = if attachments.is_empty() {
      None
    } else {
      Some(attachments)
    }
    let message = @moonmail.Message::new(
      from=@moonmail.Address::mailboxes(sender)[0],
      to=addresses(list(input, "to")),
      cc=addresses(list(input, "cc")),
      subject=text(input, "subject").unwrap_or(""),
      text?=body_text,
      html?=body_html,
      attachments?=carried,
    )
    let bytes = message.encode()
    ok(
      object([
        ("message", Json::string(@utf8.decode_lossy(bytes[:]))),
        ("bytes", Json::number(bytes.length().to_double())),
      ]),
    )
  } catch {
    error => fail("compose", error.to_repr().to_string())
  }
}

///|
/// Read a raw message back into the fields a page shows, which is the other
/// half of what the library is for.
fn parse(input : Json) -> String {
  let raw = text(input, "raw").unwrap_or("")
  if raw == "" {
    return fail("parse", "there is nothing to parse")
  }
  try {
    let message = @moonmail.Message::parse(@utf8.encode(raw))
    let subject = message.subject().unwrap_or("")
    let text_body = match message.text() {
      Some(body) => body
      None => ""
    }
    ok(
      object([
        ("subject", Json::string(subject)),
        ("text", Json::string(text_body)),
        ("bytes", Json::number(@utf8.encode(raw).length().to_double())),
      ]),
    )
  } catch {
    error => fail("parse", error.to_repr().to_string())
  }
}

///|
/// `/.well-known/jmap`, read into the four things a client needs before it can
/// call anything.
fn session(input : Json) -> String {
  let base = text(input, "base").unwrap_or("")
  let body = text(input, "body").unwrap_or("")
  try {
    let found = @jmap.Session::parse(base, body)
    ok(
      object([
        ("apiUrl", Json::string(found.api_url)),
        ("accountId", Json::string(found.account_id)),
        ("username", Json::string(found.username.unwrap_or(""))),
        ("state", Json::string(found.state)),
      ]),
    )
  } catch {
    error => fail("jmap", error.to_repr().to_string())
  }
}

///|
/// Turn a named operation into the request document to post, plus the tag the
/// answer will come back under.
fn request(input : Json) -> String {
  let op = text(input, "op").unwrap_or("")
  let account = text(input, "account").unwrap_or("")
  if account == "" {
    return fail("account", "there is no account to call against")
  }
  let request = @jmap.Request::new()
  let tag = match op {
    "mailboxes" => request.mailbox_get(account)
    "identities" => request.identity_get(account)
    "query" =>
      request.email_query(
        account,
        text(input, "mailbox").unwrap_or(""),
        int(input, "limit", 20),
      )
    "get" =>
      request.email_get(account, list(input, "ids"), [
        "id", "subject", "from", "receivedAt", "preview", "keywords",
      ])
    "draft" => {
      let draft = @jmap.Draft::new(
        to=list(input, "to"),
        subject=text(input, "subject").unwrap_or(""),
        text=text(input, "text").unwrap_or(""),
      )
      request.email_set_draft(
        account,
        text(input, "mailbox").unwrap_or(""),
        draft,
      )
    }
    "submit" =>
      request.email_submission_set(
        account,
        text(input, "identity").unwrap_or(""),
        text(input, "emailId").unwrap_or(""),
      )
    _ => return fail("op", "there is no JMAP operation called " + op)
  }
  ok(
    object([
      ("tag", Json::string(tag)),
      ("body", Json::string(request.to_string())),
    ]),
  )
}

///|
/// Read an answer back into the shape the page draws: mailboxes, letters, ids,
/// identities, or the id of something just created.
fn read_response(input : Json) -> String {
  let op = text(input, "op").unwrap_or("")
  let tag = text(input, "tag").unwrap_or("")
  let body = text(input, "body").unwrap_or("")
  try {
    let response = @jmap.Response::parse(body)
    let value = match op {
      "mailboxes" => {
        let list = @jmap.mailboxes(response, tag)
        Json::array(
          list.map(fn(mailbox) {
            object([
              ("id", Json::string(mailbox.id)),
              ("name", Json::string(mailbox.name)),
              ("role", Json::string(mailbox.role.unwrap_or(""))),
              ("total", Json::number(mailbox.total.to_double())),
              ("unread", Json::number(mailbox.unread.to_double())),
            ])
          }),
        )
      }
      "identities" => {
        let list = @jmap.identities(response, tag)
        Json::array(
          list.map(fn(identity) {
            object([
              ("id", Json::string(identity.id)),
              ("name", Json::string(identity.name.unwrap_or(""))),
              ("email", Json::string(identity.email)),
            ])
          }),
        )
      }
      "query" => strings(@jmap.email_ids(response, tag))
      "get" => {
        let list = @jmap.emails(response, tag)
        Json::array(
          list.map(fn(letter) {
            object([
              ("id", Json::string(letter.id)),
              ("subject", Json::string(letter.subject)),
              ("from", Json::string(letter.from.unwrap_or(""))),
              ("receivedAt", Json::string(letter.received_at.unwrap_or(""))),
              ("preview", Json::string(letter.preview)),
              ("unread", Json::boolean(letter.unread)),
            ])
          }),
        )
      }
      "draft" => Json::string(@jmap.created_id(response, tag, "draft"))
      "submit" => Json::string(@jmap.created_id(response, tag, "submission"))
      _ => Json::null()
    }
    ok(value)
  } catch {
    error => fail("jmap", error.to_repr().to_string())
  }
}

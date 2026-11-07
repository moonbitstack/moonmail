// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A message read into the object RFC 8621 describes, which is what a server
/// answers `Email/get` with and what a client would import. The body is
/// decomposed the way section 4.1.4 suggests: one MIME tree, and three flat
/// lists — the plain text body, the HTML body, and the parts a reader would
/// offer to download.

///|
/// A message body as JMAP describes it: the tree itself, and the three lists a
/// reader renders from.
#derive(Eq, Debug)
pub(all) struct EmailBody {
  structure : EmailBodyPart
  text : Array[EmailBodyPart]
  html : Array[EmailBodyPart]
  attachments : Array[EmailBodyPart]
}

///|
pub extend EmailBody with Eq::{equal, not_equal}

///|
pub extend EmailBody with Debug::{to_repr}

///|
/// Numbers the leaves of the tree in the order they are met, which is what a
/// `partId` is: a name inside one email, with no meaning outside it.
priv struct Parts {
  mut next : Int32
}

///|
fn inline_media(media_type : String) -> Bool {
  media_type.has_prefix("image/") ||
  media_type.has_prefix("audio/") ||
  media_type.has_prefix("video/")
}

///|
fn header_of(message : @moonmail.Message, name : String) -> String? {
  message.headers.get(name)
}

///|
fn without_brackets(value : String) -> String {
  let out = StringBuilder()
  for char in value {
    if char != '<' && char != '>' {
      out.write_char(char)
    }
  }
  out.to_string().trim().to_owned()
}

///|
fn part_of(message : @moonmail.Message, parts : Parts) -> EmailBodyPart {
  let media = message.content_type()
  let headers : Array[EmailHeader] = []
  for pair in message.headers.iter() {
    headers.push({ name: pair.0, value: pair.1, })
  }
  let disposition = match header_of(message, "Content-Disposition") {
    Some(value) => @moonmime.Disposition::parse(value)
    None => @moonmime.Disposition::parse("")
  }
  let disposition_kind = if disposition.kind == "" {
    None
  } else {
    Some(disposition.kind)
  }
  let filename = match disposition.filename() {
    Some(name) if name != "" => Some(name)
    _ =>
      match media.param("name") {
        Some(name) if name != "" => Some(@moonmime.decode_words(name))
        _ => None
      }
  }
  let charset = if media.essence.has_prefix("text/") {
    Some(media.param("charset").unwrap_or("us-ascii"))
  } else {
    None
  }
  let language = match header_of(message, "Content-Language") {
    Some(value) =>
      value.split(",").to_array().map(fn(tag) { tag.trim().to_owned() })
    None => []
  }
  let cid = match header_of(message, "Content-ID") {
    Some(value) => Some(without_brackets(value))
    None => None
  }
  let location = header_of(message, "Content-Location")
  match message.body {
    Multipart(children) =>
      {
        part_id: None,
        blob_id: None,
        size: 0,
        headers,
        name: filename,
        media_type: media.essence,
        charset,
        disposition: disposition_kind,
        cid,
        language,
        location,
        sub_parts: Some(children.map(fn(child) { part_of(child, parts) })),
      }
    Embedded(inner) => {
      let part_id = parts.next
      parts.next = part_id + 1
      {
        part_id: Some(part_id.to_string()),
        blob_id: None,
        size: inner.encode().length(),
        headers,
        name: filename,
        media_type: media.essence,
        charset,
        disposition: disposition_kind,
        cid,
        language,
        location,
        sub_parts: None,
      }
    }
    Leaf(octets) => {
      let part_id = parts.next
      parts.next = part_id + 1
      {
        part_id: Some(part_id.to_string()),
        blob_id: None,
        size: octets.length(),
        headers,
        name: filename,
        media_type: media.essence,
        charset,
        disposition: disposition_kind,
        cid,
        language,
        location,
        sub_parts: None,
      }
    }
  }
}

///|
/// What the three flat lists are being filled with. Which of them still takes
/// parts is not here: that is decided per container, and a container that
/// decides a body is plain text does not decide it for its siblings.
priv struct Buckets {
  text : Array[EmailBodyPart]
  html : Array[EmailBodyPart]
  attachments : Array[EmailBodyPart]
}

///|
/// Section 4.1.4's decomposition, written as it is given: a part is the body if
/// its disposition is not `attachment`, its type is one a body can be, and it is
/// either the first part of its container or something a body can hold inline.
///
/// `want_text` and `want_html` belong to one container: a plain text part under
/// an alternative means the alternative has no HTML version, and that is true
/// of the container, not of the message — the sibling multipart still has one.
fn decompose(
  parts : Array[EmailBodyPart],
  multipart_type : String,
  in_alternative : Bool,
  want_text : Bool,
  want_html : Bool,
  buckets : Buckets,
) -> Unit {
  let mut want_text = want_text
  let mut want_html = want_html
  let text_before = buckets.text.length()
  let html_before = buckets.html.length()
  for index, part in parts {
    let is_multipart = part.media_type.has_prefix("multipart/")
    let is_inline = part.disposition != Some("attachment") &&
      (
        part.media_type == "text/plain" ||
        part.media_type == "text/html" ||
        inline_media(part.media_type)
      ) &&
      (
        index == 0 ||
        (
          multipart_type != "related" &&
          (inline_media(part.media_type) || part.name is None)
        )
      )
    if is_multipart {
      let sub_type = match part.media_type.split("/").to_array() {
        [_, rest, ..] => rest
        _ => ""
      }
      let children = part.sub_parts.unwrap_or([])
      decompose(
        children,
        sub_type.to_owned(),
        in_alternative || sub_type == "alternative",
        want_text,
        want_html,
        buckets,
      )
    } else if is_inline {
      if multipart_type == "alternative" {
        match part.media_type {
          "text/plain" => buckets.text.push(part)
          "text/html" => buckets.html.push(part)
          _ => buckets.attachments.push(part)
        }
        continue
      } else if in_alternative {
        if part.media_type == "text/plain" {
          want_html = false
        }
        if part.media_type == "text/html" {
          want_text = false
        }
      }
      if want_text {
        buckets.text.push(part)
      }
      if want_html {
        buckets.html.push(part)
      }
      if (!want_text || !want_html) && inline_media(part.media_type) {
        buckets.attachments.push(part)
      }
    } else {
      buckets.attachments.push(part)
    }
  }
  // An alternative that carried only one of the two versions quotes the other
  // one: a reader showing plain text should still see what was written in HTML,
  // and the other way round.
  if multipart_type == "alternative" && want_text && want_html {
    if text_before == buckets.text.length() &&
      html_before != buckets.html.length() {
      for index in html_before..<buckets.html.length() {
        buckets.text.push(buckets.html[index])
      }
    }
    if html_before == buckets.html.length() &&
      text_before != buckets.text.length() {
      for index in text_before..<buckets.text.length() {
        buckets.html.push(buckets.text[index])
      }
    }
  }
}

///|
/// The body of a message as JMAP describes it: the tree, and the three lists
/// rendered from it.
pub fn email_body_of(message : @moonmail.Message) -> EmailBody {
  let structure = part_of(message, { next: 1, })
  let buckets : Buckets = { text: [], html: [], attachments: [], }
  decompose([structure], "mixed", false, true, true, buckets)
  {
    structure,
    text: buckets.text,
    html: buckets.html,
    attachments: buckets.attachments,
  }
}

///|
fn collapsed(text : String) -> String {
  let out = StringBuilder()
  let mut space = false
  let mut empty = true
  for char in text {
    let blank = char == ' ' || char == '\t' || char == '\r' || char == '\n'
    if blank {
      space = true
    } else {
      if space && !empty {
        out.write_char(' ')
      }
      space = false
      empty = false
      out.write_char(char)
    }
  }
  out.to_string()
}

///|
/// The first 256 characters of the body, white space collapsed: what a list
/// shows under a subject (RFC 8621 section 4.1.4).
pub fn preview_of(message : @moonmail.Message) -> String {
  let plain : String? = message.text() catch { _ => None }
  let markup : String? = message.html() catch { _ => None }
  let text = match plain {
    Some(text) => text
    None =>
      match markup {
        Some(html) => strip_tags(html)
        None => ""
      }
  }
  let flat = collapsed(text)
  if flat.length() > 256 {
    flat[:256].to_owned()
  } else {
    flat
  }
}

///|
fn strip_tags(html : String) -> String {
  let out = StringBuilder()
  let mut inside = false
  for char in html {
    if char == '<' {
      inside = true
    } else if char == '>' {
      inside = false
    } else if !inside {
      out.write_char(char)
    }
  }
  out.to_string()
}

///|
fn utc_stamp(moment : @moondate.Moment) -> String? {
  match moment.instant() {
    Some((seconds, nanos)) =>
      Some(@moondate.Moment::of_epoch(seconds, nano=nanos).isoformat())
    None => None
  }
}

///|
fn addresses_of(message : @moonmail.Message, header : String) -> Json? {
  let parsed = message.addresses(header) catch { _ => [] }
  let out : Array[Json] = []
  for address in parsed {
    for mailbox in address.mailboxes() {
      out.push(
        object([
          (
            "name",
            match mailbox.name {
              Some(name) => Json::string(name)
              None => Json::null()
            },
          ),
          ("email", Json::string(mailbox.address)),
        ]),
      )
    }
  }
  if out.is_empty() {
    None
  } else {
    Some(Json::array(out))
  }
}

///|
/// The message ids of a header field: RFC 8621 section 4.1.2.5 keeps the
/// brackets and the comments out and the ids in.
fn ids_of(message : @moonmail.Message, header : String) -> Json? {
  let value = header_of(message, header)
  let out : Array[Json] = []
  match value {
    Some(value) => {
      let current = StringBuilder()
      for char in value {
        if char == '<' {
          current.reset()
        } else if char == '>' {
          let id = current.to_string().trim()
          if id != "" {
            out.push(Json::string(id.to_owned()))
          }
          current.reset()
        } else {
          current.write_char(char)
        }
      }
    }
    None => ()
  }
  if out.is_empty() {
    None
  } else {
    Some(Json::array(out))
  }
}

///|
/// The octets of a message as the `Email` object RFC 8621 describes: what a
/// server answers `Email/get` with, and what another server could import. The
/// ids the store assigns — `id`, `blobId`, `threadId` — are the caller's, since
/// they name rows this library does not keep.
pub fn email_from_message(
  raw : BytesView,
  mailbox_ids~ : Array[String],
  keywords~ : Array[String] = [],
  received_at? : String,
  blob_id? : String,
  thread_id? : String,
  id? : String,
) -> Json raise Refused {
  let message = @moonmail.Message::parse(raw) catch {
    _ => raise Refused::Malformed(at="message")
  }
  let body = email_body_of(message)
  let pairs : Array[(String, Json)] = [
    ("mailboxIds", flagged(mailbox_ids)),
    ("keywords", flagged(keywords)),
    ("size", number(raw.length())),
    ("bodyStructure", body.structure.to_json()),
    ("textBody", Json::array(body.text.map(fn(part) { part.to_json() }))),
    ("htmlBody", Json::array(body.html.map(fn(part) { part.to_json() }))),
    (
      "attachments",
      Json::array(body.attachments.map(fn(part) { part.to_json() })),
    ),
    (
      "hasAttachment",
      Json::boolean(
        body.attachments.any(fn(part) { part.disposition != Some("inline") }),
      ),
    ),
    ("preview", Json::string(preview_of(message))),
  ]
  match id {
    Some(id) => pairs.push(("id", Json::string(id)))
    None => ()
  }
  match blob_id {
    Some(blob_id) => pairs.push(("blobId", Json::string(blob_id)))
    None => ()
  }
  match thread_id {
    Some(thread_id) => pairs.push(("threadId", Json::string(thread_id)))
    None => ()
  }
  match received_at {
    Some(stamp) => pairs.push(("receivedAt", Json::string(stamp)))
    None => ()
  }
  match message.subject() {
    Some(subject) => pairs.push(("subject", Json::string(subject)))
    None => ()
  }
  for header in ["sender", "from", "to", "cc", "bcc", "replyTo"] {
    let name = match header {
      "replyTo" => "Reply-To"
      "sender" => "Sender"
      "from" => "From"
      "to" => "To"
      "cc" => "Cc"
      _ => "Bcc"
    }
    match addresses_of(message, name) {
      Some(list) => pairs.push((header, list))
      None => ()
    }
  }
  for
    pair in [
      ("messageId", "Message-ID"),
      ("inReplyTo", "In-Reply-To"),
      ("references", "References"),
    ] {
    match ids_of(message, pair.1) {
      Some(ids) => pairs.push((pair.0, ids))
      None => ()
    }
  }
  let moment : @moondate.Moment? = message.date() catch { _ => None }
  match moment {
    Some(moment) =>
      match utc_stamp(moment) {
        Some(stamp) => pairs.push(("sentAt", Json::string(stamp)))
        None => ()
      }
    None => ()
  }
  object(pairs)
}

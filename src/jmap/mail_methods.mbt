// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The arguments RFC 8621 adds on top of the standard shapes in `methods.mbt`:
/// the tree flags a mailbox query takes, the body options a letter's get takes,
/// the blobs an import names. Each builder is the standard one plus the few
/// keys its own method defines, so the two cannot drift apart.

///|
/// A create argument for `Mailbox/set` (RFC 8621 section 2.5). The counts and
/// the rights are the server's to answer, so they are not here.
pub fn mailbox_new(
  name~ : String,
  parent_id? : String,
  role? : String,
  sort_order? : Int32,
  is_subscribed? : Bool,
) -> Json {
  let pairs : Array[(String, Json)] = [("name", Json::string(name))]
  match parent_id {
    Some(value) => pairs.push(("parentId", Json::string(value)))
    None => ()
  }
  match role {
    Some(value) => pairs.push(("role", Json::string(value)))
    None => ()
  }
  match sort_order {
    Some(value) => pairs.push(("sortOrder", number(value)))
    None => ()
  }
  match is_subscribed {
    Some(value) => pairs.push(("isSubscribed", Json::boolean(value)))
    None => ()
  }
  object(pairs)
}

///|
/// `Mailbox/query` (RFC 8621 section 2.3): the two tree flags are what make a
/// folder list come back as a tree rather than as a flat set of names.
pub fn Request::mailbox_query(
  self : Request,
  account : String,
  filter? : Json,
  sort? : Array[Comparator],
  position? : Int32,
  limit? : Int32,
  calculate_total? : Bool,
  sort_as_tree? : Bool,
  filter_as_tree? : Bool,
) -> String {
  self.using_capability(Kind::Mailbox.capability())
  let args = query_args(
    account,
    filter,
    sort,
    position,
    None,
    None,
    limit,
    calculate_total,
  )
  match sort_as_tree {
    Some(value) => args.push(("sortAsTree", Json::boolean(value)))
    None => ()
  }
  match filter_as_tree {
    Some(value) => args.push(("filterAsTree", Json::boolean(value)))
    None => ()
  }
  self.call("Mailbox/query", object(args))
}

///|
/// `Mailbox/set` (RFC 8621 section 2.5): destroying a mailbox that still holds
/// mail is refused unless `on_destroy_remove_emails` says to empty it.
pub fn Request::mailbox_set(
  self : Request,
  account : String,
  create? : Map[String, Json],
  update? : Map[String, Json],
  destroy? : Array[String],
  if_in_state? : String,
  on_destroy_remove_emails? : Bool,
) -> String {
  self.using_capability(Kind::Mailbox.capability())
  let args = set_args(account, create, update, destroy, if_in_state)
  match on_destroy_remove_emails {
    Some(value) => args.push(("onDestroyRemoveEmails", Json::boolean(value)))
    None => ()
  }
  self.call("Mailbox/set", object(args))
}

///|
/// `Email/get` (RFC 8621 section 4.2): the properties a list shows, and
/// optionally the decoded text of the parts, so the client need not fetch each
/// blob separately.
pub fn Request::email_get(
  self : Request,
  account : String,
  ids : Array[String],
  properties : Array[String],
  body_properties? : Array[String],
  fetch_text_body_values? : Bool,
  fetch_html_body_values? : Bool,
  fetch_all_body_values? : Bool,
  max_body_value_bytes? : Int32,
) -> String {
  self.using_capability(Kind::Email.capability())
  let args = get_args(account, Some(ids), Some(properties))
  match body_properties {
    Some(values) => args.push(("bodyProperties", strings(values)))
    None => ()
  }
  args.push(maybe_boolean("fetchTextBodyValues", fetch_text_body_values))
  args.push(maybe_boolean("fetchHTMLBodyValues", fetch_html_body_values))
  args.push(maybe_boolean("fetchAllBodyValues", fetch_all_body_values))
  args.push(maybe_number("maxBodyValueBytes", max_body_value_bytes))
  self.call("Email/get", object(args))
}

///|
/// `Email/query` for anything but a single mailbox: RFC 8621 section 4.4's
/// filters, sorts and thread collapsing. The mailbox shortcut above is a filter
/// of one key, so it is the same method with less to say.
pub fn Request::email_query_filter(
  self : Request,
  account : String,
  filter? : Json,
  sort? : Array[Comparator],
  position? : Int32,
  limit? : Int32,
  calculate_total? : Bool,
  collapse_threads? : Bool,
) -> String {
  self.using_capability(Kind::Email.capability())
  let args = query_args(
    account,
    filter,
    sort,
    position,
    None,
    None,
    limit,
    calculate_total,
  )
  match collapse_threads {
    Some(value) => args.push(("collapseThreads", Json::boolean(value)))
    None => ()
  }
  self.call("Email/query", object(args))
}

///|
/// `Email/queryChanges` (RFC 8621 section 4.5): the same filter and sort as the
/// query it continues, plus the thread collapsing it used.
pub fn Request::email_query_changes(
  self : Request,
  account : String,
  since_query_state~ : String,
  filter? : Json,
  sort? : Array[Comparator],
  max_changes? : Int32,
  up_to_id? : String,
  calculate_total? : Bool,
  collapse_threads? : Bool,
) -> String {
  self.using_capability(Kind::Email.capability())
  let args = query_changes_args(
    account, since_query_state, filter, sort, max_changes, up_to_id, calculate_total,
  )
  match collapse_threads {
    Some(value) => args.push(("collapseThreads", Json::boolean(value)))
    None => ()
  }
  self.call("Email/queryChanges", object(args))
}

///|
/// One message to add to the account: a blob already uploaded, and where it is
/// filed. `received_at` is the internal date; left out, the server uses the
/// most recent `Received` field.
pub(all) struct EmailImport {
  blob_id : String
  mailbox_ids : Array[String]
  keywords : Array[String]
  received_at : String?
}

///|
pub fn EmailImport::new(
  blob_id~ : String,
  mailbox_ids~ : Array[String],
  keywords~ : Array[String] = [],
  received_at? : String,
) -> EmailImport {
  { blob_id, mailbox_ids, keywords, received_at, }
}

///|
fn EmailImport::to_json(self : EmailImport) -> Json {
  let pairs : Array[(String, Json)] = [
    ("blobId", Json::string(self.blob_id)),
    ("mailboxIds", flagged(self.mailbox_ids)),
    ("keywords", flagged(self.keywords)),
  ]
  match self.received_at {
    Some(value) => pairs.push(("receivedAt", Json::string(value)))
    None => ()
  }
  object(pairs)
}

///|
/// `Email/import` (RFC 8621 section 4.8): a message uploaded as a blob becomes
/// an email, one creation id per message, each answered on its own.
pub fn Request::email_import(
  self : Request,
  account : String,
  emails : Map[String, EmailImport],
  if_in_state? : String,
) -> String {
  self.using_capability(Kind::Email.capability())
  let records : Map[String, Json] = Map([])
  for creation, message in emails {
    records[creation] = message.to_json()
  }
  let args : Array[(String, Json)] = [("accountId", Json::string(account))]
  args.push(maybe_string("ifInState", if_in_state))
  args.push(maybe_objects("emails", Some(records)))
  self.call("Email/import", object(args))
}

///|
/// `Email/parse` (RFC 8621 section 4.9): a blob read as a message without
/// importing it — how an attached letter is opened. The properties that belong
/// to a stored email (id, mailboxIds, keywords, receivedAt) come back null.
pub fn Request::email_parse(
  self : Request,
  account : String,
  blob_ids : Array[String],
  properties? : Array[String],
  body_properties? : Array[String],
  fetch_text_body_values? : Bool,
  fetch_html_body_values? : Bool,
  fetch_all_body_values? : Bool,
  max_body_value_bytes? : Int32,
) -> String {
  self.using_capability(Kind::Email.capability())
  let args : Array[(String, Json)] = [
    ("accountId", Json::string(account)),
    ("blobIds", strings(blob_ids)),
  ]
  match properties {
    Some(values) => args.push(("properties", strings(values)))
    None => ()
  }
  match body_properties {
    Some(values) => args.push(("bodyProperties", strings(values)))
    None => ()
  }
  args.push(maybe_boolean("fetchTextBodyValues", fetch_text_body_values))
  args.push(maybe_boolean("fetchHTMLBodyValues", fetch_html_body_values))
  args.push(maybe_boolean("fetchAllBodyValues", fetch_all_body_values))
  args.push(maybe_number("maxBodyValueBytes", max_body_value_bytes))
  self.call("Email/parse", object(args))
}

///|
/// `SearchSnippet/get` (RFC 8621 section 5.1): the matched text, quoted back
/// with the match marked. The filter has to be the one the query used, or the
/// snippet is from a different search than the list.
pub fn Request::search_snippet_get(
  self : Request,
  account : String,
  email_ids : Array[String],
  filter? : Json,
) -> String {
  self.using_capability(Kind::SearchSnippet.capability())
  let args : Array[(String, Json)] = [("accountId", Json::string(account))]
  args.push(maybe_filter(filter))
  args.push(("emailIds", strings(email_ids)))
  self.call("SearchSnippet/get", object(args))
}

///|
/// An envelope address with its ESMTP parameters (RFC 8621 section 7.1), such
/// as `NOTIFY=SUCCESS,FAILURE` or `RET=HDRS` on the sender.
pub fn address(email : String, parameters? : Map[String, String?]) -> Json {
  let pairs : Array[(String, Json)] = [("email", Json::string(email))]
  match parameters {
    Some(values) =>
      if !values.is_empty() {
        let out : Map[String, Json] = Map([])
        for name, value in values {
          out[name] = match value {
            Some(value) => Json::string(value)
            None => Json::null()
          }
        }
        pairs.push(("parameters", Json::object(out)))
      }
    None => ()
  }
  object(pairs)
}

///|
/// The envelope a submission goes out with: who it is from, and who it goes to,
/// as the SMTP dialogue will say them rather than as the headers read. Left
/// out of a submission, the server derives it from the message.
pub fn envelope(mail_from~ : Json, rcpt_to~ : Array[Json]) -> Json {
  object([("mailFrom", mail_from), ("rcptTo", Json::array(rcpt_to))])
}

///|
/// The properties of one submission to create, beyond the two it must have.
pub fn submission_new(
  identity~ : String,
  email~ : String,
  envelope? : Json,
  send_at? : String,
) -> Json {
  let pairs : Array[(String, Json)] = [
    ("identityId", Json::string(identity)),
    ("emailId", Json::string(email)),
  ]
  match envelope {
    Some(value) => pairs.push(("envelope", value))
    None => ()
  }
  match send_at {
    Some(value) => pairs.push(("sendAt", Json::string(value)))
    None => ()
  }
  object(pairs)
}

///|
/// A vacation response to set (RFC 8621 section 8): the singleton's id is
/// `singleton`, and everything but `isEnabled` may be left out to mean "the
/// server's default".
pub fn vacation_response(
  enabled~ : Bool,
  from_date? : String,
  to_date? : String,
  subject? : String,
  text_body? : String,
  html_body? : String,
) -> Json {
  let pairs : Array[(String, Json)] = [("isEnabled", Json::boolean(enabled))]
  match from_date {
    Some(value) => pairs.push(("fromDate", Json::string(value)))
    None => ()
  }
  match to_date {
    Some(value) => pairs.push(("toDate", Json::string(value)))
    None => ()
  }
  match subject {
    Some(value) => pairs.push(("subject", Json::string(value)))
    None => ()
  }
  match text_body {
    Some(value) => pairs.push(("textBody", Json::string(value)))
    None => ()
  }
  match html_body {
    Some(value) => pairs.push(("htmlBody", Json::string(value)))
    None => ()
  }
  object(pairs)
}

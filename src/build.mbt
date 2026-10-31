// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A file that travels with a message. `inline` with an `id` makes it a part
/// an HTML body shows by `cid:`; otherwise it is offered as an attachment.
pub(all) struct Attachment {
  name : String
  media_type : String
  data : Bytes
  inline : Bool
  id : String?
} derive(Eq, Debug)

///|
pub extend Attachment with Eq::{equal, not_equal}

///|
pub extend Attachment with Debug::{to_repr}

///|
pub fn Attachment::new(
  name : String,
  data : Bytes,
  media_type? : String,
  inline~ : Bool = false,
  id? : String,
) -> Attachment {
  {
    name,
    media_type: media_type.unwrap_or_else(() => @moonmime.guess_type(name)),
    data,
    inline,
    id,
  }
}

///|
/// A message ready to send. The structure follows what it carries: one body
/// alone; `multipart/alternative` for text and HTML together;
/// `multipart/related` around the body when attachments are inline with an
/// id; `multipart/mixed` around that when any are not. Text goes out as UTF-8,
/// in `7bit` while it is ASCII with short lines and in quoted-printable
/// otherwise; attachments go out in base64.
///
/// `date` and `message_id` are written only when given: this package reads no
/// clock and draws no randomness.
pub fn Message::new(
  from~ : Mailbox,
  to~ : Array[Address],
  subject~ : String,
  text? : String,
  html? : String,
  attachments? : Array[Attachment],
  cc? : Array[Address],
  date? : @moondate.Moment,
  message_id? : String,
) -> Message raise Refused {
  let attachments = attachments.unwrap_or([])
  let core = match (text, html) {
    (Some(t), Some(h)) =>
      container("alternative", [leaf_text("plain", t), leaf_text("html", h)])
    (None, Some(h)) => leaf_text("html", h)
    (Some(t), None) => leaf_text("plain", t)
    (None, None) => leaf_text("plain", "")
  }
  let inline = attachments.filter(a => a.inline && a.id is Some(_))
  let related = if inline.is_empty() {
    core
  } else {
    container(
      "related",
      [core] + inline.map(leaf_file),
      extra="; type=\"" + core.content_type().essence + "\"",
    )
  }
  let attached = attachments.filter(a => !(a.inline && a.id is Some(_)))
  let top = if attached.is_empty() {
    related
  } else {
    container("mixed", [related] + attached.map(leaf_file))
  }
  let headers = Headers::new()
  headers.add("From", from.encode(utf8=true))
  if !to.is_empty() {
    headers.add("To", encode_addresses(to[:], utf8=true))
  }
  if cc is Some(list) && !list.is_empty() {
    headers.add("Cc", encode_addresses(list[:], utf8=true))
  }
  headers.add("Subject", subject)
  if date is Some(moment) {
    headers.add("Date", format_date(moment))
  }
  if message_id is Some(id) {
    headers.add("Message-ID", id)
  }
  headers.add("MIME-Version", "1.0")
  for field in top.headers.iter() {
    headers.add(field.0, field.1)
  }
  { headers, body: top.body, }
}

///|
fn leaf_text(subtype : String, text : String) -> Message raise Refused {
  let data = crlf(@utf8.encode(text))
  let headers = Headers::new()
  headers.add("Content-Type", "text/" + subtype + "; charset=\"utf-8\"")
  headers.add(
    "Content-Transfer-Encoding",
    if fits(data, false) {
      "7bit"
    } else {
      "quoted-printable"
    },
  )
  { headers, body: Leaf(data), }
}

///|
fn leaf_file(file : Attachment) -> Message raise Refused {
  let headers = Headers::new()
  headers.add("Content-Type", file.media_type)
  headers.add(
    "Content-Disposition",
    @moonmime.content_disposition(file.name, inline=file.inline),
  )
  if file.id is Some(id) {
    headers.add("Content-ID", "<" + id + ">")
  }
  headers.add("Content-Transfer-Encoding", "base64")
  { headers, body: Leaf(file.data), }
}

///|
fn container(
  subtype : String,
  parts : Array[Message],
  extra~ : String = "",
) -> Message raise Refused {
  let boundary = boundary_of(parts.map(p => p.encode(utf8=true)))
  let headers = Headers::new()
  headers.add(
    "Content-Type",
    "multipart/" + subtype + "; boundary=\"" + boundary + "\"" + extra,
  )
  { headers, body: Multipart(parts), }
}

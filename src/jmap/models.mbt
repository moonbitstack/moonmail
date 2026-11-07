// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The objects of RFC 8621, each written down once. A description is data: the
/// same table answers what properties an object has, projects to JSON Schema
/// for documentation, and is what `@moonmail/jmap/validate` checks a document
/// against. Adding a property is a line here, not a new type.
///
/// Each model is the object as a server returns it when every property was
/// asked for, which is why the server-set properties are there too. A `create`
/// carries a subset of it and is governed by the rules of RFC 8621 section
/// 4.6, not by this table.

///|
fn prop(
  name : String,
  kind : @moonmodel.Type,
  nullable? : Bool,
  doc? : String,
) -> @moonmodel.Field {
  @moonmodel.Field::new(
    name,
    kind,
    required=false,
    nullable=nullable.unwrap_or(false),
    doc=doc.unwrap_or(""),
  )
}

///|
/// `Id`: an identifier the server assigns, opaque to the client.
fn id(name : String, doc? : String) -> @moonmodel.Field {
  prop(name, @moonmodel.Text, doc=doc.unwrap_or(""))
}

///|
/// A value that may be null, which is how JMAP writes "absent, but part of the
/// object" — a missing property and a null one mean the same thing.
fn maybe_prop(
  name : String,
  kind : @moonmodel.Type,
  doc? : String,
) -> @moonmodel.Field {
  prop(name, kind, nullable=true, doc=doc.unwrap_or(""))
}

///|
fn list_of(kind : @moonmodel.Type) -> @moonmodel.Type {
  @moonmodel.List(kind)
}

///|
fn refers(name : String) -> @moonmodel.Type {
  @moonmodel.Ref(name)
}

///|
/// The rights a user has in one mailbox (RFC 8621 section 2, `MailboxRights`),
/// spelled the way IMAP ACLs are.
pub fn mailbox_rights_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "MailboxRights",
    [
      prop(
        "mayReadItems",
        @moonmodel.Bool,
        doc="May be used as a filter, and its emails fetched",
      ),
      prop("mayAddItems", @moonmodel.Bool, doc="May take mail in"),
      prop(
        "mayRemoveItems",
        @moonmodel.Bool,
        doc="May let mail out, or be destroyed from",
      ),
      prop("maySetSeen", @moonmodel.Bool, doc="May set the $seen keyword"),
      prop("maySetKeywords", @moonmodel.Bool, doc="May set any other keyword"),
      prop(
        "mayCreateChild",
        @moonmodel.Bool,
        doc="May create a mailbox under this one",
      ),
      prop("mayRename", @moonmodel.Bool, doc="May be renamed or moved"),
      prop("mayDelete", @moonmodel.Bool, doc="May be destroyed"),
      prop("maySubmit", @moonmodel.Bool, doc="Mail may be submitted to it"),
    ],
    doc="What the user may do in one mailbox",
  )
}

///|
/// A named set of emails: the folder of a mail store, which JMAP calls a
/// mailbox (RFC 8621 section 2).
pub fn mailbox_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "Mailbox",
    [
      id("id", doc="The mailbox's id, immutable"),
      prop(
        "name",
        @moonmodel.Text,
        doc="What the user sees, in their own language",
      ),
      maybe_prop(
        "parentId",
        @moonmodel.Text,
        doc="The parent mailbox, or null at the top",
      ),
      maybe_prop(
        "role",
        @moonmodel.Text,
        doc="inbox, sent, drafts, trash and the other IMAP roles, lowercased",
      ),
      prop(
        "sortOrder",
        @moonmodel.Int,
        doc="Where it sits among its siblings; 0 by default",
      ),
      prop("totalEmails", @moonmodel.Int, doc="How many emails are in it"),
      prop(
        "unreadEmails",
        @moonmodel.Int,
        doc="How many are neither $seen nor $draft",
      ),
      prop(
        "totalThreads",
        @moonmodel.Int,
        doc="How many threads have an email in it",
      ),
      prop(
        "unreadThreads",
        @moonmodel.Int,
        doc="How many of those threads a reader would see unread",
      ),
      prop(
        "myRights",
        refers("MailboxRights"),
        doc="What this user may do in it",
      ),
      prop(
        "isSubscribed",
        @moonmodel.Bool,
        doc="Whether the user asked to see it",
      ),
    ],
    doc="A named set of emails",
  )
}

///|
/// Emails grouped by the conversation they belong to (RFC 8621 section 3).
pub fn thread_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "Thread",
    [
      id("id", doc="The thread's id"),
      prop("emailIds", list_of(@moonmodel.Text), doc="Its emails, oldest first"),
    ],
    doc="A conversation, as a list of emails",
  )
}

///|
/// One correspondent (RFC 8621 section 4.1.2.3), as an address header yields
/// it.
pub fn email_address_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "EmailAddress",
    [
      maybe_prop(
        "name",
        @moonmodel.Text,
        doc="The display name, decoded; null when there was none",
      ),
      prop("email", @moonmodel.Text, doc="The addr-spec"),
    ],
    doc="One address of a header",
  )
}

///|
/// An address group, kept as a group: `Friends: a@example.com, b@example.com;`
/// is one of these (RFC 8621 section 4.1.2.4).
pub fn email_address_group_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "EmailAddressGroup",
    [
      maybe_prop(
        "name",
        @moonmodel.Text,
        doc="The group name; null for addresses outside a group",
      ),
      prop(
        "addresses",
        list_of(refers("EmailAddress")),
        doc="Its members, in the order written",
      ),
    ],
    doc="A group of addresses, or the addresses outside one",
  )
}

///|
/// One header field, in the order and the capitalisation the message has
/// (RFC 8621 section 4.1.3).
pub fn email_header_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "EmailHeader",
    [
      prop(
        "name",
        @moonmodel.Text,
        doc="The field name as written, case and all",
      ),
      prop("value", @moonmodel.Text, doc="The field value, unfolded only"),
    ],
    doc="One header field of a message",
  )
}

///|
/// A part of a message body (RFC 8621 section 4.1.4): the leaf of a MIME tree,
/// or a multipart with its children under it.
pub fn email_body_part_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "EmailBodyPart",
    [
      maybe_prop(
        "partId",
        @moonmodel.Text,
        doc="Its name inside this email; null for multipart/*",
      ),
      maybe_prop(
        "blobId",
        @moonmodel.Text,
        doc="The id of its decoded octets; null for multipart/*",
      ),
      prop("size", @moonmodel.Int, doc="Octets after transfer decoding"),
      prop(
        "headers",
        list_of(refers("EmailHeader")),
        doc="Its own header fields, in order",
      ),
      maybe_prop(
        "name",
        @moonmodel.Text,
        doc="The filename, decoded from either header that carries one",
      ),
      prop("type", @moonmodel.Text, doc="The media type without parameters"),
      maybe_prop(
        "charset",
        @moonmodel.Text,
        doc="The charset of a text part, us-ascii when unsaid",
      ),
      maybe_prop(
        "disposition",
        @moonmodel.Text,
        doc="inline, attachment, or null",
      ),
      maybe_prop(
        "cid",
        @moonmodel.Text,
        doc="The Content-Id without its angle brackets",
      ),
      maybe_prop(
        "language",
        list_of(@moonmodel.Text),
        doc="The Content-Language tags",
      ),
      maybe_prop("location", @moonmodel.Text, doc="The Content-Location URI"),
      maybe_prop(
        "subParts",
        list_of(refers("EmailBodyPart")),
        doc="Its children, for multipart/*",
      ),
    ],
    doc="One part of a message body",
  )
}

///|
/// The text of a part, decoded for the client so it need not fetch the blob
/// (RFC 8621 section 4.1.4).
pub fn email_body_value_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "EmailBodyValue",
    [
      prop(
        "value",
        @moonmodel.Text,
        doc="The decoded text, every CRLF a single LF",
      ),
      prop(
        "isEncodingProblem",
        @moonmodel.Bool,
        doc="Something was malformed or unknown while decoding",
      ),
      prop(
        "isTruncated",
        @moonmodel.Bool,
        doc="The value was cut at maxBodyValueBytes",
      ),
    ],
    doc="The decoded text of one part",
  )
}

///|
/// A letter, as RFC 8621 section 4.1 describes it. Only some of these are fast
/// to fetch; the ones a list shows are the metadata and the parsed headers.
pub fn email_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "Email",
    [
      id("id", doc="The email's id, which is not its Message-ID"),
      prop("blobId", @moonmodel.Text, doc="The id of the raw message"),
      prop("threadId", @moonmodel.Text, doc="The thread it belongs to"),
      prop(
        "mailboxIds",
        @moonmodel.Dict(@moonmodel.Bool),
        doc="Every mailbox it is in; the values are true",
      ),
      prop(
        "keywords",
        @moonmodel.Dict(@moonmodel.Bool),
        doc="$seen, $flagged, $answered, $draft and any of its own",
      ),
      prop("size", @moonmodel.Int, doc="Octets of the raw message"),
      prop(
        "receivedAt",
        @moonmodel.Stamp,
        doc="When the store took it, the IMAP internal date",
      ),
      maybe_prop(
        "messageId",
        list_of(@moonmodel.Text),
        doc="The Message-ID field, parsed",
      ),
      maybe_prop(
        "inReplyTo",
        list_of(@moonmodel.Text),
        doc="The In-Reply-To field, parsed",
      ),
      maybe_prop(
        "references",
        list_of(@moonmodel.Text),
        doc="The References field, parsed",
      ),
      maybe_prop(
        "sender",
        list_of(refers("EmailAddress")),
        doc="The Sender field",
      ),
      maybe_prop("from", list_of(refers("EmailAddress")), doc="The From field"),
      maybe_prop("to", list_of(refers("EmailAddress")), doc="The To field"),
      maybe_prop("cc", list_of(refers("EmailAddress")), doc="The Cc field"),
      maybe_prop("bcc", list_of(refers("EmailAddress")), doc="The Bcc field"),
      maybe_prop(
        "replyTo",
        list_of(refers("EmailAddress")),
        doc="The Reply-To field",
      ),
      maybe_prop("subject", @moonmodel.Text, doc="The Subject field, decoded"),
      maybe_prop("sentAt", @moonmodel.Stamp, doc="The Date field, parsed"),
      prop(
        "hasAttachment",
        @moonmodel.Bool,
        doc="There is something a reader would offer to download",
      ),
      prop(
        "preview",
        @moonmodel.Text,
        doc="Up to 256 characters of the body, for a list",
      ),
      prop(
        "bodyValues",
        @moonmodel.Dict(refers("EmailBodyValue")),
        doc="Decoded text, by part id",
      ),
      prop(
        "headers",
        list_of(refers("EmailHeader")),
        doc="Every header field, in the order the message has them",
      ),
      prop("bodyStructure", refers("EmailBodyPart"), doc="The whole MIME tree"),
      prop(
        "textBody",
        list_of(refers("EmailBodyPart")),
        doc="The parts to show as the body, plain text preferred",
      ),
      prop(
        "htmlBody",
        list_of(refers("EmailBodyPart")),
        doc="The parts to show as the body, HTML preferred",
      ),
      prop(
        "attachments",
        list_of(refers("EmailBodyPart")),
        doc="The parts that are not the body",
      ),
    ],
    doc="A letter",
  )
}

///|
/// What a search matched, quoted back (RFC 8621 section 5).
pub fn search_snippet_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "SearchSnippet",
    [
      id("emailId", doc="The email the snippet belongs to"),
      maybe_prop(
        "subject",
        @moonmodel.Text,
        doc="The subject with the match marked",
      ),
      maybe_prop("preview", @moonmodel.Text, doc="Body text around the match"),
    ],
    doc="The part of a letter a search matched",
  )
}

///|
/// An address the account may send from (RFC 8621 section 6).
pub fn identity_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "Identity",
    [
      id("id", doc="The identity's id"),
      prop("name", @moonmodel.Text, doc="The From name to use"),
      prop(
        "email",
        @moonmodel.Text,
        doc="The From address; *@example.com allows any local part",
      ),
      maybe_prop(
        "replyTo",
        list_of(refers("EmailAddress")),
        doc="Reply-To to set on new mail",
      ),
      maybe_prop(
        "bcc",
        list_of(refers("EmailAddress")),
        doc="Bcc to set on new mail",
      ),
      prop("textSignature", @moonmodel.Text, doc="To append to plain text"),
      prop(
        "htmlSignature",
        @moonmodel.Text,
        doc="To insert into the body of HTML",
      ),
      prop("mayDelete", @moonmodel.Bool, doc="The user may destroy it"),
    ],
    doc="An address the account may send from",
  )
}

///|
/// One recipient of a submission, or its sender, with the ESMTP parameters
/// (RFC 8621 section 7.1).
pub fn address_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "Address",
    [
      prop("email", @moonmodel.Text, doc="The address"),
      maybe_prop(
        "parameters",
        @moonmodel.Dict(@moonmodel.Text),
        doc="ESMTP parameters; a parameter that takes no value maps to null",
      ),
    ],
    doc="One envelope address and its parameters",
  )
}

///|
/// The SMTP envelope a submission goes out with (RFC 8621 section 7.1).
pub fn envelope_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "Envelope",
    [
      prop(
        "mailFrom",
        refers("Address"),
        doc="Who the message is from, for the envelope",
      ),
      prop(
        "rcptTo",
        list_of(refers("Address")),
        doc="Who it goes to, deduplicated",
      ),
    ],
    doc="The envelope of a submitted message",
  )
}

///|
/// How far one recipient's copy has got (RFC 8621 section 7.1).
pub fn delivery_status_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "DeliveryStatus",
    [
      prop("smtpReply", @moonmodel.Text, doc="The SMTP reply, its lines joined"),
      prop("delivered", @moonmodel.Text, doc="queued, yes, no or unknown"),
      prop("displayed", @moonmodel.Text, doc="yes or unknown"),
    ],
    doc="The delivery of one recipient's copy",
  )
}

///|
/// A letter handed to the submission server (RFC 8621 section 7.1).
pub fn email_submission_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "EmailSubmission",
    [
      id("id", doc="The submission's id"),
      id("identityId", doc="The identity it is sent as"),
      id("emailId", doc="The email it sends"),
      id("threadId", doc="The thread that email is in"),
      maybe_prop(
        "envelope",
        refers("Envelope"),
        doc="The envelope; the server derives one when null",
      ),
      prop("sendAt", @moonmodel.Stamp, doc="When it is released for delivery"),
      prop("undoStatus", @moonmodel.Text, doc="pending, final or canceled"),
      maybe_prop(
        "deliveryStatus",
        @moonmodel.Dict(refers("DeliveryStatus")),
        doc="Per recipient, when the server knows",
      ),
      prop(
        "dsnBlobIds",
        list_of(@moonmodel.Text),
        doc="Delivery status notifications received, oldest first",
      ),
      prop(
        "mdnBlobIds",
        list_of(@moonmodel.Text),
        doc="Display notifications received, oldest first",
      ),
    ],
    doc="One sending of one letter",
  )
}

///|
/// The automatic answer an account sends while away (RFC 8621 section 8).
pub fn vacation_response_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "VacationResponse",
    [
      id("id", doc="The singleton's id"),
      prop("isEnabled", @moonmodel.Bool, doc="Whether it answers at all"),
      maybe_prop("fromDate", @moonmodel.Stamp, doc="When it starts answering"),
      maybe_prop("toDate", @moonmodel.Stamp, doc="When it stops"),
      maybe_prop(
        "subject",
        @moonmodel.Text,
        doc="The subject to answer with; null to reuse the incoming one",
      ),
      maybe_prop(
        "textBody",
        @moonmodel.Text,
        doc="The plain text to answer with",
      ),
      maybe_prop("htmlBody", @moonmodel.Text, doc="The HTML to answer with"),
    ],
    doc="The answer sent while the account is away",
  )
}

///|
/// Why one record of a `set` was refused (RFC 8620 section 5.3). The type is a
/// registered string; the properties it carries depend on that type.
pub fn set_error_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "SetError",
    [
      prop(
        "type",
        @moonmodel.Text,
        doc="invalidProperties, forbidden, overQuota, notFound and the rest",
      ),
      maybe_prop("description", @moonmodel.Text, doc="For a person to read"),
      maybe_prop(
        "properties",
        list_of(@moonmodel.Text),
        doc="The properties at fault, for invalidProperties",
      ),
      @moonmodel.Field::new(
        "existingId",
        @moonmodel.Text,
        required=false,
        doc="For alreadyExists",
      ),
    ],
    doc="Why one record of a set was refused",
  )
}

///|
/// Why a request was refused as a whole (RFC 8620 section 3.6.1): an HTTP
/// status and one of the registered problem types.
pub fn request_error_model() -> @moonmodel.Model {
  @moonmodel.Model::new(
    "RequestError",
    [
      prop("type", @moonmodel.Text, doc="A urn:ietf:params:jmap:error: type"),
      maybe_prop("status", @moonmodel.Int, doc="The HTTP status"),
      maybe_prop("detail", @moonmodel.Text, doc="For a person to read"),
      @moonmodel.Field::new(
        "limit",
        @moonmodel.Text,
        required=false,
        doc="The limit that was exceeded, when that is the problem",
      ),
    ],
    doc="Why a request was refused as a whole",
  )
}

///|
/// Every object this module describes, in the order RFC 8621 introduces them.
/// A `Ref` is resolved against this list, so a model may point at one that
/// comes later.
pub fn models() -> Array[@moonmodel.Model] {
  [
    mailbox_model(),
    mailbox_rights_model(),
    thread_model(),
    email_model(),
    email_address_model(),
    email_address_group_model(),
    email_body_part_model(),
    email_body_value_model(),
    email_header_model(),
    search_snippet_model(),
    identity_model(),
    address_model(),
    envelope_model(),
    delivery_status_model(),
    email_submission_model(),
    vacation_response_model(),
    set_error_model(),
    request_error_model(),
  ]
}

///|
/// The description of one object by the name RFC 8621 gives it, or none when
/// there is no such object.
pub fn model(name : String) -> @moonmodel.Model? {
  for entry in models() {
    if entry.name == name {
      return Some(entry)
    }
  }
  None
}

///|
/// The properties of one object, in the order they are described. Reading them
/// from the model rather than from a list of strings is what keeps `properties`
/// arguments and filters from naming a property the object does not have.
pub fn properties(name : String) -> Array[String] {
  match model(name) {
    Some(entry) => entry.fields.map(fn(field) { field.name })
    None => []
  }
}

///|
/// Whether `name` is a property of the object, which is the check a caller runs
/// before putting it in a `properties` list or a patch.
pub fn has_property(name : String, property : String) -> Bool {
  match model(name) {
    Some(entry) =>
      match entry.field(property) {
        Some(_) => true
        None => false
      }
    None => false
  }
}

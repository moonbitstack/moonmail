// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Where a JMAP server keeps its method calls, as answered by
/// `/.well-known/jmap`. Every URL the document gives may be absolute or
/// relative to the discovery URL, and the account the mail capabilities live
/// under has to be picked before any method can be called.
pub(all) struct Session {
  /// The user the server recognised, when it says.
  username : String?
  /// The account to pass as `accountId`. RFC 8620 section 2 leaves this
  /// implicit, so it is resolved once here rather than at every call site.
  account_id : String
  /// Where `Request` documents are posted.
  api_url : String
  download_url : String?
  upload_url : String?
  event_source_url : String?
  /// The `sessionState` to send back when the server offers state strings.
  state : String
} derive(Eq, Debug)

///|
pub extend Session with Eq::{equal, not_equal}

///|
pub extend Session with Debug::{to_repr}

///|
/// The discovery URL for a server origin or base URL: everything a client
/// needs before it knows where `apiUrl` is.
pub fn discovery_url(base : String) -> String {
  let trimmed = base.trim()
  let trimmed = if trimmed.has_suffix("/") {
    trimmed[:trimmed.length() - 1]
  } else {
    trimmed
  }
  trimmed.to_owned() + "/.well-known/jmap"
}

///|
fn scheme_end(url : String) -> Int32? {
  if url.has_prefix("https://") {
    Some(8)
  } else if url.has_prefix("http://") {
    Some(7)
  } else {
    None
  }
}

///|
fn origin_of(url : String) -> String? {
  match scheme_end(url) {
    None => None
    Some(start) => {
      let rest = url[start:]
      match rest.find("/") {
        Some(slash) => Some(url[:start + slash].to_owned())
        None => Some(url)
      }
    }
  }
}

///|
fn last_slash(text : String) -> Int32? {
  let mut i = text.length() - 1
  while i >= 0 {
    if text.get_char(i) == Some('/') {
      return Some(i)
    }
    i = i - 1
  }
  None
}

///|
/// RFC 3986 section 5.2, as much of it as a JMAP session document needs: an
/// absolute URL stands, a path is taken from the origin, and anything else is
/// relative to the directory of the document.
pub fn resolve(base : String, url : String) -> String raise Refused {
  if url == "" {
    raise Refused::BadUrl(url~)
  }
  if scheme_end(url) is Some(_) {
    return url
  }
  let origin = match origin_of(base) {
    Some(origin) => origin
    None => raise Refused::BadUrl(url=base)
  }
  if url.has_prefix("//") {
    let scheme = match scheme_end(base) {
      Some(8) => "https:"
      _ => "http:"
    }
    return scheme + url
  }
  if url.has_prefix("/") {
    return origin + url
  }
  let document = match base.find("?") {
    Some(at) => base[:at].to_owned()
    None => base
  }
  match last_slash(document) {
    Some(at) => document[:at + 1].to_owned() + url
    None => document + "/" + url
  }
}

///|
/// Read the session document that `discovery_url` answered with. `base` is the
/// URL that was fetched, because every relative URL in the document is
/// resolved against it.
pub fn Session::parse(base : String, body : String) -> Session raise Refused {
  let document = reads(body)
  let api_url = resolve(base, text(document, "apiUrl"))
  let accounts = object_of(field(document, "accounts"))
  let account_id = match optional(document, "primaryAccounts") {
    Some(Json::Object(primary)) =>
      match primary.get("urn:ietf:params:jmap:mail") {
        Some(Json::String(id)) => id
        _ =>
          match first_key(accounts) {
            Some(id) => id
            None => raise Refused::Missing(name="accounts")
          }
      }
    _ =>
      match first_key(accounts) {
        Some(id) => id
        None => raise Refused::Missing(name="accounts")
      }
  }
  let download_url = match text_opt(document, "downloadUrl") {
    Some(url) => Some(resolve(base, url))
    None => None
  }
  let upload_url = match text_opt(document, "uploadUrl") {
    Some(url) => Some(resolve(base, url))
    None => None
  }
  let event_source_url = match text_opt(document, "eventSourceUrl") {
    Some(url) => Some(resolve(base, url))
    None => None
  }
  {
    username: text_opt(document, "username"),
    account_id,
    api_url,
    download_url,
    upload_url,
    event_source_url,
    state: text_opt(document, "state").unwrap_or(""),
  }
}

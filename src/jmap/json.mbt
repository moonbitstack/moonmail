// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What this package refuses: a document that is not a JMAP document, a field
/// it needed and did not find, or an error the server answered with.
#derive(Eq, Debug)
pub(all) suberror Refused {
  /// The body was not JSON at all.
  Malformed(at~ : String)
  /// A document where an object was expected.
  NotAnObject
  /// An object without a field the method requires.
  Missing(name~ : String)
  /// A field of the wrong type: a number where a string belongs, or the
  /// reverse.
  WrongType(name~ : String)
  /// A URL the session document gave that cannot be resolved.
  BadUrl(url~ : String)
  /// The server answered `error`. `type` is the registered problem type from
  /// RFC 8620 section 3.6.2, not an HTTP status.
  Failed(call~ : String, kind~ : String, description~ : String)
}

///|
pub extend Refused with Eq::{equal, not_equal}

///|
pub extend Refused with Debug::{to_repr}

///|
/// Read a JSON document, or refuse it as a whole: a JMAP body that does not
/// parse has no partial reading worth keeping.
fn reads(body : String) -> Json raise Refused {
  @json.parse(body[:]) catch {
    _ => raise Refused::Malformed(at="document")
  }
}

///|
fn object_of(json : Json) -> Map[String, Json] raise Refused {
  match json {
    Json::Object(map) => map
    _ => raise Refused::NotAnObject
  }
}

///|
fn field(json : Json, name : String) -> Json raise Refused {
  let map = object_of(json)
  match map.get(name) {
    Some(value) => value
    None => raise Refused::Missing(name~)
  }
}

///|
fn optional(json : Json, name : String) -> Json? {
  match json {
    Json::Object(map) => map.get(name)
    _ => None
  }
}

///|
fn text(json : Json, name : String) -> String raise Refused {
  match field(json, name) {
    Json::String(value) => value
    _ => raise Refused::WrongType(name~)
  }
}

///|
/// A string field that may be absent: JMAP leaves `null` and a missing field
/// meaning the same thing, so both read as none.
fn text_opt(json : Json, name : String) -> String? {
  match optional(json, name) {
    Some(Json::String(value)) => Some(value)
    _ => None
  }
}

///|
fn int(json : Json, name : String) -> Int32 {
  match optional(json, name) {
    Some(Json::Number(value, ..)) => value.to_int()
    _ => 0
  }
}

///|
fn items(json : Json, name : String) -> Array[Json] raise Refused {
  match field(json, name) {
    Json::Array(list) => list
    _ => raise Refused::WrongType(name~)
  }
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
fn number(value : Int32) -> Json {
  Json::number(value.to_double(), repr=value.to_string())
}

///|
fn first_key(map : Map[String, Json]) -> String? {
  for key, _ in map {
    return Some(key)
  }
  None
}

///|
/// A map of records as a JMAP set argument, or none when there is nothing in
/// it: RFC 8620 writes "no records" as null, and an empty object would say
/// something else.
fn objects(values : Map[String, Json]) -> Json? {
  if values.is_empty() {
    None
  } else {
    Some(Json::object(values))
  }
}

///|
/// A JMAP set-of-strings, which is an object whose keys are the members and
/// whose values are all true: `mailboxIds` and `keywords` are written this way
/// (RFC 8621 section 4.1).
fn flagged(names : Array[String]) -> Json {
  let values : Map[String, Json] = Map([])
  for name in names {
    values[name] = Json::boolean(true)
  }
  Json::object(values)
}

///|
/// The strings of a JSON array, in order: identifiers and property names, which
/// JMAP writes as plain strings.
fn string_list(json : Json, name : String) -> Array[String] {
  let out : Array[String] = []
  for entry in list_or_empty(json, name) {
    match entry {
      Json::String(value) => out.push(value)
      _ => ()
    }
  }
  out
}

///|
fn list_or_empty(json : Json, name : String) -> Array[Json] {
  match optional(json, name) {
    Some(Json::Array(entries)) => entries
    _ => []
  }
}

// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What this package refuses: a document that is not a JMAP document, a field
/// it needed and did not find, or an error the server answered with.
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
} derive(Eq, Debug)

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

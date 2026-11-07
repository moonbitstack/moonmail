// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A document checked against the description of its object. The check is the
/// JSON Schema projection of `moonmail/jmap`'s models, run by a validator that
/// has no idea what an email is: what it enforces is the property names, the
/// types and the nulls, which is the half of RFC 8621 that can be written down.

///|
/// What this package refuses: a name no object in RFC 8621 goes by.
#derive(Eq, Debug)
pub(all) suberror Refused {
  Unknown(name~ : String)
}

///|
pub extend Refused with Eq::{equal, not_equal}

///|
pub extend Refused with Debug::{to_repr}

///|
fn model_of(name : String) -> @moonmodel.Model raise Refused {
  match @jmap.model(name) {
    Some(model) => model
    None => raise Refused::Unknown(name~)
  }
}

///|
/// Whether a document is the object it claims to be: every property it has is
/// of the type the object gives it, and none that must be there is missing.
/// Properties RFC 8621 leaves open — `header:Subject:asText`, and whatever a
/// server adds — are allowed through.
pub fn valid(name : String, json : Json) -> Bool raise {
  @verify.valid(model_of(name), json, known=@jmap.models())
}

///|
/// What is wrong with a document, one fault per place: the property, what the
/// schema expected and what it found. Empty when the document is valid.
pub fn faults(name : String, json : Json) -> Array[@moonschema.Fault] raise {
  @verify.faults(model_of(name), json, known=@jmap.models())
}

///|
/// The object as a JSON Schema document with its references resolved, for a
/// page that documents the protocol or a tool in another language that has to
/// read what this one writes. `draft` is the dialect, `2020-12` when left out.
pub fn schema(name : String, draft? : String) -> Json raise {
  @mjson.document(
    model_of(name),
    known=@jmap.models(),
    draft=draft.unwrap_or("2020-12"),
  )
}

///|
/// Every object of RFC 8621 as one JSON Schema document: `Email`, `Mailbox` and
/// the rest under `$defs`, so a reader has the whole vocabulary at once.
pub fn all_objects(draft? : String) -> Json {
  let definitions : Map[String, Json] = Map([])
  for model in @jmap.models() {
    definitions[model.name] = @mjson.of(model, draft=draft.unwrap_or("2020-12"))
  }
  Json::object(definitions)
}

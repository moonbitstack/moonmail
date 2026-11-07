// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The data types RFC 8621 gives methods to. Each one names its half of the
/// method surface, so a call site picks a type instead of spelling its name,
/// and a misspelling is a compile error rather than an `unknownMethod` from
/// the server.
#derive(Eq, Debug)
pub(all) enum Kind {
  Mailbox
  Thread
  Email
  SearchSnippet
  Identity
  EmailSubmission
  VacationResponse
}

///|
pub extend Kind with Eq::{equal, not_equal}

///|
pub extend Kind with Debug::{to_repr}

///|
/// The name the type goes by on the wire: `Mailbox`, `EmailSubmission`, and
/// the rest.
pub fn Kind::name(self : Kind) -> String {
  match self {
    Mailbox => "Mailbox"
    Thread => "Thread"
    Email => "Email"
    SearchSnippet => "SearchSnippet"
    Identity => "Identity"
    EmailSubmission => "EmailSubmission"
    VacationResponse => "VacationResponse"
  }
}

///|
/// The capability a call to this type has to claim in `using` (RFC 8621
/// section 1.3): asking for `submission` on a server that only holds mail is a
/// refusal of the whole request, so each call claims only its own.
pub fn Kind::capability(self : Kind) -> String {
  match self {
    Mailbox | Thread | Email | SearchSnippet => "urn:ietf:params:jmap:mail"
    Identity | EmailSubmission => "urn:ietf:params:jmap:submission"
    VacationResponse => "urn:ietf:params:jmap:vacationresponse"
  }
}

///|
/// The methods this type has, in the order RFC 8621 lists them. `query` is
/// absent where the type cannot be narrowed — a thread, an identity and a
/// vacation response are looked up, not searched.
pub fn Kind::methods(self : Kind) -> Array[String] {
  let kind = self.name()
  let out : Array[String] = []
  match self {
    Mailbox =>
      for verb in ["get", "changes", "query", "queryChanges", "set"] {
        out.push(kind + "/" + verb)
      }
    Thread =>
      for verb in ["get", "changes"] {
        out.push(kind + "/" + verb)
      }
    Email =>
      for
        verb in [
          "get", "changes", "query", "queryChanges", "set", "copy", "import", "parse",
        ] {
        out.push(kind + "/" + verb)
      }
    SearchSnippet =>
      for verb in ["get"] {
        out.push(kind + "/" + verb)
      }
    Identity =>
      for verb in ["get", "changes", "set"] {
        out.push(kind + "/" + verb)
      }
    EmailSubmission =>
      for verb in ["get", "changes", "query", "queryChanges", "set"] {
        out.push(kind + "/" + verb)
      }
    VacationResponse =>
      for verb in ["get", "set"] {
        out.push(kind + "/" + verb)
      }
  }
  out
}

///|
/// Every method RFC 8621 defines, plus the `Core/echo` every server has from
/// RFC 8620. Twenty-seven names: five for a mailbox, two for a thread, eight
/// for a letter, one for a snippet, three for an identity, five for a
/// submission, two for a vacation response, and the ping.
pub fn method_names() -> Array[String] {
  let out : Array[String] = []
  for
    kind in [
      Mailbox,
      Thread,
      Email,
      SearchSnippet,
      Identity,
      EmailSubmission,
      VacationResponse,
    ] {
    out.push_iter(kind.methods().iter())
  }
  out.push("Core/echo")
  out
}

///|
/// How one property is sorted (RFC 8620 section 5.5). `keyword` and the other
/// type-specific keys are left out on purpose: a caller that needs one writes
/// its own comparator rather than having every type's vocabulary in the
/// builder.
#derive(Eq, Debug)
pub(all) struct Comparator {
  property : String
  ascending : Bool
  collation : String?
}

///|
pub extend Comparator with Eq::{equal, not_equal}

///|
pub extend Comparator with Debug::{to_repr}

///|
pub fn Comparator::new(
  property~ : String,
  ascending~ : Bool = true,
  collation? : String,
) -> Comparator {
  { property, ascending, collation, }
}

///|
fn comparator_json(comparator : Comparator) -> Json {
  let pairs : Array[(String, Json)] = [
    ("property", Json::string(comparator.property)),
    ("isAscending", Json::boolean(comparator.ascending)),
  ]
  match comparator.collation {
    Some(collation) => pairs.push(("collation", Json::string(collation)))
    None => ()
  }
  object(pairs)
}

///|
fn comparators(values : Array[Comparator]) -> Json {
  Json::array(values.map(comparator_json))
}

///|
fn maybe_string(name : String, value : String?) -> (String, Json) {
  (
    name,
    match value {
      Some(value) => Json::string(value)
      None => Json::null()
    },
  )
}

///|
fn maybe_number(name : String, value : Int32?) -> (String, Json) {
  (
    name,
    match value {
      Some(value) => number(value)
      None => Json::null()
    },
  )
}

///|
fn maybe_filter(filter : Json?) -> (String, Json) {
  (
    "filter",
    match filter {
      Some(filter) => filter
      None => Json::null()
    },
  )
}

///|
fn maybe_comparators(sort : Array[Comparator]?) -> (String, Json) {
  (
    "sort",
    match sort {
      Some(values) => comparators(values)
      None => Json::null()
    },
  )
}

///|
fn maybe_objects(name : String, values : Map[String, Json]?) -> (String, Json) {
  (
    name,
    match values {
      Some(values) =>
        match objects(values) {
          Some(object) => object
          None => Json::null()
        }
      None => Json::null()
    },
  )
}

///|
fn maybe_ids(name : String, values : Array[String]?) -> (String, Json) {
  (
    name,
    match values {
      Some(values) => strings(values)
      None => Json::null()
    },
  )
}

///|
fn maybe_boolean(name : String, value : Bool?) -> (String, Json) {
  (
    name,
    match value {
      Some(value) => Json::boolean(value)
      None => Json::null()
    },
  )
}

///|
/// The arguments every `/get` takes (RFC 8620 section 5.1). A null `ids` asks
/// for every object of the type, which is what a first list does.
fn get_args(
  account : String,
  ids : Array[String]?,
  properties : Array[String]?,
) -> Array[(String, Json)] {
  let args : Array[(String, Json)] = [("accountId", Json::string(account))]
  args.push(maybe_ids("ids", ids))
  match properties {
    Some(properties) => args.push(("properties", strings(properties)))
    None => ()
  }
  args
}

///|
/// The arguments every `/changes` takes (RFC 8620 section 5.2).
fn changes_args(
  account : String,
  since_state : String,
  max_changes : Int32?,
) -> Array[(String, Json)] {
  let args : Array[(String, Json)] = [
    ("accountId", Json::string(account)),
    ("sinceState", Json::string(since_state)),
  ]
  match max_changes {
    Some(limit) => args.push(("maxChanges", number(limit)))
    None => ()
  }
  args
}

///|
/// The arguments every `/set` takes (RFC 8620 section 5.3). Creation ids are
/// the caller's own, which is how the answer names what it made.
fn set_args(
  account : String,
  create : Map[String, Json]?,
  update : Map[String, Json]?,
  destroy : Array[String]?,
  if_in_state : String?,
) -> Array[(String, Json)] {
  let args : Array[(String, Json)] = [("accountId", Json::string(account))]
  match if_in_state {
    Some(state) => args.push(("ifInState", Json::string(state)))
    None => ()
  }
  args.push(maybe_objects("create", create))
  args.push(maybe_objects("update", update))
  args.push(maybe_ids("destroy", destroy))
  args
}

///|
/// The arguments every `/query` takes (RFC 8620 section 5.5). `calculateTotal`
/// is only worth asking when the count is shown; it costs the server a full
/// pass over what matched.
fn query_args(
  account : String,
  filter : Json?,
  sort : Array[Comparator]?,
  position : Int32?,
  anchor : String?,
  anchor_offset : Int32?,
  limit : Int32?,
  calculate_total : Bool?,
) -> Array[(String, Json)] {
  let args : Array[(String, Json)] = [("accountId", Json::string(account))]
  args.push(maybe_filter(filter))
  args.push(maybe_comparators(sort))
  match position {
    Some(value) => args.push(("position", number(value)))
    None => ()
  }
  match anchor {
    Some(value) => args.push(("anchor", Json::string(value)))
    None => ()
  }
  match anchor_offset {
    Some(value) => args.push(("anchorOffset", number(value)))
    None => ()
  }
  match limit {
    Some(value) => args.push(("limit", number(value)))
    None => ()
  }
  match calculate_total {
    Some(value) => args.push(("calculateTotal", Json::boolean(value)))
    None => ()
  }
  args
}

///|
/// The arguments every `/queryChanges` takes (RFC 8620 section 5.6): how to
/// turn the old result into the new one without fetching it again.
fn query_changes_args(
  account : String,
  since_query_state : String,
  filter : Json?,
  sort : Array[Comparator]?,
  max_changes : Int32?,
  up_to_id : String?,
  calculate_total : Bool?,
) -> Array[(String, Json)] {
  let args : Array[(String, Json)] = [
    ("accountId", Json::string(account)),
    ("sinceQueryState", Json::string(since_query_state)),
  ]
  args.push(maybe_filter(filter))
  args.push(maybe_comparators(sort))
  match max_changes {
    Some(value) => args.push(("maxChanges", number(value)))
    None => ()
  }
  match up_to_id {
    Some(value) => args.push(("upToId", Json::string(value)))
    None => ()
  }
  match calculate_total {
    Some(value) => args.push(("calculateTotal", Json::boolean(value)))
    None => ()
  }
  args
}

///|
/// A standard `/get` (RFC 8620 section 5.1): the objects of one type, whole or
/// narrowed to the properties a page shows.
pub fn Request::get(
  self : Request,
  account : String,
  kind : Kind,
  ids? : Array[String],
  properties? : Array[String],
) -> String {
  self.using_capability(kind.capability())
  self.call(kind.name() + "/get", object(get_args(account, ids, properties)))
}

///|
/// A standard `/changes` (RFC 8620 section 5.2): what happened since a state
/// string, as created, updated and destroyed ids.
pub fn Request::changes(
  self : Request,
  account : String,
  kind : Kind,
  since_state~ : String,
  max_changes? : Int32,
) -> String {
  self.using_capability(kind.capability())
  self.call(
    kind.name() + "/changes",
    object(changes_args(account, since_state, max_changes)),
  )
}

///|
/// A standard `/set` (RFC 8620 section 5.3): create, update and destroy in one
/// call, each record answered for itself.
pub fn Request::set(
  self : Request,
  account : String,
  kind : Kind,
  create? : Map[String, Json],
  update? : Map[String, Json],
  destroy? : Array[String],
  if_in_state? : String,
) -> String {
  self.using_capability(kind.capability())
  self.call(
    kind.name() + "/set",
    object(set_args(account, create, update, destroy, if_in_state)),
  )
}

///|
/// A standard `/query` (RFC 8620 section 5.5): the ids that match, in the order
/// asked for, from `position` on.
pub fn Request::query(
  self : Request,
  account : String,
  kind : Kind,
  filter? : Json,
  sort? : Array[Comparator],
  position? : Int32,
  anchor? : String,
  anchor_offset? : Int32,
  limit? : Int32,
  calculate_total? : Bool,
) -> String {
  self.using_capability(kind.capability())
  self.call(
    kind.name() + "/query",
    object(
      query_args(
        account, filter, sort, position, anchor, anchor_offset, limit, calculate_total,
      ),
    ),
  )
}

///|
/// A standard `/queryChanges` (RFC 8620 section 5.6): the difference between
/// two results of the same query, which is how a list updates without being
/// fetched again.
pub fn Request::query_changes(
  self : Request,
  account : String,
  kind : Kind,
  since_query_state~ : String,
  filter? : Json,
  sort? : Array[Comparator],
  max_changes? : Int32,
  up_to_id? : String,
  calculate_total? : Bool,
) -> String {
  self.using_capability(kind.capability())
  self.call(
    kind.name() + "/queryChanges",
    object(
      query_changes_args(
        account, since_query_state, filter, sort, max_changes, up_to_id, calculate_total,
      ),
    ),
  )
}

///|
/// A standard `/copy` (RFC 8620 section 5.4): records of one account written
/// into another. `create` maps a creation id to an object whose `id` is the
/// record in the source account; the properties beside it replace what the
/// source holds.
pub fn Request::copy(
  self : Request,
  from_account~ : String,
  account~ : String,
  kind~ : Kind,
  create~ : Map[String, Json],
  if_from_in_state? : String,
  if_in_state? : String,
  on_success_destroy_original? : Bool,
  destroy_from_if_in_state? : String,
) -> String {
  self.using_capability(kind.capability())
  let args : Array[(String, Json)] = [
    ("fromAccountId", Json::string(from_account)),
  ]
  args.push(maybe_string("ifFromInState", if_from_in_state))
  args.push(("accountId", Json::string(account)))
  args.push(maybe_string("ifInState", if_in_state))
  args.push(maybe_objects("create", Some(create)))
  match on_success_destroy_original {
    Some(value) => args.push(("onSuccessDestroyOriginal", Json::boolean(value)))
    None => ()
  }
  args.push(maybe_string("destroyFromIfInState", destroy_from_if_in_state))
  self.call(kind.name() + "/copy", object(args))
}

///|
/// `Core/echo` (RFC 8620 section 4): the arguments come back unchanged. It
/// costs a server nothing and tells a client whether its credentials, its URL
/// and its document format are right before anything else is attempted.
pub fn Request::echo(self : Request, values : Json) -> String {
  self.using_capability("urn:ietf:params:jmap:core")
  self.call("Core/echo", values)
}

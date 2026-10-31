// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What this package refuses, and where it stopped reading. `at` is an octet
/// offset into the message for `Header`, `Boundary` and `Encoding`, and a
/// UTF-16 code unit offset into the address text for `Address`.
pub(all) suberror Refused {
  /// A field with no colon, or a name with a character RFC 5322 section 2.2
  /// keeps out of names.
  Header(at~ : Int32)
  /// An address list that stopped being one.
  Address(at~ : Int32)
  /// A multipart body without a boundary, or whose closing boundary never
  /// came.
  Boundary(at~ : Int32)
  /// A transfer encoding that is unknown, or whose payload does not read back.
  Encoding(at~ : Int32)
  /// A charset that is neither built in nor passed in.
  Charset(name~ : String)
  /// A date that does not read as an RFC 5322 date-time.
  Date
} derive(Eq, Debug)

///|
pub extend Refused with Eq::{equal, not_equal}

///|
pub extend Refused with Debug::{to_repr}

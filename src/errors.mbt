// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What this library refuses, and the place it stopped reading.
///
/// `at` counts from the first byte of whatever was handed over, so that a
/// failing test prints where the loss happened and not only that one did.
pub(all) suberror Refused {
  /// A field with no colon, or a name carrying a character RFC 5322 §2.2 keeps
  /// out of names.
  Header(at~ : Int32)
  /// An address list that stopped being one.
  Address(at~ : Int32)
  /// A multipart body whose closing boundary never came.
  Boundary(at~ : Int32)
  /// A transfer encoding whose payload does not read back as it should.
  Encoding(at~ : Int32)
  /// A named charset nobody has registered.
  Charset(name~ : String)
} derive(Eq)

///|
pub extend Refused with Eq::{equal, not_equal}

///|
pub impl Show for Refused with fn output(self, logger) {
  match self {
    Header(at~) => logger.write_string("Header(at=" + at.to_string() + ")")
    Address(at~) => logger.write_string("Address(at=" + at.to_string() + ")")
    Boundary(at~) => logger.write_string("Boundary(at=" + at.to_string() + ")")
    Encoding(at~) => logger.write_string("Encoding(at=" + at.to_string() + ")")
    Charset(name~) => logger.write_string("Charset(name=" + name + ")")
  }
}

///|
pub extend Refused with Show::{to_string, output}

// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// How a session protects itself.
pub(all) enum Security {
  /// TLS from the first octet: SMTP on 465, IMAP on 993.
  Tls(@tls.Client)
  /// In the clear only until `STARTTLS`, which the session sends first and
  /// insists on: SMTP on 587, IMAP on 143. A server that does not offer it is
  /// refused rather than spoken to in the clear.
  StartTls(@tls.Client)
  /// No TLS at all, for a relay on the same host or a test server.
  Clear
}

///|
/// Why a session stopped: the server refused a step it cannot go on from (an
/// SMTP reply, an IMAP completion, a POP3 `-ERR`), a SASL mechanism refused
/// the server, or the connection closed under it.
pub(all) suberror Rejected {
  Reply(@smtp.Command, @smtp.Reply)
  Done(@imap.Status, @imap.Code?, String)
  Err(@pop3.Command, String)
  Sasl(@sasl.Refused)
  Closed
} derive(Eq, Debug)

///|
pub extend Rejected with Eq::{equal, not_equal}

///|
pub extend Rejected with Debug::{to_repr}

///|
/// How much is read from the socket at once: one TLS record.
let chunk : Int32 = 16384

///|
async fn dial(
  host : String,
  port : Int32,
  security : Security,
  now : Int64?,
) -> @tcp.Conn {
  match security {
    Tls(config) => @tcp.dial(host, port~, tls=config, now?)
    StartTls(_) | Clear => @tcp.dial(host, port~)
  }
}

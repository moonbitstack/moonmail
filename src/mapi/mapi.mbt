// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
pub(all) suberror MapiError {
  Protocol(msg~ : String)
  Truncated(msg~ : String)
}

///|
/// The three MAPI/HTTP request types, carrying the `X-RequestType` value.
pub(all) enum RequestType {
  Connect
  Execute
  Disconnect
}

///|
fn request_type_name(kind : RequestType) -> String {
  match kind {
    RequestType::Connect => "Connect"
    RequestType::Execute => "Execute"
    RequestType::Disconnect => "Disconnect"
  }
}

///|
/// ROP ids named in MS-OXCROPS §2.2.1. The payload after the two-octet ROP
/// header is per operation and is built by the caller.
pub let rop_release : Int32 = 0x01

///|
pub let rop_open_folder : Int32 = 0x02

///|
pub let rop_open_message : Int32 = 0x03

///|
pub let rop_get_properties_specific : Int32 = 0x07

///|
pub let rop_set_properties : Int32 = 0x0A

///|
pub let rop_submit_message : Int32 = 0x0E

///|
pub let rop_logon : Int32 = 0xFE

///|
/// One ROP: its id, the logon it runs under, and the operation's own octets.
pub struct Rop {
  rop_id : Int32
  logon_id : Int32
  data : Bytes
}

///|
/// A ROP request or response buffer: a little-endian size prefix followed by one
/// or more ROPs.
pub struct RopBuffer {
  rops : Array[Rop]
}

///|
pub fn RopBuffer::new() -> RopBuffer {
  { rops: [], }
}

///|
pub fn RopBuffer::add(
  self : RopBuffer,
  rop_id : Int32,
  logon_id : Int32,
  data : BytesView,
) -> Unit {
  self.rops.push({ rop_id, logon_id, data: data.to_owned(), })
}

///|
pub fn RopBuffer::count(self : RopBuffer) -> Int32 {
  self.rops.length()
}

///|
/// Encode the buffer: `RopSize` (little-endian, the size of the ROPs that
/// follow) and then each ROP as id, logon id and payload.
pub fn RopBuffer::encode(self : RopBuffer) -> Bytes {
  let rops = Buffer()
  for r in self.rops {
    rops.write_byte(r.rop_id.to_byte())
    rops.write_byte(r.logon_id.to_byte())
    rops.write_bytes(r.data[:])
  }
  let payload = rops.to_bytes()
  let out = Buffer()
  write_u16_le(out, payload.length())
  out.write_bytes(payload[:])
  out.to_bytes()
}

///|
/// Read the size prefix of a ROP buffer.
pub fn rop_size(bytes : BytesView) -> Int32 raise MapiError {
  if bytes.length() < 2 {
    raise MapiError::Truncated(msg="ROP buffer shorter than its size prefix")
  }
  bytes.at(0).to_int() + bytes.at(1).to_int() * 256
}

///|
/// Read one ROP from the bytes after a size prefix. Because a ROP's length comes
/// from its own operation, one ROP is the most that can be split off without
/// per-operation knowledge; the rest becomes its payload.
pub fn decode_one(rops : BytesView) -> Rop raise MapiError {
  if rops.length() < 2 {
    raise MapiError::Truncated(msg="ROP shorter than its header")
  }
  {
    rop_id: rops.at(0).to_int(),
    logon_id: rops.at(1).to_int(),
    data: rops[2:].to_owned(),
  }
}

///|
/// A MAPI/HTTP request: the request type, a correlation id, and the body.
pub struct MapiHttpRequest {
  request_type : RequestType
  request_id : String
  body : Bytes
}

///|
pub fn MapiHttpRequest::new(
  request_type : RequestType,
  request_id : String,
  body : BytesView,
) -> MapiHttpRequest {
  { request_type, request_id, body: body.to_owned(), }
}

///|
/// The headers a MAPI/HTTP POST carries.
pub fn MapiHttpRequest::headers(
  self : MapiHttpRequest,
) -> Array[(String, String)] {
  [
    ("Content-Type", "application/mapi-http"),
    ("X-RequestType", request_type_name(self.request_type)),
    ("X-RequestId", self.request_id),
  ]
}

///|
fn write_u16_le(out : Buffer, n : Int32) -> Unit {
  out.write_byte((n % 256).to_byte())
  out.write_byte((n / 256 % 256).to_byte())
}

///|
/// A `RopLogon` request body (MS-OXCROPS §2.2.3.1). The field order here follows
/// the commonly published layout — output handle, logon flags, open flags, store
/// state, then the user's DN — but it has not been checked against a live
/// Exchange server. Treat the octets as a starting point, not a guarantee.
pub struct LogonRequest {
  output_handle : Int32
  logon_flags : Int32
  open_flags : Int32
  store_state : Int32
  essdn : String
}

///|
pub fn LogonRequest::new(essdn : String) -> LogonRequest {
  { output_handle: 0, logon_flags: 1, open_flags: 0, store_state: 0, essdn, }
}

///|
/// The ROP payload after the two-octet header: handle, flags, the user's DN with
/// a little-endian length.
pub fn LogonRequest::encode(self : LogonRequest) -> Bytes {
  let out = Buffer()
  out.write_byte(self.output_handle.to_byte())
  out.write_byte(self.logon_flags.to_byte())
  write_u32_le(out, self.open_flags)
  write_u32_le(out, self.store_state)
  let name = @utf8.encode(self.essdn)
  write_u16_le(out, name.length())
  out.write_bytes(name[:])
  out.to_bytes()
}

///|
/// The header every ROP response opens with (MS-OXCROPS §2.2.1.2): the id, the
/// handle the response is about, and the result code. Six octets — a response
/// carries no logon id, unlike a request.
pub struct RopResponseHeader {
  rop_id : Int32
  handle_index : Int32
  return_value : Int32
}

///|
pub fn decode_rop_response_header(
  bytes : BytesView,
) -> RopResponseHeader raise MapiError {
  if bytes.length() < 6 {
    raise MapiError::Truncated(msg="ROP response header shorter than 6 octets")
  }
  {
    rop_id: bytes.at(0).to_int(),
    handle_index: bytes.at(1).to_int(),
    return_value: read_u32_le(bytes, 2),
  }
}

///|
fn write_u32_le(out : Buffer, n : Int32) -> Unit {
  let mut rest = n
  let mut i = 0
  while i < 4 {
    out.write_byte((rest % 256).to_byte())
    rest = rest / 256
    i = i + 1
  }
}

///|
fn read_u32_le(data : BytesView, at : Int32) -> Int32 {
  data.at(at).to_int() +
  data.at(at + 1).to_int() * 256 +
  data.at(at + 2).to_int() * 65536 +
  data.at(at + 3).to_int() * 16777216
}

// ------------------------------------------------------------ property tags

///|
/// `PT_I2`, a signed 16-bit value.
pub let pt_i2 : Int32 = 0x0002

///|
/// `PT_LONG`, a signed 32-bit value.
pub let pt_long : Int32 = 0x0003

///|
/// `PT_BOOLEAN`, one octet.
pub let pt_boolean : Int32 = 0x000B

///|
/// `PT_I8`, a signed 64-bit value.
pub let pt_i8 : Int32 = 0x0014

///|
/// `PT_STRING8`, an 8-bit string.
pub let pt_string8 : Int32 = 0x001E

///|
/// `PT_UNICODE`, a UTF-16 string.
pub let pt_unicode : Int32 = 0x001F

///|
/// `PT_SYSTIME`, a FILETIME.
pub let pt_systime : Int32 = 0x0040

///|
/// `PT_BINARY`, a counted blob.
pub let pt_binary : Int32 = 0x0102

///|
/// Build a property tag: the type in the low 16 bits, the property id in the
/// high 16 (MS-OXCDATA §2.2.1).
pub fn prop_tag(prop_id : Int32, prop_type : Int32) -> Int32 {
  (prop_id << 16) | (prop_type & 0xFFFF)
}

///|
/// `PidTagMessageClass` — `IPM.Note` and friends.
pub let pid_tag_message_class : Int32 = 0x001A

///|
/// `PidTagSubject`.
pub let pid_tag_subject : Int32 = 0x0037

///|
/// `PidTagClientSubmitTime`.
pub let pid_tag_client_submit_time : Int32 = 0x0039

///|
/// `PidTagMessageDeliveryTime`.
pub let pid_tag_message_delivery_time : Int32 = 0x0E06

///|
/// `PidTagMessageSize`.
pub let pid_tag_message_size : Int32 = 0x0E08

///|
/// `PidTagParentFolderId`.
pub let pid_tag_parent_folder_id : Int32 = 0x0E09

///|
/// `PidTagDisplayTo`.
pub let pid_tag_display_to : Int32 = 0x0E04

///|
/// `PidTagSenderName`.
pub let pid_tag_sender_name : Int32 = 0x0C1A

///|
/// `PidTagEntryId` — the object's store-wide identifier.
pub let pid_tag_entry_id : Int32 = 0x0FFF

///|
/// `PidTagBody`.
pub let pid_tag_body : Int32 = 0x1000

///|
/// `PidTagDisplayName`.
pub let pid_tag_display_name : Int32 = 0x3001

///|
/// `PidTagEmailAddress`.
pub let pid_tag_email_address : Int32 = 0x3003

///|
/// `PidTagFolderType`.
pub let pid_tag_folder_type : Int32 = 0x3601

///|
/// `PidTagContentCount`.
pub let pid_tag_content_count : Int32 = 0x3602

// --------------------------------------------------------------- rop builders

///|
/// `RopGetHierarchyTable` (0x04).
pub let rop_get_hierarchy_table : Int32 = 0x04

///|
/// `RopGetContentsTable` (0x05).
pub let rop_get_contents_table : Int32 = 0x05

///|
/// `RopSetColumns` (0x12).
pub let rop_set_columns : Int32 = 0x12

///|
/// `RopQueryRows` (0x15).
pub let rop_query_rows : Int32 = 0x15

///|
/// `RopRelease` (0x01): input handle, one octet.
///
/// Every builder in this section lays its fields out in the order MS-OXCROPS
/// gives them. None has been checked against a live Exchange server, so treat
/// the octets as a starting point rather than a guarantee; the tests here pin
/// the layout, not the server's agreement with it.
pub fn rop_release_request(input_handle : Int32) -> Bytes {
  let out = Buffer()
  out.write_byte(input_handle.to_byte())
  out.to_bytes()
}

///|
/// `RopOpenFolder` (§2.2.4.1): input handle, output handle, and the 64-bit
/// folder id.
pub fn rop_open_folder_request(
  input_handle : Int32,
  output_handle : Int32,
  folder_id : Int64,
) -> Bytes {
  let out = Buffer()
  out.write_byte(input_handle.to_byte())
  out.write_byte(output_handle.to_byte())
  write_i64_le(out, folder_id)
  out.to_bytes()
}

///|
/// `RopOpenMessage` (§2.2.6.1): handles, code page, folder id, message id and
/// the open-mode flags.
pub fn rop_open_message_request(
  input_handle : Int32,
  output_handle : Int32,
  code_page : Int32,
  folder_id : Int64,
  message_id : Int64,
  open_mode : Int32,
) -> Bytes {
  let out = Buffer()
  out.write_byte(input_handle.to_byte())
  out.write_byte(output_handle.to_byte())
  write_u16_le(out, code_page)
  write_i64_le(out, folder_id)
  write_i64_le(out, message_id)
  out.write_byte(open_mode.to_byte())
  out.to_bytes()
}

///|
/// `RopGetHierarchyTable` and `RopGetContentsTable` share a layout (§2.2.4.3,
/// §2.2.4.4): input handle, output handle, table flags.
pub fn rop_get_table_request(
  input_handle : Int32,
  output_handle : Int32,
  table_flags : Int32,
) -> Bytes {
  let out = Buffer()
  out.write_byte(input_handle.to_byte())
  out.write_byte(output_handle.to_byte())
  out.write_byte(table_flags.to_byte())
  out.to_bytes()
}

///|
/// `RopSetColumns` (§2.2.5.1): input handle, flags, then the property tags the
/// rows should carry.
pub fn rop_set_columns_request(
  input_handle : Int32,
  set_columns_flags : Int32,
  tags : Array[Int32],
) -> Bytes {
  let out = Buffer()
  out.write_byte(input_handle.to_byte())
  out.write_byte(set_columns_flags.to_byte())
  write_u16_le(out, tags.length())
  for tag in tags {
    write_u32_le(out, tag)
  }
  out.to_bytes()
}

///|
/// `RopQueryRows` (§2.2.5.4): input handle, flags, forward-read, row count.
pub fn rop_query_rows_request(
  input_handle : Int32,
  query_rows_flags : Int32,
  forward_read : Bool,
  row_count : Int32,
) -> Bytes {
  let out = Buffer()
  out.write_byte(input_handle.to_byte())
  out.write_byte(query_rows_flags.to_byte())
  out.write_byte(if forward_read { 1 } else { 0 })
  write_u16_le(out, row_count)
  out.to_bytes()
}

///|
/// `RopGetPropertiesSpecific` (§2.2.8.1): the size limit, whether strings come
/// back as UTF-16, and the tags wanted.
pub fn rop_get_properties_specific_request(
  size_limit : Int32,
  want_unicode : Bool,
  tags : Array[Int32],
) -> Bytes {
  let out = Buffer()
  write_u16_le(out, size_limit)
  out.write_byte(if want_unicode { 1 } else { 0 })
  write_u16_le(out, tags.length())
  for tag in tags {
    write_u32_le(out, tag)
  }
  out.to_bytes()
}

///|
/// A `RopLogon` response (§2.2.3.1.2), decoded as far as the folder ids: the
/// header, the logon flags, the store state, then `folder_count` 64-bit folder
/// ids. Whether a server agrees with this layout has not been checked against a
/// live one.
pub struct LogonResponse {
  header : RopResponseHeader
  logon_flags : Int32
  store_state : Int32
  folder_ids : Array[Int64]
}

///|
pub fn decode_logon_response(
  bytes : BytesView,
  folder_count : Int32,
) -> LogonResponse raise MapiError {
  let header = decode_rop_response_header(bytes)
  // header is 6 octets; flags at 6, store state at 7..11, ids from 11.
  let start = 11
  let need = start + folder_count * 8
  if bytes.length() < need {
    raise MapiError::Truncated(
      msg="RopLogon response shorter than its folder ids",
    )
  }
  let ids : Array[Int64] = []
  let mut i = 0
  while i < folder_count {
    ids.push(read_i64_le(bytes, start + i * 8))
    i = i + 1
  }
  {
    header,
    logon_flags: bytes.at(6).to_int(),
    store_state: read_u32_le(bytes, 7),
    folder_ids: ids,
  }
}

///|
fn write_i64_le(out : Buffer, n : Int64) -> Unit {
  let mut rest = n
  let mut i = 0
  while i < 8 {
    let byte = (rest & 0xFFL).to_int()
    out.write_byte(byte.to_byte())
    rest = rest >> 8
    i = i + 1
  }
}

///|
fn read_i64_le(data : BytesView, at : Int32) -> Int64 {
  let mut value : Int64 = 0L
  let mut i = 7
  while i >= 0 {
    value = (value << 8) | data.at(at + i).to_int().to_int64()
    i = i - 1
  }
  value
}

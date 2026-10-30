// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
test "mapi rop buffer frames with a size prefix" {
  let buf = @mapi.RopBuffer::new()
  buf.add(@mapi.rop_logon, 0, b"\x01\x02"[:])
  buf.add(@mapi.rop_release, 1, b""[:])
  let bytes = buf.encode()
  // ROPs: (2 + 2) + (2 + 0) = 6, plus the two-octet prefix.
  inspect(bytes.length(), content="8")
  inspect(@mapi.rop_size(bytes[:]) catch { _ => -1 }, content="6")
  inspect(buf.count(), content="2")
}

///|
test "mapi decodes a single rop" {
  let mut rop_id = -1
  let mut logon_id = -1
  let mut data_len = -1
  try {
    let rop = @mapi.decode_one(b"\xfe\x07\xaa\xbb"[:])
    rop_id = rop.rop_id
    logon_id = rop.logon_id
    data_len = rop.data.length()
  } catch {
    _ => ()
  }
  inspect(rop_id, content="254")
  inspect(logon_id, content="7")
  inspect(data_len, content="2")
}

///|
test "mapi rejects truncated input" {
  let rop_raised = try {
    let _ = @mapi.decode_one(b"\xfe"[:])
    false
  } catch {
    _ => true
  }
  inspect(rop_raised, content="true")
  let size_raised = try {
    let _ = @mapi.rop_size(b"\x01"[:])
    false
  } catch {
    _ => true
  }
  inspect(size_raised, content="true")
}

///|
test "mapi http request names the request type" {
  let req = @mapi.MapiHttpRequest::new(
    @mapi.RequestType::Execute,
    "id-1",
    b"\x00\x00"[:],
  )
  let mut request_type = ""
  let mut request_id = ""
  for entry in req.headers() {
    if entry.0 == "X-RequestType" {
      request_type = entry.1
    }
    if entry.0 == "X-RequestId" {
      request_id = entry.1
    }
  }
  inspect(request_type, content="Execute")
  inspect(request_id, content="id-1")
}

///|
test "mapi encodes a logon request" {
  let bytes = @mapi.LogonRequest::new("alice").encode()
  inspect(
    bytes == b"\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x05\x00alice",
    content="true",
  )
  inspect(bytes.length(), content="17")
}

///|
test "mapi decodes a rop response header" {
  let mut rop_id = -1
  let mut handle = -1
  let mut rv = -1
  try {
    let header = @mapi.decode_rop_response_header(
      b"\xfe\x02\x01\x00\x00\x00"[:],
    )
    rop_id = header.rop_id
    handle = header.handle_index
    rv = header.return_value
  } catch {
    _ => ()
  }
  inspect(rop_id, content="254")
  inspect(handle, content="2")
  // A response header is six octets: RopId, handle, then the result.
  inspect(rv, content="1")
}

///|
test "mapi rejects a short rop response header" {
  let raised = try {
    let _ = @mapi.decode_rop_response_header(b"\xfe\x00"[:])
    false
  } catch {
    _ => true
  }
  inspect(raised, content="true")
}

///|
test "mapi builds a property tag" {
  // 0x0037 and 0x001F in one word: id high, type low.
  inspect(
    @mapi.prop_tag(@mapi.pid_tag_subject, @mapi.pt_unicode),
    content="3604511",
  )
  inspect(
    @mapi.prop_tag(@mapi.pid_tag_message_size, @mapi.pt_long),
    content="235405315",
  )
}

///|
test "mapi encodes a release and an open folder" {
  let release = @mapi.rop_release_request(2)
  inspect(release == b"\x02", content="true")
  // Folder id 0x0000000000000102, little-endian.
  let open = @mapi.rop_open_folder_request(1, 2, 258L)
  inspect(open == b"\x01\x02\x02\x01\x00\x00\x00\x00\x00\x00", content="true")
  inspect(open.length(), content="10")
}

///|
test "mapi encodes an open message" {
  let bytes = @mapi.rop_open_message_request(1, 2, 1252, 258L, 512L, 0)
  // handles, code page 0x04E4 (1252), folder 0x0102, message 0x0200, mode.
  inspect(
    bytes ==
    b"\x01\x02\xe4\x04\x02\x01\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00",
    content="true",
  )
  inspect(bytes.length(), content="21")
}

///|
test "mapi encodes table and column requests" {
  let table = @mapi.rop_get_table_request(1, 2, 0)
  inspect(table == b"\x01\x02\x00", content="true")
  let columns = @mapi.rop_set_columns_request(3, 0, [
    @mapi.prop_tag(@mapi.pid_tag_subject, @mapi.pt_unicode),
    @mapi.prop_tag(@mapi.pid_tag_message_size, @mapi.pt_long),
  ])
  // handle, flags, count (2, little-endian), then the tags, also little-endian:
  // 0x0037001F and 0x0E080003.
  inspect(columns.length(), content="12")
  inspect(
    columns == b"\x03\x00\x02\x00\x1f\x00\x37\x00\x03\x00\x08\x0e",
    content="true",
  )
  let rows = @mapi.rop_query_rows_request(3, 0, true, 100)
  inspect(rows == b"\x03\x00\x01\x64\x00", content="true")
}

///|
test "mapi encodes a get properties specific request" {
  let bytes = @mapi.rop_get_properties_specific_request(4096, true, [
    @mapi.prop_tag(@mapi.pid_tag_body, @mapi.pt_unicode),
  ])
  // size limit, want-unicode, count, then the tag (0x1000001F, little-endian).
  inspect(bytes == b"\x00\x10\x01\x01\x00\x1f\x00\x00\x10", content="true")
  inspect(bytes.length(), content="9")
}

///|
test "mapi decodes a logon response" {
  // header (RopId 0xFE, handle 1, result 0), flags 1, store state 2,
  // then two folder ids: 0x0102 and 0x030405060708090a.
  let bytes = b"\xfe\x01\x00\x00\x00\x00\x01\x02\x00\x00\x00\x02\x01\x00\x00\x00\x00\x00\x00\x0a\x09\x08\x07\x06\x05\x04\x03"[:]
  let mut flags = -1
  let mut state = -1
  let mut ids = 0
  let mut first = 0L
  let mut second = 0L
  try {
    let reply = @mapi.decode_logon_response(bytes, 2)
    flags = reply.logon_flags
    state = reply.store_state
    ids = reply.folder_ids.length()
    first = reply.folder_ids[0]
    second = reply.folder_ids[1]
  } catch {
    _ => ()
  }
  inspect(flags, content="1")
  inspect(state, content="2")
  inspect(ids, content="2")
  inspect(first, content="258")
  inspect(second, content="217304205466536202")
}

///|

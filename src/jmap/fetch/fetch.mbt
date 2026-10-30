// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A JMAP client that posts over moonfetch. Everything about the protocol — the
/// session, the request body, the method responses — is `@jmap`; this only does
/// the HTTP hop.
pub struct Client {
  api_url : String
  headers : Array[(String, String)]
}

///|
pub fn Client::new(
  api_url : String,
  headers : Array[(String, String)],
) -> Client {
  { api_url, headers, }
}

///|
/// GET the session resource.
pub async fn Client::session(
  self : Client,
) -> @jmap.Session raise @jmap.JmapError {
  let response = @moonfetch.get(self.api_url, headers=self.headers) catch {
    _ => raise @jmap.JmapError::Transport(msg="moonfetch GET failed")
  }
  if response.status < 200 || response.status >= 300 {
    raise @jmap.JmapError::Http(
      status=response.status,
      body=@utf8.decode_lossy(response.body[:]),
    )
  }
  @jmap.parse_session(@utf8.decode_lossy(response.body[:]))
}

///|
/// POST a request and parse its method responses.
pub async fn Client::send(
  self : Client,
  request : @jmap.Request,
) -> @jmap.ResponseBody raise @jmap.JmapError {
  let body = @utf8.encode(@jmap.dumps_request(request))
  let response = @moonfetch.post(
    self.api_url,
    body=@moonfetch.Body::Bytes(body),
    headers=self.headers,
  ) catch {
    _ => raise @jmap.JmapError::Transport(msg="moonfetch POST failed")
  }
  if response.status < 200 || response.status >= 300 {
    raise @jmap.JmapError::Http(
      status=response.status,
      body=@utf8.decode_lossy(response.body[:]),
    )
  }
  @jmap.parse_response(@utf8.decode_lossy(response.body[:]))
}

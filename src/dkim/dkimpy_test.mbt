// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The signatures in `vectors_test.mbt` were made by dkimpy over messages it
/// chose, so this is the one direction where the two implementations are
/// really independent: nothing here was signed by this library, and a pass says
/// RFC 6376 was read the same way twice rather than that this library agrees
/// with itself. The other direction — what this library signs, dkimpy
/// verifying — runs in CI, where Python is available.
test "dkimpy's signatures verify here" {
  let mut passed = 0
  let mut refused = 0
  for vector in dkimpy_vectors {
    let (name, message, record, should_pass) = vector
    let verdicts = @dkim.verify(
      crlf(message)[:],
      fn(_) { Some(record) },
      now=1528637910,
    )
    assert_eq(verdicts.length(), 1)
    let verdict = verdicts[0]
    if should_pass {
      assert_true(verdict is Pass(domain="example.com", selector="sel"))
      passed = passed + 1
    } else {
      match verdict {
        Fail(reason~, ..) => {
          // A body that changed after signing is the body hash, not the
          // signature: the two failures mean different things and a reader
          // should be able to tell them apart.
          assert_eq(reason, "the body hash does not match")
          refused = refused + 1
        }
        _ =>
          fail(
            name + ": expected a failure, got " + verdict.to_repr().to_string(),
          )
      }
    }
  }
  assert_eq(passed, 9)
  assert_eq(refused, 1)
}

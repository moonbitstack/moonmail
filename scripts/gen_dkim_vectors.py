#!/usr/bin/env python3
# Copyright 2026 Leo Cheng
# SPDX-License-Identifier: Apache-2.0
"""Write src/dkim/vectors_test.mbt: messages signed by dkimpy, and what this
library has to make of them.

The point is independence. The signatures here are produced by an
implementation that shares no code with this one, over messages this one did
not choose, so a test that verifies them says something about the
specification rather than about this library's agreement with itself.

    python3 scripts/gen_dkim_vectors.py            # write the file
    python3 scripts/gen_dkim_vectors.py --check    # fail if it is not current

dkimpy signs at the time it is called, so the clock is frozen for the run and
`t=` is the same on every regeneration; without that the vectors would change
every time and cannot be committed. The keys are test keys: they sign nothing
that leaves this repository.
"""

import base64
import pathlib
import sys
import time

import dkim

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "src" / "dkim" / "vectors_test.mbt"

STAMP = 1528637909

# The keys the vectors are signed with. They are test keys and sign nothing
# that leaves this repository; they are here as base64 of the DER, because a PEM
# broken across lines is easy to mangle when it is copied around.
RSA_KEY = base64.b64decode(
    "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDMW/ihyctXMwbl5o1RUuG6megj8BPXX4UdVuWykWlrjixkR9g+7cqKTKdEqzG7kd+AQrc1fmLc6gxSL/U5BdB9eyPpVstDSd1MaGyCO+8XdGM5aCpJ6UJI++qi2o4rDIE7RKKpcHKj9VjQqE474B/jNCh/LTYgJ5ihbyQ+SakEwGQ7HtN2bxe+xaYdZVEakEDxb1yBmgWLvvI1IgvR2010ZpUjJ4orj/V77gj/Ryq9OncmSbuF1/7S1XnX2PWTpAa0S3XdqalEB2ZFEFioYABWOH1bnUsIjEAYsheVOdaDoo0bH9StC0D3jECs65DPWRoWXvn6WUhh4k2MgLlFVXLdAgMBAAECggEAOL8/Svnkp6mpPDTpwA/iU7VCM5yKfe9t4OhM72mWmwHHTO9wWoUgjYfcmOJq9Hl81Tpxcn7OiCbL1hSwJS36p6WGothxqBU+SOXkX8Ox0FMG7J2CxLRrriWaEa/b85NM3X7hJmjtxJ6wE3zxAIprgGVu62XMFmC4bveUWmGM+B7PhbsD4Xwqlzbix+GdGmipmhYSSZ3PBS7+iYjiBt2pna824PPpd1RfNuWoE9oxUQOZq7V9zquHPXc/QYWmaLlhXkgNWu5Z4jrs9EHOsLXNJ8hj7gafET2ShyTB41KHI9DbTtL3vFXo7wjQqh76UM/ig8Vvhy0HURCLEA0OTBnoZwKBgQDqPyfi0o2zjyKXSFuSuSJrVRbLGrz1mWL3Pg9mv7nvv8vQNttDXyEccaLKejfb5F9O0sD6EzJEXq9toN0FObDuuWGKOYUSPiGa5jScAKilzUbphDVAhITzVxmDjxYGABOpxjM9/nxIbIV6JzKyW+NLGaDyP02IvHs54B+9nIGUTwKBgQDfVkn0lDWC8gmX0iCuJ2Q5+Ao1gYFXyZe4XTN4MXu0hdARjRoSfmQbYkV2hxwbTzQmgBF+nq4ARM5WFZcV9/J1mCgmwFg0Z4+lGwCF63o/gsgZAj1wBM+P7jvh9ir7cujonIPH58gHvkwqaBoUmvGWW6WKzmbDR/iSLWokkkg/EwKBgEwRSkCMI1vl5VO/OY2B9T1pmkdGXYpbzxl+272AET9bxzHMPpO4NqZn+HdMDQupM5IDOot65F3zaYBuNpfVzjEXnicm2qG772m/y+HFDP8alCaMukZDQnFLHYvtUTeNmtUM+eLt2yoho46xX/Mvh7YBkpRYHjODEXkP4P7P7fxdAoGAeWuCPZQuG4jXKlE1Lzl/RfzSIBDObxnMgJE7IEdWx+hQHJqn6BIK/tBIj44Y+8ftxFiwKjS+yKqfuzF1uJ3alZAplBfSXHtJHyw09pn1Fn5VpzMOj84twkR1Df41lAr/ESe2hYI/v+X3pr5+H2G1olclAvf/6n9AZsiGAmf9Gz0CgYBk8VtoeHN3Y+bk+RNxrsiuIkb4uUSgFWLouKG+NkN4qDNx9qXAx14bzWcCqJJBaoJeFnRloTiGRTzgzXann26RUv7nMq+NEVwXxyEpPPgkiGCqcwhtOlsya7lejynM1yAV2CNmtSHrQCRT5NUh8iTYUfDHUC/JDoNPgkParcGvPQ=="
)

RSA_RECORD = (
    "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzFv4ocnLVzMG5eaNUVLhupnoI/AT11+FHVblspFpa44sZEfYPu3KikynRKsxu5HfgEK3NX5i3OoMUi/1OQXQfXsj6VbLQ0ndTGhsgjvvF3RjOWgqSelCSPvqotqOKwyBO0SiqXByo/VY0KhOO+Af4zQofy02ICeYoW8kPkmpBMBkOx7Tdm8XvsWmHWVRGpBA8W9cgZoFi77yNSIL0dtNdGaVIyeKK4/1e+4I/0cqvTp3Jkm7hdf+0tV519j1k6QGtEt13ampRAdmRRBYqGAAVjh9W51LCIxAGLIXlTnWg6KNGx/UrQtA94xArOuQz1kaFl75+llIYeJNjIC5RVVy3QIDAQAB"
)

ED25519_KEY = base64.b64decode(
    "MC4CAQAwBQYDK2VwBCIEIJRrbCgyBvSRSx9V5+Kbz8o3bt9ci8ntNFllJR9fzC6T"
)

ED25519_RECORD = "v=DKIM1; k=ed25519; p=GvAroped8ssrp7v3ZmowHX9essGj/e1vcf9ZhhZBpjM="

HEADERS = [b"from", b"to", b"subject", b"date", b"message-id"]


def version() -> str:
    """The dkimpy version these vectors came from."""
    import importlib.metadata

    return importlib.metadata.version("dkimpy")


def rsa_record() -> str:
    """The DNS record of the RSA key, read out of the key itself."""
    from cryptography.hazmat.primitives.serialization import (
        Encoding,
        PublicFormat,
        load_der_private_key,
    )

    key = load_der_private_key(RSA_KEY, password=None)
    der = key.public_key().public_bytes(Encoding.DER, PublicFormat.SubjectPublicKeyInfo)
    return "v=DKIM1; k=rsa; p=" + base64.b64encode(der).decode()


def message(subject: str, body: bytes, extra: str = "") -> bytes:
    text = (
        "From: Alice <alice@example.com>\r\n"
        "To: Bob <bob@example.com>\r\n"
        f"Subject: {subject}\r\n"
        "Date: Fri, 06 Nov 2026 12:00:00 +0000\r\n"
        "Message-ID: <vector@example.com>\r\n"
        f"{extra}"
        "MIME-Version: 1.0\r\n"
        "Content-Type: text/plain; charset=utf-8\r\n"
        "\r\n"
    )
    return text.encode() + body


def pem_of(der: bytes) -> bytes:
    """The key as dkimpy wants it: PEM, which is what it reads."""
    from cryptography.hazmat.primitives.serialization import (
        Encoding,
        NoEncryption,
        PrivateFormat,
        load_der_private_key,
    )

    key = load_der_private_key(der, password=None)
    return key.private_bytes(Encoding.PEM, PrivateFormat.PKCS8, NoEncryption())


def sign(raw: bytes, canon: tuple, algorithm: bytes, length: bool = False) -> bytes:
    # dkimpy takes an RSA key as PEM and an ed25519 one as the base64 of its
    # 32-byte seed, which is what its own signer is built on.
    if algorithm == b"rsa-sha256":
        key = pem_of(RSA_KEY)
    else:
        from cryptography.hazmat.primitives.serialization import load_der_private_key

        seed = load_der_private_key(ED25519_KEY, password=None).private_bytes_raw()
        key = base64.b64encode(seed)
    return dkim.sign(
        raw,
        b"sel",
        b"example.com",
        key,
        canonicalize=canon,
        signature_algorithm=algorithm,
        include_headers=HEADERS,
        length=length,
    ) + raw


CASES = [
    (
        "relaxed over relaxed",
        "Relaxed both ways",
        b"Hi.\r\n\r\nSee you at noon.\r\n",
        (b"relaxed", b"relaxed"),
        b"rsa-sha256",
        False,
        True,
    ),
    (
        "simple over simple",
        "Simple both ways",
        b"Hi.\r\n\r\nSee you at noon.\r\n",
        (b"simple", b"simple"),
        b"rsa-sha256",
        False,
        True,
    ),
    (
        "relaxed headers, simple body",
        "Mixed canonicalization",
        b"Line one.\r\n\r\nLine two.\r\n",
        (b"relaxed", b"simple"),
        b"rsa-sha256",
        False,
        True,
    ),
    (
        "simple headers, relaxed body",
        "The other mix",
        b"Line one.\r\n\r\nLine two.\r\n",
        (b"simple", b"relaxed"),
        b"rsa-sha256",
        False,
        True,
    ),
    (
        "a folded subject",
        "A subject that needs\r\n folding",
        b"Hi.\r\n",
        (b"relaxed", b"relaxed"),
        b"rsa-sha256",
        False,
        True,
    ),
    (
        "trailing empty lines in a relaxed body",
        "Signed before the blanks",
        b"Trailing blanks follow.\r\n\r\n\r\n",
        (b"relaxed", b"relaxed"),
        b"rsa-sha256",
        False,
        True,
    ),
    (
        "an empty body",
        "Nothing said",
        b"",
        (b"relaxed", b"relaxed"),
        b"rsa-sha256",
        False,
        True,
    ),
    (
        "a length-limited body hash",
        "Signed up to here",
        b"The part that is signed.\r\n\r\nThe part that is not.\r\n",
        (b"relaxed", b"relaxed"),
        b"rsa-sha256",
        True,
        True,
    ),
    (
        "ed25519",
        "Signed with a curve",
        b"Short and to the point.\r\n",
        (b"relaxed", b"relaxed"),
        b"ed25519-sha256",
        False,
        True,
    ),
    (
        "a body changed after signing",
        "Tampered",
        b"Original wording.\r\n",
        (b"relaxed", b"relaxed"),
        b"rsa-sha256",
        False,
        False,
    ),
]


def moonbit_string(text: str) -> str:
    """The message as a `#|` block, one line per line, without its CRLFs."""
    lines = text.replace("\r\n", "\n").split("\n")
    # A trailing newline ends the last line; the block does not need an empty
    # one, since the reader's own join puts it back.
    if lines and lines[-1] == "":
        lines = lines[:-1]
    return "\n".join("#|" + line for line in lines)


def main() -> int:
    # dkimpy reads the clock when it signs, so the vectors would change on every
    # run without this. Everything else it does is deterministic.
    time.time = lambda: float(STAMP)

    record = rsa_record()
    if record != RSA_RECORD:
        print("the RSA record in this script does not match its key", file=sys.stderr)
        return 2

    out = [
        "// Copyright 2026 Leo Cheng",
        "// SPDX-License-Identifier: Apache-2.0",
        "",
        "// Generated by scripts/gen_dkim_vectors.py from dkimpy %s. Do not edit."
        % version(),
        "",
        "///|",
        "/// The signatures dkimpy made, over messages it did not choose, so that",
        "/// verifying them says something about RFC 6376 rather than about this",
        "/// library agreeing with itself. The time is frozen in the generator:",
        "/// `t=%d` in every one of them." % STAMP,
        "",
        "///|",
        "/// One case: what it is called, the message as it goes on the wire, the",
        "/// record the key is published under, and whether the signature has to",
        "/// verify.",
        "let dkimpy_vectors : Array[(String, String, String, Bool)] = [",
    ]
    for name, subject, body, canon, algorithm, length, expect_pass in CASES:
        signed = sign(message(subject, body), canon, algorithm, length)
        if name.startswith("a body changed"):
            signed = signed.replace(b"Original wording.", b"Changed wording.")
        record = ED25519_RECORD if algorithm == b"ed25519-sha256" else rsa_record()
        out.append("  (")
        out.append('    "%s",' % name)
        # The message goes in parentheses: a multiline string belongs where it
        # can be read as one expression, and the comma after it must not land
        # on the last line of the message itself.
        out.append("    (")
        for line in moonbit_string(signed.decode()).split("\n"):
            out.append("      " + line)
        out.append("    ),")
        out.append('    "%s",' % record)
        out.append("    %s," % ("true" if expect_pass else "false"))
        out.append("  ),")
    out.append("]")
    text = "\n".join(out) + "\n"

    if "--check" in sys.argv:
        current = OUT.read_text(encoding="utf-8") if OUT.exists() else ""
        if current != text:
            print(f"{OUT.relative_to(ROOT)} is not current; run the generator", file=sys.stderr)
            return 1
        print(f"{OUT.relative_to(ROOT)} is current")
        return 0
    OUT.write_text(text, encoding="utf-8", newline="\n")
    print(f"wrote {OUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())

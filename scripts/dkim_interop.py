#!/usr/bin/env python3
# Copyright 2026 Leo Cheng
# SPDX-License-Identifier: Apache-2.0
"""Check what this library signs against dkimpy, which is the other half of the
interoperability question: `src/dkim/dkimpy_test.mbt` covers what dkimpy signed
being verified here, and this covers the reverse.

    moon build --target native
    python3 scripts/dkim_interop.py

Every case is signed by `src/examples/dkim-sign`, the resulting header is put
above the message, and dkimpy decides whether the signature holds. A library
that agrees with itself is not evidence of anything, so the verifier here shares
no code with the signer there.
"""

import base64
import pathlib
import subprocess
import sys
import tempfile

import dkim
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import ed25519, rsa

ROOT = pathlib.Path(__file__).resolve().parent.parent
EXAMPLE = "src/examples/dkim-sign"


def keypair(algorithm: str):
    """A fresh key, its PEM as this library reads it, and its DNS record."""
    if algorithm == "rsa":
        key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        pem = key.private_bytes(
            serialization.Encoding.PEM,
            serialization.PrivateFormat.TraditionalOpenSSL,
            serialization.NoEncryption(),
        )
        der = key.public_key().public_bytes(
            serialization.Encoding.DER, serialization.PublicFormat.SubjectPublicKeyInfo
        )
        record = b"v=DKIM1; k=rsa; p=" + base64.b64encode(der)
    else:
        key = ed25519.Ed25519PrivateKey.generate()
        pem = key.private_bytes(
            serialization.Encoding.PEM,
            serialization.PrivateFormat.PKCS8,
            serialization.NoEncryption(),
        )
        raw = key.public_key().public_bytes(
            serialization.Encoding.Raw, serialization.PublicFormat.Raw
        )
        record = b"v=DKIM1; k=ed25519; p=" + base64.b64encode(raw)
    return pem, record


MESSAGES = [
    (
        "a short letter",
        b"From: Alice <alice@example.com>\r\n"
        b"To: Bob <bob@example.com>\r\n"
        b"Subject: Lunch\r\n"
        b"Date: Fri, 06 Nov 2026 12:00:00 +0000\r\n"
        b"Message-ID: <one@example.com>\r\n"
        b"\r\n"
        b"Noon works.\r\n",
    ),
    (
        "a folded subject and an eight-bit body",
        b"From: Alice <alice@example.com>\r\n"
        b"To: Bob <bob@example.com>\r\n"
        b"Subject: a subject that is long enough to be\r\n folded over two lines\r\n"
        b"Date: Fri, 06 Nov 2026 12:00:00 +0000\r\n"
        b"Message-ID: <two@example.com>\r\n"
        b"MIME-Version: 1.0\r\n"
        b"Content-Type: text/plain; charset=utf-8\r\n"
        b"Content-Transfer-Encoding: 8bit\r\n"
        b"\r\n"
        b"Za\xc5\xbc\xc3\xb3\xc5\x82\xc4\x87 g\xc4\x99\xc5\x9bl\xc4\x85 ja\xc5\xba\xc5\x84.\r\n",
    ),
    (
        "an empty body",
        b"From: Alice <alice@example.com>\r\n"
        b"To: Bob <bob@example.com>\r\n"
        b"Subject: Nothing said\r\n"
        b"Date: Fri, 06 Nov 2026 12:00:00 +0000\r\n"
        b"Message-ID: <three@example.com>\r\n"
        b"\r\n",
    ),
]


def sign_with_example(workdir: pathlib.Path, pem: bytes, message: bytes, name: str):
    """Run the example over one message and answer its header and the letter."""
    key_path = workdir / "key.pem"
    message_path = workdir / "message.eml"
    key_path.write_bytes(pem)
    message_path.write_bytes(message)
    run = subprocess.run(
        [
            "moon",
            "run",
            "--target",
            "native",
            EXAMPLE,
            "--",
            str(key_path),
            str(message_path),
            "sel",
            "example.com",
        ],
        cwd=ROOT,
        capture_output=True,
    )
    if run.returncode != 0:
        raise SystemExit(
            f"{name}: the example exited {run.returncode}\n"
            + run.stderr.decode(errors="replace")
        )
    # The example answers with the header alone; the letter is the file that was
    # handed to it, and putting the two together here is what a mail client does.
    header = run.stdout.decode().strip()
    if not header.startswith("DKIM-Signature:"):
        raise SystemExit(f"{name}: the example printed no signature: {header!r}")
    return header, message


def main() -> int:
    failures = 0
    cases = 0
    with tempfile.TemporaryDirectory() as directory:
        workdir = pathlib.Path(directory)
        for algorithm in ("rsa", "ed25519"):
            pem, record = keypair(algorithm)
            for name, message in MESSAGES:
                cases += 1
                try:
                    header, letter = sign_with_example(workdir, pem, message, name)
                except SystemExit as failure:
                    print(failure)
                    failures += 1
                    continue
                signed = header.encode() + b"\r\n" + letter
                # dkimpy decides; the record is the only thing it is given
                # besides the message, which is what a verifier has.
                verdict = dkim.verify(
                    signed, dnsfunc=lambda _name, timeout=5: record
                )
                if not verdict:
                    print(f"{algorithm} / {name}: dkimpy refused the signature")
                    failures += 1
                    continue
                # And a body changed under the signature has to be refused, or
                # the pass above says nothing about what was covered.
                tampered = signed.replace(b"Noon works.", b"Goodnight.").replace(
                    b"Za\xc5\xbc", b"Qa\xc5\xbc"
                )
                if tampered != signed and dkim.verify(
                    tampered, dnsfunc=lambda _name, timeout=5: record
                ):
                    print(f"{algorithm} / {name}: dkimpy accepted a changed body")
                    failures += 1
    print(f"{cases - failures} of {cases} signatures dkimpy accepts")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())

#!/bin/sh
# The reference mail services the live tests talk to: Dovecot for IMAP and POP3,
# Postfix for SMTP, both on the account `mailtest`, both writing and reading
# /var/tmp/moonmail-interop/mail/mailtest/Maildir.
#
#   sudo scripts/interop/services.sh start   # and print the MOONMAIL_LIVE line
#   sudo scripts/interop/services.sh stop    # take them down and remove all trace
#
# Both run under this repository's own configuration, on their own queue and
# base directory, so a Dovecot or Postfix the machine already serves is left
# alone. Needs dovecot-imapd, dovecot-pop3d and postfix from the distribution.
set -eu

base=/var/tmp/moonmail-interop
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
work=$(CDPATH= cd -- "$here/../.." && pwd)
account=mailtest

fail() {
  echo "$1" >&2
  exit 1
}

listening() {
  python3 - "$1" <<'PY'
import socket, sys
try:
    socket.create_connection(("127.0.0.1", int(sys.argv[1])), timeout=1).close()
except OSError:
    sys.exit(1)
PY
}

stop() {
  if [ -f "$base/conf/main.cf" ]; then
    postfix -c "$base/conf" stop 2>/dev/null || true
  fi
  if [ -f "$base/conf/dovecot.conf" ]; then
    dovecot -c "$base/conf/dovecot.conf" stop 2>/dev/null || true
  fi
  if [ -f "$base/run/master.pid" ]; then
    kill "$(cat "$base/run/master.pid")" 2>/dev/null || true
  fi
  rm -rf "$base"
  if id "$account" >/dev/null 2>&1; then
    userdel "$account" 2>/dev/null || true
  fi
}

start() {
  for program in dovecot postfix python3; do
    command -v "$program" >/dev/null 2>&1 ||
      fail "$program is not installed; on Debian and Ubuntu: apt-get install dovecot-imapd dovecot-pop3d postfix"
  done

  # A second start replaces what a first one left, rather than adding to it.
  stop

  # The account Dovecot and Postfix share. Its home is the Maildir, so local(8)
  # and Dovecot cannot disagree about where a message goes.
  if ! id "$account" >/dev/null 2>&1; then
    getent group "$account" >/dev/null 2>&1 || groupadd --gid 5000 "$account"
    useradd --uid 5000 --gid 5000 --home-dir "$base/mail/$account" \
      --no-create-home --shell /usr/sbin/nologin "$account"
  fi

  install -d -m 0755 "$base" "$base/conf" "$base/certs"
  install -d -m 0755 -o root -g root "$base/queue"
  install -d -m 0755 -o postfix -g postfix "$base/data"
  install -d -o 5000 -g 5000 -m 0700 "$base/mail/$account"
  install -d -o 5000 -g 5000 -m 0700 "$base/mail/$account/Maildir"

  cp "$here/dovecot.conf" "$base/conf/dovecot.conf"
  cp "$here/dovecot-users" "$base/conf/users"
  cp "$here/postfix-main.cf" "$base/conf/main.cf"
  cp "$here/postfix-master.cf" "$base/conf/master.cf"
  chmod 0644 "$base/conf/dovecot.conf" "$base/conf/users" \
    "$base/conf/main.cf" "$base/conf/master.cf"

  python3 "$work/scripts/write_test_certs.py" "$base/certs" 2>/dev/null

  dovecot -c "$base/conf/dovecot.conf"

  # postfix-check fills in the queue's own directories with the ownership each
  # one needs, which is the only way to get a queue that is not the packaged
  # one right. Everything but the MOONMAIL_LIVE line goes to stderr, so the
  # line can be appended to $GITHUB_ENV as it is.
  postfix -c "$base/conf" check >&2
  postfix -c "$base/conf" start >&2

  # A port that answers is the only proof either service is ready.
  waited=0
  for port in 1143 1993 1111 1995 2525 2465; do
    while ! listening "$port"; do
      waited=$((waited + 1))
      if [ "$waited" -gt 120 ]; then
        fail "nothing answers on 127.0.0.1:$port; see $base/dovecot.log and $base/postfix.log"
      fi
      sleep 0.5
    done
  done

  echo "MOONMAIL_LIVE=127.0.0.1:1143:1993:1111:1995:2525:2465"
}

if [ "$(id -u)" -ne 0 ]; then
  fail "run as root, so the services can own a user and a queue"
fi

case "${1:-start}" in
  start) start ;;
  stop) stop ;;
  *) fail "usage: $0 [start|stop]" ;;
esac

#!/bin/sh
set -e

# Seed a test user and activation token for the activate.hurl test.
# Token plaintext: ABCDEFGHIJKLMNOPQRSTUVWXYZ (26 chars, valid base32)
# Token sha256 hash: d6ec6898de87ddac6e5b3611708a7aa1c2d298293349cc1a6c299a1db7149d38

DSN="${GREENLIGHT_DB_DSN}"

psql "$DSN" -c "DELETE FROM users WHERE email = 'activate-test@example.com';" >/dev/null
psql "$DSN" -c "WITH new_user AS (INSERT INTO users (name, email, password_hash, activated, version) VALUES ('Activation Test', 'activate-test@example.com', decode('00', 'hex'), false, 1) RETURNING id) INSERT INTO tokens (hash, user_id, expiry, scope) SELECT decode('d6ec6898de87ddac6e5b3611708a7aa1c2d298293349cc1a6c299a1db7149d38', 'hex'), id, NOW() + INTERVAL '3 days', 'activation' FROM new_user;" >/dev/null

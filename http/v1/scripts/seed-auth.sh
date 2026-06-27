#!/bin/sh
set -e

# Seed users and authentication tokens for the movie e2e tests.
#
# Activated user:
#   Email:  auth-test@example.com
#   Token plaintext: RSTUVWXYZABCDEFGHIJKLMNOPQ (26 chars, valid base32)
#   Token sha256:    97a744b44c5b63a2f99fdc85a2d33dbf501f9aca617a341df1402435f2d35ec6
#
# Inactive user (used to test 403 inactive-account responses):
#   Email:  inactive-test@example.com
#   Token plaintext: YZABCDEFGHIJKLMNOPQRSTUVWX (26 chars, valid base32)
#   Token sha256:    8584178321ec09c081217fd6a1f11f9fb0f80c3322e919315a0b496e5737e1d7

DSN="${GREENLIGHT_DB_DSN}"

psql "$DSN" -c "DELETE FROM users WHERE email IN ('auth-test@example.com', 'inactive-test@example.com');" >/dev/null
psql "$DSN" -c "WITH new_user AS (INSERT INTO users (name, email, password_hash, activated, version) VALUES ('Auth Test', 'auth-test@example.com', decode('00', 'hex'), true, 1) RETURNING id) INSERT INTO tokens (hash, user_id, expiry, scope) SELECT decode('97a744b44c5b63a2f99fdc85a2d33dbf501f9aca617a341df1402435f2d35ec6', 'hex'), id, NOW() + INTERVAL '3 days', 'authentication' FROM new_user;" >/dev/null
psql "$DSN" -c "WITH new_user AS (INSERT INTO users (name, email, password_hash, activated, version) VALUES ('Inactive Test', 'inactive-test@example.com', decode('00', 'hex'), false, 1) RETURNING id) INSERT INTO tokens (hash, user_id, expiry, scope) SELECT decode('8584178321ec09c081217fd6a1f11f9fb0f80c3322e919315a0b496e5737e1d7', 'hex'), id, NOW() + INTERVAL '3 days', 'authentication' FROM new_user;" >/dev/null

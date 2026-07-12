#!/bin/sh
set -e

# Delete user if it already exists
psql "${GREENLIGHT_DB_DSN}" -c "DELETE FROM users WHERE email = 'api-permissions@example.com';" > /dev/null

#!/bin/sh
set -e

# Color definitions for all test scripts
export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m'
export BOLD='\033[1m'

# Run migrations
echo "Waiting for database reset..."
migrate -path=migrations -database=$GREENLIGHT_DB_DSN drop -f
migrate -path=migrations -database=$GREENLIGHT_DB_DSN up

# Kill server
lsof -ti :4000 | xargs kill -9

# Start server in background
go run ./cmd/api > /dev/null 2>&1 &

# Wait for server to be ready
echo "Waiting for server to start..."
for i in 1 2 3 4 5 6 7 8 9 10; do
  if curl -s http://localhost:4000/v1/healthcheck > /dev/null 2>&1; then
    echo "Server is ready"
    break
  fi
  sleep 1
done

# Run hurl tests
hurl --test http/v1/health/check.hurl
hurl --test http/v1/movies/create.hurl
hurl --test http/v1/movies/list.hurl
hurl --test http/v1/movies/show.hurl
hurl --test http/v1/movies/update.hurl
hurl --test http/v1/movies/delete.hurl

echo ""
echo "${BOLD}${YELLOW}━━━ Race Condition Tests ━━━${NC}"
echo ""

./http/v1/scripts/test-update-movie-race-condition.sh

# Kill server
lsof -ti :4000 | xargs kill -9


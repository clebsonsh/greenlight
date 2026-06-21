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

# Kill any existing servers
lsof -ti :4000 | xargs kill -9 2>/dev/null || true
lsof -ti :4001 | xargs kill -9 2>/dev/null || true

# Start normal server (port 4000, no rate limiter)
go run ./cmd/api -port=4000 -limiter-enabled=false > /dev/null 2>&1 &

# Start rate limit server (port 4001, with rate limiter)
go run ./cmd/api -port=4001 > /dev/null 2>&1 &

# Wait for both servers
echo "Waiting for servers to start..."
for i in 1 2 3 4 5 6 7 8 9 10; do
  s4000=0; s4001=0
  curl -s http://localhost:4000/v1/healthcheck > /dev/null 2>&1 && s4000=1
  curl -s http://localhost:4001/v1/healthcheck > /dev/null 2>&1 && s4001=1
  if [ "$s4000" -eq 1 ] && [ "$s4001" -eq 1 ]; then
    # Wait rete limit colldown
    sleep 1
    echo "Both servers ready"
    break
  fi
  sleep 1
done

# Run normal tests on port 4000
echo ""
echo "${BOLD}${YELLOW}━━━ Standard Tests ━━━${NC}"
echo ""
hurl --test http/v1/health/check.hurl
hurl --test http/v1/movies/create.hurl
hurl --test http/v1/movies/list.hurl
hurl --test http/v1/movies/show.hurl
hurl --test http/v1/movies/update.hurl
hurl --test http/v1/movies/delete.hurl

echo ""
echo "${BOLD}${YELLOW}━━━ Rate Limit Tests ━━━${NC}"
echo ""

hurl --variable port=4001 --test http/v1/rate_limit.hurl

echo ""
echo "${BOLD}${YELLOW}━━━ Race Condition Tests ━━━${NC}"
echo ""

./http/v1/scripts/test-update-movie-race-condition.sh

# Kill both servers
lsof -ti :4000 | xargs kill -9 2>/dev/null || true
lsof -ti :4001 | xargs kill -9 2>/dev/null || true


#!/bin/sh
set -e

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
hurl --test http/v1/healthcheck.hurl
hurl --test http/v1/createMovie.hurl
hurl --test http/v1/showMovie.hurl
hurl --test http/v1/updateMovie.hurl

# Kill server
lsof -ti :4000 | xargs kill -9


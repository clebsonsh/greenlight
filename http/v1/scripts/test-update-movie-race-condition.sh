#!/bin/sh

DIR="$(cd "$(dirname "$0")" && pwd)"

"$DIR/test-race-condition.sh" \
  "update-movie-race-condition" \
  PATCH \
  "http://localhost:4000/v1/movies/1" \
  '{"title":"Update {}"}' \
  10

#!/bin/sh

test_name="$1"
method="$2"
url="$3"
body="$4"
count="${5:-10}"

if [ -z "$test_name" ] || [ -z "$method" ] || [ -z "$url" ]; then
  echo "Usage: $0 <test-name> <method> <url> [body-template] [count]"
  echo ""
  echo "  <test-name>      Label for the test output"
  echo "  <method>         HTTP method (GET, POST, PATCH, PUT, DELETE)"
  echo "  <url>            Full request URL"
  echo "  [body-template]  JSON body with {} placeholder (empty = no body)"
  echo "  [count]          Concurrent requests (default: 10)"
  exit 1
fi

START=$(date +%s%N)

if [ -n "$body" ]; then
  RESULTS=$(seq 1 "$count" | xargs -P "$count" -I {} curl -s -o /dev/null -w "%{http_code}\n" \
    -X "$method" "$url" \
    -H "Content-Type: application/json" \
    -d "$body")
else
  RESULTS=$(seq 1 "$count" | xargs -P "$count" -I {} curl -s -o /dev/null -w "%{http_code}\n" \
    -X "$method" "$url")
fi

END=$(date +%s%N)
DURATION_MS=$(( (END - START) / 1000000 ))

SUCCESS=0
CONFLICT=0
OTHER=0
TOTAL=0

while read STATUS; do
  TOTAL=$((TOTAL + 1))
  case $STATUS in
    200) SUCCESS=$((SUCCESS + 1)) ;;
    409) CONFLICT=$((CONFLICT + 1)) ;;
    *) OTHER=$((OTHER + 1)) ;;
  esac
done <<< "$RESULTS"

if [ $CONFLICT -gt 0 ]; then
  RESULT="${GREEN}${BOLD}Success${NC}"
  SUCCEEDED=1
  FAILED=0
else
  RESULT="${RED}${BOLD}Failed${NC}"
  SUCCEEDED=0
  FAILED=1
fi

printf "%b ${BOLD}%s ${NC}(%s request(s) in %d ms)\n" "$RESULT" "$test_name" "$count" "$DURATION_MS"
echo "--------------------------------------------------------------------------------"
printf "Executed files:    1\n"
printf "Executed requests: %d (%.1f/s)\n" "$TOTAL" "$(echo "scale=1; $TOTAL * 1000 / $DURATION_MS" | bc)"
printf "Succeeded files:   %d (%.1f%%)\n" "$SUCCEEDED" "$(echo "scale=1; $SUCCEEDED * 100 / 1" | bc)"
printf "Failed files:      %d (%.1f%%)\n" "$FAILED" "$(echo "scale=1; $FAILED * 100 / 1" | bc)"
printf "Duration:          %d ms (0h:0m:0s:%dms)\n" "$DURATION_MS" "$DURATION_MS"
printf "Requests:          %d passed, %d conflicted, %d other\n" "$SUCCESS" "$CONFLICT" "$OTHER"

if [ $CONFLICT -eq 0 ]; then
  exit 1
fi

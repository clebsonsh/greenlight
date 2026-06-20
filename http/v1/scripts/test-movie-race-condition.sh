# Capture start time
START=$(date +%s%N)

# Run 10 concurrent curls via xargs, collect all status codes into a variable
RESULTS=$(seq 1 10 | xargs -P 10 -I {} curl -s -o /dev/null -w "%{http_code}\n" \
  -X PATCH http://localhost:4000/v1/movies/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Update {}"}')

# Capture end time and calculate duration
END=$(date +%s%N)
DURATION_MS=$(( (END - START) / 1000000 ))

# Parse results
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

# Determine pass/fail
if [ $CONFLICT -gt 0 ]; then
  RESULT="${GREEN}${BOLD}Success${NC}"
  SUCCEEDED=1
  FAILED=0
else
  RESULT="${RED}${BOLD}Failed${NC}"
  SUCCEEDED=0
  FAILED=1
fi

# Output in hurl format
printf "%b ${BOLD}http/v1/scripts/test-movie-race-condition.sh ${NC}(10 request(s) in %d ms)\n" "$RESULT" "$DURATION_MS"
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

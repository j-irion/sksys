#!//usr/bin/env bash

HOST="$1"
TOKEN="$2"

set -xeo pipefail

COUNTER=1
while true; do
	VALUE=$(awk "BEGIN { print sin($COUNTER * 0.01) * 10 + 10 }")
	curl -v "$HOST/api/submit" \
		-H 'Content-Type: application/json' \
		--data "{\"authtoken\":\"$TOKEN\",\"timestamp\":$(date "+%s"),\"used_power\":$VALUE}"
	sleep 5
	(( COUNTER+=1 ))
done

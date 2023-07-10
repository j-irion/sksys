#!//usr/bin/env bash

HOST="$1"
TOKEN="$2"

set -xeo pipefail

while true; do
	REPEAT=$((1 + RANDOM % 3600))
	VALUE=$((RANDOM % 256))
	while [ $REPEAT -gt 0 ]; do
		curl -v "$HOST/api/submit" \
			-H 'Content-Type: application/json' \
			--data "{\"authtoken\":\"$TOKEN\",\"timestamp\":$(date "+%s"),\"used_power\":$VALUE}"
		sleep 5
		REPEAT=$(( REPEAT - 1 ))
	done
done

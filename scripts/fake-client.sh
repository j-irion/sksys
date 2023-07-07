#!//usr/bin/env bash

HOST="http://34.159.153.108"
printf "Token: "
read -r TOKEN

set -xeo pipefail

COUNTER=1
while true; do
	VALUE=$(awk "BEGIN { print sin($COUNTER * 0.1) * 10 }")
	curl -v "$HOST/api/submit" \
		-H 'Content-Type: application/json' \
		--data "{\"authtoken\":\"$TOKEN\",\"timestamp\":$(date "+%s"),\"used_power\":$VALUE}"
	sleep 5
done

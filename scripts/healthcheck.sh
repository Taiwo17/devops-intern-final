#!/usr/bin/env bash
set -euo pipefail

# TODO: Accept a target URL as $1.
# Default: http://localhost:8080
# Check the HTTP status and exit non-zero unless it is 200.

DEFAULT_URL="http://localhost:8080"
TARGET_URL="${1:-$DEFAULT_URL}"

if [[ "$#" -gt 1 ]]; then
	printf 'ERROR: Too many argument.\n' >&2
	printf 'Usage: %s [target-url]\n' "$0" >&2
	exit 2
fi 

if ! command -v curl >/dev/null 2>&1; then
	printf "ERROR: curl is required but is not installed.\n" >&2
	exit 1
fi 

printf "Checking application: %s\n" "$TARGET_URL"

if HTTP_STATUS=$(curl \
	--silent \
	--output /dev/null \
	--write-out '%{http_code}' \
	--connect-timeout 5 \
	--max-time 10 \
	"$TARGET_URL"); then

	if [[ "$HTTP_STATUS" == "200" ]]; then
		printf 'Success: Application returned HTTP %s.\n' "$HTTP_STATUS"
		exit 0
	fi 

	printf 'ERROR: Expected HTTP 200, received HTTP %s.\n' \
		"$HTTP_STATUS" >&2
	exit 1

else 
	printf 'ERROR: Request failed for %s (connection, timeout, or URL error).\n' \
		"$TARGET_URL" >&2
	exit 1
fi


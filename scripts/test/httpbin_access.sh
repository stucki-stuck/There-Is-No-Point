#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/utils.sh"

URL="http://httpbin.there-is-no-point.localhost:8080/get"
TOKEN="$(curl -s https://raw.githubusercontent.com/istio/istio/release-1.27/security/tools/jwt/samples/demo.jwt)"

info "Waiting for $URL to be reachable with valid token"
wait_http_ok_with_token "$URL" "$TOKEN"

info "GET body with valid token :"
curl -sf --header "Authorization: Bearer $TOKEN" "$URL" | jq

info "Testing JWT authorization"
expect_status 401 --header "Authorization: Bearer bad.tok.en" "$URL"
expect_status 403 "$URL"
expect_status 200 --header "Authorization: Bearer $TOKEN" "$URL"

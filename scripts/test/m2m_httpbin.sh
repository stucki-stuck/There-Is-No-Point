#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/utils.sh"

GET_URL="http://httpbingo-mesh.m2m-httpbin:8000/get"
HEADERS_URL="http://httpbingo-mesh.m2m-httpbin:8000/headers"
TOKEN="$(curl -s https://raw.githubusercontent.com/istio/istio/release-1.27/security/tools/jwt/samples/demo.jwt)"
TOKEN_GROUP="$(curl -s https://raw.githubusercontent.com/istio/istio/release-1.27/security/tools/jwt/samples/groups-scope.jwt)"
CURL_POD="$(find_pod_by_label "m2m-httpbin" "app=curl-app")"

kubectl -n "m2m-httpbin" wait --for=condition=ready pod/"$CURL_POD" --timeout=180s

info "Running assertions (no token / bad token / valid tokens) from pod m2m-httpbin/$CURL_POD"

expect_pod_status 403 m2m-httpbin $CURL_POD $GET_URL
expect_pod_status 403 m2m-httpbin $CURL_POD $HEADERS_URL

expect_pod_status 403 m2m-httpbin $CURL_POD -H "Authorization: Bearer $TOKEN" $GET_URL
expect_pod_status 200 m2m-httpbin $CURL_POD -H "Authorization: Bearer $TOKEN" $HEADERS_URL

expect_pod_status 200 m2m-httpbin $CURL_POD -H "Authorization: Bearer $TOKEN_GROUP" $GET_URL
expect_pod_status 200 m2m-httpbin $CURL_POD -H "Authorization: Bearer $TOKEN_GROUP" $HEADERS_URL

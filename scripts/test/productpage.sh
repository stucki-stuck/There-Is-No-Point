#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/utils.sh"

LOGIN_URL="http://productpage.there-is-no-point.localhost/login"
URL="http://productpage.there-is-no-point.localhost/productpage"
TMP_DIR="$(mktemp -d)"

info "Waiting for 200 OK at $URL"
retry 120 1 curl -sfI "$URL" >/dev/null

login_and_store_cookies $TMP_DIR $LOGIN_URL "alice" "alicepwd"

info "Waiting for productpage to return a version label"
retry 120 1 bash -lc "curl -b $TMP_DIR/cookies.txt -sf $URL | grep -oE 'reviews-app-v[0-9]+' >/dev/null"

info "6 seconds grace for pods to warm up"
sleep 6

info "Review version distribution (should be 60/30/10) over 100 requests:"
for _ in $(seq 1 100); do
  curl -b $TMP_DIR/cookies.txt -s "$URL" | grep -oE 'reviews-app-v[0-9]+' | head -n1
done | sort | uniq -c

info "Alice has access to details and reviews:"
curl -b $TMP_DIR/cookies.txt -s "$URL" | grep -oE 'reviews-app-v[0-9]+' | head -n1
curl -b $TMP_DIR/cookies.txt -s "$URL" | grep -o 'Book Details'

info "Bob has only access to details (not reviews):"
login_and_store_cookies $TMP_DIR $LOGIN_URL "bob" "bobpwd"
curl -b $TMP_DIR/cookies.txt -s "$URL" | grep -o 'Book Details'
curl -b $TMP_DIR/cookies.txt -s "$URL" | grep -o 'Error fetching product reviews'

info "Anonymous has access to nothing:"
curl -s "$URL" | grep -o 'Error fetching product details'
curl -s "$URL" | grep -o 'Error fetching product reviews'

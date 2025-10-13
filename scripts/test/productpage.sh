#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/utils.sh"

URL="http://productpage.there-is-no-point.localhost/productpage"

info "Waiting for productpage to return a version label"
retry 120 1 bash -lc "curl -sf $URL | grep -oE 'reviews-app-v[0-9]+' >/dev/null"

info "6 seconds grace for pods to warm up"
sleep 6

info "Review version distribution (should be 60/30/10) over 100 requests:"
for _ in $(seq 1 100); do
  curl -s "$URL" | grep -oE 'reviews-app-v[0-9]+' | head -n1
done | sort | uniq -c

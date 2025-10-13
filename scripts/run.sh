#!/bin/bash

set -eux

k3d cluster create --config k3d/config.yaml
helmfile sync

echo -e "\e[32mTesting access to http://httpbin.there-is-no-point.localhost/get \e[0m"
TOKEN=$(curl https://raw.githubusercontent.com/istio/istio/release-1.27/security/tools/jwt/samples/demo.jwt -s)
until curl -sfI --header "Authorization: Bearer $TOKEN" http://httpbin.there-is-no-point.localhost/get >/dev/null; do
  sleep 1
done
curl -sf --header "Authorization: Bearer $TOKEN" http://httpbin.there-is-no-point.localhost/get | jq

echo -e "\e[34mTesting JWT authorization\e[0m"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -I --header "Authorization: Bearer bad.token" http://httpbin.there-is-no-point.localhost/get)
if [[ $STATUS == "401" ]]; then
  echo -e "\e[32m[PASS]\e[0m Invalid token returned 401 Unauthorized"
else
  echo -e "\e[31m[FAIL]\e[0m Expected 401, got $STATUS"
  exit 1
fi
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -I http://httpbin.there-is-no-point.localhost/get)
if [[ $STATUS == "403" ]]; then
  echo -e "\e[32m[PASS]\e[0m Missing token returned 403 Forbidden"
else
  echo -e "\e[31m[FAIL]\e[0m Expected 403, got $STATUS"
  exit 1
fi

echo -e "\e[32mTesting access to http://productpage.there-is-no-point.localhost/productpage \e[0m"
until curl -sf http://productpage.there-is-no-point.localhost/productpage | grep -oE 'reviews-app-v[0-9]+' >/dev/null; do
  sleep 1
done
sleep 5
set +x
echo -e "\e[32mReview version distribution (should be 60/30/10) (100 requests): \e[0m"
for i in $(seq 1 100); do
  curl -s http://productpage.there-is-no-point.localhost/productpage |
    grep -oE 'reviews-app-v[0-9]+' |
    head -n1
done | sort | uniq -c
set -x

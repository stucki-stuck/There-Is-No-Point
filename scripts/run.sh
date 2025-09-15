#!/bin/bash

set -eux

k3d cluster create --config k3d/config.yaml
helmfile sync

echo -e "\e[32mTesting access to http://httpbin.there-is-no-point.localhost/get \e[0m"
until curl -sfI http://httpbin.there-is-no-point.localhost/get >/dev/null; do
  sleep 1
done
curl -sf http://httpbin.there-is-no-point.localhost/get | jq

echo -e "\e[32mTesting access to http://productpage.there-is-no-point.localhost/productpage \e[0m"
until curl -sf http://productpage.there-is-no-point.localhost/productpage | grep -oE 'reviews-app-v[0-9]+' >/dev/null; do
  sleep 1
done
sleep 1
set +x
echo -e "\e[32mReview version distribution (should be 60/30/10) (100 requests): \e[0m"
for i in $(seq 1 100); do
  curl -s http://productpage.there-is-no-point.localhost/productpage |
    grep -oE 'reviews-app-v[0-9]+' |
    head -n1
done | sort | uniq -c
set -x

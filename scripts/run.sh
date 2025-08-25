#!/bin/bash

set -eux

k3d cluster create --config k3d/config.yaml
helmfile sync

until curl -sfI http://httpbin.there-is-no-point.localhost/get >/dev/null; do
  sleep 1
done
curl -sf http://httpbin.there-is-no-point.localhost/get | jq

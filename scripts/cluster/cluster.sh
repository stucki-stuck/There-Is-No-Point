#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/utils.sh"

info "Creating k3d cluster"
k3d cluster create --config k3d/config.yaml

info "Building custom images for the product page"
cd "$(dirname "${BASH_SOURCE[0]}")"
cd ../../apps/productpage
docker build --target runner -t registry.localhost:5000/istio/examples-bookinfo-productpage-v1:1.20.3 .
docker push registry.localhost:5000/istio/examples-bookinfo-productpage-v1:1.20.3
cd "$(dirname "${BASH_SOURCE[0]}")"
cd ../..

info "Deploying with helmfile"
helmfile sync

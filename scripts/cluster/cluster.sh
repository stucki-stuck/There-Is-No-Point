#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/utils.sh"

info "Creating k3d cluster"
k3d cluster create --config k3d/config.yaml

info "Deploying with helmfile"
helmfile sync

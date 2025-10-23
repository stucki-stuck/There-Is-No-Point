#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$ROOT_DIR/cluster/cluster.sh"
bash "$ROOT_DIR/test/httpbin_access.sh"
bash "$ROOT_DIR/test/productpage.sh"
bash "$ROOT_DIR/test/m2m_httpbin.sh"

echo -e "\e[32mAll tests completed successfully.\e[0m"

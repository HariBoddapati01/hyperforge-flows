#!/usr/bin/env bash
# Run the e2e suite against the deployed product.
# PLACEHOLDER: point this at your real test runner (pytest/robot/go test/...),
# targeting the guest's address from the host or via SSM port forwarding.
set -euo pipefail

LEG="${1:?leg}"
RUN_ID="${2:?run id}"

echo "TODO: run e2e suite for leg=$LEG run=$RUN_ID"
exit 1 # fail loudly until implemented

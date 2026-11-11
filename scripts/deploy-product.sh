#!/usr/bin/env bash
# Deploy the product build onto the lab guest VM.
# PLACEHOLDER: wire in your product's actual install mechanism (installer run
# inside the guest via SSM -> virsh console / PowerShell Direct, an agent the
# lab image already carries, or network install from the host).
set -euo pipefail

LEG="${1:?leg}"
RUN_ID="${2:?run id}"
PRODUCT_BUILD="${3:?product build id}"

echo "TODO: deploy product build '$PRODUCT_BUILD' to guest on leg=$LEG run=$RUN_ID"
exit 1 # fail loudly until implemented so the pipeline can't silently pass

#!/usr/bin/env bash
# Pull logs off the host before teardown: hypervisor logs, guest console log,
# test output. Lands in ./artifacts/ for the CI upload step.
set -euo pipefail

LEG="${1:?leg}"
RUN_ID="${2:?run id}"
OUT="artifacts/$LEG"
mkdir -p "$OUT"

INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:run-id,Values=$RUN_ID" "Name=instance-state-name,Values=running" \
  --query 'Reservations[0].Instances[0].InstanceId' --output text)

[[ "$INSTANCE_ID" == "None" ]] && { echo "no instance to collect from"; exit 0; }

aws ec2 get-console-output --instance-id "$INSTANCE_ID" \
  --query 'Output' --output text > "$OUT/host-console.log" || true

# PLACEHOLDER: add SSM-driven collection of libvirt/Hyper-V logs and the
# guest's own logs once deploy/run scripts are wired up.
echo "collected host console log for $INSTANCE_ID into $OUT/"

#!/usr/bin/env bash
# Poll the test host (via SSM) until the lab guest VM is up, or time out.
# The host AMIs drop a sentinel file when the guest has started:
#   KVM/VME:  /var/run/hyperforge-guest-started
#   Hyper-V:  C:\hyperforge\guest-started
set -euo pipefail

LEG="${1:?leg}"
RUN_ID="${2:?run id}"
TIMEOUT_SECS="${3:-1200}"

INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:run-id,Values=$RUN_ID" "Name=instance-state-name,Values=running" \
  --query 'Reservations[0].Instances[0].InstanceId' --output text)

if [[ "$INSTANCE_ID" == "None" ]]; then
  echo "error: no running instance for run-id=$RUN_ID" >&2
  exit 1
fi

if [[ "$LEG" == "hyperv" ]]; then
  DOC="AWS-RunPowerShellScript"
  CHECK='if (Test-Path C:\hyperforge\guest-started) { exit 0 } else { exit 1 }'
else
  DOC="AWS-RunShellScript"
  CHECK='test -f /var/run/hyperforge-guest-started'
fi

DEADLINE=$(( $(date +%s) + TIMEOUT_SECS ))
while (( $(date +%s) < DEADLINE )); do
  CMD_ID=$(aws ssm send-command \
    --instance-ids "$INSTANCE_ID" \
    --document-name "$DOC" \
    --parameters "commands=[\"$CHECK\"]" \
    --query 'Command.CommandId' --output text 2>/dev/null) || { sleep 15; continue; }

  sleep 10
  STATUS=$(aws ssm get-command-invocation \
    --command-id "$CMD_ID" --instance-id "$INSTANCE_ID" \
    --query 'Status' --output text 2>/dev/null || echo "Pending")

  if [[ "$STATUS" == "Success" ]]; then
    echo "guest is up on $INSTANCE_ID ($LEG)"
    exit 0
  fi
  echo "waiting for guest on $INSTANCE_ID ($LEG): last check $STATUS"
  sleep 20
done

echo "error: guest did not come up within ${TIMEOUT_SECS}s" >&2
exit 1

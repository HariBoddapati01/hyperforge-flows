# hyperforge-flows

CI orchestration for HyperForge. One workflow, a matrix of three
legs (`kvm`, `vme`, `hyperv`), each leg fully independent:

```
resolve golden image → terraform apply → wait for guest →
deploy product → run e2e suite → collect artifacts → terraform destroy
```

Teardown (`terraform destroy`) runs under `if: always()` so it happens on
success, failure, and cancellation. The ttl-reaper in `hyperforge-core` is
the backstop if even that fails.

## Wiring needed before first run

Secrets (repo or org level):

- `AWS_CI_ROLE_ARN` — OIDC role for GitHub Actions
- `TEST_SUBNET_ID`, `TEST_SG_ID` — from the one-time infra setup

Scripts in `scripts/` that are placeholders (they exit 1 on purpose so a
half-wired pipeline can't go green):

- `deploy-product.sh` — install the product build onto the guest VM
- `run-tests.sh` — invoke the real e2e suite
- `collect-artifacts.sh` — partially implemented (host console log); add
  hypervisor + guest log collection

`wait-for-guest.sh` is functional: it polls via SSM for the sentinel file the
host AMIs drop once the guest VM has started.

## Running

- Manual: Actions → `e2e-hypervisor-matrix` → Run workflow, pick legs and a
  product build id.
- Scheduled: weekday nightly at 06:00 UTC, all three legs.

Each leg gets its own Terraform state (`runs/<github-run-id>-<leg>.tfstate`),
so legs run in parallel and repeated runs never collide.

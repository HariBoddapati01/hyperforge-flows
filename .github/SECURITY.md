# Security Policy

HyperForge provisions ephemeral cloud infrastructure, so security reports are taken seriously.

**Please do not open public issues for vulnerabilities.** Use GitHub's private vulnerability reporting ("Report a vulnerability" under the Security tab) on this repository.

In scope: anything that could leak credentials, escalate IAM permissions beyond the documented scoping (CI role, reaper, test-host profile), defeat the TTL reaper's cost controls, or execute untrusted input in CI.

You can expect an acknowledgment within a week. There is no bug bounty — this is a community project — but reporters are credited in release notes unless they prefer otherwise.

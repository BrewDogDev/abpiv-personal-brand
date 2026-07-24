# Agent Infrastructure Migration Handoff

## Status

Complete. The migration is reviewed, validated, published as a ready pull request, and archived. The pull request is intentionally unmerged and no production deployment was performed.

## Goal And Result

The repository now uses `agents/` as its canonical portable agent infrastructure. Root `AGENTS.md` is a thin entrypoint; stable context, governance, Projects, skills, access profiles, MCP contracts, adapters, and historical evidence have explicit owners.

Useful prior root, Kilo, and Superpowers artifacts are preserved byte-for-byte as non-authoritative history. The complete `abpiv-agents@0.1.30` `agent-organization` family is repository-owned with runnable Project and Workflow validators. Credential-free Google Cloud, Cloudflare, and n8n guidance separates access selection, MCP runtime, and harness mappings.

## Decisions And Boundaries

- `preview` remains the only allowed pull-request source into `main`.
- Legacy plans and handoffs are history, not active instructions.
- `.codex-local/n8n-mcp.json` is a supported ignored local binding, never a tracked source of truth.
- The Cloudflare Access recovery handle is Secret Manager secret `abpiv-n8n-mcp-cloudflare-access`, written by `.github/workflows/n8n-apply.yml`; its values remain secret and separate from the n8n bearer token.
- Merging PR #17, production deployment, permission changes, and live credential/runtime probing remain outside this completed Project.

## Review And Verification

- Tasks 01-04 passed independent review.
- The first whole-Project review found one Important n8n recovery-contract preservation gap.
- Task 04 fix `10f455dfb65ac94f1a2da156b4e9712242bee1b8` restored the missing metadata in exactly two canonical docs.
- Task 04 amended review and whole-Project amended review both returned `READY`.
- Final reviewed evidence includes 22 Project-validator tests, live Project and empty-Workflow validation with zero warnings, 23/23 vendored skill files, 12/12 exact legacy moves, 220/220 active local links, 2/2 JSON examples, zero secret/machine-path findings, unchanged prohibited runtime domains, and an authorized 19-commit/95-path range at the amended review head.

## Publication

- Repository: `BrewDogDev/abpiv-personal-brand`
- Remote head: `preview`
- Base: `main`
- Pull request: [#17 — Migrate agent infrastructure to canonical scaffold](https://github.com/BrewDogDev/abpiv-personal-brand/pull/17)
- State when created: open and non-draft
- Initial published closing head: `baf0237ef121ac8b3f770939b2070ba2f9376a42`
- Final archive commit is pushed to the same `preview` branch and therefore updates PR #17.

## Residual Notes

- Task 03 retains one non-blocking report-heading Minor; all required evidence is present.
- Static scenarios validate routing rules and validators but do not measure every harness's selection reliability.
- Access and MCP files are operating contracts, not proof that a current machine credential or live server session works.
- Archived Project records are immutable. Future changes require a new Project that references this archive.

## Fresh-Session Continuation Prompt

Review the ready agent-infrastructure migration PR at https://github.com/BrewDogDev/abpiv-personal-brand/pull/17. Start by reading AGENTS.md, then agents/context/projects/archive/2026-07-24-agent-infrastructure-migration/handoff/latest.md and the PR diff/checks. Confirm the PR remains open, non-draft, base main, head preview. Do not merge or deploy production unless Allan explicitly asks.

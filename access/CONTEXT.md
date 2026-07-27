# External Service Access Context

## Purpose

Provide one harness-agnostic owner for the external handles this repository uses:
the ABPIV Google Cloud project, its Cloudflare account and site boundary, and the
Lobst3rs n8n instance.

## Scope

This surface owns service and profile selection, approved interfaces, read-only
target verification, credential reference names, action gates, stop rules, and
reporting requirements. It does not own credentials, implementation procedures,
MCP server behavior, or harness configuration.

## Context Layers

| Layer | Repository use |
| --- | --- |
| 1 - routing | [`ROUTING.md`](ROUTING.md) selects one service profile and default interface. |
| 3 - stable access | Service contexts, profiles, interfaces, and [`references/`](references/secret-boundary.md) define durable target and safety rules. |
| 4 - local binding | Ignored `.codex-local/`, shell-scoped variables, platform-native auth, and secret stores supply runtime values. |

## Binding Rules

- Use stable profile ids and public project, account, or host handles.
- Verify the active target before meaningful work.
- Pass project and account identifiers explicitly when the interface supports it.
- Keep all secret values outside Git. Tracked files may name required bindings but
  must not contain their values.
- Treat production mutation, permission expansion, public exposure, billing,
  identity, data movement, and destructive actions as approval-gated.
- Stop on target mismatch, stale authentication, insufficient scope, ambiguous
  ownership, missing approval, or unsafe secret handling.

Start with [`ROUTING.md`](ROUTING.md), then load only the selected service,
profile, and interface.

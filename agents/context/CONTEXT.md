# ABPIV Personal Brand Agent Context

## Purpose

Provide the portable, harness-agnostic source of truth that helps agents understand, route, plan, execute, verify, and hand off work in this repository.

## Repository Scope

This context covers:

- the public Docusaurus site under `content-site/`;
- shared Plausible analytics under `infra/analytics/`;
- n8n forms infrastructure under `infra/n8n/`;
- the ABPIV creative-production brand system under `creative-production/`;
- repository automation under `.github/workflows/`; and
- the agent infrastructure under `agents/`.

Implementation and operator documentation beside each system remains authoritative for that system. This context explains repository-wide meaning and routes agents to those narrower sources instead of copying their contracts.

## Context Layers

| Layer | Repository use |
| --- | --- |
| 0 - harness entrypoint | Thin discovery surfaces such as root [`AGENTS.md`](../../AGENTS.md). |
| 1 - context and routing | This context, [`ROUTING.md`](ROUTING.md), and [`GLOSSARY.md`](GLOSSARY.md). |
| 2 - workflow contract | Reusable agent Workflows, if any are later registered under [`workflows/`](workflows/README.md). |
| 3 - stable context | Durable references under [`references/`](references/repository-map.md) and implementation documentation beside each system. |
| 4 - working context | Active [`projects/`](projects/CONTEXT.md), [`working/`](working/README.md), [`runs/`](runs/README.md), learnings, and [`handoff/`](handoff/README.md). |

Do not promote a run-specific draft, historical plan, or unverified observation into stable context merely to make it discoverable.

## Binding Boundaries

- Never place credentials, tokens, private payloads, service-account keys, or machine-local secret values in tracked agent infrastructure.
- Keep `.codex-local/` ignored. Do not inspect or expose its credential values unless a separately authorized access task requires that operation.
- Preserve same-origin public analytics: browser-visible analytics traffic must use `/_analytics/*` on the public site origin and must not expose the private dashboard origin.
- Treat `content-site/`, `infra/analytics/`, `infra/n8n/`, `creative-production/`, repository automation, and agent infrastructure as separate implementation domains with domain-specific verification.
- Treat historical root plans, Kilo plans, and Superpowers artifacts as migration inputs or run history, not active control state.
- Use a Project only for active multi-Task or multi-session work. Project implementers change only their ready Task scope and do not edit Project control state.

## How To Start

1. Select the owning domain in [`ROUTING.md`](ROUTING.md).
2. Load the narrow files listed in the [`repository map`](references/repository-map.md).
3. Classify nontrivial planned work through [`projects/ROUTING.md`](projects/ROUTING.md).
4. Read [`GLOSSARY.md`](GLOSSARY.md) for branch, environment, analytics, and agent-lifecycle language.
5. Choose checks from [`verification.md`](references/verification.md) and follow [`git-policy.md`](references/git-policy.md).

# Codex Adapter

## Status And Scope

- Harness: Codex
- Maintenance status: active
- Canonical source of truth: canonical owners under `agents/`, including
  `agents/context/`, and root [`AGENTS.md`](../../../AGENTS.md)
- External procedure provider:
  [`BrewDogDev/abpiv-agents`](https://github.com/BrewDogDev/abpiv-agents)
  through the installed `abpiv-agents` Codex plugin

This adapter maps Codex entrypoints and discovery expectations. It does not copy
external skill bodies or define machine-local MCP credentials.

## Mapping

| Canonical asset | Codex usage |
| --- | --- |
| Root [`AGENTS.md`](../../../AGENTS.md) | Persistent repository entrypoint that routes into canonical context |
| [`agents/context/CONTEXT.md`](../../context/CONTEXT.md), [`GLOSSARY.md`](../../context/GLOSSARY.md), and [`ROUTING.md`](../../context/ROUTING.md) | Semantic meaning, canonical terms, and intent routing |
| [`agents/context/projects/`](../../context/projects/ROUTING.md) | Active multi-session Project discovery and Project-local continuity |
| [`agents/access/ROUTING.md`](../../access/ROUTING.md) | External target, verification, action gates, and secret boundary |
| [`agents/mcp-servers/n8n-instance/MCP.md`](../../mcp-servers/n8n-instance/MCP.md) | Remote n8n MCP transport, dynamic-tool, and safety contract |
| External `abpiv-agents` plugin | Reusable agent-organization procedures used to create, maintain, and validate repository-owned artifacts; no skill body is stored in this repository |
| [`agents/tools/README.md`](../../tools/README.md) | Empty executable agent capability registry; no repository-owned tool is currently registered |
| [`agents/templates/README.md`](../../templates/README.md) | Empty reusable agent artifact template registry; no template is currently registered |

## Discovery And Entrypoints

1. Codex reads the closest `AGENTS.md`; the repository root file is the supported
   entrypoint for this workspace.
2. Repository work starts from canonical context and routing, then loads only the
   selected repository-owned domain, Project, access profile, or MCP contract.
3. When reusable agent procedure is needed, Codex resolves the installed
   `abpiv-agents` plugin and uses its independently discovered skills.
4. If the required external skill is unavailable, stop before claiming that its
   procedure or validation was applied.

## Interface Metadata And Manifests

The external plugin owns its skill manifests, interface metadata, discovery,
installation, and updates. This repository owns no plugin manifest or copied
skill metadata. The adapter records only the mapping between external procedure
and repository-owned artifacts.

## Unsupported Features

- This adapter does not install or update the external plugin.
- It does not create an MCP client binding or make credentials available.
- It does not make the repository self-contained when `abpiv-agents` is absent.

## Generation Or Synchronization

There is no skill synchronization surface in this repository. Keep reusable
skill bodies in `BrewDogDev/abpiv-agents`; keep only the artifacts produced for
this workspace here. Never copy an installed plugin cache into Git.

## Validation And Reload

- Resolve the root entrypoint, context, Project, access, MCP, tool, template, and
  adapter targets.
- Confirm that no live `agents/skills/` tree exists in this repository.
- Verify required `abpiv-agents` skills through the active Codex skill catalog
  and run their bundled validators against the repository root when applicable.
- Reload or start a fresh Codex task after external plugin changes; a current
  task may retain previously loaded instructions.

## Secret And Local-State Boundary

Codex MCP endpoints, bearer tokens, Cloudflare Access values, auth sessions, and
user-specific install paths remain in ignored or platform-native configuration.
Never copy `.codex-local/` or an installed cache into this adapter.

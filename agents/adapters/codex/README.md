# Codex Adapter

## Status And Scope

- Harness: Codex
- Maintenance status: active
- Canonical source of truth: canonical owners under `agents/`, including
  `agents/context/`, and root [`AGENTS.md`](../../../AGENTS.md)

This adapter maps Codex entrypoints and discovery expectations. It does not copy
canonical instruction bodies or define machine-local MCP credentials.

## Mapping

| Canonical asset | Codex usage |
| --- | --- |
| Root [`AGENTS.md`](../../../AGENTS.md) | Persistent repository entrypoint that routes into canonical context |
| [`agents/context/CONTEXT.md`](../../context/CONTEXT.md), [`GLOSSARY.md`](../../context/GLOSSARY.md), and [`ROUTING.md`](../../context/ROUTING.md) | Semantic meaning, canonical terms, and intent routing |
| [`agents/context/projects/`](../../context/projects/ROUTING.md) | Active multi-session Project discovery and Project-local continuity |
| [`agents/access/ROUTING.md`](../../access/ROUTING.md) | External target, verification, action gates, and secret boundary |
| [`agents/mcp-servers/n8n-instance/MCP.md`](../../mcp-servers/n8n-instance/MCP.md) | Remote n8n MCP transport, dynamic-tool, and safety contract |
| [`agents/skills/agent-organization/`](../../skills/agent-organization/SKILL.md) | Agent-infrastructure router and recursively nested specialist family |
| [`agents/tools/README.md`](../../tools/README.md) | Empty executable agent capability registry; no repository-owned tool is currently registered |
| [`agents/templates/README.md`](../../templates/README.md) | Empty reusable agent artifact template registry; no template is currently registered |

## Discovery And Entrypoints

1. Codex reads the closest `AGENTS.md`; the repository root file is the supported
   entrypoint for this workspace.
2. Repository work starts from canonical context and routing, then loads only the
   selected domain, Project, access profile, MCP contract, or skill.
3. Skills must be discovered recursively so the `agent-organization` family
   router and nested specialists remain independently addressable.
4. Canonical skill frontmatter names must remain globally unique.

## Interface Metadata And Manifests

The canonical family retains 14 source `agents/openai.yaml` interface metadata
records, one beside each recursively discovered `SKILL.md`. Each record declares
`display_name`, `short_description`, and a `default_prompt` that invokes the
matching skill name. These source records do not duplicate skill bodies.

This adapter does not maintain a Codex manifest, generate those metadata
records, or claim a generated manifest for the family. The repository paths
above are canonical; installed plugin caches and machine-local configuration
are consumers, never sources of truth.

## Unsupported Features

- This adapter does not install repository skills into a Codex runtime.
- It does not create an MCP client binding or make credentials available.
- It does not promise that every Codex host supports identical recursive skill
  discovery; runtime support must be verified after installation.

## Generation Or Synchronization

The adapter is manually maintained as a thin mapping. Detect drift by resolving
every link, enumerating the nested `SKILL.md` files, and comparing any installed
consumer to the canonical repository copy without writing cache paths into Git.

## Validation And Reload

- Resolve the root entrypoint, context, Project, access, MCP, and skill-family
  targets.
- Verify recursive skill discovery and unique frontmatter names from the
  canonical `agents/skills/` owner.
- Reload or start a fresh Codex task after runtime installation or mapping
  changes; a current task may retain previously loaded instructions.

## Secret And Local-State Boundary

Codex MCP endpoints, bearer tokens, Cloudflare Access values, auth sessions, and
user-specific install paths remain in ignored or platform-native configuration.
Never copy `.codex-local/` or an installed cache into this adapter.

# Kilo Adapter

## Status And Scope

- Harness: Kilo
- Maintenance status: historical
- Canonical evidence: the
  [`legacy run-history index`](../../context/runs/legacy/README.md)

Kilo is not an active repository harness. Its prior plan files are preserved as
non-authoritative Layer 4 evidence and do not control current work.

## Mapping

| Historical surface | Current owner |
| --- | --- |
| `.kilo/plans/*` plan artifacts | Preserved under the legacy run-history index |
| Repository instructions and semantics | Root [`AGENTS.md`](../../../AGENTS.md) and canonical [`agents/context/`](../../context/CONTEXT.md) |
| Planned multi-session work | [`agents/context/projects/`](../../context/projects/ROUTING.md) |
| External service targets | [`agents/access/ROUTING.md`](../../access/ROUTING.md) |
| MCP server behavior | [`agents/mcp-servers/`](../../mcp-servers/README.md) |

## Discovery And Entrypoints

No Kilo discovery entrypoint is maintained. Historical files must not be loaded
as current instructions.

## Interface Metadata And Manifests

None. This adapter records historical status only.

## Unsupported Features

- No synchronization, manifest generation, skill installation, MCP binding, or
  reload process is supported for Kilo.
- No new Kilo-specific plans or instructions should be created.

## Generation Or Synchronization

Do not regenerate or modernize preserved history. Route new work to canonical
owners.

## Validation And Reload

Verify links to canonical owners and confirm the legacy source remains historical
run evidence rather than active routing.

## Secret And Local-State Boundary

No Kilo credential or local configuration is tracked. Historical evidence must
remain free of newly introduced secrets.

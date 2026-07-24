# Task 03: Vendor And Validate The Agent-Organization Skill Family

## Status

Complete

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-infrastructure-migration/PROJECT.md`
- Plan row: Task 03
- Planned from: `codex/migrate-agent-infrastructure` at coordinator checkpoint `44f2beb2aff94cfe0d3765e833f68dbf4121d6b9`
- Refreshed at: 2026-07-24 for isolated parallel dispatch
- Dependencies verified: Task 01 is `complete`; canonical context, skill registry location, Git policy, Project records, and required validation commands exist; installed source is `abpiv-agents@0.1.30`

## Outcome And Acceptance

- Outcome: the repository owns a portable copy of the complete `agent-organization` family and can discover and run its Project and Workflow validators without relying on a machine-local plugin cache path.
- Acceptance criteria:
  - `agents/skills/agent-organization/` contains the complete 23-file family from `abpiv-agents@0.1.30`, including every router, specialist, Project lifecycle child, template/reference, validator, validator test, and license file.
  - Reusable source content matches the installed 0.1.30 family except for a narrowly documented repository-portability correction when a copied relative link would otherwise target an absent sibling skill family.
  - `agents/skills/README.md` records source repository, version, license, copied scope, local portability deviation, external skill dependencies, recursive-discovery rule, validation commands, and update policy without persisting a machine-local source path.
  - Recursive enumeration finds every intended `SKILL.md`; every discoverable frontmatter name is globally unique and agrees with its folder; every directly linked local resource resolves.
  - `python agents/skills/agent-organization/agent-project-organization/scripts/test_validate_projects.py` passes.
  - `python agents/skills/agent-organization/agent-project-organization/scripts/validate_projects.py .` passes on the live workspace.
  - The bundled Workflow validator parses and runs against the current no-active-Workflow registry without inventing a Workflow contract.
  - Deterministic forward scenarios recorded in `REPORT.md` cover direct routing, sibling discrimination, ambiguous ownership, approval boundary, and stop behavior; fresh independent review provides the behavioral limitation check.

## Owned Scope

- Create: `agents/skills/README.md`
- Create from `abpiv-agents@0.1.30`: the complete `agents/skills/agent-organization/` family, exactly the 23 files enumerated by the installed package
- Modify only if required for repository portability: copied local relative links inside `agents/skills/agent-organization/`
- Test: copied source inventory and hashes, recursive discovery, frontmatter/folder uniqueness, direct local links, validator unit tests, live Project validation, Workflow validator behavior, diff/scope, whitespace, and secret/machine-path safety

## Do Not Touch

- `agents/context/`, `agents/access/`, `agents/mcp-servers/`, `agents/adapters/`, `agents/templates/`, or `agents/tools/`
- Root files, legacy history, implementation files, workflows, runtime systems, or external state
- Installed plugin files or caches; they are read-only migration input and never the target of edits
- Procedural semantics beyond the documented portability correction
- `PROJECT.md`, `PLAN.md`, and Project routing

## Interfaces

- Consumes: Task 01's canonical `agents/skills/` location and Git/verification contracts; source family `abpiv-agents@0.1.30`
- Produces: `agents/skills/agent-organization/SKILL.md`, all nested skill paths, and repository-local validators consumed by Task 05 and final closure
- Declared parallel interface: Task 04 may document `agents/skills/agent-organization/` as the canonical skill root but does not own or validate these files; combined resolution is verified after integration

## Skills, Tools, And Authority

- Required implementation skills: `abpiv-agents:agent-skill-organization`, `abpiv-agents:testing-agent-skills`; return through `abpiv-agents:agent-organization`
- Required review and verification skills: `abpiv-agents:requesting-code-review`, `abpiv-agents:receiving-code-review`, recursive-discovery/static-schema/link/validator inspection
- Allowed tools and actions: read the installed 0.1.30 source family; create only owned repository files with `apply_patch`; run local deterministic validators/tests; commit exact owned implementation paths in the isolated Task worktree
- Approval-gated actions: none within the repository-owned copy
- Prohibited actions: modifying or publishing the installed plugin, adding unrelated skills, persisting cache paths, external writes, broad staging, force operations, or Project control-state edits

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- Ask before guessing at a material ambiguity.
- Use test-driven development or the repository's equivalent evidence cycle when behavior changes.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: compare the installed source inventory and SHA-256 hashes with the repository copy, allowing only an explicitly enumerated portability deviation, then recursively validate skill names, directories, frontmatter, and directly linked resources.
- Broader check: run the copied validator tests, live Project validator, Workflow validator, `git diff --check`, exact scope comparison, and scans for secrets and machine-local cache paths.
- Diff or artifact review: isolated Task base-to-head diff must contain only `agents/skills/`; record exact file count and any intentionally changed line.
- Required evidence: source/version/provenance, 23-file inventory result, recursive skill count/names, link result, unit/live validator results, scenario matrix outcomes, commit identity, and residual limitations in `REPORT.md`.

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return

- Implementer report: `REPORT.md`
- Independent review: `REVIEW.md`
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

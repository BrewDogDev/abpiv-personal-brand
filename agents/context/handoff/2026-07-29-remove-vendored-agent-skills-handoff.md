# Handoff: Remove Vendored Agent Skills

## Metadata
- Date: 2026-07-29
- Goal: Remove reusable agent skill bodies from the personal-brand repository while retaining the workspace artifacts produced through those skills.
- Status: complete
- Workspace: `abpiv-personal-brand` repository on `codex/remove-vendored-agent-skills`
- Source of truth: repository context under `agents/context/` and external procedures from `BrewDogDev/abpiv-agents`

## Goal

Make this repository a consumer of external `abpiv-agents` procedures. Remove
the complete repository-owned `agents/skills/` surface while preserving the
context, Projects, access profiles, MCP contracts, adapters, tools, templates,
run history, and other repository-owned artifacts those procedures produced.

Plugin installation, changes to `BrewDogDev/abpiv-agents`, publication, merge,
deployment, and rewriting immutable archived Projects are out of scope.

## Current State

- The physical `agents/skills/` directory is absent.
- All 39 tracked files formerly under `agents/skills/` are deleted in the
  working tree.
- Active repository documentation maps reusable procedure to the external
  `abpiv-agents` Codex plugin and states that no skill synchronization surface
  exists here.
- Archived Projects and run history remain unchanged as Layer 4 evidence.
- The implementation is complete and verified but is not staged, committed,
  pushed, merged, published, or deployed.

## Decisions And Rationale

- `BrewDogDev/abpiv-agents` owns reusable skill bodies, resources, metadata, and
  validators. This repository owns only personal-brand workspace artifacts.
- The repository must not symlink, vendor, synchronize, or track an installed
  plugin cache.
- Harness-neutral verification identifies external bundled validator resources;
  the Codex adapter owns the mapping to the installed plugin.
- Historical archived references remain immutable even when they describe the
  former repository-owned skill layout.

## Changes And Artifacts

- Deleted `agents/skills/README.md` and the complete
  `agents/skills/agent-organization/` family: 39 files total.
- Updated `agents/adapters/codex/README.md`.
- Updated `agents/context/references/repository-map.md`.
- Updated `agents/context/references/verification.md`.
- Added this dated handoff and `agents/context/handoff/latest.md`.
- Created branch `codex/remove-vendored-agent-skills` from the current
  `origin/preview`.

## Verification

- External `test_validate_projects.py`: 32 tests, `OK`.
- External `validate_projects.py`: passed with 0 active Projects, 3 archived
  Projects, 0 Task directories, and 0 warnings.
- External `validate_workflows.py`: passed with 0 routes, 0 Workflows, 0 stages,
  and 0 warnings.
- Local inline-link check passed for the root instructions, canonical context,
  routing, glossary, repository map, verification reference, adapter registry,
  Codex adapter, and handoff registry.
- Filesystem and active-reference assertions found no live `agents/skills/`
  tree and no active reference to the removed paths.
- Tracked-diff safety scan found no private-key block, credential-shaped
  assignment, or concrete installed-cache path.
- `git diff --check` passed. Git emitted only the repository's existing
  LF-to-CRLF working-copy notices.

## What Worked

The validators bundled with the installed `abpiv-agents` plugin run directly
against this repository, so repository artifacts remain verifiable without
vendoring the reusable skill family.

## What Did Not Work

Treating a copied skill family as repository-owned created duplicate ownership
and a manual synchronization burden.

## Remaining Work

1. Review the current working-tree diff and confirm whether Allan wants the
   completed migration committed or published.
2. If publication is authorized, stage the exact changed paths, review the
   staged diff and safety scan, then follow the documented topic-branch to
   `preview` promotion path.

## Open Decisions Or Blockers

None for the requested implementation. Commit and publication authority were
not assumed.

## Do Not Assume

- Do not recreate `agents/skills/` or copy an installed plugin cache into Git.
- Do not rewrite immutable archived Projects or run history to update historical
  path references.
- Do not infer permission to commit, push, merge, publish, or deploy.
- Verify current Git and plugin state again before any follow-up action.

## Fresh-Session Continuation Prompt

```text
Continue the goal "remove reusable agent skill bodies from the personal-brand repository and retain only the workspace artifacts produced through those skills" in the abpiv-personal-brand repository.

First, read agents/context/handoff/2026-07-29-remove-vendored-agent-skills-handoff.md completely. Then load AGENTS.md, agents/context/CONTEXT.md, agents/context/ROUTING.md, agents/context/references/repository-map.md, agents/context/references/verification.md, and agents/adapters/codex/README.md. Treat the handoff as working context, not unquestionable truth: verify the current files, Git state, checks, approvals, external abpiv-agents plugin state, and protected changes before acting.

Resume from the ordered Remaining Work section, beginning with reviewing the current working-tree diff and confirming whether Allan wants it committed or published. Preserve unrelated user changes and stay within every scope, safety, review, and stop boundary recorded in the handoff. Do not recreate agents/skills, copy an installed plugin cache into Git, or rewrite immutable archived Projects. Do not redo completed work unless live evidence contradicts it. If state has changed, reconcile it, document the difference, and continue toward the goal.
```

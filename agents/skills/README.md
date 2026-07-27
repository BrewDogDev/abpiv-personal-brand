# Agent Skills

This directory is the repository-owned source for harness-agnostic agent skills. Discovery must recurse through every nested directory and treat each `SKILL.md` as an independently discoverable skill; a family router does not hide its children.

## Vendored Family

### `agent-organization`

- Selected source: [`BrewDogDev/abpiv-agents`](https://github.com/BrewDogDev/abpiv-agents)
- Source package version: `0.1.36`
- Supplied scope: 24 non-generated files from the package's `agent-organization` subset: 14 `SKILL.md` files, three Python validator or test scripts, and seven Markdown references or templates
- Retained repository metadata: 14 colocated `agents/openai.yaml` interface files that are required by this repository's Codex discovery contract but are not supplied by the selected package subset
- Complete family inventory: 38 non-generated files, comprising the 24 supplied files plus the 14 retained metadata files
- Exclusions: generated `__pycache__`, `.pyc`, and `.pyo` files only
- License: the source package declares MIT; the copied family also retains the [upstream MIT license](agent-organization/references/upstream-license.md) required by its adapted Project and skill-testing material
- Target-layout deviation: the selected package exposes this subset from its skills root, while this repository owns the family at `agents/skills/agent-organization/`

Retain all 14 repository `agents/openai.yaml` files beside their matching skills. Each declares `display_name`, `short_description`, and a `default_prompt` that invokes the matching `$skill-name`; none duplicates a skill body or changes adapter ownership.

The copied family depends on skills that are not vendored in this directory: `domain-driven-consulting`, `grill-me`, `dispatching-parallel-agents`, `requesting-code-review`, `receiving-code-review`, `self-improving-skill`, and `handoff`. A harness must provide those capabilities separately when the selected procedure invokes them. The family remains useful for routes and checks that do not require an absent dependency.

## Standalone Portability Corrections

The repository copy matches the 24 supplied version 0.1.36 files except for two reviewed link corrections required because the sibling `software-delivery` family is not vendored here:

1. Project provenance links to the retained family-local upstream license.
2. The Task-execution review procedure identifies the external `software-delivery/references/review-scope.md` dependency as code rather than a broken local Markdown link.

## Validation

Run from the repository root:

```powershell
python -B agents/skills/agent-organization/agent-project-organization/scripts/test_validate_projects.py
python -B agents/skills/agent-organization/agent-project-organization/scripts/validate_projects.py .
python -B agents/skills/agent-organization/agent-workflow-organization/scripts/validate_workflows.py .
```

Also compare normalized inventory and contents with the 24 supplied version 0.1.36 files, allowing only the two documented link corrections. Require 14 recursively discovered unique folder-matched skills, 14 valid matching metadata files, resolved local resources, and passing trigger, routing, ambiguity, approval, and stop-rule scenarios.

When delegation is prohibited, record that deterministic scenarios are not equivalent to fresh-context agent testing.

## Update Policy

Treat the repository copy as canonical for this workspace. To update it, select an explicit upstream version, compare complete inventories and hashes, review semantic changes, reapply only documented portability deviations, run all bundled and workspace validators, repeat the behavioral scenario matrix, obtain independent review, and record the new provenance. Never persist an installed-cache or other machine-local source path in tracked files.

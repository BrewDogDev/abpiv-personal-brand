# Agent Skills

This directory is the repository-owned source for harness-agnostic agent skills. Discovery must recurse through every nested directory and treat each `SKILL.md` as an independently discoverable skill; a family router does not hide its children.

## Vendored Family

### `agent-organization`

- Source: [`BrewDogDev/mono`](https://github.com/BrewDogDev/mono)
- Source package version: `1.1.0`
- Copied scope: the complete 37-file non-generated `agent-organization` family: 14 `SKILL.md` files, 14 colocated `agents/openai.yaml` interface metadata files, three Python validator or test scripts, and six Markdown references or templates
- Exclusions: generated `__pycache__`, `.pyc`, and `.pyo` files only
- License: the source package declares MIT; the copied family also retains the [upstream MIT license](agent-organization/references/upstream-license.md) required by its adapted Project and skill-testing material
- Repository portability deviation: in [`agent-project-organization/SKILL.md`](agent-organization/agent-project-organization/SKILL.md), the upstream-license link is `../references/upstream-license.md` instead of the package-relative `../../software-delivery/references/upstream-license.md`, because this repository vendors the license inside this family and does not vendor the sibling `software-delivery` family

Retain all 14 source `agents/openai.yaml` files beside their matching skills. Each declares `display_name`, `short_description`, and a `default_prompt` that invokes the matching `$skill-name`; none duplicates a skill body or changes adapter ownership.

The copied family depends on skills that are not vendored in this directory: `domain-driven-consulting`, `grill-me`, `dispatching-parallel-agents`, `requesting-code-review`, `receiving-code-review`, `self-improving-skill`, and `handoff`. A harness must provide those capabilities separately when the selected procedure invokes them. The family remains useful for routes and checks that do not require an absent dependency.

## Standalone Portability Corrections

The repository copy matches Mono 1.1.0 except for three reviewed corrections:

1. The Project validator command uses top-level `skills/`.
2. The Workflow validator command uses top-level `skills/`.
3. Project provenance uses the family-local license link documented above.

## Validation

Run from the repository root:

```powershell
python skills/agent-organization/agent-project-organization/scripts/test_validate_projects.py
python skills/agent-organization/agent-project-organization/scripts/validate_projects.py .
python skills/agent-organization/agent-workflow-organization/scripts/validate_workflows.py .
```

Also compare normalized inventory and hashes with Mono 1.1.0, allowing only the three corrections. Require 14 recursively discovered unique folder-matched skills, 14 valid matching metadata files, resolved local resources, and passing trigger, routing, ambiguity, approval, and stop-rule scenarios.

When delegation is prohibited, record that deterministic scenarios are not equivalent to fresh-context agent testing.

## Update Policy

Treat the repository copy as canonical for this workspace. To update it, select an explicit upstream version, compare complete inventories and hashes, review semantic changes, reapply only documented portability deviations, run all bundled and workspace validators, repeat the behavioral scenario matrix, obtain independent review, and record the new provenance. Never persist an installed-cache or other machine-local source path in tracked files.

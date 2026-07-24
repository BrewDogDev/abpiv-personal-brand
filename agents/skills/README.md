# Agent Skills

This directory is the repository-owned source for harness-agnostic agent skills. Discovery must recurse through every nested directory and treat each `SKILL.md` as an independently discoverable skill; a family router does not hide its children.

## Vendored Family

### `agent-organization`

- Source: [`BrewDogDev/abpiv-agents`](https://github.com/BrewDogDev/abpiv-agents)
- Source package version: `0.1.30`
- Copied scope: the complete 23-file `agent-organization` family, including its family router, domain specialists, Project lifecycle children, templates, references, validator scripts, validator tests, and upstream license text
- License: the source package declares MIT; the copied family also retains the [upstream MIT license](agent-organization/references/upstream-license.md) required by its adapted Project and skill-testing material
- Repository portability deviation: in [`agent-project-organization/SKILL.md`](agent-organization/agent-project-organization/SKILL.md), the upstream-license link is `../references/upstream-license.md` instead of the package-relative `../../software-delivery/references/upstream-license.md`, because this repository vendors the license inside this family and does not vendor the sibling `software-delivery` family

The copied family depends on skills that are not vendored in this directory: `domain-driven-consulting`, `grill-me`, `dispatching-parallel-agents`, `requesting-code-review`, `receiving-code-review`, `self-improving-skill`, and `handoff`. A harness must provide those capabilities separately when the selected procedure invokes them. The family remains useful for routes and checks that do not require an absent dependency.

## Validation

Run from the repository root:

```powershell
python agents/skills/agent-organization/agent-project-organization/scripts/test_validate_projects.py
python agents/skills/agent-organization/agent-project-organization/scripts/validate_projects.py .
python agents/skills/agent-organization/agent-workflow-organization/scripts/validate_workflows.py .
```

Also recursively enumerate `SKILL.md` files, require unique frontmatter names that match their containing folder, resolve every directly linked local resource, and compare the 23-file inventory and hashes with the selected upstream version while allowing only the documented link deviation.

## Update Policy

Treat the repository copy as canonical for this workspace. To update it, select an explicit upstream version, compare complete inventories and hashes, review semantic changes, reapply only documented portability deviations, run all bundled and workspace validators, repeat the behavioral scenario matrix, obtain independent review, and record the new provenance. Never persist an installed-cache or other machine-local source path in tracked files.

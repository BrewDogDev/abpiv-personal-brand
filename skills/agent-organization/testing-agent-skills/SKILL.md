---
name: testing-agent-skills
description: Use when a new or materially revised agent skill, router, discipline, technique, or reference needs behavioral validation beyond static schema checks, especially when trigger selection, stop behavior, pressure resistance, output shape, or cross-skill routing could fail in realistic use.
---

# Testing Agent Skills

Evaluate whether a skill changes agent behavior in the intended scenarios without creating trigger collisions, brittle ritual, or unsafe side effects. Use static validation first; add behavioral testing in proportion to complexity and risk.

Read the parent `agent-organization` skill and use `agent-skill-organization` for the skill's canonical structure, metadata, resources, and discovery.

## Define The Contract

Before testing, record:

- target skill and version or commit;
- intended trigger prompts and nearby non-trigger prompts;
- required behavior, output shape, approvals, and stop conditions;
- sibling skills that could conflict or should receive routing;
- environment and tools the test may use;
- prohibited mutations and external side effects;
- observable pass and fail criteria.

Use [scenario-matrix.md](references/scenario-matrix.md) to select coverage.

## Choose The Test Type

| Skill type | Primary evidence |
| --- | --- |
| Discipline or safety rule | Pressure scenarios with competing incentives and explicit stop behavior |
| Technique or workflow | Novel application scenarios, edge cases, and missing-information handling |
| Router or family | Positive selection, sibling discrimination, non-trigger, and cross-boundary routing |
| Reference | Retrieval accuracy, correct application, and gap detection |
| Output contract | Required fields, order, precision, and absence of invented content |

Do not use prohibitions to repair an output-shape failure when a positive template or contract would be clearer.

## Baseline

When the skill is new or a material behavior change is proposed:

1. Run representative scenarios without the new guidance when a clean baseline is feasible.
2. Record the actual behavior, omissions, rationalizations, or routing choices.
3. Confirm the baseline exposes a real gap. If it already succeeds consistently, reduce the skill or reconsider whether new guidance is needed.

For a revision, the prior committed skill may serve as the baseline. Do not destroy current work merely to reconstruct it; use a separate read-only copy or worktree.

## Forward Test

Use fresh-context agents only when the user, runtime, and repository permit delegation. Otherwise, run deterministic structural checks and document the behavioral limitation.

For each scenario:

1. Provide the target skill and only task-local evidence.
2. Do not reveal the intended answer, suspected loophole, or author's reasoning.
3. Keep mutation authority read-only or confined to a disposable isolated workspace.
4. Capture the resulting decision, output, tool use, artifacts, and stop behavior.
5. Score against predeclared criteria.

Use multiple independent samples when wording variance is the risk. One successful sample does not establish reliable behavior.

## Refine

Classify failures before editing:

- skipped rule under pressure: add a precise gate and counter the observed rationalization;
- wrong output shape: provide a positive contract or template;
- omitted required field: add it to the structure the agent fills;
- conditional behavior applied universally: key it to an observable predicate;
- trigger collision: sharpen frontmatter descriptions and router boundaries;
- missing procedure: add the smallest instruction or direct reference that closes the demonstrated gap.

Re-run the failing scenario and neighboring non-trigger cases after each change.

## Verification

Finish only when:

- canonical schema validation passes;
- metadata, folder, and name agree;
- every linked resource exists;
- positive, negative, edge, approval, and stop scenarios have recorded outcomes;
- sibling routing and recursive discovery pass;
- no test wrote to live production systems or broadened authority;
- limitations and untested harness behavior are explicit.

## Output

Report baseline, scenario matrix, environment, samples, pass and fail evidence, revisions, trigger and routing results, safety boundaries, static validation, and residual uncertainty.

## Provenance

Adapted from [`writing-skills`](https://github.com/obra/superpowers/tree/d884ae04edebef577e82ff7c4e143debd0bbec99/skills/writing-skills) in `obra/superpowers`, copyright 2025 Jesse Vincent. The scope is narrowed to behavioral testing because ABPIV's `agent-skill-organization` already owns authoring and discovery. See the [upstream MIT license](../references/upstream-license.md).

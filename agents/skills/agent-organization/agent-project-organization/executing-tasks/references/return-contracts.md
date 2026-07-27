# Implementer And Reviewer Return Contracts

Use these exact sections so the Project coordinator can resume from artifacts rather than conversation. Apply [capability-and-reasoning-classes.md](../../references/capability-and-reasoning-classes.md) when recording or evaluating a selection.

## `REPORT.md`

```markdown
# Task <id> Implementer Report

## Status

<DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED | BLOCKED: OVERSIZED>

## Outcome

<What exists now and how it satisfies the Task.>

## Changes

- <File, record, resource, or behavior changed>

## Selection And Isolation

- Capability class: <selected class and task evidence>
- Reasoning class: <selected class and task evidence>
- Isolation: <actual writer, worktree or resource boundary, and shared-state result>
- Authority and side effects: <actions taken and confirmation that bounds held>

## Verification

| Command or observation | Result | Evidence |
| --- | --- | --- |
| <check> | <pass, fail, or blocked> | <concise observed output or artifact> |

- Direct verification: <fresh evidence that proves the acceptance criteria>

## Test-First Evidence

- Red: <command and expected failure, approved exception, or not applicable>
- Green: <command and passing result>
- Broader checks: <command and result>

## Scope And Git

- Task base: <commit or stable state>
- Task head: <commit or stable state>
- Commits: <exact identities or None>
- Scope review: <owned paths and unrelated changes preserved>

## Reuse Assessment

- Candidate: <verified reusable knowledge or None>
- Evidence: <why it is reusable>
- Suggested canonical owner: <skill, Workflow, tool, MCP, access, adapter, context/reference, or repository docs>

## Concerns Or Needed Context

- <concern, blocker, exact missing decision, or None>
```

## `REVIEW.md`

Keep the review record proportional to its recorded depth. A clean `quick` review should usually fit the compact shape below without added sections, repeated requirements, diff narration, or command transcripts. Use `None` for empty finding classes. For `rigorous` review, add notes only for the named risk surfaces, material logic followed, relevant edge cases, and evidence gaps.

```markdown
# Task <id> Independent Review

## Boundary And Depth

- Task brief: <path>
- Report: <path>
- Base: <exact identity>
- Head: <exact identity>
- Diff or artifacts inspected: <paths or command>
- Review depth: <quick | rigorous>
- Depth rationale: <default quick basis or concrete rigorous escalation trigger>
- Reviewer selection: <capability and reasoning classes with concise review-risk evidence>
- Package ecosystem health: <excluded, or the exact accepted requirement that opts into a named concern>
- Authority: read-only except this review record

## Findings

- Critical: <finding and tight evidence, or None>
- Important: <finding and tight evidence, or None>
- Minor: <directly useful finding and tight evidence, or None>

## Verdict

- Specification: <COMPLIANT | NONCOMPLIANT>
- Quality: <APPROVED | NEEDS_FIXES>
- Readiness: <READY | NEEDS_FIXES>
- Evidence checked: <smallest set of commands or observations supporting the verdict>
- Residual risk: <specific in-scope uncertainty that matters to the next action, or None; never record excluded package ecosystem concerns>
```

For `rigorous` review, append only:

```markdown
## Rigorous Review Notes

<Named risk surfaces, material logic or interfaces traced, relevant edge cases, and evidence gaps.>
```

After fixes, append only:

```markdown
## Re-Review

<Amended head, resolved findings, fresh evidence, and new verdict.>
```

# Implementer And Reviewer Return Contracts

Use these exact sections so the Project coordinator can resume from artifacts rather than conversation.

## `REPORT.md`

```markdown
# Task <id> Implementer Report

## Status

<DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED | BLOCKED: OVERSIZED>

## Outcome

<What exists now and how it satisfies the Task.>

## Changes

- <File, record, resource, or behavior changed>

## Verification

| Command or observation | Result | Evidence |
| --- | --- | --- |
| <check> | <pass, fail, or blocked> | <concise observed output or artifact> |

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

```markdown
# Task <id> Independent Review

## Review Boundary

- Task brief: <path>
- Report: <path>
- Base: <exact identity>
- Head: <exact identity>
- Diff or artifacts inspected: <paths or command>
- Authority: read-only except this review record

## Findings

### Critical

- <Finding with tight file/line/symbol/artifact evidence or None>

### Important

- <Finding with tight evidence or None>

### Minor

- <Finding with tight evidence or None>

## Specification Compliance

<missing, extra, misunderstood, or compliant, with evidence>

## Task Quality

<approved or needs fixes, with evidence>

## Verification Assessment

- <Which claims the evidence proves, does not prove, or leaves uncertain>

## Reuse Assessment

<validated, rejected, or missing; canonical owner and rationale>

## Verdict

<READY | NEEDS_FIXES>

## Re-Review

<Append amended head, resolved findings, fresh evidence, and new verdict after fixes.>
```

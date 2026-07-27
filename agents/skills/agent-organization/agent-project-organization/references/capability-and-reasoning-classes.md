# Capability And Reasoning Classes

Use these portable classes when planning a bounded Task, selecting an implementer or reviewer, and recording the selection in Task artifacts. The classes describe required behavior; they do not grant authority or identify a particular runtime.

## Selection Factors

Inspect observable Task evidence:

- work type: implementation, investigation, review, or verification;
- ambiguity: completeness of requirements, interfaces, and expected behavior;
- consequence: security, correctness, data, cost, public impact, and recovery difficulty;
- complexity: number of interacting components, edge cases, and judgment calls;
- isolation: whether owned files, mutable resources, dependencies, approvals, and side effects are independent;
- verification strength: how directly deterministic checks prove acceptance;
- review risk: the chance that an implementation defect or specification miss survives ordinary review.

Choose the class that covers the highest material ambiguity, consequence, or complexity factor. Split an oversized Task before selection. Never compensate for unclear ownership, missing approval, unsafe side effects, or weak isolation by selecting a stronger class.

## Capability Classes

| Class | Select when observable evidence shows | Do not select when |
| --- | --- | --- |
| `deep` | Ambiguous, high-value, security-sensitive, multi-step, judgment-heavy, or difficult-to-verify work | The Task is oversized, unauthorized, or missing a material decision |
| `balanced` | Ordinary implementation that needs repository reasoning, navigation, tool use, and several related checks | The work is mechanically narrow or requires deep judgment |
| `fast-repeatable` | Narrow, explicit, low-consequence, deterministic work with strong direct verification | Requirements, ownership, side effects, or expected results are unclear |
| `rapid-explorer` | Read-heavy search, mapping, triage, summarization, or evidence gathering with no write side effects | The worker must implement, approve, or mutate shared state |

Capability selection does not weaken acceptance, direct verification, authority limits, or independent review. A fast implementer remains acceptable only when the end-to-end result passes those gates.

## Reasoning Classes

| Class | Select when observable evidence shows |
| --- | --- |
| `low` | Exact, well-scoped, mechanically verifiable work with little interpretation |
| `medium` | Ordinary implementation, repository navigation, and tool use with bounded tradeoffs |
| `high` | Complex debugging, consequential edge cases, security, independent review, or difficult verification |
| `exceptional` | Unusually difficult or consequential work where high reasoning is demonstrably insufficient |

Use the lowest reasoning class that reliably satisfies acceptance and review. Record why `exceptional` is necessary; do not select it merely because it is available.

Measure speed by end-to-end accepted completion, including implementation, direct verification, review failures, revisions, and re-review. First-response latency alone is not a speed result.

## Review Depth

Record one review depth independently from reviewer capability and reasoning:

| Depth | Select when observable evidence shows | Expected review |
| --- | --- | --- |
| `quick` | Default for narrow or ordinary work with clear acceptance, low or moderate consequence, and direct verification | Check the Task criteria, actual change, reported evidence, obvious regressions, and scope. Approve when that evidence gives reasonable confidence the result likely works. |
| `rigorous` | Security, privacy, permissions, money, identity, destructive or hard-to-recover data changes, public or production effects, complex or ambiguous business logic, concurrency, migrations, compatibility, broad cross-component behavior, weak verification, or an explicit requirement | Trace the material logic and interfaces, challenge risky assumptions and edge cases, and examine whether tests and evidence cover the named risks. |

Keep both depths bounded to the Task. A quick review is an informed sanity check, not an attempt to prove completeness: do not expand into adjacent architecture, speculative hardening, style preferences, or exhaustive edge-case search. A rigorous review is deeper, not unlimited.

Do not select `rigorous` merely because the Task changes code, belongs to a Project, has an independent reviewer, or can use a stronger model. For `quick`, use `fast-repeatable`/`low` only when the review is mechanically narrow with deterministic evidence; otherwise prefer `balanced`/`medium`. For `rigorous`, use the lowest capability and reasoning classes that cover the named risk rather than automatically selecting `deep`/`high`.

## Implementer And Reviewer Selection

Select capability and reasoning independently. A narrow but consequential verification may need a specialized capability shape and high reasoning; a broad read-only inventory may remain `rapid-explorer` with medium reasoning.

Every Project Task keeps a fresh independent reviewer, with `quick` review as the default. Select review depth, reviewer capability, and reviewer reasoning from review risk rather than copying the implementer selection. Escalate only when observable evidence meets the `rigorous` criteria. The reviewer remains read-only except for its review artifact.

Record review depth, both selections, isolation, direct evidence, and any escalation in the Task brief and return artifacts. If live evidence no longer supports the selected class or depth, stop and return the mismatch to the coordinator rather than silently changing scope or authority.

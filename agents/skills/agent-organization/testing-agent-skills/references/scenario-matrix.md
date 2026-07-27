# Skill Test Scenario Matrix

Select only scenarios relevant to the skill, but include at least one success, ambiguity, and stop case for complex behavioral skills.

| Scenario | What it tests | Example pass criterion |
| --- | --- | --- |
| Direct trigger | Obvious intended invocation | Skill is selected and follows its core contract |
| Paraphrased trigger | Discovery under different wording | Same skill selected without exact-name prompting |
| Near-neighbor | Sibling discrimination | Correct sibling or no skill selected |
| Non-trigger | Over-trigger resistance | Skill remains unused |
| Missing information | Clarification and safe inference | Inspects available evidence, then asks only if material |
| Pressure | Discipline under time, authority, sunk cost, or fatigue | Required gate remains intact |
| Approval boundary | External or destructive action | Stops or asks before crossing authority |
| Tool unavailable | Fallback and honesty | Uses safe equivalent or reports limitation |
| Conflicting sources | Evidence reconciliation | Surfaces conflict rather than choosing silently |
| Resume | Durable state and idempotence | Continues from artifacts without duplicating completed work |
| Output shape | Structural compliance | Required fields appear in the required order |
| Cross-skill route | Ownership boundary | Hands off to the correct specialist |

## Scenario Record

For each run, record:

```text
Scenario:
Skill version or commit:
Environment and tools:
Prompt or artifact:
Expected observable behavior:
Prohibited behavior:
Actual result:
Pass or fail:
Evidence:
Follow-up:
```

Keep prompts realistic and task-focused. Do not tell the test agent what failure the author expects.

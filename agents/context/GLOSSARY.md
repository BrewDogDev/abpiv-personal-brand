# Glossary

**Canonical Agent Context**:
The harness-agnostic source of repository meaning and routing under `agents/context/`.
_Avoid_: root handoff, AI notes

**Stable Context**:
Durable Layer 3 guidance that remains valid across runs and lives at the narrowest useful scope.
_Avoid_: current plan, run log, scratchpad

**Working Context**:
Layer 4 state that changes during delivery, including active Projects, Tasks, working artifacts, run history, learnings, and handoffs.
_Avoid_: policy, permanent source of truth

**Project**:
Active planned work owned by this repository context that requires multiple bounded Tasks or multiple agent sessions.
_Avoid_: any issue, any plan

**Task**:
A Project-owned unit sized for one non-delegating implementer session plus independent review.
_Avoid_: thread, arbitrary to-do

**Workflow**:
A reusable agent outcome contract with explicit stages, dependencies, gates, and outputs.
_Avoid_: GitHub Actions workflow, n8n runtime workflow

**Stable Reference**:
A durable Layer 3 document placed at the narrowest scope shared by all of its consumers.
_Avoid_: handoff, scratchpad

**Run History**:
Preserved Layer 4 evidence from a specific prior effort that is not active control state.
_Avoid_: current plan, stable policy

**Preview Branch**:
The `preview` integration branch. Eligible content-site changes pushed here automatically deploy to the preview site, and this is the only permitted pull-request source for `main`.
_Avoid_: production branch

**Production Branch**:
The `main` branch. It is the production source branch, but a merge to it does not itself deploy the content site to production.
_Avoid_: deployment

**Production Deployment**:
An explicitly dispatched GitHub Actions job using the `production` environment after changes have reached `main`.
_Avoid_: merge to main

**Same-Origin Analytics**:
The public collection boundary in which site browsers load the analytics script and send events through `/_analytics/*` on the same public site origin.
_Avoid_: browser calls to the private analytics dashboard origin

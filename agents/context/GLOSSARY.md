# Glossary

## Brand Language

**Potential Partner**:
A person or organization that might build, invest, buy, collaborate, advise, or exchange serious work with Allan B. Pedin IV. The term includes investors, customers, clients, collaborators, and serious peers when the relationship depends on mutual trust and repeated value creation.
_Avoid_: Audience, followers, prospects

**Partnerable**:
Worth choosing for repeated collaboration because a person or organization is legible, credible, and useful. TAP makes a player partnerable by making their information easier to understand, their signals easier to trust, and their judgment more valuable.
_Avoid_: Likeable, agreeable, networked

**Values as Strategy**:
The view that ethical operating principles can also be strategically optimal in repeated, trust-dependent life and business games. The point is not that values are branding, but that durable value creation often rewards transparent, authentic, and perspicacious moves.
_Avoid_: Virtue signaling, moral posture, brand values

**Repeated Multiplayer Game**:
A life or business environment where people interact over time, decisions affect future options, and trust changes what future cooperation is possible. The core article thesis is that life and business are non-zero-sum, repeated, incomplete-information, asymmetric, multiplayer games, and TAP is the strategy for winning them.
_Avoid_: One-off transaction, zero-sum contest

**Objective Function**:
An actor's definition of success in the repeated multiplayer game. Companies, nonprofits, governments, individuals, and communities can all optimize for different outcomes, but each needs trust and partnership to accomplish its objective more easily over repeated rounds.
_Avoid_: Goal, mission, KPI

**Short-Term Gamesmanship**:
An operating style that optimizes for isolated wins through opacity, persona-building, clever positioning, or selective truth at the expense of durable trust. It is the article's foil for TAP.
_Avoid_: Strategy, ambition, competitiveness

**Strong Thesis Voice**:
A public-writing voice built around a clear, durable claim that can organize the reader's worldview. It should feel decisive, strategic, and original without imitating another author's prose.
_Avoid_: Casual reflection, memoir, soft thought leadership

## Agent And Repository Language

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

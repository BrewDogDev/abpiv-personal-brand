# Project Context

## Purpose

Hold Layer 4 delivery state for active multi-Task or multi-session work in the ABPIV personal-brand repository.

## Project Contract

- [`ROUTING.md`](ROUTING.md) is the active Project registry.
- Each active Project owns one `PROJECT.md`, one authoritative `PLAN.md`, bounded Task directories, and Project-local handoffs.
- A Task is sized for one non-delegating implementer plus independent review.
- Implementers modify only their ready Task scope, write the required Task return artifacts, and never update Project control state.
- The Project coordinator owns the Task ledger, status transitions, integration, and closure.
- Completed or cancelled Projects move intact to [`archive/`](archive/README.md) and are no longer active routes.

## Layer And Continuity Boundaries

- Project state is working context, never a stable reference or a substitute for a recurring Workflow.
- Project handoffs remain inside that Project's `handoff/` directory; they do not update the context-level handoff pointer.
- Legacy plans not created under this contract remain run history and must not be rewritten as active Project state.
- Durable results or reusable procedures require explicit review and promotion to their canonical owners before Project closure.

## How To Start

Use the `agent-project-organization` classifier. Read the selected Project's `PROJECT.md`, `PLAN.md`, current Task brief, and latest Project-local handoff before planning or executing work.

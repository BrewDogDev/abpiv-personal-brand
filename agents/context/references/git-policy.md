# Git Policy

## Purpose

Keep repository work reviewable, preserve unrelated state, and maintain the documented `preview` to `main` promotion path without coupling a merge to a production deployment.

## Before Editing

1. Resolve the exact repository and worktree.
2. Read the closest `AGENTS.md`, canonical context, route, Task or request, and affected implementation documentation.
3. Inspect `git status --short --branch`, the current branch, `git worktree list`, remotes, and the relevant base and target refs.
4. Record unrelated modified or untracked files as preservation boundaries.
5. Use a dedicated topic branch for structural, multi-domain, or Project work. New topic branches normally start from the current `origin/preview` integration state.
6. Stop if branch roles, the intended base, or overlapping changes are ambiguous.

Never use destructive reset, checkout, clean, or force-push operations to remove work. Never read or stage ignored secret-bearing local configuration.

## Branch And Environment Roles

| Role | Source and promotion target | Required evidence or gate | Deployment effect |
| --- | --- | --- | --- |
| Topic branch, commonly `codex/*` | Branch from the current `origin/preview`; integrate reviewed work into `preview`. | Task-scoped checks, independent review when required, exact staging, and scope inspection. | None while isolated. A later eligible push to `preview` can trigger preview deployment. |
| `preview` | Integration branch and the only allowed pull-request source for `main`. | Relevant local/domain checks before integration; the PR to `main` must pass repository checks and review. | An eligible content-site push automatically runs the `Content Site` preview deployment to `https://content-site.lobst3rs.com/info/`. |
| `main` | Production source; receives changes through a pull request from `preview`. | [`Main Source Guard`](../../../.github/workflows/main-source-guard.yml) rejects other PR sources. Relevant CI runs according to each workflow's path filters. | A merge does not deploy the content site to production. |
| `preview` GitHub environment | Used by the `Content Site` preview deployment job. | The deployment job must pass its configuration checks. | Publishes the Cloudflare Pages preview site. |
| `production` GitHub environment | Used by content hosting setup, content production deployment, analytics apply/provision, and n8n apply/redeploy. | Explicit workflow dispatch and confirmation input where defined, plus any configured environment approval. Production publication must already be authorized. | Can change public hosting or production infrastructure. |

The canonical promotion sequence is topic branch -> `preview` -> pull request from `preview` to `main` -> merge by the authorized owner -> separate manual production action when desired.

## Workflow-Specific Gates

- [`deploy.yml`](../../../.github/workflows/deploy.yml) runs content-site CI on relevant pull requests to `main` and pushes to `preview` or `main`. Preview deploys automatically from `preview`; production deploys only through `workflow_dispatch` from `main` with `target=production`.
- [`main-source-guard.yml`](../../../.github/workflows/main-source-guard.yml) requires `preview` as the head branch of every pull request to `main`.
- [`content-site-setup.yml`](../../../.github/workflows/content-site-setup.yml) is manual. Production setup requires `main`; preview DNS repair requires `preview`.
- [`analytics-apply.yml`](../../../.github/workflows/analytics-apply.yml) and [`analytics-provision.yml`](../../../.github/workflows/analytics-provision.yml) are manual, confirmation-gated, and use the `production` environment.
- [`n8n-validate.yml`](../../../.github/workflows/n8n-validate.yml) validates relevant n8n changes on pull requests, pushes to `main`, or manual dispatch.
- [`n8n-apply.yml`](../../../.github/workflows/n8n-apply.yml) and [`n8n-redeploy.yml`](../../../.github/workflows/n8n-redeploy.yml) are manual, confirmation-gated, and use the `production` environment.

Do not infer authorization to dispatch, approve, deploy, apply, merge, or change permissions from permission to edit repository files.

## Staging, Commit, And Review

1. Run the checks selected in [`verification.md`](verification.md).
2. Inspect the unstaged diff and confirm every changed path is owned by the current Task or request.
3. Stage exact file paths. Do not use broad staging when unrelated or coordinator-owned changes exist.
4. Review `git diff --cached --check`, `git diff --cached --stat`, and the full staged diff.
5. Scan staged tracked text for private-key blocks, credential-shaped values, and unintended machine-local paths.
6. Commit one coherent change with an outcome-focused message.
7. Record the commit identity, checks, branch, push state, and remaining dirty state in the Task report or handoff.

Independent review uses the actual task base and head commits, not an assumed `HEAD~1` range. Only the Project coordinator changes Project status or control records.

## Push And Pull Request

- Fetch and compare remote refs before publication.
- Never force push.
- Do not push unrelated commits or files.
- A topic branch is not a valid head for a pull request directly to `main`; integrate it into `preview` first.
- A pull request to `main` must use `preview` as its head and be opened ready for review when publication is authorized.
- Do not merge the pull request or run a production deployment unless that separate action is explicitly authorized.

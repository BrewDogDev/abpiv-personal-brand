# Task 03 Implementer Report

## Status

DONE

## Outcome

The integrated migration now exposes the top-level `agent-organization` family
directly from the repository map, maps that family and its 14 source interface
metadata records through the active Codex adapter, documents cache-safe
canonical validator commands, and ignores Python-generated cache output.

The complete Project result passes the required source-parity, discovery,
metadata, link, JSON, validator, deterministic-scenario, old-path, safety,
history-preservation, and scope checks. This implementation is ready for the
planned independent review. Publication, Project control-state changes,
archival, push, pull-request creation, merge, and deployment remain
coordinator-owned and were not performed.

## Skills And Ownership

- Mode: Migrate.
- Required Mono 1.1.0 skills used:
  `agent-organization`, `agent-context-organization`,
  `agent-adapter-organization`, `agent-skill-organization`,
  `self-improving-skill`, `requesting-code-review`,
  `receiving-code-review`, and `verification-before-completion`.
- Context ownership: promote durable discovery and verification rules only in
  the Task-owned stable references.
- Adapter ownership: describe Codex mapping and source interface metadata
  without copying skill bodies or claiming a generated manifest.
- Skill ownership: inspect and validate the family read-only; do not modify its
  canonical bodies or metadata.
- Learning ownership: promote the four explicitly approved reusable rules
  through their stable owners; retain the rejected one-use verifier candidates
  only in existing Project history.
- Review ownership: prepare the self-contained package below. No Task 03 review
  feedback exists yet, so there is no feedback ledger or implementer fix to
  apply under `receiving-code-review`.

## Focused Evidence Cycle

The documentation-only equivalent of an initial failing observation reported:

```text
map_skill_route=False
adapter_linked_family=False
adapter_metadata_count=False
verification_cache_safe_tests=False
ignore_probe_exit=1
ignore_probe_matches=0
```

After the bounded edits, the same assertions report the repository-map route,
linked adapter family, 14-record metadata statement, no-generated-manifest
boundary, and all three `python -B` commands as present. These read-only ignore
probes each exit zero and identify the expected rule without creating a file:

```powershell
git check-ignore --no-index -v -- 'cache-probe/__pycache__/module.cpython-313.pyc'
git check-ignore --no-index -v -- 'cache-probe/module.pyc'
git check-ignore --no-index -v -- 'cache-probe/module.pyo'
```

The matches are `.gitignore:9:__pycache__/`, `.gitignore:10:*.pyc`, and
`.gitignore:11:*.pyo`. A recursive filesystem check reports zero generated
cache or bytecode files before and after all Python validation.

## Changes

- `.gitignore`: ignores `__pycache__/`, `*.pyc`, and `*.pyo`.
- `agents/context/references/repository-map.md`: adds a direct linked route to
  the top-level canonical family and its inventory/provenance policy.
- `agents/context/references/verification.md`: records the 31-test command and
  both live validators with `python -B`, plus the no-bytecode reason.
- `adapters/codex/README.md`: links the canonical family and accurately
  describes its 14 colocated source `agents/openai.yaml` records as source
  interface metadata, not adapter-generated output or a generated manifest.
- This `REPORT.md`: records the integrated result and review package.

Root `AGENTS.md` and `README.md` were inspected and not changed. Both already
route through canonical context and the repository map, so another root pointer
would duplicate discovery rather than close a gap.

## Mono 1.1.0 Source And Family Evidence

The selected read-only package manifest reports:

| Field | Value |
| --- | --- |
| Package | `mono` |
| Version | `1.1.0` |
| Author | CipherPlay Labs |
| Repository | `https://github.com/CipherPlayLabs/mono` |

The installed source location is intentionally not persisted. For a
reproduction, bind `MONO_1_1_0_AGENT_ORGANIZATION` to a separately verified
Mono 1.1.0 `skills/agent-organization` source and compare it with
`skills/agent-organization/`, normalizing CRLF and CR to LF and excluding only
`__pycache__`, `.pyc`, and `.pyo`.

Fresh normalized comparison results:

- source files: 37;
- repository files: 37;
- inventory delta: 0;
- normalized exact matches: 35;
- documented-deviation files: 2;
- documented one-occurrence corrections: 3;
- unexpected differences: 0.

The three corrections remain exactly:

1. the Project validator command uses top-level `skills/`;
2. the family-local upstream-license link resolves inside the vendored family;
3. the Workflow validator command uses top-level `skills/`.

Recursive validation reports 14 `SKILL.md` files, 14 globally unique
folder-matched frontmatter names, 14 colocated `agents/openai.yaml` records,
and 14/14 prompts invoking the matching `$skill-name`. All metadata records
match the selected source after newline normalization.

## Whole-Project Verification

Run from the repository root:

```powershell
python -B skills/agent-organization/agent-project-organization/scripts/test_validate_projects.py
python -B skills/agent-organization/agent-project-organization/scripts/validate_projects.py .
python -B skills/agent-organization/agent-workflow-organization/scripts/validate_workflows.py .
```

Results:

- Project-validator suite: PASS, 31 tests, `OK`.
- Live Project validator: PASS, 1 active Project, 1 archived Project, 3 Task
  directories, 0 warnings.
- Live Workflow validator: PASS, 0 routes, 0 Workflows, 0 stages, 0 warnings.
- Changed-and-neighboring active Markdown: PASS, 150 rendered local links
  resolved across the root entrypoints, canonical context and governance,
  active registries, Codex/access/MCP owner documents, and the complete skill
  family.
- Credential-free active JSON examples: PASS, 2/2 fenced JSON blocks parse.
- Deterministic behavior matrix: PASS, 8/8 direct-trigger,
  paraphrased-trigger, near-neighbor, non-trigger, missing-information,
  approval-boundary, stop-rule, and cross-skill-route assertions.
- Active former-owner scan: PASS, zero
  `agents/{skills,tools,mcp-servers,access,adapters,templates}/` matches outside
  immutable archives, legacy runs, and this Project's historical evidence.
- Generated-output scan: PASS, zero tracked or filesystem `__pycache__`,
  `.pyc`, or `.pyo` files.
- Whole-Project safety scan: PASS, zero private-key blocks,
  credential-shaped values, known token prefixes, installed-cache paths,
  user-specific absolute paths, or generated bytecode in the result.
- Immutable history: PASS, no difference from `c58a221` under the July 24
  archived Project or `agents/context/runs/legacy/`.
- Prohibited domains: PASS, no difference from `c58a221` under
  `content-site/`, `infra/`, `creative-production/`, or
  `.github/workflows/`.
- Whole-Project scope: PASS. Every changed path is `.gitignore`, root or
  canonical agent documentation, a top-level agent owner, or this Project's
  records; no application, infrastructure, workflow, brand, immutable archive,
  or legacy-run path changed.

### Exact Terminating Whole-Project Commands

Run the three canonical validators above, then run the following command from
the repository root in PowerShell. Before running it, set
`MONO_1_1_0_AGENT_ORGANIZATION` to the separately verified Mono 1.1.0
`skills/agent-organization` source directory. The command deliberately does
not record that external machine-local path. It uses only the Python standard
library, terminates on every mismatch, and prints the observed counts.

```powershell
@'
from pathlib import Path
from urllib.parse import unquote
import hashlib
import json
import os
import re
import subprocess

root = Path.cwd()
repo_family = root / "skills/agent-organization"
source_value = os.environ.get("MONO_1_1_0_AGENT_ORGANIZATION")
assert source_value, "Set MONO_1_1_0_AGENT_ORGANIZATION."
source_family = Path(source_value)
assert source_family.is_dir(), source_family
manifest_path = source_family.parent.parent / ".codex-plugin/plugin.json"
manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
assert manifest["name"] == "mono"
assert manifest["version"] == "1.1.0"
assert manifest["repository"] == "https://github.com/CipherPlayLabs/mono"

def generated(path):
    return "__pycache__" in path.parts or path.suffix in {".pyc", ".pyo"}

def inventory(directory):
    return {
        path.relative_to(directory).as_posix(): path
        for path in directory.rglob("*")
        if path.is_file() and not generated(path.relative_to(directory))
    }

def normalized(path):
    return path.read_bytes().replace(b"\r\n", b"\n").replace(b"\r", b"\n")

repo_files = inventory(repo_family)
source_files = inventory(source_family)
assert len(repo_files) == 37
assert len(source_files) == 37
assert set(repo_files) == set(source_files)
different = [
    relative
    for relative in sorted(repo_files)
    if hashlib.sha256(normalized(repo_files[relative])).digest()
    != hashlib.sha256(normalized(source_files[relative])).digest()
]
project_skill = "agent-project-organization/SKILL.md"
workflow_skill = "agent-workflow-organization/SKILL.md"
assert different == [project_skill, workflow_skill]
project_expected = normalized(source_files[project_skill])
project_replacements = (
    (
        b"python agents/skills/agent-organization/"
        b"agent-project-organization/scripts/validate_projects.py .",
        b"python skills/agent-organization/"
        b"agent-project-organization/scripts/validate_projects.py .",
    ),
    (
        b"../../software-delivery/references/upstream-license.md",
        b"../references/upstream-license.md",
    ),
)
for old, new in project_replacements:
    assert project_expected.count(old) == 1
    project_expected = project_expected.replace(old, new, 1)
workflow_expected = normalized(source_files[workflow_skill])
workflow_old = (
    b"python agents/skills/agent-organization/"
    b"agent-workflow-organization/scripts/validate_workflows.py "
    b"<workspace-root>"
)
workflow_new = (
    b"python skills/agent-organization/"
    b"agent-workflow-organization/scripts/validate_workflows.py "
    b"<workspace-root>"
)
assert workflow_expected.count(workflow_old) == 1
workflow_expected = workflow_expected.replace(workflow_old, workflow_new, 1)
assert normalized(repo_files[project_skill]) == project_expected
assert normalized(repo_files[workflow_skill]) == workflow_expected

skills = sorted(repo_family.rglob("SKILL.md"))
assert len(skills) == 14
names = []
for path in skills:
    text = path.read_text(encoding="utf-8").replace("\r\n", "\n")
    assert text.startswith("---\n")
    frontmatter = text.split("---\n", 2)[1].strip().splitlines()
    parsed = dict(line.split(":", 1) for line in frontmatter)
    parsed = {key.strip(): value.strip() for key, value in parsed.items()}
    assert set(parsed) == {"name", "description"}
    assert parsed["name"] == path.parent.name
    names.append(parsed["name"])
assert len(set(names)) == 14

metadata = sorted(repo_family.rglob("agents/openai.yaml"))
assert len(metadata) == 14
for path in metadata:
    text = path.read_text(encoding="utf-8")
    assert re.search(r"(?m)^interface:\s*$", text)
    keys = set(re.findall(r"(?m)^  ([a-z_]+):", text))
    assert keys == {"display_name", "short_description", "default_prompt"}
    skill_name = path.parent.parent.name
    assert skill_name in names
    assert f"${skill_name}" in text

markdown = list(root.rglob("*.md"))
active_markdown = [
    path
    for path in markdown
    if (
        path.relative_to(root).as_posix() in {"AGENTS.md", "README.md"}
        or path.relative_to(root).parts[0]
        in {"access", "adapters", "mcp-servers", "templates", "tools", "skills"}
        or (
            path.relative_to(root).as_posix().startswith("agents/context/")
            and not path.relative_to(root).as_posix().startswith(
                (
                    "agents/context/projects/archive/",
                    "agents/context/runs/legacy/",
                )
            )
        )
    )
]
link_pattern = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")
fence_pattern = re.compile(r"^```.*?^```\s*$", re.MULTILINE | re.DOTALL)
link_count = 0
link_failures = []
for path in sorted(active_markdown):
    rendered = fence_pattern.sub("", path.read_text(encoding="utf-8"))
    for match in link_pattern.finditer(rendered):
        target = match.group(1).strip().strip("<>")
        if target.startswith(("http://", "https://", "mailto:", "#", "//")):
            continue
        target = unquote(target.split("#", 1)[0].split("?", 1)[0])
        if not target:
            continue
        link_count += 1
        if not (path.parent / target).resolve().exists():
            link_failures.append((path.as_posix(), target))
assert len(active_markdown) == 72
assert link_count >= 190
assert not link_failures, link_failures

json_blocks = 0
for path in active_markdown:
    posix = path.relative_to(root).as_posix()
    if posix.startswith("agents/context/projects/"):
        continue
    text = path.read_text(encoding="utf-8")
    for block in re.findall(
        r"^```json\s*\n(.*?)^```\s*$",
        text,
        re.MULTILINE | re.DOTALL,
    ):
        json.loads(block)
        json_blocks += 1
assert json_blocks == 2

parent = (repo_family / "SKILL.md").read_text(encoding="utf-8")
skill_owner = (
    repo_family / "agent-skill-organization/SKILL.md"
).read_text(encoding="utf-8")
skill_testing = (
    repo_family / "testing-agent-skills/SKILL.md"
).read_text(encoding="utf-8")
scenarios = {
    "direct_trigger": (
        "designing, auditing, creating, updating, nesting, moving, or "
        "validating harness-agnostic agent skills"
    )
    in skill_owner,
    "paraphrased_trigger": (
        "behavioral validation beyond static schema checks" in skill_testing
    ),
    "near_neighbor": all(
        term in parent
        for term in (
            "| Tools |",
            "| MCP servers |",
            "`agent-tool-organization`",
            "`agent-mcp-organization`",
        )
    ),
    "non_trigger": (
        "Do not own workspace semantic context, executable tool contracts, "
        "MCP runtime documentation"
    )
    in skill_owner,
    "missing_information": (
        "one focused question at a time, with a recommended answer" in parent
    ),
    "approval_boundary": (
        "Require approval before moving, renaming, deleting, publishing, "
        "or breaking a skill contract"
    )
    in skill_owner,
    "stop_rule": all(
        term in skill_owner
        for term in (
            "Stop if recursive discovery cannot be demonstrated",
            "canonical authoring schema is ambiguous",
        )
    ),
    "cross_skill_route": (
        "Use `testing-agent-skills` for realistic forward scenarios"
        in skill_owner
        and "use `testing-agent-skills` for behavioral validation" in parent
    ),
}
assert all(scenarios.values()), scenarios

def git(*arguments, check=True):
    return subprocess.run(
        ["git", *arguments],
        check=check,
        capture_output=True,
        text=True,
    )

old_path = git(
    "grep",
    "-n",
    "-E",
    r"agents/(skills|tools|mcp-servers|access|adapters|templates)/",
    "--",
    ".",
    ":(exclude)agents/context/projects/archive/**",
    ":(exclude)agents/context/runs/legacy/**",
    ":(exclude)agents/context/projects/"
    "agent-documentation-mono-layout-migration/**",
    check=False,
)
assert old_path.returncode == 1
assert not old_path.stdout
agent_paths = git("ls-files", "agents").stdout.splitlines()
assert agent_paths
assert all(path.startswith("agents/context/") for path in agent_paths)

task_01_base = "56e47bd0ef98447de33cce1eb4be95994df594f0"
old_roots = (
    "agents/access",
    "agents/adapters",
    "agents/mcp-servers",
    "agents/templates",
    "agents/tools",
)
old_rows = git("ls-tree", "-r", task_01_base, "--", *old_roots).stdout.splitlines()
same_blob = 0
edited_blob = 0
new_paths = []
for row in old_rows:
    match = re.match(r"^\d+ blob ([0-9a-f]+)\t(.+)$", row)
    assert match, row
    old_blob, old_path_value = match.groups()
    new_path = old_path_value.removeprefix("agents/")
    assert (root / new_path).is_file()
    current_blob = git("hash-object", "--", new_path).stdout.strip()
    same_blob += current_blob == old_blob
    edited_blob += current_blob != old_blob
    new_paths.append(new_path)
assert len(old_rows) == 21
assert len(new_paths) == 21
assert same_blob == 14
assert edited_blob == 7
assert not git(
    "ls-files",
    "--",
    "agents/access",
    "agents/adapters",
    "agents/mcp-servers",
    "agents/templates",
    "agents/tools",
).stdout

skill_status = git(
    "diff",
    "--name-status",
    "-M",
    "55248f674332234e3d9002d273ab571587aa4984.."
    "ccb422569e4f17c6eb05e037f0d217d1110b01ff",
).stdout.splitlines()
assert len([row for row in skill_status if row.startswith("R")]) == 24
assert len([row for row in skill_status if row.startswith("A")]) == 15
assert len(skill_status) == 39

whole_project = git(
    "diff",
    "--name-only",
    "c58a221201057c3fb67ec31db198575fb0ff9970..HEAD",
).stdout.splitlines()
allowed_roots = (
    ".gitignore",
    "AGENTS.md",
    "README.md",
    "agents/",
    "access/",
    "adapters/",
    "mcp-servers/",
    "templates/",
    "tools/",
    "skills/",
)
assert len(whole_project) == 78
assert all(path.startswith(allowed_roots) for path in whole_project)
prohibited = (
    "content-site/",
    "infra/",
    "creative-production/",
    ".github/workflows/",
    "agents/context/projects/archive/"
    "2026-07-24-agent-infrastructure-migration/",
    "agents/context/runs/legacy/",
)
assert not any(path.startswith(prohibited) for path in whole_project)
assert git(
    "diff",
    "--quiet",
    "c58a221201057c3fb67ec31db198575fb0ff9970",
    "--",
    "content-site",
    "infra",
    "creative-production",
    ".github/workflows",
    "agents/context/projects/archive/"
    "2026-07-24-agent-infrastructure-migration",
    "agents/context/runs/legacy",
    check=False,
).returncode == 0

task_03_original = set(
    git(
        "diff",
        "--name-only",
        "c7acaba73f58c94fcb4e0b1c47ac38b731d27a55.."
        "d6b5dbe17b1d439bbd1903fb0c20e7e77ca6a743",
    ).stdout.splitlines()
)
expected_task_03 = {
    ".gitignore",
    "adapters/codex/README.md",
    "agents/context/references/repository-map.md",
    "agents/context/references/verification.md",
    "agents/context/projects/agent-documentation-mono-layout-migration/"
    "tasks/03_integrated-review-publication/REPORT.md",
}
assert task_03_original == expected_task_03
revision_base = "0bd3c8736cb32f48d30980f9a5d5fbb72a27b2a2"
revision_paths = set(
    git("diff", "--name-only", f"{revision_base}..HEAD").stdout.splitlines()
)
revision_paths.update(git("diff", "--name-only").stdout.splitlines())
revision_paths.update(git("diff", "--cached", "--name-only").stdout.splitlines())
assert revision_paths == {
    "agents/context/projects/agent-documentation-mono-layout-migration/"
    "tasks/03_integrated-review-publication/REPORT.md"
}

tracked = git("ls-files").stdout.splitlines()
tracked_generated = [
    path
    for path in tracked
    if "__pycache__/" in path or path.endswith((".pyc", ".pyo"))
]
filesystem_generated = [
    path
    for path in root.rglob("*")
    if path.is_file() and generated(path)
]
assert not tracked_generated
assert not filesystem_generated

safety_patterns = {
    "private_key": re.compile(
        r"-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----"
    ),
    "user_absolute": re.compile(
        r"(?i)(?:[A-Z]:[\\/]Users[\\/][A-Za-z0-9._-]+[\\/]|"
        r"/Users/[A-Za-z0-9._-]+/|/home/[A-Za-z0-9._-]+/)"
    ),
    "installed_cache": re.compile(
        r"(?i)\.codex[\\/]plugins[\\/]cache[\\/]"
    ),
    "known_token": re.compile(
        r"(?i)(?:ghp_[A-Za-z0-9]{20,}|"
        r"github_pat_[A-Za-z0-9_]{20,}|"
        r"sk-[A-Za-z0-9]{20,}|AIza[A-Za-z0-9_-]{20,})"
    ),
    "credential_assignment": re.compile(
        r"(?im)^\s*(?:password|token|api[_-]?key|client[_-]?secret|"
        r"private[_-]?key)\s*[:=]\s*[\"']?"
        r"[A-Za-z0-9/+_.=-]{16,}[\"']?\s*$"
    ),
}
safety_findings = []
for relative in whole_project:
    path = root / relative
    if not path.is_file():
        continue
    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        continue
    if path.suffix == ".md":
        text = fence_pattern.sub("", text)
    for label, pattern in safety_patterns.items():
        if pattern.search(text):
            safety_findings.append((relative, label))
assert not safety_findings, safety_findings

print(f"source_inventory={len(repo_files)}/{len(source_files)}")
print(f"source_exact={len(repo_files) - len(different)}")
print("source_corrections=3_in_2_files")
print(f"skills={len(skills)} metadata={len(metadata)}")
print(f"active_markdown={len(active_markdown)} links={link_count}")
print(f"json={json_blocks} scenarios={sum(scenarios.values())}/8")
print(
    f"owner_moves={len(old_rows)} "
    f"same={same_blob} edited={edited_blob}"
)
print("skill_moves=24 metadata_and_report_additions=15")
print(f"whole_project_paths={len(whole_project)}")
print("old_paths=0 generated=0 safety=0 prohibited=0")
'@ | python -B -
if ($LASTEXITCODE -ne 0) {
  throw 'Whole-Project assertion command failed.'
}
```

The remote and separate-local-`main` reconciliation is reproduced with this
terminating PowerShell command. It intentionally stops if either remote has
moved since the recorded review basis.

```powershell
$ErrorActionPreference = 'Stop'
$recordedMain = '7b6267d23dc092dad007f04756325be0861002bc'
$recordedPreview = 'c58a221201057c3fb67ec31db198575fb0ff9970'
git fetch --prune origin main preview
if ($LASTEXITCODE -ne 0) {
  throw 'Fetch failed.'
}
if (
  (git rev-parse origin/main).Trim() -ne $recordedMain -or
  (git rev-parse origin/preview).Trim() -ne $recordedPreview
) {
  throw 'Remote identity moved; reconcile before publication.'
}
if (
  (git rev-parse 'origin/main^{tree}').Trim() -ne
  (git rev-parse 'origin/preview^{tree}').Trim()
) {
  throw 'Recorded main and preview trees differ.'
}
$blocks = (git worktree list --porcelain) -join "`n" -split "`n`n"
$mainBlock = @($blocks | Where-Object {
  $_ -match '(?m)^branch refs/heads/main$'
})
if ($mainBlock.Count -ne 1) {
  throw 'Expected exactly one local main worktree.'
}
$localMain = (
  @($mainBlock[0] -split "`n" | Where-Object {
    $_ -like 'worktree *'
  })[0]
).Substring(9)
if (
  (git -C $localMain rev-parse HEAD).Trim() -ne $recordedMain -or
  @(git -C $localMain status --porcelain=v1 --untracked-files=all).Count -ne 0
) {
  throw 'Separate local main is not clean at recorded origin/main.'
}
$relation = @(git -C $localMain rev-list --left-right --count HEAD...origin/main)
if (($relation -join "`t") -notmatch '^0\s+0$') {
  throw 'Separate local main differs from origin/main.'
}
```

These focused ignore and Git artifact commands terminate independently:

```powershell
$ErrorActionPreference = 'Stop'
$probes = @(
  'cache-probe/__pycache__/module.cpython-313.pyc',
  'cache-probe/module.pyc',
  'cache-probe/module.pyo'
)
foreach ($probe in $probes) {
  git check-ignore --no-index -q -- $probe
  if ($LASTEXITCODE -ne 0) {
    throw "Ignore probe failed: $probe"
  }
}
git diff --check c58a221201057c3fb67ec31db198575fb0ff9970..HEAD
if ($LASTEXITCODE -ne 0) {
  throw 'Whole-Project whitespace check failed.'
}
git diff --check 0bd3c8736cb32f48d30980f9a5d5fbb72a27b2a2..HEAD
if ($LASTEXITCODE -ne 0) {
  throw 'Task 03 revision whitespace check failed.'
}
```

## Remote And Local-Main Reconciliation

A fresh `git fetch --prune origin main preview` completed successfully.

| Ref or worktree | Identity | Observation |
| --- | --- | --- |
| Project base / `origin/preview` | `c58a221201057c3fb67ec31db198575fb0ff9970` | No update since the recorded Project base. |
| `origin/main` | `7b6267d23dc092dad007f04756325be0861002bc` | No update since the Project amendment. |
| Separate local `main` | `7b6267d23dc092dad007f04756325be0861002bc` | Clean, on `main`, 0 ahead and 0 behind `origin/main`. |
| Topic dispatch base | `c7acaba73f58c94fcb4e0b1c47ac38b731d27a55` | Clean Task 03 implementation base. |

`origin/main`, `origin/preview`, and the separate local `main` all resolve to
tree `51643ede9e87dacec00b6e75dd5ce6768c598f99`. Their commit topology differs
because `7b6267d` is the squash publication of the same migration tree already
present at `c58a221`; `git diff --quiet origin/main origin/preview` and the
local-main comparison both exit zero.

There are zero `origin/main` commits after the recorded `7b6267d` identity and
zero `origin/preview` commits after the recorded `c58a221` identity. Therefore
the user-reported `main` update is already reconciled in the Project base, no
new agent-documentation content overlaps this Task, and the Task stop rule does
not fire.

Before this Task commit, the topic is 18 commits ahead and 0 behind
`origin/preview`. Relative to the squashed `origin/main` topology it is 41
commits ahead and 1 behind; this is expected divergent history with an
identical base tree, not content drift. The coordinator must fetch and repeat
the tree/path comparison immediately before publication.

## Reuse Assessment

`self-improving-skill` promotion is complete for the four explicit, reviewed
rules in this Task:

| Verified reusable rule | Stable owner |
| --- | --- |
| Direct top-level family discovery | `agents/context/references/repository-map.md` |
| Source metadata count, mapping, and non-generated boundary | `adapters/codex/README.md` |
| Cache-safe canonical Python validators | `agents/context/references/verification.md` |
| Generated Python cache exclusion | `.gitignore` and the verification reference |

The Task 01 one-use owner-migration verifier and Task 02 one-use normalized
family comparison remain only in existing Project history. Both independent
reviews rejected promotion without recurring demand; this Task does not create
a script, tool, skill, learning-log entry, or new owner for them.

## Residual Limitations

- The non-delegating Task contract prevents fresh-context agent samples.
  Deterministic 8/8 text assertions verify trigger, routing, approval, and stop
  contracts but are not claimed as independent behavioral execution.
- The selected Mono package is read-only external evidence and is not vendored
  beyond the already reviewed 37-file family. Future parity checks must bind an
  independently verified Mono 1.1.0 source without recording its machine-local
  installation path.
- Independent review and coordinator publication evidence do not yet exist.
  This report claims only a verified implementation ready for those later
  gates.

## Review Package

### Review Goal

Determine whether Task 03 integrates the Mono-layout migration completely,
reconciles remote and local `main` truthfully, and is safe for coordinator
closure and publication through `preview` to `main`.

### Requirements

- Source:
  `agents/context/projects/agent-documentation-mono-layout-migration/tasks/03_integrated-review-publication/TASK.md`.
- Whole-Project basis:
  `agents/context/projects/agent-documentation-mono-layout-migration/PROJECT.md`
  and `PLAN.md`.
- Non-goals: do not modify the checkout, index, branch, remotes, Project
  control state, external systems, pull requests, deployment state, archives,
  legacy runs, implementation domains, skill bodies, access/MCP/tool/template
  bodies, or the historical Kilo adapter.

### Change Range

- Whole Project: `c58a221201057c3fb67ec31db198575fb0ff9970..HEAD`.
- Task 03 base: `c7acaba73f58c94fcb4e0b1c47ac38b731d27a55`.
- Task 03 head: the implementation commit containing this report; use the
  exact identity returned by the implementer, not `HEAD~1`.
- Full Task diff:
  `git diff c7acaba73f58c94fcb4e0b1c47ac38b731d27a55...<task-head> -- .gitignore agents/context/references/repository-map.md agents/context/references/verification.md adapters/codex/README.md agents/context/projects/agent-documentation-mono-layout-migration/tasks/03_integrated-review-publication/REPORT.md`.

### Evidence Already Available

- Focused discovery, adapter metadata, cache-safe command, and ignore cycle:
  PASS.
- Normalized Mono comparison: PASS, 37/37 files, 35 exact, exactly three
  documented corrections in two files.
- Discovery and metadata: PASS, 14 skills and 14 mappings.
- Active links and JSON: PASS, 150 links and 2/2 JSON blocks.
- Tests and validators: PASS, 31 tests and both live validators with zero
  warnings.
- Deterministic scenarios: PASS, 8/8 with the documented limitation.
- Whole-Project old-path, safety, generated-cache, immutable-history,
  prohibited-domain, and scope checks: PASS.
- Remote reconciliation: PASS; fetched refs and clean local `main` are
  unchanged, and the `main` and `preview` trees are identical.

### Named Risks

- A direct route or metadata statement could drift from the canonical family.
- A Python validator could regenerate bytecode if `-B` is omitted.
- Squash topology could be mistaken for unreconciled content drift.
- Active old-owner paths could remain hidden outside the known exclusions.
- Project history, implementation domains, or secret-bearing local state could
  be changed or exposed by an over-broad publication step.
- The coordinator could archive or publish before consuming an exact independent
  verdict and rerunning remote gates.

### Review Contract

- Work read-only; do not alter the working tree, index, branch, remotes, or
  external systems.
- Verify claims against both exact ranges and focused surrounding contracts.
- Cite every finding with a file and tight line reference.
- Classify findings as Critical, Important, or Minor.
- Return findings first, then open questions, verification assessment, reuse
  assessment, and a clear `READY` or `NEEDS_FIXES` verdict in this Task's
  `REVIEW.md`.

## Coordinator Publication And Closure Sequence

1. Commission the independent read-only review against the exact Task base and
   implementation head. If findings arrive, apply `receiving-code-review`,
   amend only Task-owned scope, rerun covering checks, and require fresh
   re-review.
2. After a `READY` verdict, commit the reviewer record and update only
   coordinator-owned Task/Project control state to consume the verdict, mark
   the Task complete, and move the still-active Project to `closing`. Keep its
   active route and Project-local handoff writable; do not archive yet.
3. Fetch `origin/main` and `origin/preview` again. Stop for controlled
   reconciliation if either recorded identity or any overlapping
   agent-documentation path changed.
4. Integrate the reviewed migration and closing-state commits into `preview`,
   inspect the exact range, and push only that intended result. Open the first
   pull request with `preview` as the head and `main` as the base. Merge only
   after required checks pass and no blocking review finding remains; the
   original request authorizes this merge.
5. Fetch again and verify the observed first merge. While the Project remains
   active and `closing`, record the exact first-PR identity, checks, merge
   commit, `origin/main`, `origin/preview`, and resulting tree in its final
   Project-local handoff. Do not substitute an expected future identity.
6. Only after that observed migration evidence exists, set the Project to
   `archived-complete`, remove its active route, and move the intact Project to
   `agents/context/projects/archive/2026-07-27-agent-documentation-mono-layout-migration/`,
   then rerun Project, Workflow, link, safety, scope, history, and archive
   validation before publication.
7. Integrate that closure-only change into `preview`, fetch and reconcile
   again, then push the reviewed closure result. Open a second `preview` to
   `main` pull request, wait for its required checks, and merge it only when
   the archived tree and removed active route are verified.
8. Fetch once more and prove that `origin/main` contains both the migrated
   top-level owners and the intact archived Project, while active routing no
   longer contains it. Record the second PR, check, merge, ref, and tree
   identities in coordinator publication evidence without modifying the
   immutable archive.
9. Do not dispatch a production deployment. A merge to `main` changes the
   production source but is not a production deployment.

This is a two-PR lifecycle: the first PR publishes the migration while the
Project is still active and able to record observed merge evidence; the second
publishes the resulting immutable closure. Archival never claims success that
has not yet been observed.

## Review Feedback Ledger And Revision Evidence

| Review item | Severity | Verification and disposition | Status |
| --- | --- | --- | --- |
| The original sequence archived before the migration PR and observed merge. | Important | Valid. The sequence above keeps the Project active and `closing` through the first observed merge, records exact external evidence in the final Project-local handoff, then archives and publishes closure through a second PR. | Implemented; pending fresh re-review. |
| Whole-Project custom checks lacked exact terminating reproduction commands. | Important | Valid. The self-contained standard-library assertion command, remote/local-main command, ignore probes, validator commands, and pinned Git ranges above cover the required source, metadata, links, JSON, scenarios, moves, old paths, safety, generated output, scope, immutable/prohibited paths, refs, and diff checks. | Implemented; pending fresh re-review. |
| `skills/README.md` omits `-B` from its neighboring validator examples. | Minor | Valid and nonblocking because `.gitignore` prevents generated bytecode from entering the tracked result, but explicitly outside this report-only revision scope. No edit was made; the coordinator retains the consistency concern. | Acknowledged; open nonblocking coordinator concern. |

Revision basis and preservation:

- Coordinator revision base:
  `0bd3c8736cb32f48d30980f9a5d5fbb72a27b2a2`.
- Original Task 03 implementation:
  `c7acaba73f58c94fcb4e0b1c47ac38b731d27a55..d6b5dbe17b1d439bbd1903fb0c20e7e77ca6a743`.
- Revision scope: only this `REPORT.md`; `.gitignore`,
  `adapters/codex/README.md`, `agents/context/references/repository-map.md`,
  and `agents/context/references/verification.md` remain byte-identical to the
  reviewed implementation head.
- `REVIEW.md`, `skills/README.md`, Project control state, prior Tasks,
  archives, legacy runs, branches, remotes, and external systems remain
  unchanged by the implementer.
- Exact revision commit identity, fresh command results, staged-diff evidence,
  and clean post-commit state are returned to the coordinator because a commit
  cannot contain its own object identity.

## Commit Gate

The original implementation gate staged exactly the five Task-owned files
listed above. This review revision must stage only this `REPORT.md`, then run:

```powershell
git diff --cached --check
git diff --cached --stat
git diff --cached
git status --short --branch
```

The full staged diff and a targeted staged-text safety scan must pass before one
coherent commit. A commit cannot contain its own object identity; the exact
implementation commit and post-commit state are returned to the coordinator
with this report and form the review head.

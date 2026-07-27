#!/usr/bin/env python3
"""Validate Project and Task records in an agent workspace."""

from __future__ import annotations

import argparse
import re
import sys
from datetime import date
from pathlib import Path, PurePosixPath


ACTIVE_PROJECT_STATUSES = {
    "discovery",
    "planning",
    "ready",
    "executing",
    "blocked",
    "replanning",
    "closing",
}
ARCHIVED_PROJECT_STATUSES = {"archived-complete", "archived-cancelled"}
TASK_STATUSES = {
    "planned",
    "ready",
    "executing",
    "review",
    "revisions",
    "complete",
    "blocked",
}
TASK_REQUIRED_FILES = {
    "ready": {"TASK.md"},
    "executing": {"TASK.md"},
    "blocked": {"TASK.md"},
    "review": {"TASK.md", "REPORT.md"},
    "revisions": {"TASK.md", "REPORT.md", "REVIEW.md"},
    "complete": {"TASK.md", "REPORT.md", "REVIEW.md"},
}
BOUNDED_TASK_CONTRACT_STATUSES = TASK_STATUSES - {"planned"}
BOUNDED_TASK_CONTRACT_HEADINGS = (
    "Status",
    "Parent Project And Live Basis",
    "Role, Outcome, And Acceptance",
    "Relevant Context And Source Paths",
    "Owned Scope",
    "Do Not Touch",
    "Interfaces",
    "Skills, Tools, Authority, And Selection",
    "Implementation Contract",
    "Verification And Evidence",
    "Ambiguity And Escalation",
    "Reuse Assessment",
    "Return And Review",
)
BOUNDED_TASK_CONTRACT_FIELDS = (
    ("Parent Project And Live Basis", "Project"),
    ("Parent Project And Live Basis", "Plan row"),
    ("Parent Project And Live Basis", "Planned from"),
    ("Parent Project And Live Basis", "Refreshed at"),
    ("Parent Project And Live Basis", "Dependencies verified"),
    ("Role, Outcome, And Acceptance", "Role"),
    ("Role, Outcome, And Acceptance", "Outcome"),
    ("Owned Scope", "Create"),
    ("Owned Scope", "Modify"),
    ("Owned Scope", "Test"),
    ("Interfaces", "Consumes"),
    ("Interfaces", "Produces"),
    ("Skills, Tools, Authority, And Selection", "Required implementation skills"),
    (
        "Skills, Tools, Authority, And Selection",
        "Required review and verification skills",
    ),
    ("Skills, Tools, Authority, And Selection", "Allowed tools and actions"),
    ("Skills, Tools, Authority, And Selection", "Approval-gated actions"),
    ("Skills, Tools, Authority, And Selection", "Prohibited actions"),
    ("Skills, Tools, Authority, And Selection", "Implementer capability class"),
    ("Skills, Tools, Authority, And Selection", "Implementer reasoning class"),
    ("Skills, Tools, Authority, And Selection", "Review depth"),
    ("Skills, Tools, Authority, And Selection", "Reviewer capability class"),
    ("Skills, Tools, Authority, And Selection", "Reviewer reasoning class"),
    ("Skills, Tools, Authority, And Selection", "Isolation requirements"),
    ("Verification And Evidence", "Focused check"),
    ("Verification And Evidence", "Required evidence"),
    ("Return And Review", "Implementer report"),
    ("Return And Review", "Expected return artifact"),
    ("Return And Review", "Independent review"),
    ("Return And Review", "Review requirements"),
    ("Return And Review", "Allowed implementer statuses"),
)
CAPABILITY_CLASSES = {"deep", "balanced", "fast-repeatable", "rapid-explorer"}
REASONING_CLASSES = {"low", "medium", "high", "exceptional"}
REVIEW_DEPTHS = {"quick", "rigorous"}
IMPLEMENTATION_CONTRACT_REQUIREMENTS = (
    ("non-delegating implementer", r"\b(?:do not delegate|non-delegat\w*)\b"),
    (
        "task-local context",
        r"\btask-local context\b.*\b(?:coordinator conversation|parent history)\b",
    ),
    ("material ambiguity", r"\bmaterial ambiguity\b"),
    (
        "test-first behavior change",
        r"\b(?:test-driven development|test-first|evidence cycle)\b",
    ),
    (
        "bounded implementation and checks",
        r"\bimplement only this task\b.*\bchecks?\b",
    ),
    (
        "report and control-state boundary",
        r"\breport\.md\b.*\bproject control state\b",
    ),
    ("oversized stop", r"\bblocked:\s*oversized\b"),
)
NOT_CREATED_VALUES = {"", "-", "—", "none", "not created", "not yet created", "n/a"}
MARKDOWN_LINK_RE = re.compile(r"\[[^\]]*\]\(([^)]+)\)")
TASK_DIRECTORY_RE = re.compile(r"(?P<task_id>\d+)_[a-z0-9][a-z0-9-]*")
ARCHIVE_DIRECTORY_RE = re.compile(
    r"(?P<closure_date>\d{4}-\d{2}-\d{2})-[a-z0-9][a-z0-9-]*"
)
HANDOFF_RECORD_RE = re.compile(
    r"\d{4}-\d{2}-\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*-handoff\.md"
)


def clean_cell(value: str) -> str:
    value = value.strip()
    if value.startswith("`") and value.endswith("`"):
        value = value[1:-1]
    return value.strip()


def is_within(path: Path, parent: Path) -> bool:
    try:
        path.relative_to(parent)
        return True
    except ValueError:
        return False


def display_path(path: Path, root: Path) -> str:
    try:
        return path.relative_to(root).as_posix()
    except ValueError:
        return str(path)


def markdown_target(value: str) -> str | None:
    match = MARKDOWN_LINK_RE.search(value)
    if not match:
        return None
    target = match.group(1).strip()
    if target.startswith("<") and target.endswith(">"):
        target = target[1:-1]
    return target


def table_rows(text: str, first_header: str, heading: str | None = None) -> list[list[str]]:
    lines = text.splitlines()
    start = 0
    if heading is not None:
        marker = f"## {heading}"
        try:
            start = lines.index(marker) + 1
        except ValueError:
            return []

    for index in range(start, len(lines)):
        line = lines[index]
        if heading is not None and index > start and line.startswith("## "):
            break
        if not line.lstrip().startswith("|"):
            continue
        header = [cell.strip() for cell in line.strip().strip("|").split("|")]
        if not header or clean_cell(header[0]).lower() != first_header.lower():
            continue

        rows: list[list[str]] = []
        for row_line in lines[index + 2 :]:
            if not row_line.lstrip().startswith("|"):
                break
            rows.append([cell.strip() for cell in row_line.strip().strip("|").split("|")])
        return rows
    return []


def project_status(project_path: Path, root: Path, errors: list[str]) -> str | None:
    if not project_path.is_file():
        return None
    text = project_path.read_text(encoding="utf-8")
    match = re.search(
        r"^## Status\s*$.*?^\s*-\s*Status:\s*`?([a-z][a-z0-9-]*)`?\s*$",
        text,
        flags=re.MULTILINE | re.DOTALL | re.IGNORECASE,
    )
    if not match:
        errors.append(f"{display_path(project_path, root)}: missing '- Status: <status>' under ## Status")
        return None
    return match.group(1).lower()


def resolve_relative(candidate: str, base: Path, boundary: Path) -> Path | None:
    normalized = candidate.strip().replace("\\", "/")
    if (
        not normalized
        or normalized.startswith(("/", "#"))
        or re.match(r"^[a-z][a-z0-9+.-]*:", normalized, flags=re.IGNORECASE)
    ):
        return None
    resolved = base.joinpath(*PurePosixPath(normalized).parts).resolve()
    if not is_within(resolved, boundary.resolve()):
        return None
    return resolved


def validate_latest_handoff(
    latest_path: Path,
    handoff_root: Path,
    root: Path,
    errors: list[str],
) -> None:
    text = latest_path.read_text(encoding="utf-8")
    local_targets = [
        target
        for target in MARKDOWN_LINK_RE.findall(text)
        if not target.startswith(("#", "http://", "https://"))
    ]
    label = display_path(latest_path, root)
    if not local_targets:
        errors.append(f"{label}: latest.md has no local handoff target")
        return
    for target in local_targets:
        normalized_target = target.strip("<>").replace("\\", "/")
        target_path = PurePosixPath(normalized_target)
        filename = target_path.name
        if len(target_path.parts) != 1:
            errors.append(
                f"{label}: latest.md target must be a direct child of "
                f"project handoff/: {target}"
            )
        if not HANDOFF_RECORD_RE.fullmatch(filename):
            errors.append(
                f"{label}: latest.md target must use "
                f"YYYY-MM-DD-<goal-slug>-handoff.md: {target}"
            )
        resolved = resolve_relative(normalized_target, latest_path.parent, handoff_root)
        if resolved is None:
            errors.append(f"{label}: latest.md target escapes project handoff/: {target}")
        elif resolved == latest_path.resolve():
            errors.append(f"{label}: latest.md cannot point to itself")
        elif not resolved.is_file():
            errors.append(f"{label}: latest.md target does not resolve: {target}")


def markdown_section(text: str, heading: str) -> str | None:
    match = re.search(
        rf"^##[ \t]+{re.escape(heading)}[ \t]*\r?\n"
        r"(.*?)(?=^##[ \t]+|\Z)",
        text,
        flags=re.MULTILINE | re.DOTALL,
    )
    return match.group(1) if match is not None else None


def bounded_field_value(section: str, field: str) -> str | None:
    match = re.search(
        rf"^[ \t]*-[ \t]*{re.escape(field)}:[ \t]*(\S[^\r\n]*)[ \t]*$",
        section,
        flags=re.MULTILINE | re.IGNORECASE,
    )
    return match.group(1).strip() if match is not None else None


def validate_bounded_task_contract(
    task_path: Path,
    task_id: str,
    root: Path,
    errors: list[str],
) -> None:
    text = task_path.read_text(encoding="utf-8")
    label = display_path(task_path, root)
    headings = {
        match.group(1).strip()
        for match in re.finditer(r"^##\s+(.+?)\s*$", text, flags=re.MULTILINE)
    }
    for heading in BOUNDED_TASK_CONTRACT_HEADINGS:
        if heading not in headings:
            errors.append(
                f"{label}: Task {task_id} bounded contract is missing heading: "
                f"## {heading}"
            )

    sections = {
        heading: markdown_section(text, heading)
        for heading in BOUNDED_TASK_CONTRACT_HEADINGS
    }
    field_values: dict[str, str] = {}
    for heading, field in BOUNDED_TASK_CONTRACT_FIELDS:
        section = sections.get(heading)
        value = bounded_field_value(section, field) if section is not None else None
        if value is None:
            errors.append(
                f"{label}: Task {task_id} bounded contract is missing field: {field}"
            )
        else:
            field_values[field] = value

    status_section = sections.get("Status")
    if status_section is not None and re.search(
        r"^Ready[ \t]*$", status_section, flags=re.MULTILINE | re.IGNORECASE
    ) is None:
        errors.append(
            f"{label}: Task {task_id} bounded contract is missing content under "
            "heading: ## Status"
        )

    acceptance_section = sections.get("Role, Outcome, And Acceptance")
    acceptance_header = (
        re.search(
            r"^[ \t]*-[ \t]*Acceptance criteria:[ \t]*$",
            acceptance_section,
            flags=re.MULTILINE | re.IGNORECASE,
        )
        if acceptance_section is not None
        else None
    )
    acceptance_item = (
        re.search(r"^[ \t]+-[ \t]+\S", acceptance_section, flags=re.MULTILINE)
        if acceptance_section is not None
        else None
    )
    if acceptance_header is None or acceptance_item is None:
        errors.append(f"{label}: Task {task_id} bounded contract is missing acceptance criterion")

    context_section = sections.get("Relevant Context And Source Paths")
    if context_section is not None and re.search(
        r"^[ \t]*-[ \t]+[^\r\n]*`[^`\r\n]+`",
        context_section,
        flags=re.MULTILINE,
    ) is None:
        errors.append(f"{label}: Task {task_id} bounded contract is missing task-local source path")

    exclusions_section = sections.get("Do Not Touch")
    if exclusions_section is not None and re.search(
        r"^[ \t]*-[ \t]+\S", exclusions_section, flags=re.MULTILINE
    ) is None:
        errors.append(f"{label}: Task {task_id} bounded contract is missing exclusion content")

    implementation_section = sections.get("Implementation Contract")
    if implementation_section is not None:
        for requirement, pattern in IMPLEMENTATION_CONTRACT_REQUIREMENTS:
            if re.search(
                pattern,
                implementation_section,
                flags=re.IGNORECASE | re.DOTALL,
            ) is None:
                errors.append(
                    f"{label}: Task {task_id} implementation contract is missing "
                    f"requirement: {requirement}"
                )

    verification_section = sections.get("Verification And Evidence")
    if verification_section is not None:
        if not any(
            bounded_field_value(verification_section, field) is not None
            for field in ("Broader check", "Project check", "Skill checks")
        ):
            errors.append(f"{label}: Task {task_id} bounded contract is missing broader verification")
        if not any(
            bounded_field_value(verification_section, field) is not None
            for field in ("Diff or artifact review", "Diff review", "Artifact review")
        ):
            errors.append(f"{label}: Task {task_id} bounded contract is missing diff or artifact review")

    ambiguity_section = sections.get("Ambiguity And Escalation")
    ambiguity_items = (
        re.findall(r"^[ \t]*-[ \t]+\S[^\r\n]*", ambiguity_section, flags=re.MULTILINE)
        if ambiguity_section is not None
        else []
    )
    if (
        ambiguity_section is not None
        and (
            len(ambiguity_items) < 2
            or re.search(r"\bescalat\w*\b", ambiguity_section, re.IGNORECASE) is None
        )
    ):
        errors.append(f"{label}: Task {task_id} bounded contract is missing escalation instruction")

    reuse_section = sections.get("Reuse Assessment")
    if reuse_section is not None and (
        not reuse_section.strip()
        or re.search(r"\breport\.md\b", reuse_section, re.IGNORECASE) is None
    ):
        errors.append(f"{label}: Task {task_id} bounded contract is missing reuse assessment content")

    for field, allowed in (
        ("Implementer capability class", CAPABILITY_CLASSES),
        ("Implementer reasoning class", REASONING_CLASSES),
        ("Review depth", REVIEW_DEPTHS),
        ("Reviewer capability class", CAPABILITY_CLASSES),
        ("Reviewer reasoning class", REASONING_CLASSES),
    ):
        raw_value = field_values.get(field)
        if raw_value is None:
            continue
        token_match = re.match(r"`([^`]+)`|([a-z][a-z0-9-]*)", raw_value, re.IGNORECASE)
        value = (
            (token_match.group(1) or token_match.group(2)).lower()
            if token_match is not None
            else raw_value.lower()
        )
        if value not in allowed:
            errors.append(f"{label}: Task {task_id} has invalid {field}: {value}")
        if field == "Review depth" and value == "rigorous":
            rationale = raw_value[token_match.end() :].strip(" \t:;,-.") if token_match else ""
            if not rationale:
                errors.append(
                    f"{label}: Task {task_id} rigorous review depth is missing "
                    "a named risk rationale"
                )


def validate_task_ledger(
    project: Path,
    root: Path,
    errors: list[str],
    task_owners: dict[Path, set[str]],
    *,
    require_complete: bool = False,
    enforce_bounded_contract: bool = False,
) -> int:
    plan_path = project / "PLAN.md"
    tasks_root = project / "tasks"
    if not plan_path.is_file() or not tasks_root.is_dir():
        return 0

    label = display_path(project, root)
    rows = table_rows(plan_path.read_text(encoding="utf-8"), "Task", "Task Ledger")
    ledger: dict[str, str] = {}
    if not rows:
        errors.append(f"{display_path(plan_path, root)}: missing or empty Task Ledger table")
    for row_number, row in enumerate(rows, start=1):
        if len(row) < 4:
            errors.append(f"{display_path(plan_path, root)}: Task Ledger row {row_number} has fewer than four columns")
            continue
        task_id = clean_cell(row[0])
        status = clean_cell(row[3]).lower()
        if not re.fullmatch(r"\d+", task_id):
            errors.append(f"{display_path(plan_path, root)}: invalid Task id: {task_id}")
            continue
        if task_id in ledger:
            errors.append(f"{display_path(plan_path, root)}: duplicate Task id: {task_id}")
            continue
        ledger[task_id] = status
        if status not in TASK_STATUSES:
            errors.append(f"{label}: Task {task_id} has invalid status: {status}")
        elif require_complete and status != "complete":
            errors.append(
                f"{label}: archived-complete Project has non-complete "
                f"Task {task_id}: {status}"
            )

    task_dirs = sorted(path for path in tasks_root.iterdir() if path.is_dir())
    directories_by_id: dict[str, list[Path]] = {}
    for task_dir in task_dirs:
        match = TASK_DIRECTORY_RE.fullmatch(task_dir.name)
        if not match:
            errors.append(f"{display_path(task_dir, root)}: invalid Task directory name")
            continue
        task_id = match.group("task_id")
        directories_by_id.setdefault(task_id, []).append(task_dir)
        resolved = task_dir.resolve()
        task_owners.setdefault(resolved, set()).add(project.name)
        if not is_within(resolved, tasks_root.resolve()):
            errors.append(f"{display_path(task_dir, root)}: Task directory escapes its owning Project")
        if task_id not in ledger:
            errors.append(f"{label}: Task directory {task_dir.name} is not declared in PLAN.md")

    for task_id, directories in sorted(directories_by_id.items()):
        if len(directories) > 1:
            names = ", ".join(directory.name for directory in directories)
            errors.append(f"{label}: Task {task_id} has multiple Task directories: {names}")

    for task_id, status in sorted(ledger.items()):
        directories = directories_by_id.get(task_id, [])
        if status in TASK_REQUIRED_FILES and not directories:
            errors.append(f"{label}: {status} Task {task_id} has no Task directory")
            continue
        if len(directories) != 1 or status not in TASK_REQUIRED_FILES:
            continue
        task_dir = directories[0]
        for required_file in sorted(TASK_REQUIRED_FILES[status]):
            if not (task_dir / required_file).is_file():
                errors.append(f"{display_path(task_dir, root)}: Task {task_id} is missing {required_file}")
        task_path = task_dir / "TASK.md"
        if (
            enforce_bounded_contract
            and status in BOUNDED_TASK_CONTRACT_STATUSES
            and task_path.is_file()
        ):
            validate_bounded_task_contract(task_path, task_id, root, errors)

    return len(task_dirs)


def validate_active_project(
    project: Path,
    route_status: str,
    route_latest: str,
    root: Path,
    projects_root: Path,
    errors: list[str],
    task_owners: dict[Path, set[str]],
) -> int:
    label = display_path(project, root)
    for required_file in ("PROJECT.md", "PLAN.md"):
        if not (project / required_file).is_file():
            errors.append(f"{label}: missing {required_file}")
    for required_directory in ("tasks", "handoff"):
        if not (project / required_directory).is_dir():
            errors.append(f"{label}: missing {required_directory}/")

    actual_status = project_status(project / "PROJECT.md", root, errors)
    if actual_status in ARCHIVED_PROJECT_STATUSES:
        errors.append(f"{label}: completed or cancelled Project cannot remain active")
    elif actual_status is not None and actual_status not in ACTIVE_PROJECT_STATUSES:
        errors.append(f"{label}: invalid active Project status: {actual_status}")

    normalized_route_status = clean_cell(route_status).lower()
    if normalized_route_status in ARCHIVED_PROJECT_STATUSES:
        errors.append(f"{label}: completed or cancelled Project cannot remain active")
    elif normalized_route_status not in ACTIVE_PROJECT_STATUSES:
        errors.append(f"{label}: invalid active route status: {normalized_route_status}")
    if actual_status is not None and normalized_route_status != actual_status:
        errors.append(
            f"{label}: route status {normalized_route_status} does not match "
            f"Project status {actual_status}"
        )

    handoff_root = project / "handoff"
    if handoff_root.is_dir():
        latest_path = handoff_root / "latest.md"
        if latest_path.is_file():
            validate_latest_handoff(latest_path, handoff_root, root, errors)

        latest_value = clean_cell(route_latest)
        if latest_value.lower() in NOT_CREATED_VALUES:
            if latest_path.is_file():
                errors.append(
                    f"{label}: ROUTING.md says 'Not created' but handoff/latest.md exists"
                )
        else:
            target = markdown_target(latest_value)
            if target is None:
                errors.append(f"{label}: latest handoff route must be a Markdown link or 'Not created'")
            else:
                route_base = projects_root if target.replace("\\", "/").startswith(f"{project.name}/") else project
                resolved = resolve_relative(target, route_base, handoff_root)
                if resolved is None:
                    errors.append(f"{label}: latest handoff route escapes project handoff/: {target}")
                elif resolved != latest_path.resolve():
                    errors.append(f"{label}: latest handoff route must resolve to handoff/latest.md: {target}")
                elif not resolved.is_file():
                    errors.append(f"{label}: latest handoff route does not resolve: {target}")

    return validate_task_ledger(
        project,
        root,
        errors,
        task_owners,
        enforce_bounded_contract=True,
    )


def validate_archive(archive_root: Path, root: Path, errors: list[str]) -> int:
    if not archive_root.is_dir():
        return 0
    archived_projects = sorted(path for path in archive_root.iterdir() if path.is_dir())
    for project in archived_projects:
        label = display_path(project, root)
        archive_match = ARCHIVE_DIRECTORY_RE.fullmatch(project.name)
        if archive_match is None:
            errors.append(f"{display_path(archive_root, root)}: invalid archive folder name: {project.name}")
        else:
            closure_date = archive_match.group("closure_date")
            try:
                date.fromisoformat(closure_date)
            except ValueError:
                errors.append(f"{label}: invalid archive closure date: {closure_date}")

        for required_file in ("PROJECT.md", "PLAN.md"):
            if not (project / required_file).is_file():
                errors.append(f"{label}: archived Project is missing {required_file}")
        for required_directory in ("tasks", "handoff"):
            if not (project / required_directory).is_dir():
                errors.append(f"{label}: archived Project is missing {required_directory}/")

        project_path = project / "PROJECT.md"
        if not project_path.is_file():
            continue
        status = project_status(project_path, root, errors)
        if status is not None and status not in ARCHIVED_PROJECT_STATUSES:
            errors.append(f"{label}: invalid archived Project status: {status}")

        handoff_root = project / "handoff"
        if handoff_root.is_dir():
            latest_path = handoff_root / "latest.md"
            if not latest_path.is_file():
                errors.append(f"{label}: archived Project is missing handoff/latest.md")
            else:
                validate_latest_handoff(latest_path, handoff_root, root, errors)

        validate_task_ledger(
            project,
            root,
            errors,
            {},
            require_complete=status == "archived-complete",
        )
    return len(archived_projects)


def validate_workspace(root: Path) -> tuple[list[str], list[str], int, int, int]:
    """Return validation findings and object counts for one workspace."""
    root = root.resolve()
    errors: list[str] = []
    warnings: list[str] = []
    projects_root = root / "agents" / "context" / "projects"
    context_path = projects_root / "CONTEXT.md"
    routing_path = projects_root / "ROUTING.md"
    archive_root = projects_root / "archive"

    if not context_path.is_file():
        errors.append(f"Missing Project context: {display_path(context_path, root)}")
    if not routing_path.is_file():
        errors.append(f"Missing active Project routing: {display_path(routing_path, root)}")
    if not archive_root.is_dir():
        errors.append(f"Missing Project archive directory: {display_path(archive_root, root)}")
    if not projects_root.is_dir():
        return errors, warnings, 0, 0, 0

    archived_count = validate_archive(archive_root, root, errors)
    active_dirs = {
        path.name: path
        for path in projects_root.iterdir()
        if path.is_dir() and path.name != "archive"
    }
    if not routing_path.is_file():
        for slug in sorted(active_dirs):
            errors.append(f"{display_path(projects_root, root)}: active Project directory is absent from ROUTING.md: {slug}")
        return errors, warnings, len(active_dirs), archived_count, 0

    route_rows = table_rows(routing_path.read_text(encoding="utf-8"), "Project")
    routed_slugs: set[str] = set()
    task_owners: dict[Path, set[str]] = {}
    task_count = 0
    for row_number, row in enumerate(route_rows, start=1):
        if len(row) < 5:
            errors.append(f"{display_path(routing_path, root)}: active Project row {row_number} has fewer than five columns")
            continue
        target = markdown_target(row[0])
        if target is None:
            errors.append(f"{display_path(routing_path, root)}: active Project row {row_number} has no Project link")
            continue
        normalized_target = target.replace("\\", "/")
        if normalized_target.startswith("archive/"):
            errors.append(f"{display_path(routing_path, root)}: route points into archive/: {target}")
            continue
        resolved_project_file = resolve_relative(target, projects_root, projects_root)
        if resolved_project_file is None:
            errors.append(f"{display_path(routing_path, root)}: Project route escapes projects/: {target}")
            continue
        if resolved_project_file.name != "PROJECT.md" or resolved_project_file.parent.parent != projects_root.resolve():
            errors.append(f"{display_path(routing_path, root)}: Project route must target <project>/PROJECT.md: {target}")
            continue
        project = resolved_project_file.parent
        slug = project.name
        if slug in routed_slugs:
            errors.append(f"{display_path(routing_path, root)}: duplicate active Project route: {slug}")
            continue
        routed_slugs.add(slug)
        if not project.is_dir():
            errors.append(f"{display_path(routing_path, root)}: active Project route does not resolve: {target}")
            continue
        task_count += validate_active_project(
            project,
            row[2],
            row[4],
            root,
            projects_root,
            errors,
            task_owners,
        )

    for slug in sorted(active_dirs.keys() - routed_slugs):
        errors.append(f"{display_path(projects_root, root)}: active Project directory is absent from ROUTING.md: {slug}")
    for resolved_task, owners in sorted(task_owners.items(), key=lambda item: str(item[0])):
        if len(owners) != 1:
            errors.append(
                f"{display_path(resolved_task, root)}: Task directory belongs to "
                f"{len(owners)} active Projects: {', '.join(sorted(owners))}"
            )

    return errors, warnings, len(active_dirs), archived_count, task_count


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("workspace", nargs="?", default=".", help="Workspace root (default: current directory)")
    args = parser.parse_args()
    root = Path(args.workspace).resolve()

    errors, warnings, active, archived, tasks = validate_workspace(root)
    for warning in warnings:
        print(f"WARNING: {warning}")
    for error in errors:
        print(f"ERROR: {error}", file=sys.stderr)
    if errors:
        print(
            f"Project validation failed: {len(errors)} error(s), {len(warnings)} warning(s)",
            file=sys.stderr,
        )
        return 1
    print(
        f"Project validation passed: {active} active Project(s), "
        f"{archived} archived Project(s), {tasks} Task directory(s), "
        f"{len(warnings)} warning(s)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

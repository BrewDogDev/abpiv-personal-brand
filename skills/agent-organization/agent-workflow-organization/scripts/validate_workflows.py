#!/usr/bin/env python3
"""Validate Markdown workflow and stage contracts in an agent workspace."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path, PurePosixPath


WORKFLOW_HEADINGS = {
    "Boundary",
    "Stages",
    "Review Points",
    "Shared References",
    "Stop Rules",
}
STAGE_HEADINGS = {
    "Purpose",
    "Inputs",
    "Process",
    "Outputs",
    "Human Review Gate",
    "Verify Gate",
    "Stop Rules",
}


def clean_cell(value: str) -> str:
    value = value.strip()
    if value.startswith("`") and value.endswith("`"):
        value = value[1:-1]
    return value.strip()


def headings(text: str) -> set[str]:
    return set(re.findall(r"^##\s+(.+?)\s*$", text, flags=re.MULTILINE))


def table_rows(text: str, heading: str) -> list[list[str]]:
    lines = text.splitlines()
    marker = f"## {heading}"
    try:
        start = lines.index(marker) + 1
    except ValueError:
        return []

    rows: list[list[str]] = []
    in_table = False
    for line in lines[start:]:
        if line.startswith("## "):
            break
        if not line.strip():
            if in_table:
                break
            continue
        if not line.lstrip().startswith("|"):
            if in_table:
                break
            continue
        in_table = True
        rows.append([cell.strip() for cell in line.strip().strip("|").split("|")])

    if len(rows) < 2:
        return []
    return rows[2:]


def is_within(path: Path, parent: Path) -> bool:
    try:
        path.relative_to(parent)
        return True
    except ValueError:
        return False


def looks_like_stable_path(value: str) -> bool:
    return bool(re.search(r"(?:^|[\\/]).+\.(?:md|json|ya?ml)$", value, re.IGNORECASE))


def validate_stable_paths(
    rows: list[list[str]],
    source_dir: Path,
    root: Path,
    label: str,
    errors: list[str],
    column: int = 0,
) -> None:
    for row in rows:
        if len(row) <= column:
            continue
        candidate = clean_cell(row[column])
        if candidate.startswith(("http://", "https://", "<")) or not looks_like_stable_path(candidate):
            continue
        resolved = (source_dir / candidate).resolve()
        if not is_within(resolved, root.resolve()):
            errors.append(f"{label}: stable path escapes workspace: {candidate}")
        elif not resolved.exists():
            errors.append(f"{label}: stable path does not resolve: {candidate}")


def validate_workspace(root: Path) -> tuple[list[str], list[str], int, int, int]:
    errors: list[str] = []
    warnings: list[str] = []
    context_root = root / "agents" / "context"
    workflows_root = context_root / "workflows"
    routing_path = context_root / "ROUTING.md"

    if not routing_path.is_file():
        return [f"Missing routing file: {routing_path}"], warnings, 0, 0, 0
    if not workflows_root.is_dir():
        return [f"Missing workflows directory: {workflows_root}"], warnings, 0, 0, 0

    route_rows = table_rows(routing_path.read_text(encoding="utf-8"), "Workflows")
    routed_workflows: set[Path] = set()
    routed_starts: dict[Path, set[str]] = {}

    for row_number, row in enumerate(route_rows, start=1):
        if len(row) < 3:
            errors.append(f"ROUTING.md workflow row {row_number} has fewer than three columns")
            continue
        relative_workflow = clean_cell(row[1]).replace("\\", "/")
        start_stage = clean_cell(row[2])
        workflow_dir = context_root.joinpath(*PurePosixPath(relative_workflow).parts).resolve()
        if not is_within(workflow_dir, workflows_root.resolve()):
            errors.append(f"ROUTING.md row {row_number} points outside agents/context/workflows: {relative_workflow}")
            continue
        routed_workflows.add(workflow_dir)
        routed_starts.setdefault(workflow_dir, set()).add(start_stage)
        if not (workflow_dir / "CONTEXT.md").is_file():
            errors.append(f"ROUTING.md row {row_number} workflow does not resolve: {relative_workflow}")
        if not (workflow_dir / "stages" / start_stage / "CONTEXT.md").is_file():
            errors.append(
                f"ROUTING.md row {row_number} start stage does not resolve: "
                f"{relative_workflow}/stages/{start_stage}"
            )

    workflow_count = 0
    stage_count = 0
    workflow_dirs = sorted(path for path in workflows_root.iterdir() if path.is_dir())
    for workflow_dir in workflow_dirs:
        workflow_count += 1
        workflow_context = workflow_dir / "CONTEXT.md"
        if not workflow_context.is_file():
            errors.append(f"{workflow_dir.relative_to(root)}: missing CONTEXT.md")
            continue

        workflow_text = workflow_context.read_text(encoding="utf-8")
        missing = WORKFLOW_HEADINGS - headings(workflow_text)
        if missing:
            errors.append(
                f"{workflow_context.relative_to(root)}: missing headings: {', '.join(sorted(missing))}"
            )

        stage_rows = table_rows(workflow_text, "Stages")
        declared_stages = [clean_cell(row[0]) for row in stage_rows if row]
        if not declared_stages:
            errors.append(f"{workflow_context.relative_to(root)}: no stages declared")
        if len(declared_stages) != len(set(declared_stages)):
            errors.append(f"{workflow_context.relative_to(root)}: duplicate stage declarations")

        stages_root = workflow_dir / "stages"
        actual_stages = (
            {path.name for path in stages_root.iterdir() if path.is_dir()}
            if stages_root.is_dir()
            else set()
        )
        declared_set = set(declared_stages)
        for stage_name in sorted(declared_set - actual_stages):
            errors.append(f"{workflow_dir.relative_to(root)}: declared stage missing directory: {stage_name}")
        for stage_name in sorted(actual_stages - declared_set):
            errors.append(f"{workflow_dir.relative_to(root)}: stage directory is undeclared: {stage_name}")

        for start_stage in routed_starts.get(workflow_dir.resolve(), set()):
            if start_stage not in declared_set:
                errors.append(
                    f"{workflow_context.relative_to(root)}: routed start stage is not declared: {start_stage}"
                )

        validate_stable_paths(
            table_rows(workflow_text, "Shared References"),
            workflow_dir,
            root,
            str(workflow_context.relative_to(root)),
            errors,
        )
        validate_stable_paths(
            table_rows(workflow_text, "Capability Dependencies"),
            workflow_dir,
            root,
            str(workflow_context.relative_to(root)),
            errors,
            column=1,
        )

        for stage_name in sorted(actual_stages):
            stage_count += 1
            if not re.fullmatch(r"\d+_[a-z0-9_]+", stage_name):
                errors.append(f"{workflow_dir.relative_to(root)}: invalid stage folder name: {stage_name}")
            stage_context = stages_root / stage_name / "CONTEXT.md"
            if not stage_context.is_file():
                errors.append(f"{stage_context.relative_to(root)}: missing file")
                continue
            stage_text = stage_context.read_text(encoding="utf-8")
            missing = STAGE_HEADINGS - headings(stage_text)
            if missing:
                errors.append(
                    f"{stage_context.relative_to(root)}: missing headings: {', '.join(sorted(missing))}"
                )
            layer_three_inputs = [
                row
                for row in table_rows(stage_text, "Inputs")
                if row and clean_cell(row[0]).lower().startswith("layer 3")
            ]
            validate_stable_paths(
                layer_three_inputs,
                stage_context.parent,
                root,
                str(stage_context.relative_to(root)),
                errors,
                column=1,
            )
            validate_stable_paths(
                table_rows(stage_text, "Required Capabilities"),
                stage_context.parent,
                root,
                str(stage_context.relative_to(root)),
                errors,
                column=1,
            )

    for workflow_dir in workflow_dirs:
        if workflow_dir.resolve() not in routed_workflows:
            warnings.append(
                f"{workflow_dir.relative_to(root)}: no direct user-intent route; verify it is an internal workflow"
            )

    return errors, warnings, len(route_rows), workflow_count, stage_count


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("workspace", nargs="?", default=".", help="Workspace root (default: current directory)")
    args = parser.parse_args()
    root = Path(args.workspace).resolve()

    errors, warnings, routes, workflows, stages = validate_workspace(root)
    for warning in warnings:
        print(f"WARNING: {warning}")
    for error in errors:
        print(f"ERROR: {error}", file=sys.stderr)

    if errors:
        print(
            f"Workflow validation failed: {len(errors)} error(s), {len(warnings)} warning(s)",
            file=sys.stderr,
        )
        return 1
    print(
        f"Workflow validation passed: {routes} route(s), {workflows} workflow(s), "
        f"{stages} stage(s), {len(warnings)} warning(s)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

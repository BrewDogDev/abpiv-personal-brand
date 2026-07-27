#!/usr/bin/env python3
"""Focused tests for the Project filesystem validator."""

from __future__ import annotations

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from validate_projects import validate_workspace


VALIDATOR = Path(__file__).with_name("validate_projects.py")


class ProjectFixture:
    def __init__(self, root: Path) -> None:
        self.root = root
        self.projects = root / "agents" / "context" / "projects"
        self.archive = self.projects / "archive"
        self.archive.mkdir(parents=True)
        (self.projects / "CONTEXT.md").write_text("# Project Context\n", encoding="utf-8")
        self.routes: list[tuple[str, str, str, str]] = []
        self.write_routing()

    def write_routing(self) -> None:
        lines = [
            "# Active Projects",
            "",
            "| Project | Goal | Status | Current task | Latest handoff |",
            "| --- | --- | --- | --- | --- |",
        ]
        for slug, status, current, latest in self.routes:
            lines.append(
                f"| [`{slug}`]({slug}/PROJECT.md) | Test {slug}. | {status} | "
                f"{current} | {latest} |"
            )
        lines.extend(
            [
                "",
                "Archived projects are not active routes.",
                "",
            ]
        )
        (self.projects / "ROUTING.md").write_text("\n".join(lines), encoding="utf-8")

    def add_project(
        self,
        slug: str = "sample-project",
        *,
        project_status: str = "executing",
        route_status: str | None = None,
        current: str | None = None,
        latest: str = "Not created",
        tasks: tuple[tuple[str, str], ...] = (("01", "executing"),),
        route: bool = True,
    ) -> Path:
        project = self.projects / slug
        (project / "tasks").mkdir(parents=True)
        (project / "handoff").mkdir()
        (project / "PROJECT.md").write_text(
            f"# Sample Project\n\n## Status\n\n- Status: {project_status}\n",
            encoding="utf-8",
        )
        ledger = [
            "# Sample Plan",
            "",
            "## Task Ledger",
            "",
            "| Task | Outcome | Dependencies | Status | Implementer | Review |",
            "| --- | --- | --- | --- | --- | --- |",
        ]
        for task_id, status in tasks:
            ledger.append(
                f"| {task_id} | Implement {task_id}. | None | {status} | assigned | pending |"
            )
        ledger.append("")
        (project / "PLAN.md").write_text("\n".join(ledger), encoding="utf-8")
        if route:
            if current is None:
                in_flight = [
                    task_id
                    for task_id, status in tasks
                    if status in {"executing", "review", "revisions", "blocked"}
                ]
                ready = [task_id for task_id, status in tasks if status == "ready"]
                if in_flight:
                    current = ", ".join(in_flight)
                elif ready:
                    current = ", ".join(ready)
                elif project_status in {"discovery", "planning", "replanning"}:
                    current = "Not assigned"
                elif project_status == "closing" and all(
                    status == "complete" for _, status in tasks
                ):
                    current = "None"
                else:
                    current = "Not assigned"
            self.routes.append(
                (slug, route_status or project_status, current, latest)
            )
            self.write_routing()
        return project

    def add_archived_project(
        self,
        slug: str = "2026-07-23-sample-project",
        *,
        project_status: str = "archived-complete",
        tasks: tuple[tuple[str, str], ...] = (("01", "complete"),),
        handoff: bool = True,
    ) -> Path:
        project = self.archive / slug
        (project / "tasks").mkdir(parents=True)
        (project / "handoff").mkdir()
        (project / "PROJECT.md").write_text(
            f"# Archived Project\n\n## Status\n\n- Status: {project_status}\n",
            encoding="utf-8",
        )
        ledger = [
            "# Archived Plan",
            "",
            "## Task Ledger",
            "",
            "| Task | Outcome | Dependencies | Status | Implementer | Review |",
            "| --- | --- | --- | --- | --- | --- |",
        ]
        for task_id, status in tasks:
            ledger.append(
                f"| {task_id} | Implement {task_id}. | None | {status} | assigned | complete |"
            )
        ledger.append("")
        (project / "PLAN.md").write_text("\n".join(ledger), encoding="utf-8")
        for task_id, status in tasks:
            if status == "planned":
                continue
            self.add_task_files(
                project,
                task_id,
                report=status in {"review", "revisions", "complete"},
                review=status in {"revisions", "complete"},
            )
        if handoff:
            (project / "handoff" / "latest.md").write_text(
                "# Latest\n\n[Continue](2026-07-23-sample-project-handoff.md)\n",
                encoding="utf-8",
            )
            (project / "handoff" / "2026-07-23-sample-project-handoff.md").write_text(
                "# Final Project Handoff\n",
                encoding="utf-8",
            )
        return project

    @staticmethod
    def add_task_files(
        project: Path,
        task_id: str,
        *,
        report: bool = False,
        review: bool = False,
    ) -> Path:
        task = project / "tasks" / f"{task_id}_sample-task"
        task.mkdir()
        (task / "TASK.md").write_text(
            f"# Task {task_id}\n\n## Status\n\nReady\n",
            encoding="utf-8",
        )
        if report:
            (task / "REPORT.md").write_text("# Report\n", encoding="utf-8")
        if review:
            (task / "REVIEW.md").write_text("# Review\n", encoding="utf-8")
        return task

    @classmethod
    def add_required_task_files(
        cls,
        project: Path,
        tasks: tuple[tuple[str, str], ...],
    ) -> None:
        for task_id, status in tasks:
            if status == "planned":
                continue
            cls.add_task_files(
                project,
                task_id,
                report=status in {"review", "revisions", "complete"},
                review=status in {"revisions", "complete"},
            )


class ValidateProjectsTests(unittest.TestCase):
    def make_fixture(self) -> tuple[tempfile.TemporaryDirectory[str], ProjectFixture]:
        temporary = tempfile.TemporaryDirectory()
        return temporary, ProjectFixture(Path(temporary.name))

    def current_task_errors(
        self,
        *,
        project_status: str,
        current: str,
        tasks: tuple[tuple[str, str], ...],
    ) -> list[str]:
        with tempfile.TemporaryDirectory() as temporary:
            fixture = ProjectFixture(Path(temporary))
            project = fixture.add_project(
                project_status=project_status,
                current=current,
                tasks=tasks,
            )
            fixture.add_required_task_files(project, tasks)
            errors, _, _, _, _ = validate_workspace(fixture.root)
        return errors

    def test_valid_active_project_passes(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        project = fixture.add_project()
        fixture.add_task_files(project, "01")

        errors, warnings, active, archived, tasks = validate_workspace(fixture.root)

        self.assertEqual([], errors)
        self.assertEqual([], warnings)
        self.assertEqual((1, 0, 1), (active, archived, tasks))

    def test_required_project_scaffold_is_reported(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            errors, _, _, _, _ = validate_workspace(Path(temporary))

        self.assertTrue(any("agents/context/projects/CONTEXT.md" in error for error in errors))
        self.assertTrue(any("agents/context/projects/ROUTING.md" in error for error in errors))
        self.assertTrue(any("agents/context/projects/archive" in error for error in errors))

    def test_route_requires_project_contract_files(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        project = fixture.add_project()
        (project / "PLAN.md").unlink()
        (project / "handoff").rmdir()

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(any("missing PLAN.md" in error for error in errors))
        self.assertTrue(any("missing handoff/" in error for error in errors))

    def test_ready_task_requires_directory_and_brief(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        project = fixture.add_project(tasks=(("01", "ready"),))

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(any("ready Task 01 has no Task directory" in error for error in errors))
        task = project / "tasks" / "01_sample-task"
        task.mkdir()
        errors, _, _, _, _ = validate_workspace(fixture.root)
        self.assertTrue(any("missing TASK.md" in error for error in errors))

    def test_task_artifacts_follow_ledger_status(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        project = fixture.add_project(tasks=(("01", "review"), ("02", "complete")))
        fixture.add_task_files(project, "01")
        fixture.add_task_files(project, "02", report=True)

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(any("Task 01" in error and "missing REPORT.md" in error for error in errors))
        self.assertTrue(any("Task 02" in error and "missing REVIEW.md" in error for error in errors))

    def test_task_directory_must_be_declared_by_its_active_project(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        project = fixture.add_project(tasks=(("01", "executing"),))
        fixture.add_task_files(project, "01")
        fixture.add_task_files(project, "02")

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(any("Task directory 02_sample-task is not declared" in error for error in errors))

    def test_project_and_task_status_vocabulary_is_enforced(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        project = fixture.add_project(project_status="doing", tasks=(("01", "doing"),))
        fixture.add_task_files(project, "01")

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(any("invalid active Project status: doing" in error for error in errors))
        self.assertTrue(any("Task 01 has invalid status: doing" in error for error in errors))

    def test_route_status_must_match_project_status(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        project = fixture.add_project(project_status="executing", route_status="planning")
        fixture.add_task_files(project, "01")

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(any("route status planning does not match Project status executing" in error for error in errors))

    def test_current_task_accepts_single_ready_and_in_flight_states(self) -> None:
        cases = [
            ("ready", "ready"),
            ("executing", "executing"),
            ("executing", "review"),
            ("executing", "revisions"),
            ("blocked", "blocked"),
        ]

        for project_status, task_status in cases:
            with self.subTest(
                project_status=project_status,
                task_status=task_status,
            ):
                self.assertEqual(
                    [],
                    self.current_task_errors(
                        project_status=project_status,
                        current="01",
                        tasks=(("01", task_status),),
                    ),
                )

    def test_current_task_accepts_all_parallel_in_flight_tasks(self) -> None:
        tasks = (
            ("01", "executing"),
            ("02", "review"),
            ("03", "revisions"),
            ("04", "blocked"),
            ("05", "ready"),
        )

        errors = self.current_task_errors(
            project_status="executing",
            current="01, 02, 03, 04",
            tasks=tasks,
        )

        self.assertEqual([], errors)

    def test_current_task_accepts_all_ready_tasks_when_none_are_in_flight(self) -> None:
        tasks = (("01", "ready"), ("02", "ready"), ("03", "planned"))

        errors = self.current_task_errors(
            project_status="ready",
            current="01, 02",
            tasks=tasks,
        )

        self.assertEqual([], errors)

    def test_current_task_accepts_state_compatible_sentinels(self) -> None:
        cases = [
            ("discovery", "Not assigned", (("01", "planned"),)),
            ("planning", "Not assigned", (("01", "planned"),)),
            (
                "replanning",
                "Not assigned",
                (("01", "complete"), ("02", "planned")),
            ),
            ("closing", "None", (("01", "complete"), ("02", "complete"))),
        ]

        for project_status, current, tasks in cases:
            with self.subTest(project_status=project_status, current=current):
                self.assertEqual(
                    [],
                    self.current_task_errors(
                        project_status=project_status,
                        current=current,
                        tasks=tasks,
                    ),
                )

    def test_current_task_rejects_original_stale_completed_route(self) -> None:
        errors = self.current_task_errors(
            project_status="executing",
            current="01",
            tasks=(("01", "complete"), ("05", "executing")),
        )

        self.assertTrue(
            any(
                "current task route 01 does not match Task ledger; expected 05"
                in error
                for error in errors
            ),
            errors,
        )

    def test_current_task_rejects_planned_and_unknown_ids(self) -> None:
        cases = [
            ("planned", "01"),
            ("unknown", "99"),
        ]

        for case, current in cases:
            with self.subTest(case=case):
                errors = self.current_task_errors(
                    project_status="executing",
                    current=current,
                    tasks=(("01", "planned"), ("02", "executing")),
                )
                self.assertTrue(
                    any(
                        f"current task route {current} does not match Task ledger; "
                        "expected 02" in error
                        for error in errors
                    ),
                    errors,
                )

    def test_current_task_rejects_missing_and_extra_active_ids(self) -> None:
        cases = [
            ("missing", "01"),
            ("extra", "01, 02, 03"),
        ]

        for case, current in cases:
            with self.subTest(case=case):
                errors = self.current_task_errors(
                    project_status="executing",
                    current=current,
                    tasks=(("01", "executing"), ("02", "review")),
                )
                self.assertTrue(
                    any(
                        f"current task route {current} does not match Task ledger; "
                        "expected 01, 02" in error
                        for error in errors
                    ),
                    errors,
                )

    def test_current_task_rejects_duplicate_unordered_and_malformed_ids(self) -> None:
        cases = [
            ("duplicate", "01, 01, 02", "duplicate Task ids"),
            ("unordered", "02, 01", "normalized ascending"),
            ("malformed", "01,02", "normalized ascending"),
        ]

        for case, current, expected_error in cases:
            with self.subTest(case=case):
                errors = self.current_task_errors(
                    project_status="executing",
                    current=current,
                    tasks=(("01", "executing"), ("02", "review")),
                )
                self.assertTrue(
                    any(expected_error in error for error in errors),
                    errors,
                )

    def test_current_task_rejects_state_incompatible_sentinels(self) -> None:
        cases = [
            ("executing", "Not assigned", (("01", "executing"),)),
            ("planning", "Not assigned", (("01", "ready"),)),
            ("planning", "None", (("01", "planned"),)),
            ("closing", "Not assigned", (("01", "complete"),)),
            ("closing", "None", (("01", "planned"),)),
            ("executing", "None", (("01", "complete"),)),
        ]

        for project_status, current, tasks in cases:
            with self.subTest(project_status=project_status, current=current, tasks=tasks):
                errors = self.current_task_errors(
                    project_status=project_status,
                    current=current,
                    tasks=tasks,
                )
                self.assertTrue(
                    any(
                        f"current task sentinel '{current}' is not valid" in error
                        for error in errors
                    ),
                    errors,
                )

    def test_handoff_latest_and_route_paths_must_resolve_locally(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        latest = "[`handoff/latest.md`](sample-project/handoff/latest.md)"
        project = fixture.add_project(latest=latest)
        fixture.add_task_files(project, "01")
        (project / "handoff" / "latest.md").write_text(
            "# Latest\n\n[Continue](missing-handoff.md)\n",
            encoding="utf-8",
        )

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(any("latest.md target does not resolve: missing-handoff.md" in error for error in errors))
        (project / "handoff" / "latest.md").write_text(
            "# Latest\n\n[Continue](2026-07-23-sample-handoff.md)\n",
            encoding="utf-8",
        )
        (project / "handoff" / "2026-07-23-sample-handoff.md").write_text(
            "# Handoff\n",
            encoding="utf-8",
        )
        errors, _, _, _, _ = validate_workspace(fixture.root)
        self.assertEqual([], errors)

    def test_existing_latest_handoff_must_be_registered(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        project = fixture.add_project()
        fixture.add_task_files(project, "01")
        (project / "handoff" / "latest.md").write_text(
            "# Latest\n\n[Continue](2026-07-23-sample-handoff.md)\n",
            encoding="utf-8",
        )
        (project / "handoff" / "2026-07-23-sample-handoff.md").write_text(
            "# Handoff\n",
            encoding="utf-8",
        )

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(
            any(
                "ROUTING.md says 'Not created' but handoff/latest.md exists" in error
                for error in errors
            )
        )

    def test_latest_handoff_target_requires_dated_filename(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        latest = "[`handoff/latest.md`](sample-project/handoff/latest.md)"
        project = fixture.add_project(latest=latest)
        fixture.add_task_files(project, "01")
        (project / "handoff" / "latest.md").write_text(
            "# Latest\n\n[Continue](current.md)\n",
            encoding="utf-8",
        )
        (project / "handoff" / "current.md").write_text("# Handoff\n", encoding="utf-8")

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(
            any(
                "latest.md target must use YYYY-MM-DD-<goal-slug>-handoff.md: current.md"
                in error
                for error in errors
            )
        )

    def test_latest_handoff_target_must_be_direct_child(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        latest = "[`handoff/latest.md`](sample-project/handoff/latest.md)"
        project = fixture.add_project(latest=latest)
        fixture.add_task_files(project, "01")
        records = project / "handoff" / "records"
        records.mkdir()
        (project / "handoff" / "latest.md").write_text(
            "# Latest\n\n[Continue](records/2026-07-23-sample-handoff.md)\n",
            encoding="utf-8",
        )
        (records / "2026-07-23-sample-handoff.md").write_text(
            "# Handoff\n",
            encoding="utf-8",
        )

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(
            any(
                "latest.md target must be a direct child of project handoff/: "
                "records/2026-07-23-sample-handoff.md"
                in error
                for error in errors
            )
        )

    def test_unrouted_and_archived_projects_are_not_active(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        fixture.add_project(slug="unrouted", route=False, tasks=())
        archived = fixture.archive / "2026-07-23-old-project"
        archived.mkdir()
        (archived / "PROJECT.md").write_text(
            "# Old Project\n\n## Status\n\n- Status: archived-complete\n",
            encoding="utf-8",
        )
        fixture.routes.append(
            (
                "archive/2026-07-23-old-project",
                "archived-complete",
                "None",
                "Not created",
            )
        )
        fixture.write_routing()

        errors, _, _, archived_count, _ = validate_workspace(fixture.root)

        self.assertTrue(any("active Project directory is absent from ROUTING.md: unrouted" in error for error in errors))
        self.assertTrue(any("route points into archive/" in error for error in errors))
        self.assertEqual(1, archived_count)

    def test_completed_or_cancelled_project_cannot_remain_active(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        fixture.add_project(project_status="archived-cancelled", tasks=())

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(any("completed or cancelled Project cannot remain active" in error for error in errors))

    def test_archived_project_status_and_folder_name_are_validated(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        archived = fixture.archive / "old-project"
        archived.mkdir()
        (archived / "PROJECT.md").write_text(
            "# Old Project\n\n## Status\n\n- Status: planning\n",
            encoding="utf-8",
        )

        errors, _, _, archived_count, _ = validate_workspace(fixture.root)

        self.assertTrue(any("invalid archive folder name: old-project" in error for error in errors))
        self.assertTrue(any("invalid archived Project status: planning" in error for error in errors))
        self.assertEqual(1, archived_count)

    def test_archived_project_requires_intact_scaffold(self) -> None:
        for missing in ("PLAN.md", "tasks", "handoff"):
            with self.subTest(missing=missing):
                temporary, fixture = self.make_fixture()
                self.addCleanup(temporary.cleanup)
                archived = fixture.add_archived_project(tasks=())
                target = archived / missing
                if target.is_dir():
                    for child in target.iterdir():
                        child.unlink()
                    target.rmdir()
                else:
                    target.unlink()

                errors, _, _, archived_count, _ = validate_workspace(fixture.root)

                self.assertTrue(
                    any(f"missing {missing}{'/' if missing != 'PLAN.md' else ''}" in error for error in errors),
                    errors,
                )
                self.assertEqual(1, archived_count)

    def test_archive_folder_date_must_be_a_real_iso_date(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        fixture.add_archived_project(slug="2026-02-30-impossible-date")

        errors, _, _, archived_count, _ = validate_workspace(fixture.root)

        self.assertTrue(
            any("invalid archive closure date: 2026-02-30" in error for error in errors),
            errors,
        )
        self.assertEqual(1, archived_count)

    def test_archived_project_validates_ledger_task_artifacts_and_handoff(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        archived = fixture.add_archived_project()
        (archived / "tasks" / "01_sample-task" / "REVIEW.md").unlink()
        (archived / "handoff" / "latest.md").write_text(
            "# Latest\n\n[Continue](missing-handoff.md)\n",
            encoding="utf-8",
        )

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(
            any("Task 01" in error and "missing REVIEW.md" in error for error in errors),
            errors,
        )
        self.assertTrue(
            any("latest.md target does not resolve: missing-handoff.md" in error for error in errors),
            errors,
        )

    def test_archived_project_requires_final_latest_handoff(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        fixture.add_archived_project(handoff=False)

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(
            any("archived Project is missing handoff/latest.md" in error for error in errors),
            errors,
        )

    def test_archived_complete_requires_every_task_complete(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        fixture.add_archived_project(tasks=(("01", "blocked"),))

        errors, _, _, _, _ = validate_workspace(fixture.root)

        self.assertTrue(
            any("archived-complete Project has non-complete Task 01: blocked" in error for error in errors),
            errors,
        )

    def test_valid_complete_and_cancelled_intact_archives_pass(self) -> None:
        temporary, fixture = self.make_fixture()
        self.addCleanup(temporary.cleanup)
        fixture.add_archived_project()
        fixture.add_archived_project(
            slug="2026-07-24-cancelled-project",
            project_status="archived-cancelled",
            tasks=(("01", "blocked"),),
        )

        errors, warnings, active, archived, tasks = validate_workspace(fixture.root)

        self.assertEqual([], errors)
        self.assertEqual([], warnings)
        self.assertEqual((0, 2, 0), (active, archived, tasks))

    def test_cli_exits_nonzero_with_useful_errors(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            result = subprocess.run(
                [sys.executable, str(VALIDATOR), temporary],
                capture_output=True,
                text=True,
                check=False,
            )

        self.assertEqual(1, result.returncode)
        self.assertIn("ERROR:", result.stderr)
        self.assertIn("Project validation failed", result.stderr)


if __name__ == "__main__":
    unittest.main()

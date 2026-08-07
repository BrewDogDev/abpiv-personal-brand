from __future__ import annotations

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


REPOSITORY_ROOT = Path(__file__).resolve().parents[3]
SCRIPT = REPOSITORY_ROOT / "infra" / "n8n" / "tools" / "assert-plan-allowlist.py"


def change(
    address: str,
    *actions: str,
    before: dict[str, object] | None = None,
    after: dict[str, object] | None = None,
    after_unknown: dict[str, object] | None = None,
) -> dict[str, object]:
    payload: dict[str, object] = {"actions": list(actions)}
    if before is not None:
        payload["before"] = before
    if after is not None:
        payload["after"] = after
    if after_unknown is not None:
        payload["after_unknown"] = after_unknown
    return {"address": address, "change": payload}


def dns_update(name: str, before_type: str, after_type: str) -> dict[str, object]:
    before_content = "203.0.113.10" if before_type == "A" else "tunnel-id.cfargotunnel.com"
    after_content = "203.0.113.10" if after_type == "A" else "tunnel-id.cfargotunnel.com"
    common = {"zone_id": "zone", "name": name, "ttl": 1, "proxied": True}
    return change(
        f"cloudflare_dns_record.{name}[0]",
        "update",
        before={**common, "type": before_type, "content": before_content},
        after={**common, "type": after_type, "content": after_content},
    )


def cloud_run_min_update() -> dict[str, object]:
    return change(
        "google_cloud_run_v2_service.n8n[0]",
        "update",
        before={"template": [{"scaling": [{"min_instance_count": 0}]}]},
        after={"template": [{"scaling": [{"min_instance_count": 1}]}]},
    )


class PlanAllowlistTests(unittest.TestCase):
    def run_plan(self, phase: str, changes: list[dict[str, object]]) -> subprocess.CompletedProcess[str]:
        with tempfile.TemporaryDirectory() as temporary_directory:
            plan_path = Path(temporary_directory) / "plan.json"
            plan_path.write_text(json.dumps({"resource_changes": changes}), encoding="utf-8")
            return subprocess.run(
                [sys.executable, str(SCRIPT), str(plan_path), "--phase", phase],
                check=False,
                capture_output=True,
                text=True,
            )

    def test_prepare_accepts_only_known_additions(self) -> None:
        result = self.run_plan(
            "prepare",
            [
                change("google_compute_instance.n8n", "create"),
                change("google_compute_disk.n8n_data", "create"),
                change("google_compute_disk.plausible_data", "create"),
                change(
                    'google_secret_manager_secret.plausible_runtime["secret_key_base"]',
                    "create",
                ),
                change(
                    'google_secret_manager_secret_iam_member.compute_plausible_secret_accessor["secret_key_base"]',
                    "create",
                ),
                change(
                    "google_service_account_iam_member.github_deployer_plausible_runtime_service_account_user",
                    "create",
                ),
                change("google_cloud_run_v2_service.n8n[0]", "no-op"),
            ],
        )
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_prepare_rejects_any_update_or_delete(self) -> None:
        result = self.run_plan(
            "prepare",
            [change("google_cloud_run_v2_service.n8n[0]", "delete")],
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Unlisted plan actions", result.stderr)

    def test_cutover_requires_exactly_two_dns_updates(self) -> None:
        accepted = self.run_plan(
            "cutover",
            [
                dns_update("forms", "A", "CNAME"),
                dns_update("editor", "A", "CNAME"),
            ],
        )
        self.assertEqual(accepted.returncode, 0, accepted.stderr)

        rejected = self.run_plan(
            "cutover",
            [
                dns_update("forms", "A", "CNAME"),
                dns_update("editor", "A", "CNAME"),
                change("cloudflare_workers_script.unrelated", "update"),
            ],
        )
        self.assertNotEqual(rejected.returncode, 0)

        broad_dns_update = self.run_plan(
            "cutover",
            [
                change(
                    "cloudflare_dns_record.forms[0]",
                    "update",
                    before={
                        "zone_id": "zone",
                        "name": "forms",
                        "ttl": 1,
                        "proxied": True,
                        "type": "A",
                        "content": "203.0.113.10",
                    },
                    after={
                        "zone_id": "zone",
                        "name": "forms",
                        "ttl": 60,
                        "proxied": True,
                        "type": "CNAME",
                        "content": "tunnel-id.cfargotunnel.com",
                    },
                ),
                dns_update("editor", "A", "CNAME"),
            ],
        )
        self.assertNotEqual(broad_dns_update.returncode, 0)

    def test_rollback_requires_dns_and_cloud_run_updates_only(self) -> None:
        accepted = self.run_plan(
            "rollback",
            [
                dns_update("forms", "CNAME", "A"),
                dns_update("editor", "CNAME", "A"),
            ],
        )
        self.assertEqual(accepted.returncode, 0, accepted.stderr)

        accepted_after_quiescence = self.run_plan(
            "rollback",
            [
                dns_update("forms", "CNAME", "A"),
                dns_update("editor", "CNAME", "A"),
                cloud_run_min_update(),
            ],
        )
        self.assertEqual(
            accepted_after_quiescence.returncode,
            0,
            accepted_after_quiescence.stderr,
        )

        rejected = self.run_plan(
            "rollback",
            [
                dns_update("forms", "CNAME", "A"),
                dns_update("editor", "CNAME", "A"),
                cloud_run_min_update(),
                change("google_compute_instance.n8n", "update"),
            ],
        )
        self.assertNotEqual(rejected.returncode, 0)

        no_changes = self.run_plan("rollback", [])
        self.assertEqual(no_changes.returncode, 0, no_changes.stderr)

        one_partial_dns_change = self.run_plan(
            "rollback", [dns_update("forms", "CNAME", "A")]
        )
        self.assertEqual(
            one_partial_dns_change.returncode,
            0,
            one_partial_dns_change.stderr,
        )

    def test_arm_is_idempotent_and_narrow(self) -> None:
        already_armed = self.run_plan("arm", [])
        self.assertEqual(already_armed.returncode, 0, already_armed.stderr)

        update = self.run_plan(
            "arm",
            [
                change(
                    "google_sql_database_instance.n8n[0]",
                    "update",
                    before={"deletion_protection": True, "settings": {"tier": "db-g1-small"}},
                    after={"deletion_protection": False, "settings": {"tier": "db-g1-small"}},
                )
            ],
        )
        self.assertEqual(update.returncode, 0, update.stderr)

        broad_update = self.run_plan(
            "arm",
            [
                change(
                    "google_sql_database_instance.n8n[0]",
                    "update",
                    before={"deletion_protection": True, "settings": {"tier": "db-g1-small"}},
                    after={"deletion_protection": False, "settings": {"tier": "db-custom-1-3840"}},
                )
            ],
        )
        self.assertNotEqual(broad_update.returncode, 0)

        protect = self.run_plan(
            "protect",
            [
                change(
                    "google_sql_database_instance.n8n[0]",
                    "update",
                    before={"deletion_protection": False},
                    after={"deletion_protection": True},
                )
            ],
        )
        self.assertEqual(protect.returncode, 0, protect.stderr)

    def test_destroy_rejects_retained_compute_resources(self) -> None:
        accepted = self.run_plan(
            "destroy",
            [change("google_sql_database_instance.n8n[0]", "delete")],
        )
        self.assertEqual(accepted.returncode, 0, accepted.stderr)

        rejected = self.run_plan(
            "destroy",
            [change("google_compute_instance.n8n", "delete")],
        )
        self.assertNotEqual(rejected.returncode, 0)


if __name__ == "__main__":
    unittest.main()

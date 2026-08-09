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


def dns_change(
    name: str, before_type: str, after_type: str, *actions: str
) -> dict[str, object]:
    before_content = "203.0.113.10" if before_type == "A" else "tunnel-id.cfargotunnel.com"
    after_content = "203.0.113.10" if after_type == "A" else "tunnel-id.cfargotunnel.com"
    common = {"zone_id": "zone", "name": name, "ttl": 1, "proxied": True}
    return change(
        f"cloudflare_dns_record.{name}[0]",
        *actions,
        before={**common, "type": before_type, "content": before_content},
        after={**common, "type": after_type, "content": after_content},
    )


def dns_update(name: str, before_type: str, after_type: str) -> dict[str, object]:
    return dns_change(name, before_type, after_type, "update")


def dns_replacement(name: str, before_type: str, after_type: str) -> dict[str, object]:
    replacement = dns_change(name, before_type, after_type, "delete", "create")
    payload = replacement["change"]
    assert isinstance(payload, dict)
    before = payload["before"]
    after = payload["after"]
    assert isinstance(before, dict)
    assert isinstance(after, dict)
    before.update({"settings": {}, "tags": []})
    after.update({"settings": None, "tags": None})
    payload["after_unknown"] = {"settings": True, "tags": True}
    return replacement


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
                change(
                    'google_project_iam_member.github_deployer_project_roles["roles/compute.securityAdmin"]',
                    "create",
                ),
                change("google_cloud_run_v2_service.n8n[0]", "no-op"),
            ],
        )
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_bootstrap_accepts_only_deployer_identity_and_iam_additions(self) -> None:
        accepted = self.run_plan(
            "bootstrap",
            [
                change("google_service_account.n8n_compute", "create"),
                *[
                    change(
                        f'google_project_service.required["{service}.googleapis.com"]',
                        "create",
                    )
                    for service in ("iap", "logging", "monitoring", "oslogin")
                ],
                change(
                    'google_project_iam_member.github_deployer_project_roles["roles/logging.configWriter"]',
                    "create",
                ),
                change(
                    'google_project_iam_member.github_deployer_project_roles["roles/compute.securityAdmin"]',
                    "create",
                ),
                change(
                    "google_service_account_iam_member.github_deployer_compute_service_account_user",
                    "create",
                ),
                change(
                    "google_service_account_iam_member.github_deployer_plausible_runtime_service_account_user",
                    "create",
                ),
                change(
                    "google_service_account_iam_member.github_oidc_workload_identity_user[0]",
                    "create",
                ),
                change(
                    "google_service_account_iam_member.github_oidc_service_account_token_creator[0]",
                    "create",
                ),
            ],
        )
        self.assertEqual(accepted.returncode, 0, accepted.stderr)

        rejected = self.run_plan(
            "bootstrap", [change("google_compute_instance.n8n", "create")]
        )
        self.assertNotEqual(rejected.returncode, 0)

        rejected_legacy_action = self.run_plan(
            "bootstrap",
            [change("google_sql_database_instance.n8n[0]", "update")],
        )
        self.assertNotEqual(rejected_legacy_action.returncode, 0)

        rejected_unlisted_service = self.run_plan(
            "bootstrap",
            [change('google_project_service.required["run.googleapis.com"]', "create")],
        )
        self.assertNotEqual(rejected_unlisted_service.returncode, 0)

    def test_bootstrap_allows_move_only_recovery_without_actions(self) -> None:
        result = self.run_plan("bootstrap", [])
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_prepare_rejects_any_update_or_delete(self) -> None:
        result = self.run_plan(
            "prepare",
            [change("google_cloud_run_v2_service.n8n[0]", "delete")],
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Unlisted plan actions", result.stderr)

    def test_cutover_requires_exactly_two_dns_transitions(self) -> None:
        accepted = self.run_plan(
            "cutover",
            [
                dns_update("forms", "A", "CNAME"),
                dns_update("editor", "A", "CNAME"),
            ],
        )
        self.assertEqual(accepted.returncode, 0, accepted.stderr)

        accepted_replacements = self.run_plan(
            "cutover",
            [
                dns_replacement("forms", "A", "CNAME"),
                dns_replacement("editor", "A", "CNAME"),
            ],
        )
        self.assertEqual(
            accepted_replacements.returncode,
            0,
            accepted_replacements.stderr,
        )

        for field, configured_value in (
            ("settings", {"flatten_cname": True}),
            ("tags", ["unexpected"]),
        ):
            with self.subTest(field=field):
                configured_replacement = dns_replacement("forms", "A", "CNAME")
                payload = configured_replacement["change"]
                assert isinstance(payload, dict)
                after = payload["after"]
                after_unknown = payload["after_unknown"]
                assert isinstance(after, dict)
                assert isinstance(after_unknown, dict)
                after[field] = configured_value
                del after_unknown[field]
                rejected_configured_field = self.run_plan(
                    "cutover",
                    [
                        configured_replacement,
                        dns_replacement("editor", "A", "CNAME"),
                    ],
                )
                self.assertNotEqual(rejected_configured_field.returncode, 0)

                configured_before_replacement = dns_replacement(
                    "forms", "A", "CNAME"
                )
                before_payload = configured_before_replacement["change"]
                assert isinstance(before_payload, dict)
                before = before_payload["before"]
                assert isinstance(before, dict)
                before[field] = configured_value
                rejected_existing_field = self.run_plan(
                    "cutover",
                    [
                        configured_before_replacement,
                        dns_replacement("editor", "A", "CNAME"),
                    ],
                )
                self.assertNotEqual(rejected_existing_field.returncode, 0)

                equal_known_replacement = dns_replacement("forms", "A", "CNAME")
                equal_known_payload = equal_known_replacement["change"]
                assert isinstance(equal_known_payload, dict)
                equal_known_before = equal_known_payload["before"]
                equal_known_after = equal_known_payload["after"]
                equal_known_unknown = equal_known_payload["after_unknown"]
                assert isinstance(equal_known_before, dict)
                assert isinstance(equal_known_after, dict)
                assert isinstance(equal_known_unknown, dict)
                equal_known_before[field] = configured_value
                equal_known_after[field] = configured_value
                del equal_known_unknown[field]
                rejected_equal_known = self.run_plan(
                    "cutover",
                    [
                        equal_known_replacement,
                        dns_replacement("editor", "A", "CNAME"),
                    ],
                )
                self.assertNotEqual(rejected_equal_known.returncode, 0)

                empty_value: object = {} if field == "settings" else []
                equal_empty_replacement = dns_replacement("forms", "A", "CNAME")
                equal_empty_payload = equal_empty_replacement["change"]
                assert isinstance(equal_empty_payload, dict)
                equal_empty_before = equal_empty_payload["before"]
                equal_empty_after = equal_empty_payload["after"]
                equal_empty_unknown = equal_empty_payload["after_unknown"]
                assert isinstance(equal_empty_before, dict)
                assert isinstance(equal_empty_after, dict)
                assert isinstance(equal_empty_unknown, dict)
                equal_empty_before[field] = empty_value
                equal_empty_after[field] = empty_value
                del equal_empty_unknown[field]
                rejected_equal_empty = self.run_plan(
                    "cutover",
                    [
                        equal_empty_replacement,
                        dns_replacement("editor", "A", "CNAME"),
                    ],
                )
                self.assertNotEqual(rejected_equal_empty.returncode, 0)

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
                    "delete",
                    "create",
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

    def test_rollback_requires_dns_transitions_and_cloud_run_update_only(self) -> None:
        accepted = self.run_plan(
            "rollback",
            [
                dns_update("forms", "CNAME", "A"),
                dns_update("editor", "CNAME", "A"),
            ],
        )
        self.assertEqual(accepted.returncode, 0, accepted.stderr)

        accepted_replacements = self.run_plan(
            "rollback",
            [
                dns_replacement("forms", "CNAME", "A"),
                dns_replacement("editor", "CNAME", "A"),
            ],
        )
        self.assertEqual(
            accepted_replacements.returncode,
            0,
            accepted_replacements.stderr,
        )

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

        one_partial_dns_replacement = self.run_plan(
            "rollback", [dns_replacement("forms", "CNAME", "A")]
        )
        self.assertEqual(
            one_partial_dns_replacement.returncode,
            0,
            one_partial_dns_replacement.stderr,
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

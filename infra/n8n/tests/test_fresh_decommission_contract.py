from __future__ import annotations

import re
import unittest
from pathlib import Path


REPOSITORY_ROOT = Path(__file__).resolve().parents[3]
WORKFLOW = REPOSITORY_ROOT / ".github" / "workflows" / "n8n-fresh-decommission.yml"
MIGRATION_WORKFLOW = REPOSITORY_ROOT / ".github" / "workflows" / "n8n-decommission.yml"
GCP = REPOSITORY_ROOT / "infra" / "n8n" / "opentofu" / "gcp.tf"
LOCALS = REPOSITORY_ROOT / "infra" / "n8n" / "opentofu" / "locals.tf"
VARIABLES = REPOSITORY_ROOT / "infra" / "n8n" / "opentofu" / "variables.tf"


def resource_block(source: str, resource_type: str, resource_name: str) -> str:
    match = re.search(
        rf'resource\s+"{re.escape(resource_type)}"\s+"{re.escape(resource_name)}"\s*\{{',
        source,
    )
    if match is None:
        raise AssertionError(f"Missing resource {resource_type}.{resource_name}")

    depth = 0
    for index in range(match.end() - 1, len(source)):
        if source[index] == "{":
            depth += 1
        elif source[index] == "}":
            depth -= 1
            if depth == 0:
                return source[match.start() : index + 1]
    raise AssertionError(f"Unclosed resource {resource_type}.{resource_name}")


class FreshDecommissionContractTests(unittest.TestCase):
    def test_cloud_run_source_matches_the_disabled_live_service(self) -> None:
        gcp = GCP.read_text(encoding="utf-8")

        self.assertRegex(
            gcp,
            re.compile(
                r'resource\s+"google_cloud_run_v2_service"\s+"n8n"[\s\S]*?'
                r'scaling\s*\{\s*'
                r'scaling_mode\s*=\s*"MANUAL"\s*'
                r'manual_instance_count\s*=\s*0\s*'
                r'min_instance_count\s*=\s*0\s*'
                r'\}',
            ),
        )

    def test_fresh_decommission_is_separately_planned_and_hash_bound(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        for required in (
            "options: [plan, apply]",
            "destroy-abandoned-fresh-start-legacy-n8n",
            "fresh-runtime-manual-acceptance-passed",
            "COMPLIANT / APPROVED / READY",
            "production-destruction",
            "production-plan",
            "reviewed_commit_sha",
            "reviewed_allowlist_sha256",
            "destruction-actions.sha256",
            "--phase arm",
            "--phase destroy",
            "legacy_stack_enabled=true",
            "legacy_stack_enabled=false",
        ):
            self.assertIn(required, workflow)

        self.assertRegex(
            workflow,
            re.compile(
                r'REVIEWED_COMMIT_SHA[\s\S]*?GITHUB_SHA[\s\S]*?'
                r'REVIEWED_ALLOWLIST_SHA256[\s\S]*?destruction-actions\.sha256'
            ),
        )

    def test_fresh_decommission_does_not_read_or_preserve_abandoned_data(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        for forbidden in (
            "gcloud storage cp",
            "gcloud storage ls",
            "gcloud sql export",
            "pg_dump",
            "database.dump",
            "binary-data.tar",
            "source-counts.tsv",
            "retained_migration",
            "migration-backup",
        ):
            self.assertNotIn(forbidden, workflow)

        self.assertIn(
            'gcloud storage rm --recursive "${legacy_bucket}/**"', workflow
        )
        self.assertRegex(
            workflow,
            re.compile(
                r'gcloud storage rm --recursive "\$\{legacy_bucket\}/\*\*"'
                r'[^^\r\n]*>/dev/null 2>&1 \|\| true'
            ),
        )
        self.assertIn("fresh-start-abandoned-data", workflow)

    def test_fresh_decommission_verifies_cloud_run_is_disabled_first(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        self.assertIn("gcloud run services list", workflow)
        self.assertIn("Cloud Run is already absent after a partial decommission", workflow)
        self.assertIn("run.googleapis.com/scalingMode", workflow)
        self.assertIn("run.googleapis.com/manualInstanceCount", workflow)
        self.assertRegex(
            workflow,
            re.compile(
                r'cloud_run_count[\s\S]*?0\)[\s\S]*?already absent[\s\S]*?'
                r'1\)[\s\S]*?scalingMode[\s\S]*?manual[\s\S]*?'
                r'manualInstanceCount[\s\S]*?0'
            ),
        )

    def test_fresh_decommission_preserves_review_and_post_destroy_health_evidence(
        self,
    ) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        self.assertIn('tee -a "$GITHUB_STEP_SUMMARY" < destruction-actions.txt', workflow)
        for container in (
            "abpiv-n8n-postgres-1",
            "abpiv-n8n-n8n-1",
            "abpiv-n8n-nginx-1",
        ):
            self.assertGreaterEqual(workflow.count(container), 2)

    def test_fresh_decommission_recovers_after_any_started_arm_failure(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        self.assertIn("failure() || cancelled()", workflow)
        self.assertIn("steps.arm.outcome != 'skipped'", workflow)
        self.assertNotIn("steps.arm.outcome == 'success'", workflow)

    def test_legacy_gcp_resources_keep_deployer_grants_until_destroyed(self) -> None:
        gcp = GCP.read_text(encoding="utf-8")
        legacy_resources = (
            ("google_compute_global_address", "private_services"),
            ("google_service_networking_connection", "private_services"),
            ("google_vpc_access_connector", "n8n"),
            ("google_sql_database_instance", "n8n"),
            ("google_sql_database", "n8n"),
            ("google_storage_bucket", "binary_data"),
            ("google_cloud_run_v2_service", "n8n"),
            ("google_compute_region_network_endpoint_group", "n8n"),
            ("google_compute_backend_service", "n8n"),
            ("google_compute_url_map", "n8n"),
            ("google_certificate_manager_dns_authorization", "n8n"),
            ("google_certificate_manager_certificate", "n8n"),
            ("google_certificate_manager_certificate", "editor"),
            ("google_certificate_manager_certificate_map", "n8n"),
            ("google_certificate_manager_certificate_map_entry", "n8n"),
            ("google_compute_target_https_proxy", "n8n"),
            ("google_compute_global_address", "n8n_lb"),
            ("google_compute_global_forwarding_rule", "https"),
        )

        for resource_type, resource_name in legacy_resources:
            with self.subTest(resource=f"{resource_type}.{resource_name}"):
                self.assertIn(
                    "google_project_iam_member.github_deployer_project_roles",
                    resource_block(gcp, resource_type, resource_name),
                )

    def test_legacy_permissions_are_removed_only_after_resource_verification(self) -> None:
        variables = VARIABLES.read_text(encoding="utf-8")
        locals_source = LOCALS.read_text(encoding="utf-8")
        workflow = WORKFLOW.read_text(encoding="utf-8")
        migration_workflow = MIGRATION_WORKFLOW.read_text(encoding="utf-8")

        self.assertRegex(
            variables,
            re.compile(
                r'variable\s+"legacy_deployer_permissions_enabled"\s*\{'
                r'[\s\S]*?default\s*=\s*true'
            ),
        )
        self.assertRegex(
            locals_source,
            re.compile(
                r'var\.legacy_deployer_permissions_enabled\s*\?\s*\['
                r'[\s\S]*?roles/run\.admin[\s\S]*?roles/vpcaccess\.admin'
            ),
        )
        self.assertRegex(
            workflow,
            re.compile(
                r"legacy_deployer_permissions_enabled=true[\s\S]*?"
                r"out=destroy-resources\.tfplan[\s\S]*?"
                r"apply[^\r\n]*destroy-resources\.tfplan[\s\S]*?"
                r"Verify legacy GCP resources are absent[\s\S]*?"
                r"legacy_deployer_permissions_enabled=false[\s\S]*?"
                r"out=destroy-permissions\.tfplan[\s\S]*?"
                r"apply[^\r\n]*destroy-permissions\.tfplan"
            ),
        )
        self.assertIn("legacy_deployer_permissions_enabled=false", migration_workflow)


if __name__ == "__main__":
    unittest.main()

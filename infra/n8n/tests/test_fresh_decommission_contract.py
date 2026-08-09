from __future__ import annotations

import re
import unittest
from pathlib import Path


REPOSITORY_ROOT = Path(__file__).resolve().parents[3]
WORKFLOW = REPOSITORY_ROOT / ".github" / "workflows" / "n8n-fresh-decommission.yml"
GCP = REPOSITORY_ROOT / "infra" / "n8n" / "opentofu" / "gcp.tf"


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
        self.assertIn("fresh-start-abandoned-data", workflow)

    def test_fresh_decommission_verifies_cloud_run_is_disabled_first(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        self.assertIn("run.googleapis.com/scalingMode", workflow)
        self.assertIn("run.googleapis.com/manualInstanceCount", workflow)
        self.assertRegex(
            workflow,
            re.compile(
                r'scalingMode[\s\S]*?manual[\s\S]*?manualInstanceCount[\s\S]*?0'
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


if __name__ == "__main__":
    unittest.main()

from __future__ import annotations

import re
import unittest
from pathlib import Path


REPOSITORY_ROOT = Path(__file__).resolve().parents[3]
WORKFLOW = REPOSITORY_ROOT / ".github" / "workflows" / "n8n-fresh-residual-cleanup.yml"
GCP = REPOSITORY_ROOT / "infra" / "n8n" / "opentofu" / "gcp.tf"
LOCALS = REPOSITORY_ROOT / "infra" / "n8n" / "opentofu" / "locals.tf"
VARIABLES = REPOSITORY_ROOT / "infra" / "n8n" / "opentofu" / "variables.tf"


class FreshResidualCleanupContractTests(unittest.TestCase):
    def test_google_retained_network_and_permission_have_independent_controls(self) -> None:
        variables = VARIABLES.read_text(encoding="utf-8")
        locals_source = LOCALS.read_text(encoding="utf-8")
        gcp = GCP.read_text(encoding="utf-8")

        self.assertRegex(
            variables,
            re.compile(
                r'variable\s+"legacy_private_service_connection_enabled"\s*\{'
                r'[\s\S]*?default\s*=\s*false'
            ),
        )
        self.assertRegex(
            variables,
            re.compile(
                r'variable\s+"legacy_service_networking_permission_enabled"\s*\{'
                r'[\s\S]*?default\s*=\s*false'
            ),
        )
        self.assertGreaterEqual(
            gcp.count(
                "var.legacy_stack_enabled || "
                "var.legacy_private_service_connection_enabled"
            ),
            2,
        )
        self.assertRegex(
            locals_source,
            re.compile(
                r'var\.legacy_deployer_permissions_enabled\s*\?\s*\['
                r'[\s\S]*?roles/certificatemanager\.editor'
                r'[\s\S]*?roles/vpcaccess\.admin'
                r'[\s\S]*?var\.legacy_deployer_permissions_enabled\s*\|\|\s*'
                r'var\.legacy_service_networking_permission_enabled'
                r'[\s\S]*?roles/servicenetworking\.networksAdmin'
            ),
        )
        self.assertRegex(
            locals_source,
            re.compile(
                r'check\s+"deferred_private_service_connection_is_narrow"'
                r'[\s\S]*?!var\.legacy_private_service_connection_enabled'
                r'[\s\S]*?var\.runtime_origin\s*==\s*"compute"'
                r'[\s\S]*?!var\.legacy_stack_enabled'
                r'[\s\S]*?!var\.legacy_deployer_permissions_enabled'
                r'[\s\S]*?var\.legacy_service_networking_permission_enabled'
            ),
        )
        self.assertRegex(
            locals_source,
            re.compile(
                r'check\s+"deferred_service_networking_permission_is_narrow"'
                r'[\s\S]*?!var\.legacy_service_networking_permission_enabled'
                r'[\s\S]*?var\.runtime_origin\s*==\s*"compute"'
                r'[\s\S]*?!var\.legacy_stack_enabled'
                r'[\s\S]*?!var\.legacy_deployer_permissions_enabled'
            ),
        )

    def test_workflow_is_reviewed_hash_bound_and_two_phase(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        for required in (
            "options: [prune-obsolete-permissions, finalize-private-network]",
            "options: [plan, apply]",
            "fresh-runtime-manual-acceptance-passed",
            "fresh-start-abandoned-data-authorized",
            "destroy-abandoned-fresh-start-legacy-n8n",
            "COMPLIANT / APPROVED / READY",
            "reviewed_commit_sha",
            "reviewed_allowlist_sha256",
            "production-plan",
            "production-destruction",
            "residual-actions.sha256",
            "prune-obsolete-legacy-permissions",
            "finalize-legacy-private-network-resources",
            "--phase finalize-legacy-private-network-permission",
        ):
            self.assertIn(required, workflow)

        self.assertRegex(
            workflow,
            re.compile(
                r'REVIEWED_COMMIT_SHA[\s\S]*?GITHUB_SHA[\s\S]*?'
                r'REVIEWED_ALLOWLIST_SHA256[\s\S]*?residual-actions\.sha256'
            ),
        )
        self.assertRegex(
            workflow,
            re.compile(
                r'prune-obsolete-permissions\)[\s\S]*?'
                r'legacy_private_service_connection_enabled=true[\s\S]*?'
                r'legacy_service_networking_permission_enabled=true[\s\S]*?'
                r'finalize-private-network\)[\s\S]*?'
                r'legacy_private_service_connection_enabled=false[\s\S]*?'
                r'legacy_service_networking_permission_enabled=true'
            ),
        )
        self.assertRegex(
            workflow,
            re.compile(
                r'Apply only the freshly regenerated and hash-matched residual-resource plan'
                r'[\s\S]*?Verify the residual private network is absent'
                r'[\s\S]*?legacy_service_networking_permission_enabled=false'
                r'[\s\S]*?Apply only the freshly regenerated final-permission plan'
            ),
        )

    def test_workflow_replans_and_matches_before_apply(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        self.assertIn("residual-actions-expected.txt", workflow)
        self.assertIn("residual-actions-final.txt", workflow)
        self.assertIn("cmp --silent residual-actions-expected.txt residual-actions-final.txt", workflow)
        self.assertRegex(
            workflow,
            re.compile(
                r'Bind apply to the exact reviewed commit[\s\S]*?'
                r'Regenerate and match the reviewed residual plan[\s\S]*?'
                r'Apply only the freshly regenerated and hash-matched residual-resource plan'
            ),
        )

    def test_partial_retries_only_converge_forward(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        self.assertRegex(
            workflow,
            re.compile(
                r'prune-obsolete-permissions\)[\s\S]*?'
                r'test "\$address_count" -eq 1[\s\S]*?'
                r'test "\$connection_count" -eq 1'
            ),
        )
        self.assertRegex(
            workflow,
            re.compile(
                r'finalize-private-network\)[\s\S]*?'
                r'test "\$address_count" -ge 0[\s\S]*?'
                r'test "\$address_count" -le 1[\s\S]*?'
                r'test "\$connection_count" -ge 0[\s\S]*?'
                r'test "\$connection_count" -le 1'
            ),
        )
        self.assertRegex(
            workflow,
            re.compile(
                r'service_role_count[\s\S]*?'
                r'test "\$service_role_count" -eq 0[\s\S]*?'
                r'TF_VAR_legacy_service_networking_permission_enabled=false'
            ),
        )
        self.assertNotIn("gcloud projects add-iam-policy-binding", workflow)
        self.assertNotIn("restore-legacy-permissions", workflow)

    def test_workflow_preserves_runtime_and_public_security_gates(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        for container in (
            "abpiv-n8n-postgres-1",
            "abpiv-n8n-n8n-1",
            "abpiv-n8n-nginx-1",
        ):
            self.assertGreaterEqual(workflow.count(container), 2)
        self.assertGreaterEqual(workflow.count("active-ready"), 2)
        self.assertGreaterEqual(workflow.count("= 302"), 2)
        self.assertGreaterEqual(workflow.count("403|404"), 2)
        self.assertIn("gcloud compute networks peerings list", workflow)
        self.assertNotIn("gcloud services vpc-peerings list", workflow)

    def test_workflow_never_reads_or_preserves_abandoned_data(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        for forbidden in (
            "gcloud storage cp",
            "gcloud storage ls",
            "gcloud sql export",
            "pg_dump",
            "database.dump",
            "binary-data.tar",
            "retained_migration",
            "migration-backup",
        ):
            self.assertNotIn(forbidden, workflow)


if __name__ == "__main__":
    unittest.main()

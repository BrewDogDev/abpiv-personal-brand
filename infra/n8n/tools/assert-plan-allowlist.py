#!/usr/bin/env python3
"""Reject OpenTofu plans containing actions outside an explicitly selected phase."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


PREPARE_CREATE = [
    r"^google_project_service\.required\[\"(iap|logging|monitoring|oslogin)\.googleapis\.com\"\]$",
    r"^google_compute_(router\.n8n|router_nat\.n8n|disk\.n8n_data|instance\.n8n|firewall\.iap_ssh)$",
    r"^google_compute_disk\.plausible_data$",
    r"^google_storage_bucket\.n8n_backups$",
    r"^google_secret_manager_secret\.cloudflare_tunnel_token$",
    r"^google_secret_manager_secret\.plausible_runtime\[.+\]$",
    r"^google_service_account\.n8n_compute$",
    r"^google_secret_manager_secret_iam_member\.compute_(runtime_secret_accessor\[.+\]|tunnel_secret_accessor)$",
    r"^google_secret_manager_secret_iam_member\.compute_plausible_secret_accessor\[.+\]$",
    r"^google_storage_bucket_iam_member\.compute_(backup_object_user|legacy_binary_object_viewer\[0\])$",
    r"^google_project_iam_member\.compute_observability_roles\[.+\]$",
    r"^google_service_account_iam_member\.github_deployer_compute_service_account_user$",
    r"^google_service_account_iam_member\.github_deployer_plausible_runtime_service_account_user$",
    r"^google_project_iam_member\.github_deployer_project_roles\[\"roles/(compute\.instanceAdmin\.v1|compute\.osAdminLogin|compute\.securityAdmin|iap\.tunnelResourceAccessor|logging\.configWriter|monitoring\.editor)\"\]$",
    r"^google_monitoring_alert_policy\.compute_(capacity\[.+\]|runtime_fault)$",
    r"^google_logging_metric\.compute_runtime_fault$",
    r"^cloudflare_zero_trust_tunnel_cloudflared(_config)?\.n8n\[0\]$",
]

BOOTSTRAP_CREATE = [
    r"^google_project_service\.required\[\"(iap|logging|monitoring|oslogin)\.googleapis\.com\"\]$",
    r"^google_service_account\.n8n_compute$",
    r"^google_service_account_iam_member\.github_deployer_compute_service_account_user$",
    r"^google_service_account_iam_member\.github_deployer_plausible_runtime_service_account_user$",
    r"^google_service_account_iam_member\.github_oidc_(workload_identity_user|service_account_token_creator)\[0\]$",
    r"^google_project_iam_member\.github_deployer_project_roles\[\"roles/(compute\.instanceAdmin\.v1|compute\.osAdminLogin|compute\.securityAdmin|iap\.tunnelResourceAccessor|logging\.configWriter|monitoring\.editor)\"\]$",
]

CUTOVER_UPDATE = [
    r"^cloudflare_dns_record\.(forms|editor)\[0\]$",
]

ROLLBACK_UPDATE = [
    r"^cloudflare_dns_record\.(forms|editor)\[0\]$",
    r"^google_cloud_run_v2_service\.n8n\[0\]$",
]

DNS_COMPUTED_ROOTS = {
    "comment_modified_on",
    "created_on",
    "id",
    "meta",
    "modified_on",
    "proxiable",
    "tags_modified_on",
}

SQL_COMPUTED_ROOTS = {
    "available_maintenance_versions",
    "connection_name",
    "dns_name",
    "first_ip_address",
    "ip_address",
    "private_ip_address",
    "public_ip_address",
    "self_link",
    "server_ca_cert",
    "service_account_email_address",
}

CLOUD_RUN_COMPUTED_ROOTS = {
    "conditions",
    "etag",
    "latest_created_revision",
    "latest_ready_revision",
    "observed_generation",
    "terminal_condition",
    "traffic_statuses",
    "uri",
}

ARM_UPDATE = [
    r"^google_sql_database_instance\.n8n\[0\]$",
]

DESTROY_DELETE = [
    r"^google_compute_global_address\.(private_services|n8n_lb)\[0\]$",
    r"^google_service_networking_connection\.private_services\[0\]$",
    r"^google_vpc_access_connector\.n8n\[0\]$",
    r"^google_sql_database(_instance)?\.n8n\[0\]$",
    r"^google_storage_bucket\.binary_data\[0\]$",
    r"^google_cloud_run_v2_service\.n8n\[0\]$",
    r"^google_compute_(region_network_endpoint_group|backend_service|url_map|target_https_proxy|global_forwarding_rule)\.(n8n|https)\[0\]$",
    r"^google_certificate_manager_(dns_authorization|certificate_map_entry)\.n8n\[.+\]$",
    r"^google_certificate_manager_certificate\.n8n\[0\]$",
    r"^google_certificate_manager_certificate\.editor\[0\]$",
    r"^google_certificate_manager_certificate_map\.n8n\[0\]$",
    r"^cloudflare_dns_record\.certificate_authorization\[.+\]$",
    r"^google_service_account\.n8n_runtime\[0\]$",
    r"^google_project_iam_member\.runtime_cloudsql_client\[0\]$",
    r"^google_storage_bucket_iam_member\.(runtime_binary_data_object_user|compute_legacy_binary_object_viewer)\[0\]$",
    r"^google_secret_manager_secret_iam_member\.runtime_secret_accessor\[.+\]$",
    r"^google_service_account_iam_member\.github_deployer_runtime_service_account_user\[0\]$",
    r"^google_project_iam_member\.github_deployer_project_roles\[\"roles/(certificatemanager\.editor|cloudsql\.admin|compute\.loadBalancerAdmin|run\.admin|servicenetworking\.networksAdmin|vpcaccess\.admin)\"\]$",
]


def matches(address: str, patterns: list[str]) -> bool:
    return any(re.fullmatch(pattern, address) for pattern in patterns)


def changed_paths(before: object, after: object, prefix: tuple[str, ...] = ()) -> set[tuple[str, ...]]:
    if isinstance(before, dict) and isinstance(after, dict):
        paths: set[tuple[str, ...]] = set()
        for key in before.keys() | after.keys():
            paths |= changed_paths(before.get(key), after.get(key), (*prefix, key))
        return paths
    if isinstance(before, list) and isinstance(after, list):
        paths = set()
        for index in range(max(len(before), len(after))):
            before_item = before[index] if index < len(before) else None
            after_item = after[index] if index < len(after) else None
            paths |= changed_paths(before_item, after_item, (*prefix, str(index)))
        return paths
    return set() if before == after else {prefix}


def unknown_paths(value: object, prefix: tuple[str, ...] = ()) -> set[tuple[str, ...]]:
    if value is True:
        return {prefix}
    if isinstance(value, dict):
        paths: set[tuple[str, ...]] = set()
        for key, nested in value.items():
            paths |= unknown_paths(nested, (*prefix, key))
        return paths
    if isinstance(value, list):
        paths = set()
        for index, nested in enumerate(value):
            paths |= unknown_paths(nested, (*prefix, str(index)))
        return paths
    return set()


def noncomputed(paths: set[tuple[str, ...]], computed_roots: set[str]) -> set[tuple[str, ...]]:
    return {path for path in paths if path and path[0] not in computed_roots}


def value_at(value: object, path: tuple[str, ...]) -> object:
    current = value
    for part in path:
        current = current[int(part)] if isinstance(current, list) else current[part]  # type: ignore[index]
    return current


def exact_update_error(phase: str, address: str, change: dict[str, object]) -> str | None:
    before = change.get("before")
    after = change.get("after")
    after_unknown = change.get("after_unknown", {})
    if not isinstance(before, dict) or not isinstance(after, dict):
        return f"{address}: {phase} update lacks inspectable before/after values"

    paths = changed_paths(before, after)
    unknown = unknown_paths(after_unknown)

    if address.startswith("cloudflare_dns_record."):
        expected = {("content",), ("type",)}
        if noncomputed(paths, DNS_COMPUTED_ROOTS) != expected:
            return f"{address}: DNS update changed fields other than content and type"
        if noncomputed(unknown, DNS_COMPUTED_ROOTS):
            return f"{address}: DNS update contains unknown configured values"
        for key in ("zone_id", "name", "ttl", "proxied"):
            if before.get(key) != after.get(key):
                return f"{address}: DNS update changed protected field {key}"
        if after.get("proxied") is not True:
            return f"{address}: DNS record must remain proxied"
        if phase == "cutover":
            if before.get("type") != "A" or after.get("type") != "CNAME":
                return f"{address}: cutover must change A to CNAME"
            if not str(after.get("content", "")).endswith(".cfargotunnel.com"):
                return f"{address}: cutover CNAME must target the managed Tunnel"
        elif phase == "rollback":
            if before.get("type") != "CNAME" or after.get("type") != "A":
                return f"{address}: rollback must change CNAME to A"
            if not re.fullmatch(r"(?:\d{1,3}\.){3}\d{1,3}", str(after.get("content", ""))):
                return f"{address}: rollback A record must target the load-balancer IPv4 address"
        return None

    if address == "google_sql_database_instance.n8n[0]":
        expected = {("deletion_protection",)}
        if noncomputed(paths, SQL_COMPUTED_ROOTS) != expected:
            return f"{address}: arming changed fields other than deletion_protection"
        if noncomputed(unknown, SQL_COMPUTED_ROOTS):
            return f"{address}: arming contains unknown configured values"
        expected_values = (True, False) if phase == "arm" else (False, True)
        if (
            before.get("deletion_protection"),
            after.get("deletion_protection"),
        ) != expected_values:
            return f"{address}: {phase} changed deletion_protection in the wrong direction"
        return None

    if address == "google_cloud_run_v2_service.n8n[0]":
        expected_path = ("template", "0", "scaling", "0", "min_instance_count")
        if noncomputed(paths, CLOUD_RUN_COMPUTED_ROOTS) != {expected_path}:
            return f"{address}: rollback changed Cloud Run fields other than minimum instances"
        if noncomputed(unknown, CLOUD_RUN_COMPUTED_ROOTS):
            return f"{address}: rollback contains unknown configured values"
        if value_at(before, expected_path) != 0 or value_at(after, expected_path) != 1:
            return f"{address}: rollback must change Cloud Run minimum instances from zero to one"
        return None

    return f"{address}: no exact {phase} update contract is defined"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("plan_json", type=Path)
    parser.add_argument(
        "--phase",
        choices=("bootstrap", "prepare", "cutover", "rollback", "arm", "protect", "destroy"),
        required=True,
    )
    args = parser.parse_args()

    plan = json.loads(args.plan_json.read_text(encoding="utf-8"))
    observed: list[tuple[str, tuple[str, ...]]] = []
    violations: list[str] = []

    for change in plan.get("resource_changes", []):
        address = change["address"]
        actions = tuple(change["change"]["actions"])
        if actions in (("no-op",), ("read",)):
            continue
        observed.append((address, actions))

        allowed = False
        if args.phase == "bootstrap":
            allowed = actions == ("create",) and matches(address, BOOTSTRAP_CREATE)
        elif args.phase == "prepare":
            allowed = actions == ("create",) and matches(address, PREPARE_CREATE)
        elif args.phase == "cutover":
            allowed = actions == ("update",) and matches(address, CUTOVER_UPDATE)
        elif args.phase == "rollback":
            allowed = actions == ("update",) and matches(address, ROLLBACK_UPDATE)
        elif args.phase in {"arm", "protect"}:
            allowed = actions == ("update",) and matches(address, ARM_UPDATE)
        else:
            allowed = actions == ("delete",) and matches(address, DESTROY_DELETE)

        if not allowed:
            violations.append(f"{address}: {','.join(actions)}")
        elif args.phase in {"cutover", "rollback", "arm", "protect"} and actions == ("update",):
            detail_error = exact_update_error(args.phase, address, change["change"])
            if detail_error:
                violations.append(detail_error)

    for address, actions in observed:
        print(f"{','.join(actions):12} {address}")

    if violations:
        print("\nUnlisted plan actions:", file=sys.stderr)
        for violation in violations:
            print(f"  {violation}", file=sys.stderr)
        return 1

    if args.phase == "cutover":
        updates = [item for item in observed if item[1] == ("update",)]
        if len(updates) != 2:
            print(f"Cutover requires exactly two DNS updates; found {len(updates)}.", file=sys.stderr)
            return 1

    if args.phase == "rollback":
        updates = [item for item in observed if item[1] == ("update",)]
        observed_addresses = {item[0] for item in updates}
        permitted = {
            "cloudflare_dns_record.forms[0]",
            "cloudflare_dns_record.editor[0]",
            "google_cloud_run_v2_service.n8n[0]",
        }
        if not observed_addresses.issubset(permitted):
            print(
                "Rollback permits only zero to two DNS corrections and the optional Cloud Run minimum-instance update.",
                file=sys.stderr,
            )
            return 1

    if args.phase in {"arm", "protect"}:
        updates = [item for item in observed if item[1] == ("update",)]
        if len(updates) > 1:
            print(f"{args.phase} permits at most one Cloud SQL protection update; found {len(updates)}.", file=sys.stderr)
            return 1

        if not updates:
            print(f"Cloud SQL deletion protection already satisfies phase {args.phase}.")
            return 0

    if not observed and args.phase not in {"bootstrap", "rollback", "arm", "protect"}:
        print(f"No actionable changes found for phase {args.phase}.", file=sys.stderr)
        return 1

    print(f"Plan satisfies the {args.phase} allowlist ({len(observed)} action(s)).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

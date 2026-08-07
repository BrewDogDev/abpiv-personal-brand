# Plausible project on the shared private VM

This directory is the executable target for moving the existing Plausible CE v2.1.4 stack from `plausible-analytics-vm` to `abpiv-runtime-vm`. It is additive until the separately approved cutover workflow runs. The old VM remains the production and rollback source until all migration comparisons and acceptance checks pass.

The project uses pinned Plausible, PostgreSQL 16, ClickHouse, and Nginx image digests. Its Docker backend network is internal, its egress network is separate, and only Nginx publishes `127.0.0.1:8000`. Durable PostgreSQL, ClickHouse, and application state live under `/srv/plausible` on the independent `abpiv-plausible-data` disk. Startup, restore, backup, and observation refuse to operate unless that exact UUID is mounted.

Runtime secrets are loaded from Secret Manager into root-only `/run/plausible` files. PostgreSQL uses `POSTGRES_PASSWORD_FILE`; the Plausible wrapper copies its key and database URL into container tmpfs before dropping to the image's `plausible` user. Secret values are absent from Compose environment metadata, Git, OpenTofu plans, and durable application state. A persistent `DOCKER-USER` firewall rule blocks every container from `169.254.169.254`, so neither runtime can exchange its isolated secret access for the shared VM service-account token. Daily backups are age-encrypted under the isolated `plausible/daily/` prefix in the shared private, versioned, seven-day target bucket and are checksum-verified after a round-trip download.

The migration package contains:

- a PostgreSQL custom-format dump and stable source public-table counts;
- a native ClickHouse `plausible_events_db` backup and stable per-table counts;
- the durable `/var/lib/plausible` state archive and per-file SHA-256 evidence, excluding its configured ephemeral `tmp/` directory; and
- an inner checksum manifest, an age-encrypted outer archive, and a ciphertext checksum.

`restore-migration.sh` verifies both checksum layers and archive paths, restores every data class, and runs `verify-migration.sh`. Exact count and checksum equality is a prerequisite to active mode. `plausible-cutover.yml` then performs read-only public script and Access checks, observes the complete host for 15 minutes, creates the first encrypted backup, and stops—but never deletes—the old VM. A pre-acceptance transition failure stops the target and restores the old containers and Tunnel connector. After the verified target becomes canonical, failure recovery keeps the target active so newly written analytics data is never replaced by the now-stale old disk.

Cutover boots and checks the restored application behind a read-only precommit Nginx configuration. Public script reads work, but every event-writing method is denied. Only then does the workflow mark the target canonical and open event writes. A precommit rollback must positively prove the target Tunnel connector inactive before it starts the old connector; after write exposure, recovery keeps the target canonical so new analytics data is never replaced by the stale old disk.

An actual daily package is exercised by the disposable restore rehearsal. For an approved disaster recovery, put the runtime in maintenance and run the exact object through the typed production command:

```bash
sudo env \
  BACKUP_URI=gs://BUCKET/plausible/daily/TIMESTAMP/plausible-backup.tar.age \
  CONFIRM_RESTORE=restore-plausible-daily-backup \
  /opt/abpiv-plausible/scripts/restore-backup.sh
```

The command checks the ciphertext checksum, decrypts and checks the inner manifest, restores PostgreSQL, every ClickHouse table, and application state, compares counts and state checksums, and leaves Plausible in maintenance for separate acceptance.

Local validation:

```bash
pwsh -File infra/analytics/tests/shared-runtime-contract.ps1
find infra/analytics/compute/scripts -name '*.sh' -print0 | xargs -0 -n1 bash -n
shellcheck infra/analytics/compute/scripts/*.sh infra/analytics/tests/restore-rehearsal.sh
docker compose --project-directory infra/analytics/compute --file infra/analytics/compute/docker-compose.yml config --quiet
bash infra/analytics/tests/restore-rehearsal.sh
```

Do not dispatch provisioning or cutover, access secrets, move data, change the Tunnel connector, stop either VM, or publish repository changes without its specific recorded approval.

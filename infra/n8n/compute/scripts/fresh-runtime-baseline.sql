DO $fresh_runtime$
DECLARE
  table_record record;
  required_table text;
  actual_count bigint;
  expected_count bigint;
  public_table_count bigint;
BEGIN
  IF to_regclass('public.migrations') IS NULL THEN
    SELECT count(*)
      INTO public_table_count
      FROM information_schema.tables
     WHERE table_schema = 'public'
       AND table_type = 'BASE TABLE';

    IF public_table_count <> 0 THEN
      RAISE EXCEPTION 'Fresh runtime has a partial or unexpected public schema (% tables)', public_table_count;
    END IF;
    RETURN;
  END IF;

  FOREACH required_table IN ARRAY ARRAY[
    'workflow_entity',
    'credentials_entity',
    'execution_entity',
    'webhook_entity',
    'variables',
    'installed_packages',
    'tag_entity',
    'shared_workflow',
    'shared_credentials',
    'deployment_key',
    'instance_version_history',
    'mcp_registry_server',
    'migrations',
    'project',
    'project_relation',
    'role',
    'role_scope',
    'scope',
    'settings',
    'user'
  ] LOOP
    IF to_regclass(format('public.%I', required_table)) IS NULL THEN
      RAISE EXCEPTION 'Fresh runtime is missing required baseline table %', required_table;
    END IF;
  END LOOP;

  FOR table_record IN
    SELECT table_name
      FROM information_schema.tables
     WHERE table_schema = 'public'
       AND table_type = 'BASE TABLE'
     ORDER BY table_name
  LOOP
    EXECUTE format('SELECT count(*) FROM public.%I', table_record.table_name)
      INTO actual_count;
    expected_count := CASE table_record.table_name
      WHEN 'deployment_key' THEN 4
      WHEN 'instance_version_history' THEN 1
      WHEN 'mcp_registry_server' THEN 69
      WHEN 'migrations' THEN 184
      WHEN 'project' THEN 1
      WHEN 'project_relation' THEN 1
      WHEN 'role' THEN 15
      WHEN 'role_scope' THEN 523
      WHEN 'scope' THEN 203
      WHEN 'settings' THEN 3
      WHEN 'user' THEN 1
      ELSE 0
    END;

    IF actual_count <> expected_count THEN
      RAISE EXCEPTION 'Fresh runtime table % has % rows; expected %',
        table_record.table_name, actual_count, expected_count;
    END IF;
  END LOOP;

  IF (
    SELECT count(*)
      FROM settings
     WHERE ("key" = 'userManagement.isInstanceOwnerSetUp' AND value = 'false')
        OR "key" = 'features.ldap'
        OR "key" = 'ui.banners.dismissed'
  ) <> 3 THEN
    RAISE EXCEPTION 'Fresh runtime settings do not match the unclaimed baseline';
  END IF;

  IF (
    SELECT count(*)
      FROM "user"
     WHERE email IS NULL
       AND "firstName" IS NULL
       AND "lastName" IS NULL
       AND password IS NULL
       AND "roleSlug" = 'global:owner'
       AND disabled IS FALSE
       AND "mfaEnabled" IS FALSE
  ) <> 1 THEN
    RAISE EXCEPTION 'Fresh runtime owner account has already been claimed or changed';
  END IF;

  IF (
    SELECT count(*)
      FROM project
     WHERE name = 'Unnamed Project'
       AND type = 'personal'
  ) <> 1 THEN
    RAISE EXCEPTION 'Fresh runtime bootstrap project has already been changed';
  END IF;

  IF (
    SELECT count(*)
      FROM project_relation
     WHERE role = 'project:personalOwner'
  ) <> 1 THEN
    RAISE EXCEPTION 'Fresh runtime bootstrap project ownership has already been changed';
  END IF;
END
$fresh_runtime$;

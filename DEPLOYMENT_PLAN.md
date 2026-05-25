# Deployment Plan: Firebase Hosting + Cloudflare DNS

Last audited: 2026-05-25

## Context

This repo contains a Docusaurus v3 static site in `content-site/`.

Production target:

| Item | Value |
| --- | --- |
| Production host | Firebase Hosting |
| GCP / Firebase project ID | `abpiv-personal-brand` |
| Production domain | `allanbpediniv.com` |
| Production site path | `https://allanbpediniv.com/info/` |
| DNS registrar / manager | Cloudflare |
| Docusaurus `baseUrl` | `/info/` |
| Auth to GCP | Workload Identity Federation (no long-lived service account keys) |

Staging target:

| Item | Value |
| --- | --- |
| Staging host | Firebase Hosting |
| Staging deploy target | `staging` in `content-site/firebase.staging.json` |
| Staging project ID | GitHub variable `FIREBASE_STAGING_PROJECT_ID`, defaulting to `abpiv-personal-brand` if unset |
| Staging site ID | GitHub variable `FIREBASE_STAGING_SITE_ID`, with proposed default `personal-brand-staging` |
| Staging domain | `personal-brand-staging.lobst3rs.com` |
| Staging site path | `https://personal-brand-staging.lobst3rs.com/info/` |
| Staging DNS manager | Cloudflare zone `lobst3rs.com` |

Legacy comparison target:

| Item | Value |
| --- | --- |
| Comparison host | GitHub Pages |
| Comparison URL from earlier plan | `https://abpiv.github.io/info/` |
| Current caveat | This URL returned 404 during the 2026-05-25 audit. Treat GitHub Pages as a legacy/comparison target, not the requested staging environment. |

Observed repository remote during audit:

```text
origin https://github.com/BrewDogDev/abpiv-personal-brand.git
```

Use `BrewDogDev/abpiv-personal-brand` in Workload Identity Federation conditions unless the repository is transferred or the remote is intentionally changed before setup.

## Repo State

The repo-side deployment files already exist:

- `.github/workflows/deploy.yml`
- `content-site/firebase.json`
- `content-site/.firebaserc`
- `content-site/docusaurus.config.ts`
- `content-site/package.json`

The workflow builds the Docusaurus artifact once, deploys Firebase staging to `personal-brand-staging.lobst3rs.com`, keeps a GitHub Pages legacy/comparison deploy, and deploys production automatically through Firebase Hosting whenever changes merge to `main`. Staging can also be run manually with `workflow_dispatch` and `target=staging`; select the `main` branch to redeploy the current main artifact. Production can be run manually from `main` with `target=production`.

Both Firebase jobs package the Docusaurus `build/` output under `firebase-public/info/` before deploying so Firebase serves the site at the configured `/info/` base path. Production uses `content-site/firebase.json`. Staging uses `content-site/firebase.staging.json`, whose `hosting.target` is `staging`; the workflow binds that target at runtime with `firebase target:apply hosting staging "$FIREBASE_STAGING_SITE_ID"` so account-specific staging site IDs do not have to be committed.

The Firebase jobs use `google-github-actions/auth` plus the Firebase CLI so GitHub Actions can authenticate with Google Application Default Credentials from Workload Identity Federation.

`content-site/package.json` still includes the default Docusaurus `deploy` script for manual compatibility, but the current deployment flow does not use it. GitHub Actions deploys Firebase Hosting with `npx --yes firebase-tools@15.18.0 deploy`.

## Local Verification

From `content-site/`:

```bash
npm.cmd run typecheck
npm.cmd run build
```

The Firebase staging deployment commands used by GitHub Actions are:

```bash
npx --yes firebase-tools@15.18.0 target:apply hosting staging "$FIREBASE_STAGING_SITE_ID" --project "$FIREBASE_STAGING_PROJECT_ID" --non-interactive
npx --yes firebase-tools@15.18.0 deploy --config firebase.staging.json --only hosting:staging --project "$FIREBASE_STAGING_PROJECT_ID" --non-interactive
```

The Firebase production deployment command used by GitHub Actions is:

```bash
npx --yes firebase-tools@15.18.0 deploy --only hosting --project abpiv-personal-brand --non-interactive
```

That command requires Google credentials and should be run by GitHub Actions after the WIF setup, or locally by a user already authenticated to the target Firebase project.

For manual local Firebase deploys, first package the Docusaurus build under the configured Firebase public directory:

```bash
rm -rf firebase-public
mkdir -p firebase-public/info
cp -R build/. firebase-public/info/
```

## One-Time GCP / Firebase Setup

These steps require a user with access to Google Cloud and Firebase:

1. Create or select GCP project `abpiv-personal-brand`.
2. In Firebase Console, add Firebase to the existing GCP project.
3. In Firebase Hosting, initialize the production default Hosting site. The expected default site ID is `abpiv-personal-brand`, which creates `https://abpiv-personal-brand.web.app/`.
4. Create the staging Hosting site. Recommended default: `personal-brand-staging`, which creates `https://personal-brand-staging.web.app/`. If that globally unique site ID is unavailable, choose another valid site ID and store it in GitHub variable `FIREBASE_STAGING_SITE_ID`.
5. Staging can live in the same Firebase project as production, or in a separate Firebase/GCP project. If using a separate project, store its ID in `FIREBASE_STAGING_PROJECT_ID` and set up separate WIF variables.
6. Enable required APIs in each Firebase/GCP project used for deploys:

```bash
gcloud services enable \
  firebasehosting.googleapis.com \
  iamcredentials.googleapis.com \
  iam.googleapis.com \
  sts.googleapis.com \
  --project=abpiv-personal-brand
```

## One-Time Workload Identity Federation Setup

Run in Google Cloud Shell or another authenticated Google Cloud environment:

```bash
PROJECT_ID=abpiv-personal-brand
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
REPO=BrewDogDev/abpiv-personal-brand

gcloud iam service-accounts create github-deployer \
  --display-name="GitHub Actions Firebase Hosting Deployer" \
  --project=$PROJECT_ID

SA_EMAIL=github-deployer@$PROJECT_ID.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/firebasehosting.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/serviceusage.serviceUsageConsumer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/serviceusage.apiKeysViewer"

gcloud iam workload-identity-pools create github-pool \
  --location=global \
  --project=$PROJECT_ID

gcloud iam workload-identity-pools providers create-oidc github-provider \
  --location=global \
  --workload-identity-pool=github-pool \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.ref=assertion.ref,attribute.workflow=assertion.workflow" \
  --attribute-condition="assertion.repository=='${REPO}' && assertion.ref=='refs/heads/main' && assertion.workflow=='Deploy'" \
  --project=$PROJECT_ID

gcloud iam service-accounts add-iam-policy-binding $SA_EMAIL \
  --role=roles/iam.workloadIdentityUser \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/attribute.repository/$REPO" \
  --project=$PROJECT_ID

echo "GCP_WORKLOAD_IDENTITY_PROVIDER=projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/providers/github-provider"
echo "GCP_SERVICE_ACCOUNT=$SA_EMAIL"
```

Add the printed values as GitHub repository variables for production:

- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_SERVICE_ACCOUNT`

For staging, either reuse the production WIF variables if staging lives in the same project and the same service account is allowed to deploy to the staging site, or create a separate staging service account/provider and add:

- `GCP_STAGING_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_STAGING_SERVICE_ACCOUNT`
- `FIREBASE_STAGING_PROJECT_ID` if the staging Firebase project differs from `abpiv-personal-brand`
- `FIREBASE_STAGING_SITE_ID` if the staging site ID differs from the proposed `personal-brand-staging`

Create a GitHub environment named `production`. For fully automatic deploys on merge to `main`, do not configure required reviewers on this environment; required reviewers turn the production job into an approval-gated deploy.

Create a GitHub environment named `staging`. The workflow sets its environment URL to `https://personal-brand-staging.lobst3rs.com/info/`.

## Cloudflare DNS + Firebase Custom Domain Setup

These steps require access to Firebase Console and the Cloudflare zones for `allanbpediniv.com` and `lobst3rs.com`.

### Staging: `personal-brand-staging.lobst3rs.com`

1. In Firebase Console -> Hosting -> Add custom domain, choose the staging site, and enter `personal-brand-staging.lobst3rs.com`.
2. Keep the Firebase-provided TXT verification record permanently in Cloudflare DNS for the `lobst3rs.com` zone.
3. Add or update the Cloudflare record Firebase requests for the staging subdomain:

| Type | Name | Content | Proxy status |
| --- | --- | --- | --- |
| TXT | `personal-brand-staging` or full `personal-brand-staging.lobst3rs.com` | Firebase verification value | DNS only |
| A | `personal-brand-staging` | `199.36.158.100` | DNS only during verification/cert provisioning |

4. Wait for Firebase domain verification and managed SSL certificate provisioning.
5. Verify:

```bash
curl -I https://personal-brand-staging.lobst3rs.com/info/
curl -I https://personal-brand-staging.lobst3rs.com/
```

### Production: `allanbpediniv.com`

1. In Firebase Console -> Hosting -> Add custom domain, enter `allanbpediniv.com`.
2. Keep the Firebase-provided TXT verification record permanently in Cloudflare DNS.
3. Add or update Cloudflare records for the apex domain:

| Type | Name | Content | Proxy status |
| --- | --- | --- | --- |
| TXT | `allanbpediniv.com` or `@` | Firebase verification value | DNS only |
| A | `allanbpediniv.com` or `@` | `199.36.158.100` | DNS only during verification/cert provisioning |

4. If `www.allanbpediniv.com` should also work, add it as a Firebase custom domain too, preferably configured in Firebase to redirect to `allanbpediniv.com`. Then add:

| Type | Name | Content | Proxy status |
| --- | --- | --- | --- |
| A | `www` | `199.36.158.100` | DNS only during verification/cert provisioning |

5. Wait for Firebase domain verification and managed SSL certificate provisioning.
6. Verify:

```bash
curl -I https://abpiv-personal-brand.web.app/info/
curl -I https://allanbpediniv.com/info/
curl -I https://allanbpediniv.com/
```

Expected behavior:

- `/info/` serves the Docusaurus site.
- `/` redirects to `/info/`.
- Unknown paths serve the Docusaurus/Firebase 404 behavior.

After Firebase shows the custom domain and certificate as active, leaving Cloudflare DNS records as DNS only is acceptable because Firebase Hosting already provides CDN and SSL. If Cloudflare proxy is enabled later, use Cloudflare SSL/TLS mode `Full (strict)` and re-test redirects and certificate status.

## Deployment Flow

1. Merge deployment repo changes to `main`.
2. The `Deploy` workflow builds the site once, deploys Firebase staging to `personal-brand-staging.lobst3rs.com`, deploys the legacy/comparison GitHub Pages artifact, and deploys Firebase production to `allanbpediniv.com` automatically.
3. Verify Firebase staging default URL: `https://personal-brand-staging.web.app/info/` if using the proposed site ID.
4. Verify staging custom domain: `https://personal-brand-staging.lobst3rs.com/info/`.
5. Verify production default URL: `https://abpiv-personal-brand.web.app/info/`.
6. Verify production custom domain: `https://allanbpediniv.com/info/`.
7. Optional: run the `Deploy` workflow manually from the `main` branch with `target=staging` or `target=production` to redeploy the current main artifact.

## Rollback

Firebase Hosting keeps release history per site. In Firebase Console -> Hosting, select the staging or production site and roll back to a prior release if needed.

GitHub Pages is separate from both Firebase staging and Firebase production and can be used as a legacy comparison target once its URL is confirmed live.

## Known Deployment Caveats

- `content-site/docusaurus.config.ts` currently has `url: 'https://abpiv.github.io'`. If production SEO/canonical URLs must point to `allanbpediniv.com`, the site should eventually support target-specific Docusaurus `url` values or choose a single canonical host.
- The observed remote is `BrewDogDev/abpiv-personal-brand`, while earlier notes referenced `abpiv/abpiv-personal-brand`. WIF conditions must match the actual GitHub repository that runs the workflow.
- `https://allanbpediniv.com/info/` did not resolve during the 2026-05-25 audit, so DNS/custom-domain setup is still account-side work.
- `https://abpiv-personal-brand.web.app/info/` returned 404 during the 2026-05-25 audit, so Firebase Hosting has not yet served this artifact.
- `https://personal-brand-staging.lobst3rs.com/info/` is new account-side setup and must be verified after the staging Firebase site, custom domain, DNS, WIF variables, and first deploy are configured.
- `https://abpiv.github.io/info/` returned 404 during the 2026-05-25 audit, so the legacy comparison target is not currently verified live.

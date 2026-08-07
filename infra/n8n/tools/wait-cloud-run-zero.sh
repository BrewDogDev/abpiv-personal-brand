#!/usr/bin/env bash
set -euo pipefail

: "${GCP_PROJECT_ID:?Set GCP_PROJECT_ID}"
: "${GCP_REGION:?Set GCP_REGION}"
: "${CLOUD_RUN_SERVICE:?Set CLOUD_RUN_SERVICE}"

consecutive_zero=0
sleep 60
while [ "$consecutive_zero" -lt 5 ]; do
  end_time="$(date --utc +%Y-%m-%dT%H:%M:%SZ)"
  start_time="$(date --utc --date='2 minutes ago' +%Y-%m-%dT%H:%M:%SZ)"
  filter="metric.type=\"run.googleapis.com/container/instance_count\" AND resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${CLOUD_RUN_SERVICE}\" AND resource.labels.location=\"${GCP_REGION}\""
  response="$(curl --fail --silent --show-error --get \
    --header "Authorization: Bearer $(gcloud auth print-access-token)" \
    --data-urlencode "filter=${filter}" \
    --data-urlencode "interval.startTime=${start_time}" \
    --data-urlencode "interval.endTime=${end_time}" \
    --data-urlencode 'view=FULL' \
    "https://monitoring.googleapis.com/v3/projects/${GCP_PROJECT_ID}/timeSeries")"
  sample_count="$(jq '[.timeSeries[]?.points[]?.value.int64] | length' <<<"$response")"
  if [ "$sample_count" -eq 0 ]; then
    echo "Cloud Run Monitoring returned no instance-count samples; zero is not proven." >&2
    consecutive_zero=0
    sleep 60
    continue
  fi
  maximum="$(jq '[.timeSeries[]?.points[]?.value.int64 | tonumber] | max' <<<"$response")"
  if [ "$maximum" -eq 0 ]; then
    consecutive_zero="$((consecutive_zero + 1))"
  else
    consecutive_zero=0
  fi
  if [ "$consecutive_zero" -lt 5 ]; then
    sleep 60
  fi
done

echo "Cloud Run reported zero instances for five consecutive one-minute checks."

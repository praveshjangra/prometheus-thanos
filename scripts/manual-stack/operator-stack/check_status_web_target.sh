#!/usr/bin/env bash
set -euo pipefail

kubectl -n monitoring-manual run prom-query-op --image=curlimages/curl:8.8.0 --restart=Never --rm -i -- sh -c '
echo "up{job=\"status-web\"}:";
curl --globoff -s "http://prometheus-k8s.monitoring-manual.svc:9090/api/v1/query?query=up%7Bjob%3D%22status-web%22%7D";
echo "";
echo "rate by status:";
curl --globoff -s "http://prometheus-k8s.monitoring-manual.svc:9090/api/v1/query?query=sum%20by%20(status)%20(rate(http_request_duration_seconds_count%7Bjob%3D%22status-web%22%2Cstatus%3D~%22200%7C400%7C503%22%7D%5B5m%5D))";
'

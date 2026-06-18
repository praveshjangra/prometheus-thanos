#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$ROOT_DIR/manifests/prod/status-web-deployment.yaml"
kubectl apply -f "$ROOT_DIR/manifests/prod/status-web-service.yaml"
kubectl apply -f "$ROOT_DIR/manifests/prod/status-web-servicemonitor.yaml"
kubectl apply -f "$ROOT_DIR/manifests/prod/status-web-prometheusrule.yaml"

kubectl -n default rollout status deploy/status-web --timeout=180s

kubectl -n default run status-web-load --image=curlimages/curl:8.8.0 --restart=Never --rm -i -- sh -c '
for i in $(seq 1 60); do
  curl -s -o /dev/null http://status-web:9898/;
  curl -s -o /dev/null http://status-web:9898/status/400;
  curl -s -o /dev/null http://status-web:9898/status/503;
done
'

PROM_POD="$(kubectl -n monitoring get pod -l app.kubernetes.io/name=prometheus -o jsonpath='{.items[0].metadata.name}')"

kubectl -n monitoring exec "$PROM_POD" -c config-reloader -- sh -c \
  "grep -n 'job_name: serviceMonitor/monitoring/status-web/0' /etc/prometheus/config_out/prometheus.env.yaml"

echo "PromQL: request rate by status"
kubectl -n monitoring exec "$PROM_POD" -c config-reloader -- sh -c \
  "wget -qO- 'http://127.0.0.1:9090/api/v1/query?query=sum%20by%20(status)%20(rate(http_request_duration_seconds_count%7Bjob%3D%22status-web%22%2Cstatus%3D~%22200%7C400%7C503%22%7D%5B5m%5D))'"

echo "PromQL: target up"
kubectl -n monitoring exec "$PROM_POD" -c config-reloader -- sh -c \
  "wget -qO- 'http://127.0.0.1:9090/api/v1/query?query=up%7Bjob%3D%22status-web%22%7D'"

echo "Done. status-web is deployed and verified."

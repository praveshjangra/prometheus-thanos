#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STACK_DIR="$ROOT_DIR/manifests/manual-stack"
THANOS_DIR="$STACK_DIR/thanos"

DELETE_PVCS="${DELETE_PVCS:-false}"

usage() {
  cat <<EOF
Usage: $0

Tear down the manual monitoring stack (default and Thanos modes).

Environment:
  DELETE_PVCS=true   Also delete Prometheus PVCs (prometheus-k8s-db-*). Default: false.

Examples:
  $0
  DELETE_PVCS=true $0
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

echo "=== Cleaning Thanos workloads (07-01) ==="
kubectl delete -f "$THANOS_DIR/07-thanos-compactor.yaml" --ignore-not-found --wait=false
kubectl delete -f "$THANOS_DIR/06-thanos-store-gateway.yaml" --ignore-not-found --wait=false
kubectl delete -f "$THANOS_DIR/05-thanos-query.yaml" --ignore-not-found --wait=false

echo "=== Cleaning Prometheus CR (thanos + default manifests) ==="
kubectl delete -f "$THANOS_DIR/04-prometheus-cr-thanos.yaml" --ignore-not-found --wait=false
kubectl delete -f "$STACK_DIR/10-operator-prometheus-cr.yaml" --ignore-not-found --wait=false
kubectl -n monitoring-manual delete prometheus k8s --ignore-not-found --wait=true 2>/dev/null || true

echo "=== Cleaning Thanos MinIO / secrets ==="
kubectl -n monitoring-manual delete job minio-create-thanos-bucket --ignore-not-found
kubectl delete -f "$THANOS_DIR/03-objstore-secret.yaml" --ignore-not-found --wait=false
kubectl delete -f "$THANOS_DIR/02-minio-bucket-job.yaml" --ignore-not-found --wait=false
kubectl delete -f "$THANOS_DIR/01-minio.yaml" --ignore-not-found --wait=false

if [[ "$DELETE_PVCS" == "true" ]]; then
  echo "=== Deleting Prometheus PVCs ==="
  kubectl -n monitoring-manual delete pvc -l operator.prometheus.io/name=k8s --ignore-not-found
  kubectl -n monitoring-manual delete pvc prometheus-k8s-db-prometheus-k8s-0 --ignore-not-found 2>/dev/null || true
fi

echo "=== Cleaning operator stack (13-07) ==="
kubectl delete -f "$STACK_DIR/13-operator-status-web-prometheusrule.yaml" --ignore-not-found --wait=false
kubectl delete -f "$STACK_DIR/12-operator-status-web-servicemonitor.yaml" --ignore-not-found --wait=false
kubectl delete -f "$STACK_DIR/11-operator-prometheus-service.yaml" --ignore-not-found --wait=false
kubectl delete -f "$STACK_DIR/09-operator-prometheus-rbac.yaml" --ignore-not-found --wait=false
kubectl delete -f "$STACK_DIR/08-operator-deployment.yaml" --ignore-not-found --wait=false
kubectl delete -f "$STACK_DIR/07-operator-rbac.yaml" --ignore-not-found --wait=false

echo "=== Cleaning shared stack (Grafana, Alertmanager, app) ==="
kubectl delete -f "$ROOT_DIR/manifests/prod/status-web-service.yaml" --ignore-not-found --wait=false
kubectl delete -f "$ROOT_DIR/manifests/prod/status-web-deployment.yaml" --ignore-not-found --wait=false
kubectl delete -f "$THANOS_DIR/08-grafana-datasource-thanos.yaml" --ignore-not-found --wait=false
kubectl delete -f "$STACK_DIR/06-grafana.yaml" --ignore-not-found --wait=false
kubectl delete -f "$STACK_DIR/05-grafana-datasource.yaml" --ignore-not-found --wait=false
kubectl delete -f "$STACK_DIR/04-grafana-secret.yaml" --ignore-not-found --wait=false
kubectl delete -f "$STACK_DIR/03-alertmanager.yaml" --ignore-not-found --wait=false
kubectl delete -f "$STACK_DIR/02-alertmanager-config.yaml" --ignore-not-found --wait=false

echo "=== Cleaning namespace and lab CRDs ==="
kubectl delete -f "$STACK_DIR/01-crds.yaml" --ignore-not-found --wait=false
kubectl delete -f "$STACK_DIR/00-namespace.yaml" --ignore-not-found --wait=true

echo ""
echo "=== Manual stack cleaned up ==="
if [[ "$DELETE_PVCS" != "true" ]]; then
  echo "Note: Prometheus PVCs were kept. Full reset: DELETE_PVCS=true $0"
fi

#!/usr/bin/env bash
# Tear down only the Thanos layer (keeps base Prometheus operator stack).
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STACK_DIR="$ROOT_DIR/manifests/manual-stack"
THANOS_DIR="$STACK_DIR/thanos"

echo "=== Removing Thanos components only ==="
kubectl delete -f "$THANOS_DIR/07-thanos-compactor.yaml" --ignore-not-found --wait=false
kubectl delete -f "$THANOS_DIR/06-thanos-store-gateway.yaml" --ignore-not-found --wait=false
kubectl delete -f "$THANOS_DIR/05-thanos-query.yaml" --ignore-not-found --wait=false
kubectl delete -f "$THANOS_DIR/04-prometheus-cr-thanos.yaml" --ignore-not-found --wait=false
kubectl -n monitoring-manual delete job minio-create-thanos-bucket --ignore-not-found
kubectl delete -f "$THANOS_DIR/03-objstore-secret.yaml" --ignore-not-found --wait=false
kubectl delete -f "$THANOS_DIR/02-minio-bucket-job.yaml" --ignore-not-found --wait=false
kubectl delete -f "$THANOS_DIR/01-minio.yaml" --ignore-not-found --wait=false
kubectl delete -f "$THANOS_DIR/08-grafana-datasource-thanos.yaml" --ignore-not-found --wait=false

echo "=== Re-applying default Prometheus CR + Grafana datasource ==="
kubectl apply -f "$STACK_DIR/10-operator-prometheus-cr.yaml"
kubectl apply -f "$STACK_DIR/05-grafana-datasource.yaml"
kubectl -n monitoring-manual rollout restart deploy/grafana 2>/dev/null || true

echo "Thanos removed. Default Prometheus CR re-applied (no sidecar)."

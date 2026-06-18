#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STACK_DIR="$ROOT_DIR/manifests/manual-stack"
THANOS_DIR="$STACK_DIR/thanos"

usage() {
  cat <<EOF
Usage: $0 [default|thanos]

  default  Deploy operator stack without Thanos (files 00-13). This is the default.
  thanos   Deploy with Thanos sidecar, MinIO, Query, Store Gateway, and Compactor.

Environment overrides:
  WITH_GRAFANA=true|false    Include Grafana (default: true)
  WITH_STATUS_WEB=true|false Include prod status-web (default: true)
  WITH_THANOS=true           Same as 'thanos' mode
  PRELOAD_IMAGES=true        Run podman/kind image preload before deploy (thanos mode)

Examples:
  $0
  $0 default
  $0 thanos
  PRELOAD_IMAGES=true KIND_CLUSTER_NAME=kind-otel-test $0 thanos
EOF
}

MODE="${1:-default}"
WITH_GRAFANA="${WITH_GRAFANA:-true}"
WITH_STATUS_WEB="${WITH_STATUS_WEB:-true}"
WITH_THANOS="${WITH_THANOS:-false}"
PRELOAD_IMAGES="${PRELOAD_IMAGES:-false}"

case "$MODE" in
  default) ;;
  thanos) WITH_THANOS=true ;;
  -h|--help) usage; exit 0 ;;
  *)
    echo "Unknown mode: $MODE" >&2
    usage >&2
    exit 1
    ;;
esac

wait_for_prometheus() {
  local ns=monitoring-manual
  local sts=prometheus-k8s
  local i
  local expected_ready=2

  if [[ "$WITH_THANOS" == "true" ]]; then
    expected_ready=3
  fi

  echo "=== Waiting for Prometheus workload ==="
  for i in $(seq 1 60); do
    if kubectl -n "$ns" get statefulset "$sts" &>/dev/null; then
      echo "StatefulSet $sts found (operator reconciled Prometheus CR)"
      kubectl -n "$ns" rollout status "statefulset/$sts" --timeout=300s
      local ready
      ready="$(kubectl -n "$ns" get pod prometheus-k8s-0 -o jsonpath='{.status.containerStatuses[*].ready}' 2>/dev/null | tr ' ' '\n' | grep -c true || true)"
      if [[ "$ready" -ge "$expected_ready" ]]; then
        echo "Prometheus pod ready ($ready containers; thanos expects $expected_ready)"
        return 0
      fi
    fi
    if kubectl -n "$ns" get pod prometheus-k8s-0 &>/dev/null; then
      if kubectl -n "$ns" wait --for=condition=ready pod/prometheus-k8s-0 --timeout=60s 2>/dev/null; then
        return 0
      fi
    fi
    sleep 5
  done

  echo "ERROR: Prometheus StatefulSet/pod not ready after 5 minutes." >&2
  echo "Diagnostics:" >&2
  kubectl -n "$ns" get prometheus,statefulset,pods,pvc 2>/dev/null || true
  kubectl -n "$ns" describe prometheus k8s 2>/dev/null | tail -40 || true
  kubectl -n "$ns" logs deploy/prometheus-operator --tail=30 2>/dev/null || true
  return 1
}

deploy_thanos_minio() {
  kubectl apply -f "$THANOS_DIR/01-minio.yaml"
  kubectl -n monitoring-manual rollout status deploy/minio --timeout=180s
  kubectl -n monitoring-manual delete job minio-create-thanos-bucket --ignore-not-found
  kubectl apply -f "$THANOS_DIR/02-minio-bucket-job.yaml"
  kubectl -n monitoring-manual wait --for=condition=complete job/minio-create-thanos-bucket --timeout=120s
  kubectl apply -f "$THANOS_DIR/03-objstore-secret.yaml"
}

deploy_thanos_query_stack() {
  echo "=== Deploying Thanos Query / Store / Compactor ==="
  kubectl apply -f "$THANOS_DIR/05-thanos-query.yaml"
  kubectl apply -f "$THANOS_DIR/06-thanos-store-gateway.yaml"
  kubectl apply -f "$THANOS_DIR/07-thanos-compactor.yaml"
  kubectl -n monitoring-manual rollout status deploy/thanos-query --timeout=180s
  kubectl -n monitoring-manual rollout status deploy/thanos-store-gateway --timeout=180s
  kubectl -n monitoring-manual rollout status deploy/thanos-compactor --timeout=180s
  echo "Thanos Query stores:"
  kubectl -n monitoring-manual run thanos-stores-check --rm -i --restart=Never \
    --image=curlimages/curl:8.8.0 --command -- \
    curl -sf "http://thanos-query.monitoring-manual.svc:9090/api/v1/stores" | head -c 400 || true
  echo ""
}

if [[ "$WITH_THANOS" == "true" ]]; then
  echo "=== Deploying operator/CR stack WITH Thanos (MinIO on kind) ==="
  if [[ "$PRELOAD_IMAGES" == "true" ]]; then
    "$ROOT_DIR/scripts/manual-stack/thanos/preload_images_podman_kind.sh"
  fi
else
  echo "=== Deploying operator/CR monitoring stack (files 00-13) ==="
fi

kubectl apply -f "$STACK_DIR/00-namespace.yaml"

USE_FULL_CRDS=true "$ROOT_DIR/scripts/manual-stack/operator-stack/install_operator_crds.sh"

kubectl apply -f "$STACK_DIR/02-alertmanager-config.yaml"
kubectl apply -f "$STACK_DIR/03-alertmanager.yaml"

if [[ "$WITH_THANOS" == "true" ]]; then
  deploy_thanos_minio
fi

if [[ "$WITH_GRAFANA" == "true" ]]; then
  kubectl apply -f "$STACK_DIR/04-grafana-secret.yaml"
  if [[ "$WITH_THANOS" == "true" ]]; then
    kubectl apply -f "$THANOS_DIR/08-grafana-datasource-thanos.yaml"
  else
    kubectl apply -f "$STACK_DIR/05-grafana-datasource.yaml"
  fi
  kubectl apply -f "$STACK_DIR/06-grafana.yaml"
fi

if [[ "$WITH_STATUS_WEB" == "true" ]]; then
  kubectl apply -f "$ROOT_DIR/manifests/prod/status-web-deployment.yaml"
  kubectl apply -f "$ROOT_DIR/manifests/prod/status-web-service.yaml"
fi

kubectl apply -f "$STACK_DIR/07-operator-rbac.yaml"
kubectl apply -f "$STACK_DIR/08-operator-deployment.yaml"
kubectl apply -f "$STACK_DIR/09-operator-prometheus-rbac.yaml"

echo "=== Waiting for Prometheus Operator ==="
kubectl -n monitoring-manual rollout status deploy/prometheus-operator --timeout=180s

if [[ "$WITH_THANOS" == "true" ]]; then
  kubectl apply -f "$THANOS_DIR/04-prometheus-cr-thanos.yaml"
else
  kubectl apply -f "$STACK_DIR/10-operator-prometheus-cr.yaml"
fi

kubectl apply -f "$STACK_DIR/11-operator-prometheus-service.yaml"
kubectl apply -f "$STACK_DIR/12-operator-status-web-servicemonitor.yaml"
kubectl apply -f "$STACK_DIR/13-operator-status-web-prometheusrule.yaml"

echo "=== Waiting for rollouts ==="
kubectl -n monitoring-manual rollout status deploy/alertmanager --timeout=180s

if ! wait_for_prometheus; then
  exit 1
fi

if [[ "$WITH_THANOS" == "true" ]]; then
  deploy_thanos_query_stack
fi

if [[ "$WITH_GRAFANA" == "true" ]]; then
  kubectl -n monitoring-manual rollout status deploy/grafana --timeout=180s
fi

if [[ "$WITH_STATUS_WEB" == "true" ]]; then
  kubectl -n default rollout status deploy/status-web --timeout=180s
fi

echo ""
if [[ "$WITH_THANOS" == "true" ]]; then
  echo "=== Stack deployed with Thanos ==="
  echo "Thanos Query:  kubectl -n monitoring-manual port-forward svc/thanos-query 9090:9090"
  echo "  verify:       curl http://127.0.0.1:9090/api/v1/stores"
  echo "Prometheus:    kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9091:9090"
  echo "MinIO console: kubectl -n monitoring-manual port-forward svc/minio 9001:9001  (minio / minio123)"
else
  echo "=== Operator/CR stack deployed (00-13) ==="
  echo "Prometheus:    kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090"
fi
echo "Alertmanager:  kubectl -n monitoring-manual port-forward svc/alertmanager 9093:9093"
if [[ "$WITH_GRAFANA" == "true" ]]; then
  echo "Grafana:       kubectl -n monitoring-manual port-forward svc/grafana 3000:3000"
fi

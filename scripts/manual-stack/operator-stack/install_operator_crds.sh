#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
LOCAL_CRDS="${ROOT_DIR}/manifests/manual-stack/01-crds.yaml"

OPERATOR_VERSION="${PROMETHEUS_OPERATOR_VERSION:-v0.76.0}"
CRD_BASE_URL="https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/${OPERATOR_VERSION}/example/prometheus-operator-crd"

install_full_upstream_crds() {
  echo "Installing full upstream CRDs (${OPERATOR_VERSION}) ..."
  kubectl apply --server-side -f "${CRD_BASE_URL}/monitoring.coreos.com_alertmanagerconfigs.yaml"
  kubectl apply --server-side -f "${CRD_BASE_URL}/monitoring.coreos.com_alertmanagers.yaml"
  kubectl apply --server-side -f "${CRD_BASE_URL}/monitoring.coreos.com_podmonitors.yaml"
  kubectl apply --server-side -f "${CRD_BASE_URL}/monitoring.coreos.com_probes.yaml"
  kubectl apply --server-side -f "${CRD_BASE_URL}/monitoring.coreos.com_prometheusagents.yaml"
  kubectl apply --server-side -f "${CRD_BASE_URL}/monitoring.coreos.com_prometheuses.yaml"
  kubectl apply --server-side -f "${CRD_BASE_URL}/monitoring.coreos.com_prometheusrules.yaml"
  kubectl apply --server-side -f "${CRD_BASE_URL}/monitoring.coreos.com_scrapeconfigs.yaml"
  kubectl apply --server-side -f "${CRD_BASE_URL}/monitoring.coreos.com_servicemonitors.yaml"
  kubectl apply --server-side -f "${CRD_BASE_URL}/monitoring.coreos.com_thanosrulers.yaml"
}

echo "=== Prometheus Operator CRDs ==="

if [[ "${USE_FULL_CRDS:-false}" == "true" ]]; then
  install_full_upstream_crds
  echo ""
  kubectl api-resources --api-group=monitoring.coreos.com
  exit 0
fi

if kubectl api-resources --api-group=monitoring.coreos.com 2>/dev/null | grep -q prometheuses; then
  echo "CRDs already registered (prometheuses.monitoring.coreos.com found). Skipping install."
  kubectl api-resources --api-group=monitoring.coreos.com
  exit 0
fi

if [[ -f "$LOCAL_CRDS" ]]; then
  echo "Installing lab CRDs from manifests/manual-stack/01-crds.yaml ..."
  echo "  (Prometheus, ServiceMonitor, PrometheusRule — sufficient for files 07-13 without Thanos)"
  kubectl apply -f "$LOCAL_CRDS"
else
  install_full_upstream_crds
fi

echo ""
echo "CRDs installed. Registered resources:"
kubectl api-resources --api-group=monitoring.coreos.com

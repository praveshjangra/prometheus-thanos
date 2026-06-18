#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
STACK_DIR="$ROOT_DIR/manifests/manual-stack"

kubectl apply -f "$STACK_DIR/00-namespace.yaml"
USE_FULL_CRDS=true "$ROOT_DIR/scripts/manual-stack/operator-stack/install_operator_crds.sh"
kubectl apply -f "$STACK_DIR/02-alertmanager-config.yaml"
kubectl apply -f "$STACK_DIR/03-alertmanager.yaml"
kubectl apply -f "$STACK_DIR/07-operator-rbac.yaml"
kubectl apply -f "$STACK_DIR/08-operator-deployment.yaml"
kubectl apply -f "$STACK_DIR/09-operator-prometheus-rbac.yaml"
kubectl apply -f "$STACK_DIR/10-operator-prometheus-cr.yaml"
kubectl apply -f "$STACK_DIR/11-operator-prometheus-service.yaml"
kubectl apply -f "$STACK_DIR/12-operator-status-web-servicemonitor.yaml"
kubectl apply -f "$STACK_DIR/13-operator-status-web-prometheusrule.yaml"

kubectl -n monitoring-manual rollout status deploy/alertmanager --timeout=180s
kubectl -n monitoring-manual rollout status deploy/prometheus-operator --timeout=180s
kubectl -n monitoring-manual get prometheus k8s
kubectl -n monitoring-manual get pods -l app.kubernetes.io/name=prometheus -o wide || true

echo "Deployed operator stack resources (files 00-03, 07-13)."
echo "Next checks:"
echo "  kubectl -n monitoring-manual get pods"
echo "  kubectl -n monitoring-manual get servicemonitor status-web -o yaml"
echo "  kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090"
echo "  kubectl -n monitoring-manual port-forward svc/alertmanager 9093:9093"

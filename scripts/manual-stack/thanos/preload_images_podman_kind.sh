#!/usr/bin/env bash
# Preload Thanos/MinIO images into a kind cluster when using podman (no docker).
#
# Run from REPO ROOT:
#   cd ~/Desktop/local-repo
#   ./scripts/manual-stack/thanos/preload_images_podman_kind.sh
#
# Or set cluster name explicitly (see: kind get clusters):
#   KIND_CLUSTER_NAME=kind-otel-test ./scripts/manual-stack/thanos/preload_images_podman_kind.sh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
BUCKET_JOB="$ROOT_DIR/manifests/manual-stack/thanos/02-minio-bucket-job.yaml"

if [[ ! -f "$BUCKET_JOB" ]]; then
  echo "Expected bucket job at: $BUCKET_JOB" >&2
  echo "Run this script from the repo: cd <repo-root> && ./scripts/manual-stack/thanos/preload_images_podman_kind.sh" >&2
  exit 1
fi

if [[ -n "${KIND_CLUSTER_NAME:-}" ]]; then
  CLUSTER="$KIND_CLUSTER_NAME"
else
  mapfile -t _kind_clusters < <(kind get clusters 2>/dev/null || true)
  if [[ ${#_kind_clusters[@]} -eq 1 ]]; then
    CLUSTER="${_kind_clusters[0]}"
  elif [[ ${#_kind_clusters[@]} -gt 1 ]]; then
    echo "Multiple kind clusters found: ${_kind_clusters[*]}" >&2
    echo "Set KIND_CLUSTER_NAME, e.g.: KIND_CLUSTER_NAME=kind-otel-test $0" >&2
    exit 1
  else
    CLUSTER="kind"
  fi
fi

IMAGES=(
  minio/minio:RELEASE.2024-06-13T22-53-53Z
  minio/mc:latest
  quay.io/thanos/thanos:v0.35.1
  quay.io/prometheus-operator/prometheus-operator:v0.76.0
  quay.io/prometheus-operator/prometheus-config-reloader:v0.76.0
)

if ! command -v podman >/dev/null 2>&1; then
  echo "podman not found in PATH" >&2
  exit 1
fi

if ! command -v kind >/dev/null 2>&1; then
  echo "kind not found in PATH" >&2
  exit 1
fi

export KIND_EXPERIMENTAL_PROVIDER="${KIND_EXPERIMENTAL_PROVIDER:-podman}"

echo "=== Pulling images with podman ==="
for img in "${IMAGES[@]}"; do
  echo "  pull $img"
  podman pull "$img"
done

echo ""
echo "=== Loading images into kind cluster: $CLUSTER ==="
for img in "${IMAGES[@]}"; do
  echo "  load $img"
  kind load docker-image "$img" --name "$CLUSTER"
done

echo ""
echo "Done. Re-run the bucket job:"
echo "  kubectl -n monitoring-manual delete job minio-create-thanos-bucket --ignore-not-found"
echo "  kubectl apply -f $BUCKET_JOB"
echo "  kubectl -n monitoring-manual wait --for=condition=complete job/minio-create-thanos-bucket --timeout=120s"

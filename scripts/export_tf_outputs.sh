#!/usr/bin/env bash
set -euo pipefail
ENV="${1:-dev}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

pushd "${ROOT}/envs/${ENV}" >/dev/null
DB_HOST=$(terraform output -raw rds_endpoint)
ALB_DNS=$(terraform output -raw alb_dns_name)
SSM_PREFIX=$(terraform output -raw ssm_prefix 2>/dev/null || echo "/wp-ha-${ENV}/wordpress" || true)

mkdir -p "${ROOT}/ansible/inventories/${ENV}/group_vars"
cat > "${ROOT}/ansible/inventories/${ENV}/group_vars/all.yml" <<YAML
app_env: ${ENV}
alb_dns_name: ${ALB_DNS}
ssm_prefix: ${SSM_PREFIX}
YAML
popd >/dev/null

echo "[OK] Exported outputs to group_vars for env=${ENV}"

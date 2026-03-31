#!/usr/bin/env bash
set -euo pipefail
if [ -z "${VERCEL_TOKEN:-}" ]; then
  echo "ERROR: VERCEL_TOKEN environment variable is not set."
  echo "Set it locally (export VERCEL_TOKEN=...) or create GitHub secret VERCEL_TOKEN."
  exit 1
fi
echo "Installing vercel CLI (if needed) and deploying..."
npx vercel --prod --token "${VERCEL_TOKEN}" --confirm

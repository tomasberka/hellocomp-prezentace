#!/usr/bin/env bash
set -euo pipefail

REPO="tomasberka/hellocomp-prezentace"
WORKFLOW_FILE="deploy-cloudflare-pages.yml"

echo "Setup Cloudflare preview for $REPO"

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: GitHub CLI 'gh' is required. Install from https://cli.github.com/"
  exit 1
fi

# Read values from env or prompt
: ${CF_TOKEN:=}
: ${CF_ACCOUNT_ID:=}
: ${CF_PROJECT_NAME:=}

if [ -z "${CF_TOKEN}" ]; then
  read -s -p "Cloudflare API token (input hidden): " CF_TOKEN
  echo
fi
if [ -z "${CF_ACCOUNT_ID}" ]; then
  read -p "Cloudflare Account ID: " CF_ACCOUNT_ID
fi
if [ -z "${CF_PROJECT_NAME}" ]; then
  read -p "Cloudflare Pages project name [hellocomp-prezentace]: " CF_PROJECT_NAME
  CF_PROJECT_NAME=${CF_PROJECT_NAME:-hellocomp-prezentace}
fi

echo "Setting GitHub secrets in $REPO..."
gh secret set CLOUDFLARE_API_TOKEN --body "$CF_TOKEN" -R "$REPO"
gh secret set CLOUDFLARE_ACCOUNT_ID --body "$CF_ACCOUNT_ID" -R "$REPO"
gh secret set CLOUDFLARE_PAGES_PROJECT_NAME --body "$CF_PROJECT_NAME" -R "$REPO"

echo "Secrets set. Triggering workflow $WORKFLOW_FILE..."
gh workflow run "$WORKFLOW_FILE" -R "$REPO"

echo "Workflow triggered. Open GitHub Actions for the repo to watch the run logs." 
echo "Example: https://github.com/$REPO/actions/workflows/$WORKFLOW_FILE"

echo "If the workflow fails, check DOKUMENTACE.md for troubleshooting steps." 

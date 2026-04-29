#!/usr/bin/env bash
# Create github.com/jimhostetler/claim-aggregator (if missing) and push main.
set -euo pipefail

REPO_NAME="claim-aggregator"
GITHUB_USER="jimhostetler"
FULL_NAME="${GITHUB_USER}/${REPO_NAME}"
REMOTE_URL="https://github.com/${FULL_NAME}.git"

cd "$(dirname "$0")"

if ! command -v gh >/dev/null 2>&1; then
  echo "Install GitHub CLI first:  brew install gh"
  exit 1
fi

echo "==> GitHub CLI auth"
gh auth status

if gh repo view "${FULL_NAME}" >/dev/null 2>&1; then
  echo "==> Repo already exists: https://github.com/${FULL_NAME}"
else
  echo "==> Creating public repo ${FULL_NAME}"
  gh repo create "${FULL_NAME}" \
    --public \
    --description "Mobile claims prototype — visits by date and grouped bill breakdown"
fi

if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "${REMOTE_URL}"
else
  git remote add origin "${REMOTE_URL}"
fi

echo "==> Pushing branch main to origin"
git push -u origin main

echo "==> Done. Site (after Pages): https://${GITHUB_USER}.github.io/${REPO_NAME}/"
echo "    Enable: repo Settings → Pages → Branch main, folder / (root)"

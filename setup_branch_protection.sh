#!/bin/bash

# Branch Protection Setup Script
# Purpose: Configure branch protection rules via GitHub API
# Note: Requires GITHUB_TOKEN with repo permissions

echo "🛡️ SETTING UP BRANCH PROTECTION RULES"
echo "======================================"

# Repository information
OWNER="ardhaecosystem"
REPO="ArdhaRAG"

# Check for GitHub token
if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "❌ GITHUB_TOKEN environment variable not set"
    echo "Create a personal access token with 'repo' scope at:"
    echo "https://github.com/settings/tokens"
    echo "Then run: export GITHUB_TOKEN=your_token_here"
    exit 1
fi

# Main branch protection
echo "🔒 Setting up main branch protection..."
curl -X PUT \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$OWNER/$REPO/branches/main/protection" \
  -d '{
    "required_status_checks": {
      "strict": true,
      "contexts": ["🧹 Code Quality", "🧪 Tests", "🐳 Docker Build", "🛡️ Security Scan"]
    },
    "enforce_admins": false,
    "required_pull_request_reviews": {
      "required_approving_review_count": 2,
      "dismiss_stale_reviews": true,
      "require_code_owner_reviews": true
    },
    "restrictions": null,
    "allow_force_pushes": false,
    "allow_deletions": false
  }'

# Develop branch protection  
echo "🔒 Setting up develop branch protection..."
curl -X PUT \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$OWNER/$REPO/branches/develop/protection" \
  -d '{
    "required_status_checks": {
      "strict": true,
      "contexts": ["🧹 Code Quality", "🧪 Tests"]
    },
    "enforce_admins": false,
    "required_pull_request_reviews": {
      "required_approving_review_count": 1,
      "dismiss_stale_reviews": true
    },
    "restrictions": null,
    "allow_force_pushes": true,
    "allow_deletions": false
  }'

echo "✅ Branch protection rules configured!"
echo "📋 Summary:"
echo "  - main: 2 required reviews, all status checks required"
echo "  - develop: 1 required review, basic status checks required"

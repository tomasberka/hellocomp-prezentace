<#
.SYNOPSIS
  Set GitHub repo secrets for Cloudflare Pages and trigger the deploy workflow.

  Requires: GitHub CLI (`gh`) authenticated locally.
#>

param()

$ErrorActionPreference = 'Stop'

$repo = 'tomasberka/hellocomp-prezentace'
$workflowFile = 'deploy-cloudflare-pages.yml'

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  Write-Error "GitHub CLI 'gh' not found. Install from https://cli.github.com/"
  exit 1
}

function Prompt-Secret([string]$prompt, [switch]$hidden) {
  if ($hidden) {
    $secure = Read-Host -AsSecureString $prompt
    return [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
  } else {
    return Read-Host $prompt
  }
}

$cfToken = $env:CF_TOKEN
if (-not $cfToken) { $cfToken = Prompt-Secret "Cloudflare API token (input hidden)" -hidden }

$cfAccountId = $env:CF_ACCOUNT_ID
if (-not $cfAccountId) { $cfAccountId = Prompt-Secret "Cloudflare Account ID" }

$cfProjectName = $env:CF_PROJECT_NAME
if (-not $cfProjectName) { $cfProjectName = Read-Host "Cloudflare Pages project name (default: hellocomp-prezentace)"; if (-not $cfProjectName) { $cfProjectName = 'hellocomp-prezentace' } }

Write-Output "Setting GitHub secrets in $repo..."
gh secret set CLOUDFLARE_API_TOKEN --body "$cfToken" -R $repo
gh secret set CLOUDFLARE_ACCOUNT_ID --body "$cfAccountId" -R $repo
gh secret set CLOUDFLARE_PAGES_PROJECT_NAME --body "$cfProjectName" -R $repo

Write-Output "Secrets set. Triggering workflow $workflowFile..."
gh workflow run $workflowFile -R $repo

Write-Output "Workflow dispatched. Monitor Actions: https://github.com/$repo/actions/workflows/$workflowFile"

param()
if (-not $env:VERCEL_TOKEN) {
  Write-Error "VERCEL_TOKEN environment variable is not set. Provide it before running the script."
  exit 1
}
Write-Host "Deploying to Vercel..."
npx vercel --prod --token $env:VERCEL_TOKEN --confirm

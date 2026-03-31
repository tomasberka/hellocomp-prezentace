# Cloudflare preview setup scripts

Files:

- `setup_cloudflare_preview.sh` — Bash script to set GitHub repository secrets and trigger the Cloudflare Pages deploy workflow. Requires `gh` CLI.
- `setup_cloudflare_preview.ps1` — PowerShell equivalent for Windows.

Usage (Bash):

```bash
# set environment variables (optional) then run the script
export CF_TOKEN="<your_cloudflare_api_token>"
export CF_ACCOUNT_ID="<your_account_id>"
export CF_PROJECT_NAME="hellocomp-prezentace"
./setup_cloudflare_preview.sh
```

Usage (PowerShell):

```powershell
# run in PowerShell
.\setup_cloudflare_preview.ps1
```

What the scripts do:

- Prompt for (or read from environment) the Cloudflare API token, Account ID, and Pages project name.
- Use `gh secret set` to store `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`, and `CLOUDFLARE_PAGES_PROJECT_NAME` in the repo `tomasberka/hellocomp-prezentace`.
- Trigger the `deploy-cloudflare-pages.yml` workflow to deploy/preview the `HelloComp_PREZENTACE` directory.

Notes:

- You must be authenticated with `gh` CLI and have write access to the repository.
- The scripts do not transmit secrets anywhere except to GitHub Secrets for the repository.
- If you prefer not to use `gh`, follow the manual steps in `DOKUMENTACE.md`.

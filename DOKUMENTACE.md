# DOKUMENTACE PRO HelloComp PREZENTACE

## Účel
Tento dokument shrnuje, co bylo vytvořeno, jak to otevřít, jak propojit články s videi a jak dosáhnout E‑E‑A‑T (Experience, Expertise, Authoritativeness, Trustworthiness). Slouží jako balík, který můžete odeslat kolegům nebo klientovi spolu s pokyny k otevření.

## Jak otevřít
- Lokálně (rychle): otevřete `HelloComp_PREZENTACE/index.html` v prohlížeči.
- Doporučeně lokálně (server): spusťte jednoduchý HTTP server a otevřete `http://localhost:8000/`.

  PowerShell / příkazová řádka:
  ```powershell
  cd HelloComp_PREZENTACE
  python -m http.server 8000
  # nebo (Node): npx http-server -p 8000
  ```

- GitHub Pages: (pokud je repozitář publikovaný) https://tomasberka.github.io/hellocomp-prezentace/
- Heslo pro interní obsah (in-site gate): `prezentace` — viz `assets/auth.js`.

## Co je v balíku (klíčové soubory)
- `index.html` — vstup do prezentace.
- `HelloComp_Content_Hub.html` / `content-hub.html` — obsahový hub se seznamem článků a videí.
- `HelloComp_SEO_Video_Scripts.html` — seznam a texty video-skriptů.
- `HelloComp_Instagram_Carousels.html` / `HelloComp_Carousel_Export.html` — exporty pro sociální sítě.
- `assets/auth.js` — lehký in-site password gate (heslo viz výše).
- Všechny články a SEO copy: najdete v repozitáři `CODE_MAHONY/PROJECTS/Hellocomp SEO + COPY/` (obsah ve formátu Markdown, ~180 souborů).

## Doporučená struktura dokumentu pro odeslání
1. Tento soubor `DOKUMENTACE.md` (popis a instrukce)
2. ZIP archív `presentation.zip` (volitelně) obsahující `HelloComp_PREZENTACE/` (index + assets)
3. Odkazy na repozitář s články (nebo export CSV s názvy článků a URL)
4. Mapovací tabulka (CSV/MD) článků -> video skriptů (viz níže)

## Jak propojit články s videi (workflow)
1. Vytvořte mapu: pro každý článek (soubor `.md`) přiřaďte 0..n video skriptů podle tématu a klíčových slov.
2. Do hlavičky článku (frontmatter) přidejte metadata:
   - `video:` cesta nebo YouTube URL
   - `transcript:` cesta k přepisu (.txt/.vtt)
   - `video_script_id:` interní id skriptu
3. Na stránce článku vložte hráč (embed) s přiloženým přepisem (transcript) a časovými razítky.
4. Aktualizujte obsahový hub (`HelloComp_Content_Hub.html`) o přímé odkazy Article ↔ Video.

Příklad frontmatter (YAML):
```yaml
---
title: "Jak vybrat grafickou kartu"
date: 2026-03-01
author: "Tomáš Berka"
video:
  - url: "https://www.youtube.com/watch?v=..."
    transcript: "assets/transcripts/gpu-transcript.vtt"
    script_file: "HelloComp_SEO_Video_Scripts/gpu.md"
---
```

## Technická doporučení pro SEO a E‑E‑A‑T
- Autor a autority:
  - Každý článek musí obsahovat autorův blok (`About the author`) s krátkým bio a odkazem na `ABOUT ME/bio.md`.
  - Přidejte odkazy na profesní profily (LinkedIn) a relevantní reference.
- Video a přepis:
  - U každého videa publikujte přepis (plain text a VTT) a vložte jej do článku (nebo jako `details` block). Přepisy indexují vyhledávače a zvyšují E‑E‑A‑T.
- Citace a odkazy:
  - Vždy uvádějte zdroje — odkazy, data, odkazy na studie.
- Strukturovaná data (JSON‑LD):
  - Přidejte `Article` + `VideoObject` schema do hlavičky stránky.

Příklad JSON‑LD pro video (vložit do `<head>` článku):
```json
{
  "@context": "https://schema.org",
  "@type": "VideoObject",
  "name": "Název videa",
  "description": "Krátký popis",
  "thumbnailUrl": ["https://.../thumb.jpg"],
  "uploadDate": "2026-03-31",
  "duration": "PT2M34S",
  "contentUrl": "https://example.com/videos/video.mp4",
  "embedUrl": "https://www.youtube.com/embed/..."
}
```

## Cloudflare preview (Cloudflare Pages)

Možnosti nasazení/preview přes Cloudflare:

- Variant A — rychlé připojení přes Cloudflare Pages (doporučené):
  1. V Cloudflare dashboardu otevřete **Pages** → **Create a project**.
  2. Připojte GitHub (pokud ještě není) a vyberte repozitář `tomasberka/hellocomp-prezentace`.
  3. Build settings: Framework = None, Build command = (ponechat prázdné), Output directory = `HelloComp_PREZENTACE`.
  4. Vytvořte projekt; Cloudflare vytvoří `*.pages.dev` doménu a každé pushnutí spustí nasazení a náhledy.

- Variant B — nasazení přes GitHub Actions (workflow je v repozitáři):
  1. V repozitáři jděte do **Settings → Secrets → Actions** a přidejte tyto secrets:
     - `CLOUDFLARE_API_TOKEN` — API token s právy na Pages (Pages: Edit / Read as needed).
     - `CLOUDFLARE_ACCOUNT_ID` — najdete v Cloudflare dashboardu (Account → Overview).
     - `CLOUDFLARE_PAGES_PROJECT_NAME` — název Pages projektu (např. `hellocomp-prezentace`).
  2. Workflow `deploy-cloudflare-pages.yml` v `.github/workflows/` je připraven: po pushi do `main` nebo manuálním spuštění (workflow_dispatch) provede nasazení.
  3. Po úspěšném běhu získáte URL `https://<project>.pages.dev` (nebo custom domain, pokud ji nastavíte).

Poznámky a rychlý náhled lokálně přes Cloudflare Tunnel (volitelně):
- Pokud chcete sdílet lokální preview přes Cloudflare bez vytváření Pages projektu, použijte `cloudflared` a příkaz
  ```bash
  cloudflared tunnel --url http://localhost:8000
  ```
  To vyžaduje přihlášení `cloudflared login` do Cloudflare a není součástí tohoto repozitáře.

Troubleshooting
- Pokud workflow selže, otevřete GitHub Actions → vyberte běh → zobrazte logy kroku `Deploy to Cloudflare Pages`.
- Zkontrolujte, že `directory` v workflow odpovídá umístění (zde `HelloComp_PREZENTACE`).

Hotovo — po přidání secrets spusťte workflow ručně (`Actions → Deploy to Cloudflare Pages → Run workflow`) a po úspěšném buildu vám Cloudflare předá preview URL.

## Připojení repozitáře k Cloudflare Pages (UI) — krok za krokem

1. Přihlaste se do Cloudflare: https://dash.cloudflare.com/ (použijte účet, který má přístup k Pages).
2. V levém menu vyberte **Pages** → **Create a project**.
3. Klikněte na **Connect to Git** → vyberte GitHub a autorizujte přístup (pokud Cloudflare dosud nemá oprávnění k vašemu GitHub účtu).
4. Vyberte repozitář `tomasberka/hellocomp-prezentace` a klikněte **Begin setup**.
5. Build settings:
   - Framework: **None** (statická HTML prezentace)
   - Build command: (ponechat prázdné)
   - Output directory: `HelloComp_PREZENTACE`
   - Production branch: `main`
6. Dokončete vytvoření projektu. Cloudflare vytvoří adresu `https://<project>.pages.dev` — uložte si ji pro preview.

Poznámka: Pokud chcete, aby se nasazení spouštělo přes náš GitHub Actions workflow (místo integrovaného konektoru), použijte níže uvedené secrets a workflow.

## Vytvoření Cloudflare API tokenu (pokud používáte workflow)

1. V Cloudflare dashboardu klikněte na profil (pravý horní roh) → **My Profile** → **API Tokens** → **Create Token**.
2. Použijte šablonu **Edit Cloudflare Pages** (nebo vytvořte Custom token) a udělte mu oprávnění pro Pages (Edit/Publish) a případně Account:Read.
3. Po vytvoření tokenu zkopírujte jeho hodnotu (jednorázově — už ji neukáže znovu).
4. Najděte `Account ID`: Cloudflare → Account → Overview → Account ID.

## Přidání secrets do GitHubu (UI nebo GH CLI)

GitHub UI:
- Repo → Settings → Secrets & variables → Actions → New repository secret → přidejte tyto tři secrety:
  - `CLOUDFLARE_API_TOKEN` → (váš token)
  - `CLOUDFLARE_ACCOUNT_ID` → (Account ID)
  - `CLOUDFLARE_PAGES_PROJECT_NAME` → `hellocomp-prezentace`

GH CLI (pokud máte nainstalovaný `gh` a jste přihlášeni):
```bash
# nastavte proměnné lokálně a spusťte tyto příkazy
export CF_TOKEN="<váš_cloudflare_token>"
export CF_ACCOUNT_ID="<váš_account_id>"
gh secret set CLOUDFLARE_API_TOKEN --body "$CF_TOKEN" -R tomasberka/hellocomp-prezentace
gh secret set CLOUDFLARE_ACCOUNT_ID --body "$CF_ACCOUNT_ID" -R tomasberka/hellocomp-prezentace
gh secret set CLOUDFLARE_PAGES_PROJECT_NAME --body "hellocomp-prezentace" -R tomasberka/hellocomp-prezentace
```

## Spuštění workflow a kontrola preview

- Po přidání secretů otevřete GitHub → Actions → `Deploy to Cloudflare Pages` workflow a klikněte **Run workflow** (vyberte `main`).
- Po úspěšném běhu otevřete logy a najděte URL `https://<project>.pages.dev` nebo zkontrolujte Cloudflare Pages dashboard.

## Pokud chcete, abych to udělal za Vás

- Můžu provést automatické připojení a dokončit nastavení Pages, ale potřebuji jedno z následujícího:
  1. Dočasný **Cloudflare API token** (doporučeno: token s právem Pages Edit) + vaše **Account ID** — já vytvořím/konfiguruji Pages projekt přes API nebo `cloudflare/pages-action` a přidám potřebné GitHub secrets. Nebo
  2. Udělení přístupu přes Cloudflare UI (poskytnutí přihlašovacích údajů) — méně doporučené.

- Bezpečnostní doporučení: místo zasílání tokenu přes chat doporučuji, abyste token vytvořil(a) a vložil(a) ho přímo do GitHub repo secrets podle instrukcí výše; já pak mohu workflow spustit a sledovat nasazení.

---


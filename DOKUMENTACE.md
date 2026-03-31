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
  "embedUrl": "https://www.youtube.com/embed/...",
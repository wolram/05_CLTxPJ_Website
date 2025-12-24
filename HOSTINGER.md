# Hostinger Git Deploy

This repository is ready for Hostinger Git deployment as a static site. All public assets live in `public/`.

## Recommended Setup
1. In hPanel, create a **Git** deployment for your domain.
2. Set the deployment path to `public_html`.
3. If Hostinger allows a **subdirectory** or **document root** setting, point it to `public/`.

## If a Subdirectory Option Is Not Available
Use a post-deploy command to sync `public/` into `public_html`. Example:

```bash
rsync -a --delete public/ public_html/
```

If `rsync` is unavailable, use:

```bash
cp -R public/* public_html/
```

## Notes
- The site is static; no build step is required.
- Keep `public/index.html` as the entry point.
- Do not deploy `calccltxpj_artifacts/` or other repo docs to the web root.

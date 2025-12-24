# Repository Guidelines

## Project Structure & Module Organization
- `public/` is the deployable site root.
- `public/index.html` is the single-page marketing site and entry point.
- `public/css/styles.css` holds custom styles (Tailwind is loaded via CDN).
- `public/js/app.js` contains calculator logic, formatting utilities, and the optional AI analysis call.
- `calccltxpj_artifacts/` includes planning and policy docs (e.g., `CONTRIBUTING.md`, `SECURITY.md`) and is not used by the live page.

## Build, Test, and Development Commands
- No build step is required; assets are static.
- Local preview (any static server works):
  - `python3 -m http.server 8000` then open `http://localhost:8000/public/`.
- Quick smoke check: open `public/index.html` directly in a browser.

## Coding Style & Naming Conventions
- Indentation: 4 spaces in HTML, CSS, and JS.
- JavaScript: use `camelCase` for variables/functions; keep functions small and DOM-focused.
- CSS: use `kebab-case` for custom class names (e.g., `.text-brand`).
- Prefer Tailwind utility classes in `index.html`; keep `css/styles.css` for shared overrides only.

## Testing Guidelines
- There are no automated tests in this repository today.
- If you add tests, document the framework and add a `tests/` directory with `*.test.js` naming.

## Commit & Pull Request Guidelines
- Recent commit messages are short, sentence-style, and in Portuguese. Keep them concise.
- `calccltxpj_artifacts/CONTRIBUTING.md` suggests Conventional Commits and branch names like:
  - `feat/<slug>`, `fix/<slug>`, `chore/<slug>`
- PRs should be small and focused, describe the user-facing impact, and include screenshots for UI changes.

## Security & Configuration Tips
- Do not commit secrets. The `CONFIG.apiKey` in `js/app.js` should remain empty in git.
- AI requests should be routed server-side in production; mock mode is enabled by default.

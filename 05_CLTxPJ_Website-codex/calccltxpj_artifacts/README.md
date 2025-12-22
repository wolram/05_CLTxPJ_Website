# Calculadora CLT x PJ — Web

Website oficial do produto **CalcCLTxPJ** (produto independente) com:
- simulador CLT x PJ
- CTA para App Store
- blog para SEO
- (opcional) análise qualitativa por IA via endpoint seguro

## Links
- **Domínio:** https://calccltxpj.com.br
- **App Store:** https://apps.apple.com/br/app/calculadora-clt-x-pj/id6755878441

## Stack recomendada
- Next.js (App Router) + React + TypeScript
- Tailwind CSS
- Framer Motion (animações)
- MDX (blog)
- Vercel (deploy)

## Como rodar
```bash
npm install
npm run dev
```

## Variáveis de ambiente
Crie um `.env.local` baseado em `.env.example`.

- `GEMINI_API_KEY` — chave do Gemini (server-side)
- `NEXT_PUBLIC_GA_MEASUREMENT_ID` — GA4 (opcional)

> Importante: **nunca** coloque a chave do Gemini no código client-side.

## Endpoint de IA (sugestão)
Implementar rota server-side:
- `POST /api/career-analysis` → chama Gemini e retorna um texto curto.
- Rate-limit e validação básica (anti-abuso) recomendados.

## Tracking (mínimo)
Eventos sugeridos:
- `simulator_change`
- `verdict_generated`
- `appstore_click`
- `ai_analysis_requested`
- `ai_analysis_returned`

## Publicação (Vercel)
1. Import Project do GitHub
2. Deploy automático por push
3. Conectar domínio `calccltxpj.com.br`

Checklist detalhado: `docs/LAUNCH_CHECKLIST.md`

## Licença
Veja `LICENSE`.

# ContextMD — CalcCLTxPJ

## Visão
CalcCLTxPJ é um **produto independente** que ajuda pessoas a decidirem entre **CLT** e **PJ (CNPJ)** com:
- **simulador financeiro** rápido e claro (resultado + veredito);
- **análise qualitativa** (estilo de vida, estabilidade, riscos e responsabilidades) suportada por IA;
- conteúdo (blog) para educação e aquisição orgânica.

## Problema
- Comparações CLT x PJ geralmente são confusas, incompletas e cheias de “achismos”.
- A decisão envolve **números + trade-offs não financeiros** (risco, estabilidade, benefícios, disciplina).
- Usuários não têm uma ferramenta simples para explorar cenários.

## Proposta de valor
- Resultado em segundos, linguagem direta.
- Explicação do “porquê” (números + contexto).
- Exportável/compartilhável (resumo do cenário).
- Funil simples: **site → App Store**.

## Público-alvo
- Pessoas avaliando migração CLT → PJ.
- Profissionais recebendo proposta PJ.
- Recrutadores/gestores (para orientar ofertas).
- Estudantes e curiosos.

## Produto e canais
- **Website:** https://calccltxpj.com.br
- **App iOS:** https://apps.apple.com/br/app/calculadora-clt-x-pj/id6755878441

## Princípios do produto
1. **Clareza > complexidade.** Mostrar o essencial primeiro.
2. **Segurança por padrão.** Nunca expor segredos (API keys) no front.
3. **Rastreável.** Todo CTA e passo do funil deve ser mensurável.
4. **Reprodutível.** Mesmos inputs → mesmo resultado.
5. **Sem aconselhamento financeiro.** Ferramenta educacional/estimativa.

## Arquitetura (alto nível)
- **Frontend (Next.js/React):** simulador, blog, páginas estáticas.
- **Backend (Serverless):** endpoint para IA (Gemini proxy) + validações.
- **Analytics:** GA4 (site) + App Store Connect Campaign Links (atribuição).

## Métricas (MVP)
- `cta_appstore_click_rate` = cliques App Store / sessões
- `simulator_completion_rate` = veredito gerado / sessões
- `seo_indexed_pages` e `organic_clicks` (Search Console)
- `app_installs_from_campaign` (App Store Connect)

## Roadmap (resumo)
- v0.1: site + simulador + CTA + tracking
- v0.2: IA via endpoint seguro + página de privacidade/termos
- v0.3: blog + 3 posts SEO + melhorias de conversão (copy/FAQ)
- v1.0: histórico de cenários (opcional) + melhorias de ASO

## Definition of Done (DoD)
Uma entrega está “Done” quando:
- funciona em desktop e mobile;
- tem evento de tracking onde faz sentido;
- tem texto/UX revisados (claros e curtos);
- não expõe segredos;
- está publicada e revisada no domínio.

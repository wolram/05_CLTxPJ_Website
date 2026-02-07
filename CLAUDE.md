# CLAUDE.md - Calculadora CLT x PJ Website

> Guia para assistentes de IA que trabalharão neste projeto.

## Architecture

### Estrutura de Pastas
```
/
├── public/                    # Site estático (produção)
│   ├── index.html            # Landing page principal
│   ├── css/styles.css        # Estilos customizados (Navy+Gold theme)
│   ├── js/app.js             # Lógica da calculadora e IA mock
│   ├── blog/                 # Artigos do blog (HTML estático)
│   ├── privacy.html          # Política de Privacidade
│   ├── terms.html            # Termos de Uso
│   ├── android-waitlist.html # Waitlist para Android
│   └── logo.jpg              # Logo do app
├── calccltxpj_artifacts/     # Documentação do produto
│   ├── context.md            # Visão e princípios
│   ├── ROADMAP.md            # Roadmap do produto
│   └── docs/                 # Documentos auxiliares
├── .github/workflows/
│   └── deploy.yml            # CI/CD via FTP para Hostinger
├── HOSTINGER.md              # Instruções de deploy no Hostinger
└── AGENTS.md                 # Contexto para agentes de IA
```

### Padrão de Design
- **Static Site**: HTML/CSS/JS puro (sem framework React/Vue)
- **Styling**: TailwindCSS via CDN + CSS customizado (`styles.css`)
- **Design System**: Glassmorphism dark theme (Navy #0d1a2d + Gold #c9a227)
- **Arquitetura Frontend**: Single-page com seções (Hero, Features, Blog, Footer)

### Fluxo de Dados
1. Usuário insere valores CLT/PJ nos inputs
2. `app.js` calcula estimativa anual líquida
3. Exibe comparativo visual com barras de progresso
4. Botão "Leitura Comparativa" gera análise (mock ou Gemini API)
5. CTA redireciona para App Store

## Commands

### Desenvolvimento
```bash
# Não há build step - projeto é 100% estático
# Para testar localmente:
cd public && python -m http.server 8000
# ou
npx serve public
```

### Deploy
```bash
# Deploy automático via GitHub Actions
git push origin main
# O workflow .github/workflows/deploy.yml faz FTP para Hostinger
```

### Verificações Manuais
```bash
# Validar HTML
npx html-validate public/*.html

# Lighthouse (via CLI)
npx lighthouse https://calculadoracltpj.com.br --view
```

## Conventions

### Stack Tecnológica
| Camada       | Tecnologia                          |
|--------------|-------------------------------------|
| Markup       | HTML5 semântico                     |
| Estilos      | TailwindCSS CDN + CSS custom        |
| JS           | Vanilla ES6+ (sem bundler)          |
| Fonte        | Google Fonts (Inter)                |
| Icons        | SVG inline                          |
| Deploy       | GitHub Actions → FTP Hostinger      |
| Analytics    | GA4 (a implementar)                 |
| IA           | Gemini API (mock por padrão)        |

### Regras de Código
1. **Sem dependências npm** - projeto estático simples
2. **Mobile-first** - todas as seções responsivas
3. **Acessibilidade** - `prefers-reduced-motion` respeitado
4. **Nenhum segredo no frontend** - API keys só via backend/proxy
5. **Português BR** - todo conteúdo e comentários em PT-BR

### Padrão de Cores (CSS Variables)
```css
--bg-primary: #0d1a2d;      /* Navy escuro */
--accent-primary: #c9a227;  /* Gold */
--accent-secondary: #d4af37;
--text-primary: #f8fafc;
```

### Convenções de Arquivos
- CSS classes seguem Tailwind utility-first
- JS usa funções declarativas (não classes)
- HTML usa indentação de 4 espaços
- Imagens externas via Unsplash CDN (para dev)

## Status Atual

### Implementado
- Landing page completa com simulador
- Sistema de cálculo CLT vs PJ
- Análise comparativa (mock mode)
- 3 artigos de blog
- Páginas de Privacidade e Termos
- Waitlist para Android
- Deploy automatizado

### Pendente (por prioridade)
1. Migrar para Next.js + build otimizado
2. Implementar GA4 + Search Console
3. Endpoint seguro para Gemini API
4. Sitemap.xml e robots.txt
5. Testes automatizados

## Links Úteis
- **Produção**: https://calculadoracltpj.com.br
- **App iOS**: https://apps.apple.com/br/app/calculadora-clt-x-pj/id6755878441
- **Roadmap**: [calccltxpj_artifacts/ROADMAP.md](./calccltxpj_artifacts/ROADMAP.md)
- **Context**: [calccltxpj_artifacts/context.md](./calccltxpj_artifacts/context.md)

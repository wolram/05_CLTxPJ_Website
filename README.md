# Calculadora CLT x PJ - Website

Landing page oficial da Calculadora CLT x PJ, ferramenta que ajuda profissionais a comparar propostas de trabalho CLT versus PJ (CNPJ).

## Links

- **Site**: https://calculadoracltpj.com.br
- **App iOS**: https://apps.apple.com/br/app/calculadora-clt-x-pj/id6755878441

## Stack

| Tecnologia | Uso |
|------------|-----|
| HTML5 | Estrutura semântica |
| TailwindCSS (CDN) | Estilização utility-first |
| CSS Custom | Tema glassmorphism (Navy + Gold) |
| Vanilla JS | Lógica do simulador |
| GitHub Actions | CI/CD via FTP |
| Hostinger | Hospedagem |

## Estrutura

```
public/
├── index.html            # Landing page com simulador
├── css/styles.css        # Estilos customizados
├── js/app.js             # Lógica da calculadora
├── blog/                 # Artigos do blog
├── privacy.html          # Política de Privacidade
├── terms.html            # Termos de Uso
└── android-waitlist.html # Waitlist Android
```

## Desenvolvimento

```bash
# Servidor local
cd public && python -m http.server 8000

# Alternativa com Node
npx serve public
```

Acesse http://localhost:8000

## Deploy

O deploy é automático via GitHub Actions ao fazer push na branch `main`:

```bash
git push origin main
```

O workflow `.github/workflows/deploy.yml` sincroniza a pasta `public/` para o Hostinger via FTP.

## Funcionalidades

- Simulador CLT vs PJ com cálculo em tempo real
- Análise comparativa com IA (modo mock por padrão)
- Blog com conteúdo sobre carreira e finanças
- Design responsivo mobile-first
- Animações respeitando `prefers-reduced-motion`

## Documentação

- [CLAUDE.md](./CLAUDE.md) - Guia para assistentes de IA
- [HOSTINGER.md](./HOSTINGER.md) - Instruções de deploy
- [calccltxpj_artifacts/](./calccltxpj_artifacts/) - Documentação do produto

## Licença

Todos os direitos reservados.

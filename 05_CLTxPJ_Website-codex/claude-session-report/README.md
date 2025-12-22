# 📊 Claude Session Report Generator

> Ferramenta CLI para gerar relatórios estruturados após sessões de Claude Code
> Parte do **Solo Developer Framework**

## 🚀 Instalação Rápida

```bash
# 1. Clone ou copie os arquivos
mkdir -p ~/.local/bin
cp session-report.sh ~/.local/bin/session-report
chmod +x ~/.local/bin/session-report

# 2. Adicione os hooks ao seu shell
echo 'source ~/path/to/claude-hooks.sh' >> ~/.zshrc
# ou
echo 'source ~/path/to/claude-hooks.sh' >> ~/.bashrc

# 3. Recarregue o shell
source ~/.zshrc
```

## 📋 Tipos de Relatório

### 1. Daily Standup (`-t daily`)
Ideal para: **Daily meetings, async updates**

```bash
session-report -t daily -c  # Gera e copia pro clipboard
```

**Inclui:**
- Commits realizados
- Linhas adicionadas/removidas
- Arquivos alterados
- Métricas da sessão Claude
- Próximos passos

---

### 2. Code Review (`-t review`)
Ideal para: **Pull Requests, Code Reviews**

```bash
session-report -t review -f markdown
```

**Inclui:**
- Escopo das alterações
- Lista de arquivos modificados
- Decisões de arquitetura
- Trade-offs discutidos
- Pontos de atenção
- FinOps da review

---

### 3. Retrospectiva (`-t retro`)
Ideal para: **Sprint Retros, Post-mortems**

```bash
session-report -t retro -o retro-sprint-42.md
```

**Inclui:**
- O que funcionou bem
- O que pode melhorar
- Ações para próxima sprint
- Métricas de produtividade
- FinOps summary

---

### 4. FinOps (`-t finops`)
Ideal para: **Controle de custos, Budget tracking**

```bash
session-report -t finops -s week
```

**Inclui:**
- Tokens consumidos (input/output)
- Custo detalhado da sessão
- Projeções mensais
- ROI estimado
- Sugestões de otimização

---

### 5. Relatório Completo (`-t full`)
Ideal para: **Documentação, Handover, Reports executivos**

```bash
session-report -t full -o report-completo.md
```

**Inclui:** Todos os relatórios acima combinados

---

## 🎮 Workflow Recomendado

### Início da Sessão
```bash
# Terminal 1: Inicia tracking
cs-start

# Terminal 2: Trabalha normalmente com Claude Code
claude "implement feature X"
```

### Durante a Sessão
- Os hooks capturam automaticamente:
  - Tempo de sessão
  - Commits realizados
  - Arquivos alterados

### Fim da Sessão
```bash
# Finaliza e mostra resumo
cs-end

# Gera relatório para daily
cs-daily

# Ou para code review
cs-review
```

---

## 📁 Estrutura de Arquivos

```
~/.claude-reports/
├── report_daily_2025-01-15_09-30-00.md
├── report_review_2025-01-15_14-00-00.md
├── report_finops_2025-01-15_18-00-00.md
└── ...

~/.claude-metrics/
├── session_20250115_093000.json
├── session_20250115_140000.json
└── ...
```

---

## ⚙️ Opções Disponíveis

| Flag | Descrição | Valores |
|------|-----------|---------|
| `-t, --type` | Tipo de relatório | `daily`, `review`, `retro`, `finops`, `full` |
| `-f, --format` | Formato de saída | `markdown`, `json`, `html` |
| `-p, --project` | Nome do projeto | Auto-detecta do git |
| `-s, --since` | Período | `today`, `yesterday`, `week`, `session` |
| `-o, --output` | Arquivo de saída | Qualquer path |
| `-c, --copy` | Copia para clipboard | Flag booleana |

---

## 🔗 Integração com Outras Ferramentas

### Linear (PM)
```bash
# Gera report e cria issue
session-report -t daily | linear issue create --stdin
```

### Notion
```bash
# Exporta para Notion via API
session-report -t full -f markdown | notion-upload
```

### Slack
```bash
# Posta no canal da daily
session-report -t daily | slack-post --channel #daily
```

### Git (commit message)
```bash
# Usa resumo como commit message
session-report -t daily | head -20 > .git/COMMIT_EDITMSG
```

---

## 🎯 Exemplos de Output

### Daily Report Preview
```markdown
# 📅 Daily Standup Report
**Data:** 15/01/2025 09:30
**Projeto:** meu-app
**Branch:** feature/login

## 🎯 O que foi feito (com Claude Code)

### Commits realizados: 5
- Último commit: `a1b2c3d - feat: implement OAuth login`

### Métricas de código
| Métrica | Valor |
|---------|-------|
| Arquivos alterados | 12 |
| Linhas adicionadas | +450 |
| Linhas removidas | -120 |
```

### FinOps Report Preview
```markdown
# 💰 FinOps Report
**Projeto:** meu-app

## 📊 Consumo da Sessão

| Tipo | Quantidade | Custo |
|------|------------|-------|
| Input | 12,500 | $0.04 |
| Output | 45,000 | $0.68 |
| **Total** | **57,500** | **$0.72** |

### ROI Estimado
- Tempo economizado: ~45 min
- Economia estimada: R$112.50
- ROI: 31x
```

---

## 🛠️ Customização

### Adicionar notas de sessão
Crie um arquivo `.claude-session-notes.md` no diretório do projeto:

```markdown
## Decisões tomadas
- Optamos por usar JWT ao invés de sessions
- Implementamos rate limiting no middleware

## Dúvidas para revisar
- Timeout do token está adequado?
- Precisamos de refresh token?
```

Este conteúdo será incluído nos relatórios automaticamente.

---

## 📝 Changelog

### v1.0.0 (2025-01)
- Release inicial
- 5 tipos de relatório
- Hooks de sessão
- Integração com git

---

*Desenvolvido para o Solo Developer Framework*
*MSS Consultoria | Marlow Santos Silva*

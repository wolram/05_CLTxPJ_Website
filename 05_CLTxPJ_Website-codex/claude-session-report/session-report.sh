#!/bin/bash
#
# 📊 CLAUDE SESSION REPORT GENERATOR
# ===================================
# Gera relatórios estruturados após sessões de Claude Code
# Para: Daily, Code Review, Sprint Review, Retro, FinOps
#
# Autor: MSS Consultoria
# Versão: 1.0.0
#

set -e

# ============================================
# CONFIGURAÇÃO
# ============================================

REPORT_DIR="${HOME}/.claude-reports"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DATE_HUMAN=$(date +"%d/%m/%Y %H:%M")
SESSION_LOG="${HOME}/.claude/logs"
OUTPUT_FORMAT="markdown"  # markdown, json, html
REPORT_TYPE="daily"       # daily, review, retro, finops, full

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================
# FUNÇÕES AUXILIARES
# ============================================

print_header() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║         📊 CLAUDE SESSION REPORT GENERATOR                   ║"
    echo "║         Solo Developer Framework v1.0                        ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

usage() {
    echo -e "${CYAN}Uso:${NC} session-report [OPTIONS]"
    echo ""
    echo -e "${YELLOW}Opções:${NC}"
    echo "  -t, --type TYPE      Tipo de relatório: daily|review|retro|finops|full"
    echo "  -f, --format FORMAT  Formato de saída: markdown|json|html"
    echo "  -p, --project NAME   Nome do projeto (auto-detecta do git)"
    echo "  -s, --since TIME     Período: today|yesterday|week|session"
    echo "  -o, --output FILE    Arquivo de saída (default: stdout + arquivo)"
    echo "  -c, --copy           Copia para clipboard"
    echo "  -h, --help           Mostra esta ajuda"
    echo ""
    echo -e "${YELLOW}Exemplos:${NC}"
    echo "  session-report -t daily -c              # Daily standup, copia pro clipboard"
    echo "  session-report -t review -f markdown    # Code review em markdown"
    echo "  session-report -t finops -s week        # FinOps da semana"
    echo "  session-report -t full -o report.md     # Relatório completo"
}

# ============================================
# COLETA DE DADOS
# ============================================

get_git_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        PROJECT_NAME=$(basename "$(git rev-parse --show-toplevel)")
        BRANCH=$(git branch --show-current)
        LAST_COMMIT=$(git log -1 --pretty=format:"%h - %s" 2>/dev/null || echo "N/A")
        COMMITS_TODAY=$(git log --since="midnight" --oneline 2>/dev/null | wc -l | tr -d ' ')
        FILES_CHANGED=$(git diff --name-only HEAD~${COMMITS_TODAY:-1} 2>/dev/null | wc -l | tr -d ' ')
        LINES_ADDED=$(git diff --stat HEAD~${COMMITS_TODAY:-1} 2>/dev/null | tail -1 | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+' || echo "0")
        LINES_REMOVED=$(git diff --stat HEAD~${COMMITS_TODAY:-1} 2>/dev/null | tail -1 | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+' || echo "0")
    else
        PROJECT_NAME="N/A"
        BRANCH="N/A"
        LAST_COMMIT="N/A"
        COMMITS_TODAY="0"
        FILES_CHANGED="0"
        LINES_ADDED="0"
        LINES_REMOVED="0"
    fi
}

get_claude_metrics() {
    # Simula métricas do Claude Code (adaptar conforme logs reais)
    # Em produção, parsear ~/.claude/logs ou usar API
    
    PROMPTS_COUNT="${PROMPTS_COUNT:-15}"
    TOKENS_INPUT="${TOKENS_INPUT:-12500}"
    TOKENS_OUTPUT="${TOKENS_OUTPUT:-45000}"
    TOKENS_TOTAL=$((TOKENS_INPUT + TOKENS_OUTPUT))
    
    # Custo estimado (Claude Sonnet 4 pricing)
    # Input: $3/1M tokens, Output: $15/1M tokens
    COST_INPUT=$(echo "scale=4; $TOKENS_INPUT * 0.000003" | bc)
    COST_OUTPUT=$(echo "scale=4; $TOKENS_OUTPUT * 0.000015" | bc)
    COST_TOTAL=$(echo "scale=2; $COST_INPUT + $COST_OUTPUT" | bc)
    
    SESSION_DURATION="${SESSION_DURATION:-45}"
    TOOLS_USED="${TOOLS_USED:-bash, edit, write, read}"
}

get_session_summary() {
    # Aqui você pode integrar com o histórico real do Claude
    # Por enquanto, captura do git e contexto
    
    if [ -f ".claude-session-notes.md" ]; then
        SESSION_NOTES=$(cat .claude-session-notes.md)
    else
        SESSION_NOTES="Sem notas de sessão capturadas."
    fi
}

# ============================================
# GERADORES DE RELATÓRIO
# ============================================

generate_daily_report() {
    cat << EOF
# 📅 Daily Standup Report
**Data:** ${DATE_HUMAN}
**Projeto:** ${PROJECT_NAME}
**Branch:** ${BRANCH}

## 🎯 O que foi feito (com Claude Code)

### Commits realizados: ${COMMITS_TODAY}
- Último commit: \`${LAST_COMMIT}\`

### Métricas de código
| Métrica | Valor |
|---------|-------|
| Arquivos alterados | ${FILES_CHANGED} |
| Linhas adicionadas | +${LINES_ADDED} |
| Linhas removidas | -${LINES_REMOVED} |

### Sessão Claude Code
| Métrica | Valor |
|---------|-------|
| Prompts enviados | ${PROMPTS_COUNT} |
| Duração da sessão | ~${SESSION_DURATION} min |
| Tokens consumidos | ${TOKENS_TOTAL} |

## 🚧 Bloqueios
- [ ] Nenhum bloqueio identificado

## 📋 Próximos passos
- [ ] Continuar implementação
- [ ] Code review pendente
- [ ] Testes a adicionar

---
*Gerado automaticamente pelo Solo Developer Framework*
EOF
}

generate_review_report() {
    cat << EOF
# 🔍 Code Review Report
**Data:** ${DATE_HUMAN}
**Projeto:** ${PROJECT_NAME}
**Branch:** ${BRANCH}
**Reviewer:** Claude Code + Developer

## 📝 Resumo das Alterações

### Escopo
- **Arquivos modificados:** ${FILES_CHANGED}
- **Linhas adicionadas:** +${LINES_ADDED}
- **Linhas removidas:** -${LINES_REMOVED}

### Commits inclusos
\`\`\`
$(git log --since="midnight" --oneline 2>/dev/null || echo "Nenhum commit hoje")
\`\`\`

### Arquivos alterados
\`\`\`
$(git diff --name-only HEAD~${COMMITS_TODAY:-1} 2>/dev/null || echo "Nenhum arquivo")
\`\`\`

## 🤖 Decisões tomadas com IA

### Padrões aplicados
- [ ] SOLID principles
- [ ] Clean Code
- [ ] Error handling
- [ ] Logging adequado

### Trade-offs discutidos
1. **Performance vs Legibilidade:** [Descrever decisão]
2. **Complexidade vs Simplicidade:** [Descrever decisão]

## ⚠️ Pontos de atenção
- [ ] Cobertura de testes
- [ ] Edge cases
- [ ] Security considerations

## 💰 FinOps da Review
| Recurso | Consumo | Custo |
|---------|---------|-------|
| Tokens Input | ${TOKENS_INPUT} | \$${COST_INPUT} |
| Tokens Output | ${TOKENS_OUTPUT} | \$${COST_OUTPUT} |
| **Total** | ${TOKENS_TOTAL} | **\$${COST_TOTAL}** |

---
*Gerado automaticamente pelo Solo Developer Framework*
EOF
}

generate_retro_report() {
    cat << EOF
# 🔄 Sprint Retrospective Report
**Data:** ${DATE_HUMAN}
**Projeto:** ${PROJECT_NAME}
**Período:** Sprint atual

## 😊 O que funcionou bem

### Uso do Claude Code
- Aceleração do desenvolvimento com pair programming IA
- Geração de boilerplate e testes
- Debugging assistido

### Métricas positivas
| Métrica | Valor |
|---------|-------|
| Commits | ${COMMITS_TODAY} |
| Código novo | +${LINES_ADDED} linhas |
| Refatoração | -${LINES_REMOVED} linhas |

## 😕 O que pode melhorar

### Fluxo de trabalho
- [ ] Prompts mais específicos
- [ ] Melhor contexto inicial
- [ ] Documentação inline

### Custos
- Tokens consumidos: ${TOKENS_TOTAL}
- Custo estimado: \$${COST_TOTAL}
- [ ] Otimizar prompts para reduzir tokens

## 🎯 Ações para próxima sprint

### Processo
1. [ ] Criar templates de prompts
2. [ ] Documentar decisões de arquitetura
3. [ ] Automatizar relatórios

### Técnico
1. [ ] Aumentar cobertura de testes
2. [ ] Refatorar código legado
3. [ ] Melhorar CI/CD

## 📊 FinOps Summary
| Período | Tokens | Custo | ROI Estimado |
|---------|--------|-------|--------------|
| Esta sessão | ${TOKENS_TOTAL} | \$${COST_TOTAL} | ~${SESSION_DURATION} min economizados |
| Estimativa mensal | ~500k | ~\$10-15 | ~20h economizadas |

---
*Gerado automaticamente pelo Solo Developer Framework*
EOF
}

generate_finops_report() {
    cat << EOF
# 💰 FinOps Report - Claude Code Usage
**Data:** ${DATE_HUMAN}
**Projeto:** ${PROJECT_NAME}

## 📊 Consumo da Sessão

### Tokens
| Tipo | Quantidade | Custo/1M | Subtotal |
|------|------------|----------|----------|
| Input | ${TOKENS_INPUT} | \$3.00 | \$${COST_INPUT} |
| Output | ${TOKENS_OUTPUT} | \$15.00 | \$${COST_OUTPUT} |
| **Total** | **${TOKENS_TOTAL}** | - | **\$${COST_TOTAL}** |

### Ferramentas Utilizadas
- ${TOOLS_USED}

### Duração
- Tempo de sessão: ~${SESSION_DURATION} minutos
- Prompts enviados: ${PROMPTS_COUNT}
- Média tokens/prompt: $((TOKENS_TOTAL / PROMPTS_COUNT))

## 📈 Projeções

### Custo Mensal Estimado
| Cenário | Sessões/dia | Custo/dia | Custo/mês |
|---------|-------------|-----------|-----------|
| Leve | 2 | \$$(echo "scale=2; $COST_TOTAL * 2" | bc) | \$$(echo "scale=2; $COST_TOTAL * 2 * 22" | bc) |
| Médio | 4 | \$$(echo "scale=2; $COST_TOTAL * 4" | bc) | \$$(echo "scale=2; $COST_TOTAL * 4 * 22" | bc) |
| Intenso | 8 | \$$(echo "scale=2; $COST_TOTAL * 8" | bc) | \$$(echo "scale=2; $COST_TOTAL * 8 * 22" | bc) |

### ROI Estimado
| Métrica | Valor |
|---------|-------|
| Tempo economizado | ~${SESSION_DURATION} min |
| Custo hora dev (BR) | ~R\$150/h |
| Economia estimada | R\$$(echo "scale=2; $SESSION_DURATION * 2.5" | bc) |
| ROI | $(echo "scale=0; ($SESSION_DURATION * 2.5) / ($COST_TOTAL * 5)" | bc)x |

## 🎯 Otimizações Sugeridas

### Redução de custos
1. **Prompts mais concisos:** Reduzir contexto desnecessário
2. **Reutilizar respostas:** Cache local de snippets comuns
3. **Batch operations:** Agrupar tarefas relacionadas

### Monitoramento
- [ ] Configurar alertas de custo diário
- [ ] Dashboard de consumo semanal
- [ ] Comparativo mensal

---
*Gerado automaticamente pelo Solo Developer Framework*
EOF
}

generate_full_report() {
    cat << EOF
# 📋 RELATÓRIO COMPLETO DE SESSÃO
## Solo Developer Framework - Session Report

**Data:** ${DATE_HUMAN}
**Projeto:** ${PROJECT_NAME}
**Branch:** ${BRANCH}

---

$(generate_daily_report)

---

$(generate_review_report)

---

$(generate_finops_report)

---

## 📎 Anexos

### Git Log Completo
\`\`\`
$(git log --since="midnight" --pretty=format:"%h %ad | %s [%an]" --date=short 2>/dev/null || echo "N/A")
\`\`\`

### Diff Summary
\`\`\`
$(git diff --stat HEAD~${COMMITS_TODAY:-1} 2>/dev/null || echo "N/A")
\`\`\`

---
*Solo Developer Framework v1.0 | MSS Consultoria*
*Gerado em: ${DATE_HUMAN}*
EOF
}

# ============================================
# MAIN
# ============================================

main() {
    print_header
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--type)
                REPORT_TYPE="$2"
                shift 2
                ;;
            -f|--format)
                OUTPUT_FORMAT="$2"
                shift 2
                ;;
            -p|--project)
                PROJECT_NAME="$2"
                shift 2
                ;;
            -s|--since)
                SINCE="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            -c|--copy)
                COPY_CLIPBOARD=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo -e "${RED}Opção desconhecida: $1${NC}"
                usage
                exit 1
                ;;
        esac
    done
    
    # Coleta dados
    echo -e "${CYAN}📥 Coletando dados...${NC}"
    get_git_info
    get_claude_metrics
    get_session_summary
    
    # Gera relatório
    echo -e "${CYAN}📝 Gerando relatório tipo: ${YELLOW}${REPORT_TYPE}${NC}"
    
    case $REPORT_TYPE in
        daily)
            REPORT=$(generate_daily_report)
            ;;
        review)
            REPORT=$(generate_review_report)
            ;;
        retro)
            REPORT=$(generate_retro_report)
            ;;
        finops)
            REPORT=$(generate_finops_report)
            ;;
        full)
            REPORT=$(generate_full_report)
            ;;
        *)
            echo -e "${RED}Tipo de relatório inválido: ${REPORT_TYPE}${NC}"
            exit 1
            ;;
    esac
    
    # Cria diretório de reports
    mkdir -p "$REPORT_DIR"
    
    # Salva arquivo
    if [ -z "$OUTPUT_FILE" ]; then
        OUTPUT_FILE="${REPORT_DIR}/report_${REPORT_TYPE}_${TIMESTAMP}.md"
    fi
    
    echo "$REPORT" > "$OUTPUT_FILE"
    echo -e "${GREEN}✅ Relatório salvo em: ${OUTPUT_FILE}${NC}"
    
    # Copia para clipboard
    if [ "$COPY_CLIPBOARD" = true ]; then
        if command -v pbcopy &> /dev/null; then
            echo "$REPORT" | pbcopy
            echo -e "${GREEN}📋 Copiado para o clipboard!${NC}"
        elif command -v xclip &> /dev/null; then
            echo "$REPORT" | xclip -selection clipboard
            echo -e "${GREEN}📋 Copiado para o clipboard!${NC}"
        fi
    fi
    
    # Mostra preview
    echo ""
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}PREVIEW:${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo "$REPORT" | head -40
    echo ""
    echo -e "${CYAN}... (truncado, arquivo completo em ${OUTPUT_FILE})${NC}"
}

main "$@"

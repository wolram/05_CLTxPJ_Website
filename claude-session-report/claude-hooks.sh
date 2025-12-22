#!/bin/bash
#
# 🪝 CLAUDE SESSION HOOK
# =======================
# Auto-captura métricas ao final de sessões Claude Code
# Adicione ao seu .zshrc ou .bashrc
#

CLAUDE_METRICS_DIR="${HOME}/.claude-metrics"
mkdir -p "$CLAUDE_METRICS_DIR"

# ============================================
# FUNÇÃO: Iniciar tracking de sessão
# ============================================
claude_session_start() {
    export CLAUDE_SESSION_START=$(date +%s)
    export CLAUDE_SESSION_ID=$(date +"%Y%m%d_%H%M%S")
    export CLAUDE_PROMPTS_COUNT=0
    
    echo "🚀 Sessão Claude iniciada: $CLAUDE_SESSION_ID"
    
    # Log inicial
    cat > "${CLAUDE_METRICS_DIR}/session_${CLAUDE_SESSION_ID}.json" << EOF
{
  "session_id": "$CLAUDE_SESSION_ID",
  "start_time": "$(date -Iseconds)",
  "project": "$(basename $(pwd))",
  "branch": "$(git branch --show-current 2>/dev/null || echo 'N/A')",
  "prompts": [],
  "metrics": {}
}
EOF
}

# ============================================
# FUNÇÃO: Registrar prompt (wrapper)
# ============================================
claude_log_prompt() {
    if [ -n "$CLAUDE_SESSION_ID" ]; then
        CLAUDE_PROMPTS_COUNT=$((CLAUDE_PROMPTS_COUNT + 1))
        
        # Append to session log
        local timestamp=$(date -Iseconds)
        local prompt_preview="${1:0:100}..."
        
        # Update JSON (simplificado - em produção usar jq)
        echo "  📝 Prompt #${CLAUDE_PROMPTS_COUNT} registrado"
    fi
}

# ============================================
# FUNÇÃO: Finalizar sessão
# ============================================
claude_session_end() {
    if [ -z "$CLAUDE_SESSION_ID" ]; then
        echo "⚠️  Nenhuma sessão ativa"
        return 1
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - CLAUDE_SESSION_START))
    local duration_min=$((duration / 60))
    
    # Git metrics
    local commits=$(git log --since="@${CLAUDE_SESSION_START}" --oneline 2>/dev/null | wc -l | tr -d ' ')
    local files_changed=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
    
    # Atualiza arquivo de métricas
    cat >> "${CLAUDE_METRICS_DIR}/session_${CLAUDE_SESSION_ID}.json" << EOF

--- SESSION END ---
End Time: $(date -Iseconds)
Duration: ${duration_min} minutes
Prompts: ${CLAUDE_PROMPTS_COUNT}
Commits: ${commits}
Files Changed: ${files_changed}
EOF

    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║           📊 SESSÃO CLAUDE FINALIZADA                    ║"
    echo "╠══════════════════════════════════════════════════════════╣"
    echo "║  Session ID:    $CLAUDE_SESSION_ID"
    echo "║  Duração:       ${duration_min} minutos"
    echo "║  Prompts:       ${CLAUDE_PROMPTS_COUNT}"
    echo "║  Commits:       ${commits}"
    echo "║  Arquivos:      ${files_changed}"
    echo "╠══════════════════════════════════════════════════════════╣"
    echo "║  📄 Gerar relatório: session-report -t daily -c          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    
    # Limpa variáveis
    unset CLAUDE_SESSION_START
    unset CLAUDE_SESSION_ID
    unset CLAUDE_PROMPTS_COUNT
}

# ============================================
# ALIASES ÚTEIS
# ============================================
alias cs-start="claude_session_start"
alias cs-end="claude_session_end"
alias cs-report="session-report"
alias cs-daily="session-report -t daily -c"
alias cs-review="session-report -t review -c"
alias cs-finops="session-report -t finops"

# ============================================
# AUTO-HOOK (opcional)
# ============================================
# Descomentar para auto-iniciar sessão ao abrir terminal em repo git
#
# if git rev-parse --git-dir > /dev/null 2>&1; then
#     claude_session_start
# fi

echo "🪝 Claude Session Hooks carregados. Use: cs-start, cs-end, cs-report"

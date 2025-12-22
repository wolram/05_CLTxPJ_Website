// CONFIGURAÇÃO
const CONFIG = {
    apiKey: "", // Deixe vazio para usar o Mock Mode
    apiUrl: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent",
    mockMode: true // Ativa resposta simulada se não houver API Key
};

// --- UTILS ---

function formatMoney(value) {
    return value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
}

function parseCurrency(value) {
    // Remove tudo que não é dígito, divide por 100 para centavos
    return Number(value.replace(/\D/g, "")) / 100;
}

function formatCurrencyInput(value) {
    // Formata o número cru para visualização BRL
    const number = value.replace(/\D/g, "") / 100;
    return number.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
}

// --- CORE LOGIC ---

function calculate() {
    // Busca valores crus dos inputs
    const cltInput = document.getElementById('input-clt');
    const pjInput = document.getElementById('input-pj');
    
    // Obtém valores numéricos limpos (data-value ou parse direto se não tiver máscara ainda)
    // Se estivermos usando máscara, o value visual é "R$ 6.000,00", então precisamos limpar
    const cltVal = parseCurrency(cltInput.value) || 0;
    const pjVal = parseCurrency(pjInput.value) || 0;

    // Simulação Simplificada
    // CLT: (Salário * 13.33 meses) - ~18% descontos médios (INSS+IR) simplificado
    const cltTotal = (cltVal * 13.33) * 0.82; 
    
    // PJ: (Faturamento * 12) - ~10% impostos (Simples Nacional Anexo III/V médio)
    const pjTotal = (pjVal * 12) * 0.90;

    // Atualiza DOM
    const resClt = document.getElementById('res-clt');
    const resPj = document.getElementById('res-pj');
    const verdict = document.getElementById('verdict');
    const barClt = document.getElementById('bar-clt');
    const barPj = document.getElementById('bar-pj');

    resClt.innerText = formatMoney(cltTotal);
    resPj.innerText = formatMoney(pjTotal);

    // Animação das barras
    const max = Math.max(cltTotal, pjTotal) * 1.1 || 1; // Evita divisão por zero
    const cltPercent = (cltTotal / max) * 100;
    const pjPercent = (pjTotal / max) * 100;

    barClt.style.width = `${cltPercent}%`;
    barPj.style.width = `${pjPercent}%`;

    if (pjTotal > cltTotal) {
        const diff = pjTotal - cltTotal;
        verdict.innerHTML = `CNPJ rende aprox. <span class="text-green-600 font-bold">+${formatMoney(diff)}</span> por ano`;
        resPj.className = "font-bold text-green-600 text-lg";
        barPj.className = "bg-green-600 h-2 rounded-full transition-all duration-500";
    } else {
        const diff = cltTotal - pjTotal;
        verdict.innerHTML = `CLT rende aprox. <span class="text-blue-600 font-bold">+${formatMoney(diff)}</span> por ano`;
        resPj.className = "font-bold text-blue-600 text-lg";
        barPj.className = "bg-blue-600 h-2 rounded-full transition-all duration-500";
    }
}

// --- EVENT HANDLERS ---

function setupInputs() {
    const inputs = ['input-clt', 'input-pj'];
    
    inputs.forEach(id => {
        const el = document.getElementById(id);
        
        // Inicializa com formatação
        // O valor inicial no HTML é numérico puro (ex: 6000). Vamos formatar ao carregar.
        if(el.value && !el.value.includes('R$')) {
            el.value = (parseFloat(el.value)).toLocaleString('pt-BR', { minimumFractionDigits: 2, style: 'currency', currency: 'BRL' });
        }

        el.addEventListener('input', (e) => {
            let value = e.target.value;
            
            // Garante que o cursor não pule loucamente (básico)
            if (value === '') value = '0';
            
            // Aplica máscara
            e.target.value = formatCurrencyInput(value);
            
            // Recalcula
            calculate();
        });
    });
}

function handleAndroidClick() {
    alert("📢 Lista de Espera\n\nEstamos finalizando a versão Android! Cadastramos seu interesse (simulado).");
}

// --- AI LOGIC ---

async function fetchWithExponentialBackoff(url, options, maxRetries = 3) {
    for (let i = 0; i < maxRetries; i++) {
        try {
            const response = await fetch(url, options);
            if (response.ok) return response;
            if (response.status === 429 && i < maxRetries - 1) {
                const delay = Math.pow(2, i) * 1000 + Math.random() * 1000;
                await new Promise(resolve => setTimeout(resolve, delay));
                continue;
            }
            throw new Error(`API Error: ${response.status} ${response.statusText}`);
        } catch (error) {
            if (i === maxRetries - 1) throw error;
            await new Promise(resolve => setTimeout(resolve, 1000));
        }
    }
}

async function handleAnalysisClick() {
    const btn = document.getElementById('btn-ia');
    const resultDiv = document.getElementById('ia-result');
    const cltInput = document.getElementById('input-clt');
    const pjInput = document.getElementById('input-pj');

    // Estado de loading
    const originalText = btn.innerHTML;
    btn.innerHTML = '<div class="loader mr-2" style="border-top-color: white; width: 16px; height: 16px; display: inline-block;"></div> Analisando...';
    btn.disabled = true;
    resultDiv.classList.add('hidden');

    try {
        let analysisText = "";

        if (!CONFIG.apiKey) {
            if (CONFIG.mockMode) {
                // Simulação de delay de rede
                await new Promise(resolve => setTimeout(resolve, 1500));
                
                const cltVal = parseCurrency(cltInput.value);
                const pjVal = parseCurrency(pjInput.value);
                const diff = pjVal - cltVal;
                
                if (diff > 0) {
                    analysisText = "💡 <strong>Análise Preliminar (Modo Demo):</strong><br>Financeiramente o CNPJ parece mais atrativo neste cenário. Recomenda-se criar uma reserva de emergência de 6 meses, já que você não terá FGTS/Seguro Desemprego. Ideal para perfis mais arrojados.";
                } else {
                    analysisText = "🛡️ <strong>Análise Preliminar (Modo Demo):</strong><br>A proposta CLT oferece maior segurança e benefícios indiretos que superam o valor numérico atual do PJ. Mantenha-se na CLT a menos que o PJ ofereça pelo menos 40% de aumento.";
                }
                analysisText += "<br><br><em class='text-xs text-gray-400'>(Nota: Adicione uma API Key para análise real com IA)</em>";
            } else {
                throw new Error("Chave de API não configurada.");
            }
        } else {
            // Chamada Real
            const systemPrompt = "Você é um consultor financeiro. Compare CLT vs PJ baseado nos valores, focando em segurança vs liquidez. Resposta curta (max 30 palavras).";
            const userQuery = `CLT: ${cltInput.value}. PJ: ${pjInput.value}.`;

            const payload = {
                contents: [{ parts: [{ text: userQuery }] }],
                systemInstruction: { parts: [{ text: systemPrompt }] },
            };

            const response = await fetchWithExponentialBackoff(`${CONFIG.apiUrl}?key=${CONFIG.apiKey}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });
            const result = await response.json();
            analysisText = result.candidates?.[0]?.content?.parts?.[0]?.text || "Erro na geração.";
        }
        
        resultDiv.innerHTML = analysisText;
        resultDiv.classList.remove('hidden');

    } catch (error) {
        console.error(error);
        resultDiv.innerHTML = `<span class="text-red-600">Erro: ${error.message}</span>`;
        resultDiv.classList.remove('hidden');
    } finally {
        btn.innerHTML = originalText;
        btn.disabled = false;
    }
}

// Inicialização
document.addEventListener('DOMContentLoaded', () => {
    setupInputs();
    calculate(); // Calculo inicial
    
    // Configura botão android
    const androidBtn = document.querySelector('button disabled') || document.querySelectorAll('button')[1]; // Fallback selector
    if(androidBtn) {
         // Remove disabled para permitir clique com aviso
         androidBtn.removeAttribute('disabled');
         androidBtn.classList.remove('cursor-not-allowed', 'opacity-60', 'grayscale');
         androidBtn.classList.add('hover:bg-gray-200');
         androidBtn.onclick = handleAndroidClick;
    }
});

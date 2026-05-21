# wish_final_project
**Entregável Final — Projeto Final Data Analyst Junior**
**Bytes4Future Bootcamp**
**Grupo:** Letícia · Ricardo · Gustavo
**Data:** 21 de maio de 2026
---
## Questão de Negócio
> *"Analisar os padrões de consumo na plataforma Wish que geram impacto
> ambiental negativo e definir métricas sustentáveis capazes de orientar
> práticas mais ecológicas sem comprometer o lucro."*
---
## Estrutura de Pastas (real)
wish_final_project/
│
├── 00_docs/                        # Documentação externa obrigatória
│   ├── business_goal.md            # Objetivo de negócio — 5W2H + SMART
│   ├── variables_definition.md     # Definição e classificação de 43 variáveis
│   ├── data_treatment_log.md       # Log de tratamento — 10 decisões
│   ├── analysis_subquestions.md    # 7+2 subquestões com hipóteses
│   └── perguntas.md                # Tabela mestra: 9 perguntas × colunas × métricas
│
├── 01_data/                        # Dados brutos, processados e documentação
│   ├── processed/                  # Output da limpeza
│   │   ├── 01_cleaning.ipynb       # Notebook de limpeza
│   │   ├── power-m.m               # Fórmulas Power Query (M)
│   │   └── tags.csv                # Tags de categoria
│   ├── checklist_metricas_formulas.md  # Catálogo M001–M149
│   ├── guiao_power_query.md        # 14 passos da limpeza no Power Query
│   ├── lembretes_ETL.md            # Notas de apoio ao ETL
│   ├── observacoes_externas.md     # 24 códigos RFIX do criador do Kaggle
│   └── types.md                    # Tipos de dados e conversões
│
├── 02_validation/                  # Notebooks de validação
│   ├── Limpeza.ipynb               # Carrega limpos_final.xlsm, valida tipos e nulos
│   └── Notebook 1.ipynb            # Primeira vista aos dados brutos
│
├── 03_analysis/python/             # Análise por subquestão (notebooks)
│   ├── Pergunta_1.ipynb            # SQ1: distância × frete
│   ├── Pergunta2.ipynb            # SQ2: preço × qualidade
│   ├── Pergunta4.ipynb            # SQ4: resíduos têxteis
│   ├── Pergunta5.ipynb            # SQ5: prémio de qualidade
│   ├── Pergunta_badge.ipynb        # SQ6: badges e urgência
│   ├── Pergunta_co2.ipynb          # SQ3: CO₂ por transporte
│   ├── Pergunta_inconsistencias.ipynb  # Validação cruzada
│   └── INSIGHTS.ipynb              # Insights consolidados
│
├── 04_results/                     # Outputs gerados pela análise
│   ├── charts/                     # 24 gráficos (output-0.png a output-23.png)
│   └── key_findings.md             # 5–6 conclusões principais
│
└── 05_presentation/                # Apresentação final
    ├── slides/
    │   └── wish_sustainability2020.pdf   # PDF final da apresentação
    ├── assets/                     # Script, esboço, notas, HTML
    └── gifs/
        └── ban.gif                 # GIF de apoio visual
---
## Documentação — 00_docs/
Cada documento tem contribuição dos três membros do grupo.
| Ficheiro | Conteúdo | Lidera |
|---|---|---|
| `business_goal.md` | Objetivo de negócio, 5W2H, SMART, contexto ESG e pandemia | Ricardo |
| `variables_definition.md` | 43 colunas classificadas, estatísticas, colunas Fix | Gustavo |
| `data_treatment_log.md` | 10 decisões de tratamento — o quê, como, porquê | Gustavo |
| `analysis_subquestions.md` | 7+2 subquestões com hipóteses e visualizações | Ricardo + Gustavo |
| `perguntas.md` | Tabela mestra: 9 perguntas × colunas × 149 métricas | Gustavo |
---
## Subquestões — Resumo
| # | Pergunta | Notebook |
|---|---|---|
| SQ1 | Distância de origem × frete pago — o custo ambiental está no preço? | `Pergunta_1.ipynb` |
| SQ2 | Preço baixo × avaliações — o barato é descartável? | `Pergunta_2.ipynb` |
| SQ3 | Emissões de CO₂ por modo de transporte | `Pergunta_co2.ipynb` |
| SQ4 | Estimativa de resíduos têxteis gerados | `Pergunta_4.ipynb` |
| SQ5 | O consumidor paga mais por qualidade certificada? | `Pergunta_5.ipynb` |
| SQ6 | Ad boosts e urgency banners distorcem a qualidade? | `Pergunta_badge.ipynb` |
| SQ7 | Inconsistências cruzadas nos dados | `Pergunta_inconsistencias.ipynb` |
| — | Insights consolidados | `INSIGHTS.ipynb` |
---
## Stack
| Ferramenta | Uso |
|---|---|
| `Python` | Limpeza, colunas calculadas, EDA, visualizações |
| `Excel` | Dataset limpo (`limpos_final.xlsm`), validações |
---
## Responsabilidades por Fase
| Fase | Gustavo | Ricardo | Letícia |
|---|---|---|---|
| Objetivo de negócio | Colunas que sustentam | Formula a questão | Define público e tom visual |
| Variáveis | Classifica e valida | Justifica relevância | Identifica o que visualizar |
| Tratamento de dados | Executa e documenta | Redige o porquê | Sinaliza achados visuais |
| Análise | Escreve o código | Documenta os resultados | Planeia cada slide |
| Apresentação | Valida cada número | Escreve o guião | Design e narrativa visual |
---
## Contexto
**Dataset:** agosto de 2020 — plena pandemia COVID-19, anterior à regulação
europeia de têxteis sustentáveis (2022). Funciona como baseline histórico:
o comportamento de consumo fast fashion antes da mudança regulatória.
**Mercado inferido:** Europa Ocidental / interface francesa do Wish
(`currency_buyer` = EUR 100%, `shipping_option_name` = "Livraison standard" 96%)
**Limitação principal:** `countries_shipped_to` é uma contagem, não uma lista
de países. Destino exato desconhecido — tratado como proxy de alcance global.
---
# wish_final_project

**Entregável Final — Projeto Final Data Analyst Junior**
**Bytes4Future Bootcamp**
**Grupo:** Letícia · Ricardo · Gustavo
**Data:** 16 de maio de 2025

---

## Questão de Negócio

> *"Analisar os padrões de consumo na plataforma Wish que geram impacto
> ambiental negativo e definir métricas sustentáveis capazes de orientar
> práticas mais ecológicas sem comprometer o lucro."*

---

## Estrutura de Pastas

```
wish_final_project/
│
├── 00_docs/                        # Documentação externa obrigatória
│   ├── business_goal.md            # Objetivo de negócio — 5W2H + SMART
│   ├── variables_definition.md     # Definição e classificação de variáveis
│   ├── data_treatment_log.md       # Log de tratamento de anomalias
│   └── analysis_subquestions.md    # Subquestões analíticas detalhadas
│
├── 01_data/
│   ├── raw/                        # Dataset original — NUNCA EDITAR
│   │   └── Summer_Products.csv
│   └── processed/                  # Dataset limpo com colunas Fix
│       └── summer_products_clean.csv
│
├── 02_validation/                  # Testes e controlos de qualidade
│   ├── validation_report.md        # Relatório: nulos, extremos, incorretos
│   └── checks.sql                  # Queries de controlo e validação
│
├── 03_analysis/                    # Código de análise por ferramenta
│   ├── sql/
│   │   ├── 01_subquestion_1.sql
│   │   ├── 02_subquestion_2.sql
│   │   └── 03_subquestion_3.sql
│   ├── excel/
│   ├── powerbi/
│   └── python/
│       ├── 01_cleaning.ipynb       # Limpeza e colunas Fix
│       ├── 02_eda.ipynb            # Análise exploratória
│       └── 03_visualization.ipynb  # Visualizações para apresentação
│
├── 04_results/                     # Outputs gerados pela análise
│   ├── charts/                     # Gráficos exportados
│   ├── dashboard_screenshots/      # Prints do Power BI
│   └── key_findings.md             # 5–6 conclusões principais
│
└── 05_presentation/                # Apresentação final
    ├── slides/
    │   └── final_presentation.pptx
    ├── assets/                     # Imagens, paleta, ícones
    └── script.md                   # Guião dos 15 minutos
```

---

## Documentação — 00_docs/

Cada documento tem contribuição dos três membros do grupo.

| Ficheiro | Conteúdo | Lidera |
|---|---|---|
| `business_goal.md` | Objetivo de negócio, 5W2H, SMART, cliente, contexto ESG e pandemia | Ricardo |
| `variables_definition.md` | 43 colunas classificadas, estatísticas, colunas Fix e externas | Gustavo |
| `data_treatment_log.md` | 10 decisões de tratamento — o quê, como, porquê e porquê não outra abordagem | Gustavo |
| `analysis_subquestions.md` | 7 subquestões com dados, hipóteses e visualizações sugeridas + 2 externas | Ricardo + Gustavo |

---

## Regras do Projeto

```
01_data/raw/       →  INTOCÁVEL. Nunca editar o ficheiro original.
ColNameFix         →  Toda a correção vive numa coluna nova. Original preservado.
data_treatment_log →  Toda a decisão é documentada com alternativas rejeitadas.
```

---

## Colunas Calculadas — Resumo

| Coluna | Origem | Descrição |
|---|---|---|
| `discount_pct_fix` | Interna | Desconto real — negativos → 0 |
| `units_sold_tier` | Interna | Volume de vendas em 5 níveis ordinais |
| `has_urgency_banner_fix` | Interna | Banner urgência — NaN → 0 |
| `product_color_fix` | Interna | Cor — NaN → "unknown" |
| `origin_country_fix` | Interna | País origem — NaN → "unknown" |
| `negative_rating_pct` | Interna | % avaliações 1★ e 2★ |
| `total_badges` | Interna | Soma dos 3 badges |
| `distance_km` | Externa | Distância país origem → Paris |
| `estimated_weight_g` | Externa | Peso médio por peça têxtil |
| `estimated_textile_kg` | Calculada | `units_sold × estimated_weight_g / 1000` |

---

## Subquestões — Resumo

| # | Pergunta | Tipo |
|---|---|---|
| SQ1 | Distância de origem × frete pago — o custo ambiental está no preço? | Dados |
| SQ2 | Preço baixo × avaliações — o barato é descartável? | Dados |
| SQ3 | Stock × vendas — existe desperdício de produção? | Dados |
| SQ4 | Estimativa de resíduos têxteis gerados | Dados + Externa |
| SQ5 | O consumidor paga mais por qualidade certificada? | Dados |
| SQ6 | Ad boosts e urgency banners distorcem a qualidade? | Dados |
| SQ7 | Alcance de envio × volume — mais países = mais vendas? | Dados |
| SQ-EXT1 | Porque é que os europeus não pagam mais pelo ambiente? | Externa |
| SQ-EXT2 | Que leis europeias regulam este comportamento? | Externa |

---

## Stack

| Ferramenta | Uso |
|---|---|
| `Python` | Limpeza, colunas calculadas, EDA, visualizações |
| `SQL` | Validação, segmentação, agregações |
| `Power BI` | Dashboard interativo para apresentação |
| `Excel` | Validações pontuais |

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
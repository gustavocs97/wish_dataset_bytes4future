# 03_analysis — Análise
Todo o código produzido para responder às subquestões.
Organizado por pergunta, em Python (Jupyter notebooks).
---
## Estrutura
03_analysis/
└── python/
    ├── Pergunta1.ipynb             # SQ1: distância × frete
    ├── Pergunta2.ipynb             # SQ2: preço × qualidade
    ├── Pergunta4.ipynb             # SQ4: resíduos têxteis
    ├── Pergunta5.ipynb             # SQ5: prémio de qualidade
    ├── Pergunta_badge.ipynb         # SQ6: badges e urgência
    ├── Pergunta_co2.ipynb           # SQ3: CO₂ por transporte
    ├── Pergunta_inconsistencias.ipynb  # Validação cruzada (SQ7)
    └── INSIGHTS.ipynb               # Insights consolidados
---
## Subquestões vs. Notebooks
| Pergunta | Subquestão | Notebook |
|---|---|---|
| O custo ambiental está no preço? | SQ1 | `Pergunta_1.ipynb` |
| O barato é descartável? | SQ2 | `Pergunta_2.ipynb` |
| Emissões de CO₂ por transporte | SQ3 | `Pergunta_co2.ipynb` |
| Resíduos têxteis gerados | SQ4 | `Pergunta_4.ipynb` |
| O consumidor paga mais por qualidade? | SQ5 | `Pergunta_5.ipynb` |
| Badges e banners de urgência | SQ6 | `Pergunta_badge.ipynb` |
| Inconsistências nos dados | SQ7 | `Pergunta_inconsistencias.ipynb` |
| Visão geral | — | `INSIGHTS.ipynb` |
---
## Regras
- Cada notebook começa com o objetivo da subquestão que responde
- Resultados exportados vão para `04_results/charts/`
- Dataset de entrada: `../../Datasets/limpos_final_csv.csv`
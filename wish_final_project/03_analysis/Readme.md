# 03_analysis — Código de Análise

Todo o código produzido para responder às subquestões.
Organizado por ferramenta.

---

## Estrutura

```
03_analysis/
├── sql/
│   ├── 01_subquestion_1.sql    ← SQ1: distância × frete
│   ├── 02_subquestion_2.sql    ← SQ2: preço × qualidade
│   └── 03_subquestion_3.sql    ← SQ3: stock × vendas
├── excel/                      ← validações pontuais
├── powerbi/                    ← dashboard.pbix
└── python/
    ├── 01_cleaning.ipynb       ← limpeza e colunas Fix
    ├── 02_eda.ipynb            ← análise exploratória por subquestão
    └── 03_visualization.ipynb  ← gráficos para exportar para 04_results
```

---

## Regras

- Todo o código tem comentários inline
- Cada notebook começa com o objetivo da subquestão que responde
- Resultados exportados vão para `04_results/charts/`
- Se Excel for usado, pelo menos uma ferramenta adicional é obrigatória

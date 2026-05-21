# 01_data — Dados
Os dados brutos (em `../Datasets/`) e os ficheiros de documentação dos dados.
A separação entre raw e processed é inviolável.
---
## Estrutura
01_data/
├── processed/                  ← output da limpeza
│   ├── 01_cleaning.ipynb      ← Notebook de limpeza
│   ├── power-m.m              ← Fórmulas Power Query (linguagem M)
│   └── tags.csv               ← Tags de categoria dos produtos
├── checklist_metricas_formulas.md   ← Catálogo M001–M149
├── guiao_power_query.md        ← 14 passos da limpeza no Power Query
├── lembretes_ETL.md            ← Notas de apoio ao processo ETL
├── observacoes_externas.md     ← 24 códigos RFIX do criador do Kaggle
└── types.md                    ← Tipos de dados e conversões
## Regra absoluta
**Ficheiros raw são intocáveis.**
O dataset original (`Summer_Products.csv`) nunca é alterado.
Qualquer transformação acontece em Python / Power Query
e o resultado final está em `../Datasets/limpos_final.xlsm` e `limpos_final_csv.csv`.
Se precisares de comparar antes/depois — tens os dois.
---
## Dataset
**Fonte:** Kaggle — Sales of Summer Clothes in E-commerce Wish
**Recolha:** agosto de 2020
**Linhas:** 1.573 · **Colunas:** 43
**Mercado:** Europa Ocidental / interface francesa
---
## Ficheiros externos referenciados
| Ficheiro | Localização | Conteúdo |
|---|---|---|
| `Summer_Products.csv` | `../Datasets/` | Dataset original bruto |
| `limpos_final.xlsm` | `../Datasets/` | Dataset limpo (Excel) |
| `limpos_final_csv.csv` | `../Datasets/` | Dataset limpo (CSV) |
| `CO2_transporte.csv` | `../Datasets/` | Fatores de emissão por modo de transporte |
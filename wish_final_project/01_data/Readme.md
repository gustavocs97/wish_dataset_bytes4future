
# 01_data — Dados

Os dados brutos e os dados processados. A separação entre os dois é inviolável.

---

## Estrutura

```
01_data/
├── raw/                        ← NUNCA EDITAR
│   └── Summer_Products.csv
├── processed/                  ← output da limpeza
│   └── summer_products_clean.csv
├── guiao_power_query.md        ← passo a passo da limpeza no Power Query
└── lembretes_ETL.md            ← notas de apoio ao processo ETL
```

## Regra absoluta

**`raw/` é intocável.**
O ficheiro original nunca é alterado, renomeado ou movido.
Qualquer transformação acontece no Power Query ou em Python
e o resultado vai para `processed/`.

Se precisares de comparar antes/depois — tens os dois.

---

## Dataset

**Fonte:** Kaggle — Sales of Summer Clothes in E-commerce Wish
**Recolha:** agosto de 2020
**Linhas:** 1.573 · **Colunas:** 43
**Mercado:** Europa Ocidental / interface francesa

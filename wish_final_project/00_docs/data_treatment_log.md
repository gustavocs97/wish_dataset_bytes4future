

----------




# Data Treatment Log
**Projeto Final — Data Analyst Junior**
**Grupo:** Letícia · Ricardo · Gustavo
**Dataset:** Sales of Summer Clothes — Wish Platform (Kaggle, agosto 2020)
**Responsável:** Gustavo
**Data:** 16 de maio de 2025

---

## Como usar este documento

Para cada variável tratada, este log regista:
- O problema encontrado nos dados brutos
- A decisão tomada e a coluna de correção criada (`ColNameFix`)
- As alternativas consideradas e porque foram rejeitadas
- O impacto na análise

**Regra de ouro:** os dados originais nunca são alterados.
Todas as correções vivem em colunas novas. O ficheiro `raw/` é intocável.

---

## Resumo de Decisões

| Coluna Original | Problema | Coluna Fix | Decisão |
|---|---|---|---|
| `price` / `retail_price` | price > retail em 35% dos casos | `discount_pct_fix` | Negativos → 0 (sem desconto) |
| `units_sold` | Buckets arredondados, não contínuo | `units_sold_tier` | Convertido para variável ordinal |
| `has_urgency_banner` | 70% NaN — campo ausente, não nulo | `has_urgency_banner_fix` | NaN → 0 (sem banner) |
| `product_color` | 41 NaN (2.6%) | `product_color_fix` | NaN → "unknown" |
| `origin_country` | 17 NaN (1.1%) | `origin_country_fix` | NaN → "unknown" |
| `rating_*_count` | 45 NaN em todos os subcampos (2.9%) | — | Excluídos da análise de breakdown |
| `merchant_profile_picture` | 86% NaN | — | Coluna excluída da análise |
| `product_id` | 232 duplicados | — | Duplicados identificados, decisão documentada abaixo |
| `badge_local_product` | Badge "local" em produtos 100% chineses | — | Limitação declarada, coluna usada com ressalva |
| `inventory_total` | 99% no máximo (50) — sem variação útil | — | Coluna excluída da análise principal |

---

## Tratamentos Detalhados

---

### 1. `price` vs `retail_price` → `discount_pct_fix`

**Problema:**
559 registos (35.5%) têm `price` > `retail_price`.
O `retail_price` é suposto ser o preço de referência de mercado — mas em mais
de um terço dos casos o produto custa mais do que o "preço normal".
193 registos (12.3%) têm `price` == `retail_price` (desconto zero).

**Valores:**
- Desconto mínimo calculado: -18.2% (price muito acima do retail)
- Desconto máximo: 96.9%
- Mediana do desconto: 5.8%

**Decisão: Metodologia B — negativos → 0**
Criar coluna `discount_pct_fix`:
```
discount_pct = (retail_price - price) / retail_price * 100
discount_pct_fix = max(discount_pct, 0)
```
Produtos com desconto negativo passam a ter `discount_pct_fix = 0`
(interpretação: sem desconto real, não preço inflacionado).

**Metodologia A — excluir os 559 registos — REJEITADA**
Perderíamos 35.5% do dataset. Dado o objetivo de analisar padrões de consumo,
excluir um terço dos produtos distorceria a análise tanto quanto mantê-los.
Além disso, estes produtos fazem parte do comportamento real da plataforma.

**Metodologia C — ignorar retail_price — REJEITADA**
O retail_price é usado como variável de contexto (percepção de valor pelo
consumidor). Ignorá-lo eliminaria a possibilidade de analisar a ilusão de
desconto como mecanismo de impulso de compra — relevante para o objetivo ESG.

**Impacto na análise:**
`discount_pct_fix` será usado para analisar se a perceção de desconto influencia
`units_sold` independentemente da qualidade (`rating`).

---

### 2. `units_sold` → `units_sold_tier`

**Problema:**
`units_sold` não é uma variável contínua real. Os valores são buckets
arredondados que o Wish usa para mostrar popularidade:

| Valor | Registos |
|---|---|
| 100 | 509 |
| 1000 | 405 |
| 5000 | 217 |
| 10000 | 177 |
| 20000 | 103 |
| 50 | 76 |
| outros | 79 |

Tratar como contínuo geraria correlações falsas — a distância entre "100" e
"1000" não é proporcional à distância real de vendas.

**Decisão: converter para variável ordinal `units_sold_tier`**

| Tier | Intervalo | Interpretação |
|---|---|---|
| 1 | < 100 | Volume muito baixo |
| 2 | 100–999 | Volume baixo |
| 3 | 1.000–4.999 | Volume médio |
| 4 | 5.000–19.999 | Volume alto |
| 5 | ≥ 20.000 | Volume muito alto |

**Alternativa — manter contínuo — REJEITADA**
Correlações com variável contínua de buckets produziriam resultados
numericamente precisos mas analiticamente enganosos. A apresentação de
resultados baseada em médias de buckets não seria defensável.

**Alternativa — log transform — REJEITADA**
Log de buckets não resolve o problema de origem — os valores não são
medições reais, são categorias disfarçadas de números.

**Impacto na análise:**
Todas as análises de volume de vendas usarão `units_sold_tier`.
O cálculo de kg de têxtil usará os valores originais com ressalva declarada
de que são estimativas por excesso/defeito.

---

### 3. `has_urgency_banner` → `has_urgency_banner_fix`

**Problema:**
1.100 registos (69.9%) têm NaN. Apenas 473 têm valor 1.0.
O campo não tem valor 0 — quando não há banner, o campo está vazio.

**Decisão: NaN → 0**
```
has_urgency_banner_fix = has_urgency_banner.fillna(0).astype(int)
```
NaN significa ausência de banner, não dado em falta. É uma decisão de
design do dataset — campos binários de presença/ausência frequentemente
omitem o caso negativo.

**Alternativa — excluir os 1.100 registos — REJEITADA**
Eliminaria 70% do dataset. A ausência de banner é informação relevante —
é o grupo de controlo para comparar com produtos que têm banner.

**Alternativa — manter NaN — REJEITADA**
Impossibilitaria qualquer análise de comparação entre grupos.
Funções de agregação ignoram NaN e distorceriam contagens.

**Impacto na análise:**
`has_urgency_banner_fix` será variável central na análise de consumo por
impulso — comparação de `units_sold_tier` entre produtos com e sem banner.

---

### 4. `product_color` → `product_color_fix`

**Problema:**
41 registos (2.6%) sem cor registada.

**Decisão: NaN → "unknown"**
```
product_color_fix = product_color.fillna("unknown")
```
A ausência de cor é informação válida — pode indicar produtos sem
variação de cor ou sellers que não preencheram o campo.

**Alternativa — moda (cor mais frequente = "black") — REJEITADA**
Imputar "black" em 41 produtos sem justificação seria inventar dados.
A cor é uma variável categórica sem ordenação — não existe "cor média".

**Alternativa — excluir os 41 registos — REJEITADA**
2.6% do dataset por uma variável que não é central na análise.
Impacto desproporcional ao problema.

**Impacto na análise:**
Usado apenas como variável descritiva. Categoria "unknown" excluída
de análises de distribuição por cor.

---

### 5. `origin_country` → `origin_country_fix`

**Problema:**
17 registos (1.1%) sem país de origem.

**Decisão: NaN → "unknown"**
```
origin_country_fix = origin_country.fillna("unknown")
```
País de origem desconhecido é informação relevante para o cálculo de
distância de frete — será tratado como caso separado, não imputado.

**Alternativa — imputar "CN" (moda, 96%) — REJEITADA**
Assumir que produtos sem origem registada são chineses seria especulação.
Para o cálculo de distância de frete, uma imputação errada produziria
um valor numérico falso com aparência de precisão.

**Impacto na análise:**
Registos "unknown" excluídos do cálculo de distância de frete.
Representam apenas 1.1% — impacto negligenciável.

---

### 6. `rating_five_count` ... `rating_one_count` — sem coluna Fix

**Problema:**
45 registos (2.9%) com NaN em todos os subcampos de rating simultaneamente.
O `rating` principal está completo em 100% dos registos.

**Decisão: manter NaN, excluir estes registos apenas das análises de breakdown**
Os 45 registos continuam na análise principal (usam `rating`).
Análises que requerem o breakdown por estrelas excluem estes 45 registos
e declaram n=1.528.

**Alternativa — imputar por proporção média — REJEITADA**
Criar subcounts sintéticos a partir do rating médio introduziria variância
artificial. As correlações entre subcounts seriam matematicamente corretas
mas empiricamente vazias.

**Impacto na análise:**
Mínimo. 2.9% do dataset afetado apenas em análises secundárias.

---

### 7. `merchant_profile_picture` — excluída da análise

**Problema:**
1.347 registos (85.6%) sem URL de foto de perfil.

**Decisão: coluna excluída da análise**
Com 86% de ausência, qualquer análise seria baseada em 14% do dataset —
não representativa. A variável `merchant_has_profile_picture` (binária,
completa) cobre o mesmo conceito de forma utilizável.

**Impacto na análise:**
Nenhum. `merchant_has_profile_picture` substitui onde relevante.

---

### 8. `product_id` duplicados

**Problema:**
1.573 linhas totais, 1.341 `product_id` únicos → 232 duplicados (14.7%).

**Contexto:**
O dataset pode ter múltiplas linhas por produto por variações de tamanho
ou cor (`product_variation_size_id`, `product_color`). Não são
necessariamente erros — podem ser registos legítimos de variações.

**Decisão: manter todos os registos, declarar como limitação**
A análise opera ao nível de listing (linha), não de produto único.
Para análises onde produto único importa (ex: contagem de produtos
distintos), usar `product_id` com `.drop_duplicates()` e declarar n=1.341.

**Alternativa — desduplicar por product_id — REJEITADA**
Perderíamos informação de variações. Um produto com 3 tamanhos diferentes
pode ter padrões de venda distintos por variação — relevante para análise
de stock e desperdício.

**Impacto na análise:**
Declarado em cada análise se usa n=1.573 (listings) ou n=1.341 (produtos).

---

### 9. `badge_local_product` — limitação declarada

**Problema identificado:**
29 produtos têm `badge_local_product = 1`.
Desses 29, **100% têm `origin_country = CN`** (China).

O badge "produto local" em produtos de origem chinesa é uma contradição.
Pode significar: produto fabricado localmente para o mercado europeu por
empresa de origem chinesa, ou uso indevido do badge pelo seller.

**Decisão: usar a coluna com ressalva explícita**
O badge é tratado como declaração do seller, não facto verificado.
Análises que usem `badge_local_product` declaram esta limitação.

Adicionalmente: produtos "locais" têm `countries_shipped_to` médio de
42.86 vs 40.41 dos não-locais — contradição adicional com o conceito
de produto local.

**Impacto na análise:**
O badge local não pode ser usado como proxy de sustentabilidade de
transporte. Serve como indicador de estratégia de marketing do seller.

---

### 10. `inventory_total` — excluída da análise principal

**Problema:**
1.563 dos 1.573 registos (99.4%) têm `inventory_total = 50`.
O valor 50 é o máximo permitido pela plataforma — não é o stock real,
é o tecto da plataforma.

**Decisão: coluna excluída da análise principal**
Sem variação real, a coluna não tem poder analítico.
`product_variation_inventory` tem distribuição mais variada e pode ser
usado como proxy de stock por variação onde relevante.

**Impacto na análise:**
A análise de desperdício/sobreprodução usará `product_variation_inventory`
como proxy secundário, com limitação declarada.

---

## Colunas Adicionadas de Fontes Externas

| Coluna | Fonte | Método |
|---|---|---|
| `distance_km` | Tabela de distâncias por `origin_country_fix` até Paris (Europa Ocidental) | CN=9200km, US=8500km, VE=8300km, SG=10200km, AT=1050km, GB=340km |
| `estimated_weight_g` | Peso médio estimado por categoria têxtil | A definir — fonte: Ellen MacArthur Foundation / literatura têxtil |
| `units_sold_tier` | Calculada internamente | Ver secção 2 |
| `discount_pct_fix` | Calculada internamente | Ver secção 1 |
| `has_urgency_banner_fix` | Calculada internamente | Ver secção 3 |

---

## Colunas Irrelevantes para a Análise

Excluídas por não contribuírem para o objetivo de negócio:

| Coluna | Motivo |
|---|---|
| `title` | Versão localizada — `title_orig` suficiente |
| `currency_buyer` | Constante (EUR = 100%) — sem variação |
| `theme` | Constante (summer = 100%) — sem variação |
| `crawl_month` | Constante (2020-08 = 100%) — sem variação |
| `merchant_profile_picture` | 86% NaN — ver secção 7 |
| `product_url` | URL — não analítico |
| `product_picture` | URL — não analítico |
| `merchant_info_subtitle` | Texto não estruturado em francês |


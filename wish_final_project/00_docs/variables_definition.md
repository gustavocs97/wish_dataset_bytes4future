# Variables Definition
**Projeto Final — Data Analyst Junior**
**Grupo:** Letícia · Ricardo · Gustavo
**Dataset:** Sales of Summer Clothes — Wish Platform (Kaggle, agosto 2020)
**Responsável:** Gustavo (estrutura e classificação) · Ricardo (contexto e relevância)
**Data:** 16 de maio de 2025

---

## Estrutura do Dataset

- **Total de registos:** 1.573 linhas
- **Total de colunas originais:** 43
- **Produtos únicos:** 1.341 (`product_id` distinto)
- **Merchants únicos:** 958
- **Moeda:** EUR (100%)
- **Período:** agosto de 2020 (pandemia COVID-19)
- **Mercado inferido:** Europa Ocidental / interface francesa

---

## Classificação de Variáveis

As variáveis são classificadas em três grupos:

| Grupo | Descrição |
|---|---|
| ✅ **Análise** | Usadas diretamente na análise |
| 🔧 **Fix** | Usadas com coluna de correção (`ColNameFix`) |
| ❌ **Excluída** | Sem valor analítico para o objetivo |

---

## Tipo de Variável

| Tipo | Definição | Exemplos no dataset |
|---|---|---|
| **Contínua** | Valores numa escala numérica com gradação real | `price`, `rating`, `merchant_rating` |
| **Ordinal** | Categorias com ordem mas sem escala linear | `units_sold_tier`, `badges_count` |
| **Categórica** | Etiquetas sem ordenação intrínseca | `product_color`, `origin_country` |
| **Binária** | Dois valores possíveis: 0 ou 1 | `uses_ad_boosts`, `badge_product_quality` |
| **Texto** | Campo livre não estruturado | `tags`, `title_orig`, `urgency_text` |
| **URL / ID** | Identificador ou endereço — não analítico | `product_url`, `merchant_id` |

---

## Painel de Variáveis — Análise Principal

### BLOCO 1 — Produto e Preço

---

#### `price` ✅ Contínua
**Descrição:** Preço que o consumidor paga pelo produto.
**Estatísticas:** min=€1.00 | média=€8.33 | max=€49.00 | nulos=0
**Relevância:** Variável central. Preço baixo é o mecanismo principal de atração
do Wish e o principal indicador de produto descartável — artigos abaixo de €5
dificilmente têm qualidade para durabilidade. Cruzar com `rating` e `units_sold`
para testar a hipótese de consumo insustentável por preço.

---

#### `retail_price` 🔧 Contínua
**Descrição:** Preço de referência de mercado declarado pelo seller.
Usado para criar a perceção de desconto no consumidor.
**Estatísticas:** min=€1.00 | média=€23.29 | max=€252.00 | nulos=0
**Problema:** Em 35.5% dos casos `price` > `retail_price` — desconto negativo.
**Coluna Fix:** `discount_pct_fix` — ver `data_treatment_log.md` secção 1.
**Relevância:** A ilusão de desconto é um mecanismo de impulso de compra.
Analisar se produtos com desconto percebido alto vendem mais independentemente
da qualidade — ligação direta ao consumo por impulso.

---

#### `title_orig` ✅ Texto
**Descrição:** Título original do produto em inglês.
**Relevância:** Não entra em análise quantitativa. Útil para validação
qualitativa de categorias e para contextualizar casos extremos na apresentação.

---

#### `product_color` 🔧 Categórica
**Descrição:** Cor principal do produto. 101 valores únicos.
**Top cores:** black (302), white (254), yellow (105), blue (99), pink (99)
**Nulos:** 41 (2.6%) → `product_color_fix`: NaN = "unknown"
**Relevância:** Secundária. Pode revelar se cores específicas dominam o
volume de vendas — contexto para análise de produção em massa.

---

#### `product_variation_size_id` ✅ Categórica
**Descrição:** Uma das variações de tamanho disponíveis para o produto.
**Valores dominantes:** S (641), XS (356), M (200), XXS (100)
**Nulos:** 14 (0.9%)
**Relevância:** Secundária. Indica o tamanho mais representado no crawl.
Nota: valores inconsistentes (ex: "S.", "SIZE S", "s") — não normalizar
para esta análise, usar apenas como contexto descritivo.

---

### BLOCO 2 — Vendas e Volume

---

#### `units_sold` 🔧 Ordinal (tratada)
**Descrição:** Número de unidades vendidas durante o ciclo de vida do listing.
**Atenção:** Não é um valor real contínuo — são buckets de visualização do Wish.
**Valores observados:** 100 (509 produtos), 1000 (405), 5000 (217), 10000 (177)...
**Coluna Fix:** `units_sold_tier` — variável ordinal em 5 níveis.

| Tier | Intervalo | N produtos |
|---|---|---|
| 1 | < 100 | 63 |
| 2 | 100–999 | 509 |
| 3 | 1.000–4.999 | 405 |
| 4 | 5.000–19.999 | 394 |
| 5 | ≥ 20.000 | 126 |

**Relevância:** Variável dependente principal. Todas as análises de "o que
vende mais" usam `units_sold_tier`. O cálculo de peso de têxtil usa os
valores originais com ressalva de estimativa.

---

#### `inventory_total` ❌ Excluída
**Descrição:** Stock total para todas as variações do produto. Máximo: 50.
**Problema:** 1.563 dos 1.573 registos (99.4%) têm valor 50 — o tecto da
plataforma. Sem variação real. Sem poder analítico.
**Substituída por:** `product_variation_inventory` onde relevante.

---

#### `product_variation_inventory` ✅ Contínua
**Descrição:** Stock disponível para a variação específica desta linha.
**Estatísticas:** min=1 | média=33.08 | max=50 | nulos=0
**Relevância:** Proxy de stock por variação. Produtos com stock máximo (50)
e vendas baixas (tier 1-2) são candidatos a desperdício de produção.

---

### BLOCO 3 — Qualidade e Avaliação

---

#### `rating` ✅ Contínua
**Descrição:** Avaliação média do produto pelos compradores (1 a 5 estrelas).
**Estatísticas:** min=1.00 | média=3.82 | max=5.00 | nulos=0
**Relevância:** Proxy de qualidade percebida e durabilidade. Produtos com
`rating` < 3.5 são considerados de baixa qualidade — proxy de descarte precoce.
Cruzar com `price` para testar: *"o barato sai caro — e o consumidor sabe-o?"*

---

#### `rating_count` ✅ Contínua
**Descrição:** Número total de avaliações recebidas.
**Estatísticas:** min=0 | média=889.66 | max=20.744 | nulos=0
**Relevância:** Indicador de maturidade do produto na plataforma. Alta
`rating_count` com baixo `rating` é o sinal mais forte de produto problemático
com exposição massiva.

---

#### `rating_five_count` ... `rating_one_count` ✅ Contínuas
**Descrição:** Breakdown de avaliações por número de estrelas (5 a 1).
**Nulos:** 45 registos em todos os subcampos simultaneamente (2.9%)
**Relevância:** Permite calcular a proporção de avaliações negativas (1 e 2
estrelas) como métrica de insatisfação. `rating_one_count` elevado em produto
barato = evidência de descarte por baixa qualidade.

---

#### `badge_product_quality` ✅ Binária
**Descrição:** Badge atribuído pela plataforma quando compradores consistentemente
avaliam bem o produto. 1 = tem badge; 0 = não tem.
**Distribuição:** 117 com badge (7.4%) | 1.456 sem badge (92.6%)
**Relevância:** Apenas 7.4% dos produtos têm certificação de qualidade pela
plataforma. Este número por si só é um achado — e é defensável com os dados.

---

#### `badge_fast_shipping` ✅ Binária
**Descrição:** Badge atribuído quando o produto é consistentemente enviado
de forma rápida. 1 = tem badge; 0 = não tem.
**Distribuição:** 20 com badge (1.3%) | 1.553 sem badge (98.7%)
**Relevância:** Indicador de fiabilidade logística — relevante para cruzar
com `shipping_is_express` e `origin_country`.

---

#### `badges_count` ✅ Ordinal
**Descrição:** Número total de badges do produto (0 a 3).
**Distribuição:** 0 badges: 1.422 (90.4%) | 1: 138 | 2: 11 | 3: 2
**Relevância:** Proxy agregado de confiança/qualidade certificada pela
plataforma. Cruzar com `units_sold_tier`: badges aumentam vendas?

---

### BLOCO 4 — Mecanismos de Plataforma (Impulso de Compra)

---

#### `uses_ad_boosts` ✅ Binária
**Descrição:** Se o seller pagou para destacar o produto na plataforma
(melhor posicionamento, highlighting). 0 = não; 1 = sim.
**Distribuição:** 681 com boost (43.3%) | 892 sem boost (56.7%)
**Relevância:** Central para a análise de consumo por impulso. Quase metade
dos produtos são artificialmente promovidos. Testar: *"ad boost aumenta vendas
independentemente da qualidade?"*

---

#### `has_urgency_banner` 🔧 Binária
**Descrição:** Se o produto tem banner de urgência visível na pesquisa.
**Problema:** NaN = sem banner (não é dado em falta).
**Distribuição:** 473 com banner (30.1%) | 1.100 sem banner (69.9%)
**Coluna Fix:** `has_urgency_banner_fix`: NaN → 0
**Relevância:** Mecanismo de pressão de compra por escassez percebida.
Cruzar com `units_sold_tier` e `rating` — produtos com banner vendem mais
mesmo com baixa qualidade?

---

#### `urgency_text` ✅ Texto
**Descrição:** Texto do banner de urgência (ex: "Almost Gone!", "Quantité limitée!").
**Nulos:** 1.100 (70%) — mesmo padrão de `has_urgency_banner`
**Relevância:** Análise qualitativa da linguagem de pressão usada. Maioritariamente
em francês — consistente com o mercado inferido. Não entra em análise quantitativa.

---

### BLOCO 5 — Transporte e Origem

---

#### `origin_country` 🔧 Categórica
**Descrição:** País de origem do produto.
**Distribuição:** CN=1.516 (96.4%) | US=31 | NaN=17 | VE=5 | SG=2 | AT=1 | GB=1
**Coluna Fix:** `origin_country_fix`: NaN → "unknown"
**Coluna calculada:** `distance_km` — distância estimada até Europa Ocidental (Paris)

| País | Distância até Paris |
|---|---|
| CN | 9.200 km |
| US | 8.500 km |
| VE | 8.300 km |
| SG | 10.200 km |
| AT | 1.050 km |
| GB | 340 km |
| unknown | excluído |

**Relevância:** 96% dos produtos percorrem ~9.200 km até chegar ao consumidor
europeu. Cruzar com `shipping_option_price` e volume vendido para estimar
pegada de transporte relativa.

---

#### `countries_shipped_to` ✅ Contínua
**Descrição:** Número de países para onde o produto é enviado (não lista dos países).
**Estatísticas:** min=6 | média=40.46 | max=140 | nulos=0
**Relevância:** Proxy de alcance global do produto. Maior alcance = mais rotas
de transporte = maior impacto ambiental estimado. Cruzar com `badge_local_product`
para testar a contradição: produtos "locais" com envio global.

---

#### `shipping_option_price` ✅ Contínua
**Descrição:** Custo do frete pago pelo comprador.
**Estatísticas:** min=€1.00 | média=€2.35 | max=€12.00 | nulos=0
**Relevância:** Frete barato em produtos de origem distante é subsidiado —
o custo ambiental real do transporte não está refletido no preço. Cruzar com
`distance_km` para ilustrar o subsídio implícito ao frete de longa distância.

---

#### `shipping_is_express` ✅ Binária
**Descrição:** Se o envio é expresso. 1 = sim (geralmente aéreo, mais poluente).
**Distribuição:** 4 com express (0.3%) | 1.569 sem express (99.7%)
**Relevância:** Quase irrelevante estatisticamente (4 casos). Manter como
nota descritiva — o Wish opera quase exclusivamente em frete padrão/marítimo.

---

#### `shipping_option_name` ❌ Excluída (descritiva)
**Descrição:** Nome do método de envio. 96% = "Livraison standard" (francês).
**Relevância:** Confirma o mercado europeu/francês. Sem valor analítico adicional
— usada apenas para inferir o destino geográfico dos dados.

---

#### `badge_local_product` 🔧 Binária
**Descrição:** Badge que indica produto local. 1 = tem badge; 0 = não tem.
**Distribuição:** 29 com badge (1.8%) | 1.544 sem badge (98.2%)
**Contradição documentada:** 100% dos 29 produtos "locais" têm `origin_country = CN`.
`countries_shipped_to` médio de produtos "locais": 42.86 vs 40.41 dos restantes.
**Relevância:** O badge não pode ser usado como proxy de sustentabilidade
de transporte. Serve como indicador de estratégia de marketing — e a
contradição é em si um achado analítico sobre a fiabilidade de "eco-labels"
em plataformas de fast fashion.

---

### BLOCO 6 — Merchant / Seller

---

#### `merchant_rating` ✅ Contínua
**Descrição:** Avaliação média do seller na plataforma.
**Estatísticas:** min=2.33 | média=4.03 | max=5.00 | nulos=0
**Relevância:** Confiança no seller vs confiança no produto — são independentes?
Cruzar `merchant_rating` com `rating` do produto para ver se sellers bem
avaliados têm produtos melhor avaliados.

---

#### `merchant_rating_count` ✅ Contínua
**Descrição:** Número de avaliações recebidas pelo merchant.
**Estatísticas:** min=0 | média=26.495 | max=2.174.765 | nulos=0
**Relevância:** Indicador de dimensão e maturidade do seller. Sellers com
alto volume de avaliações representam operações de maior escala.

---

#### `merchant_has_profile_picture` ✅ Binária
**Descrição:** Se o seller tem foto de perfil. 1 = sim; 0 = não.
**Distribuição:** 226 com foto (14.4%) | 1.347 sem foto (85.6%)
**Relevância:** Proxy de profissionalismo / identidade do seller.
Cruzar com `merchant_rating` — sellers identificáveis têm melhor reputação?

---

#### `merchant_id` ❌ Excluída
**Descrição:** Identificador único do merchant. Não analítico.

#### `merchant_title` / `merchant_name` ❌ Excluídas
**Descrição:** Nome público e nome canónico do seller. Não analíticos.

#### `merchant_profile_picture` ❌ Excluída
**Descrição:** URL da foto de perfil. 85.6% NaN. Substituída por
`merchant_has_profile_picture`.

---

### BLOCO 7 — Colunas Constantes (sem valor analítico)

| Coluna | Valor único | Motivo de exclusão |
|---|---|---|
| `currency_buyer` | EUR (100%) | Sem variação |
| `theme` | summer (100%) | Sem variação |
| `crawl_month` | 2020-08 (100%) | Sem variação |
| `title` | — | Substituída por `title_orig` |
| `product_url` | URL | Não analítico |
| `product_picture` | URL | Não analítico |
| `merchant_info_subtitle` | Texto % francês | Não estruturado |

---

## Colunas Calculadas — Fontes Internas

| Coluna | Fórmula | Propósito |
|---|---|---|
| `discount_pct_fix` | `max((retail_price - price) / retail_price * 100, 0)` | Desconto percebido sem negativos |
| `units_sold_tier` | Ordinal 1–5 por intervalo | Volume de vendas comparável |
| `has_urgency_banner_fix` | `has_urgency_banner.fillna(0)` | Banner como binário completo |
| `product_color_fix` | `product_color.fillna("unknown")` | Cor sem nulos |
| `origin_country_fix` | `origin_country.fillna("unknown")` | Origem sem nulos |
| `negative_rating_pct` | `(rating_one_count + rating_two_count) / rating_count * 100` | % avaliações negativas |
| `total_badges` | `badge_local + badge_quality + badge_fast` | Confiança agregada |

---

## Colunas Calculadas — Fontes Externas

| Coluna | Fonte externa | Método |
|---|---|---|
| `distance_km` | Distâncias geográficas públicas | Tabela fixa por `origin_country_fix` |
| `estimated_weight_g` | Ellen MacArthur Foundation / literatura têxtil | Peso médio por categoria de peça |
| `estimated_textile_kg` | Calculada | `units_sold × estimated_weight_g / 1000` |

---

## Relações Entre Variáveis — Mapa para a Análise

```
PREÇO BAIXO ──────────────────────────────────────────► DESCARTE PRECOCE
price < €5 + rating < 3.5 + units_sold alto             (estimativa em kg)

MECANISMOS DE PLATAFORMA ────────────────────────────► CONSUMO POR IMPULSO
uses_ad_boosts + has_urgency_banner_fix                  independente da qualidade?

ORIGEM DISTANTE ─────────────────────────────────────► PEGADA DE TRANSPORTE
origin_country (96% CN) + distance_km                   proxy de emissões relativas

ECO-LABEL vs REALIDADE ──────────────────────────────► GREENWASHING
badge_local_product (100% CN) + countries_shipped_to    contradição mensurável
```

---

*Documento vivo — atualizar se novas variáveis calculadas forem adicionadas.*
*Última atualização: 16 mai 2025 — Gustavo*
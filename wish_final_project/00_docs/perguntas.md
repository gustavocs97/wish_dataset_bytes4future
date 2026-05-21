# Lista Mestra — Projeto Wish ESG
**Grupo:** Letícia · Ricardo · Gustavo
**Dataset:** Sales of Summer Clothes — Wish Platform (Kaggle, agosto 2020)
**Objetivo:** *"Analisar os padrões de consumo na plataforma Wish que geram impacto ambiental negativo e definir métricas sustentáveis capazes de orientar práticas mais ecológicas sem comprometer o lucro."*
---
## SECÇÃO 1 — OBJETIVO DE NEGÓCIO
### 5W2H Resumido
| | |
|---|---|
| **WHAT** | Analisar 5 dimensões de impacto ambiental no Wish: concentração geográfica, transporte, cores, qualidade vs. lucro, preço vs. descarte |
| **WHO** | Marcas europeias, plataformas e-commerce, reguladores UE, investidores ESG |
| **WHERE** | Mercado europeu (100% EUR, 96% "Livraison standard" francês) |
| **WHEN** | Agosto 2020 (pandemia COVID-19, pré-regulação têxtil UE 2022) |
| **WHY** | Gap entre intenção de consumo sustentável e comportamento real |
| **HOW** | Python + Excel sobre 1.573 registos + fontes externas (CO2_transporte.csv, literatura tingimento) |
| **HOW MUCH** | Toneladas de CO₂ por transporte, kg de têxtil em risco de descarte, concentração de origem |
### 5 Objetivos SMART
| # | Objetivo | Métrica | Pergunta |
|---|---|---|---|
| **SMART 1** | Quantificar concentração geográfica: % CN, contradição badge "local" | % `origin_country` = CN; % `badge_local_product` com `origin_country` = CN | Q1 |
| **SMART 2** | Estimar CO₂ total do transporte por modo e faixa de preço | Ton CO₂ = `CO2_transporte.csv` × `distance_km` × `units_sold` | Q2 |
| **SMART 3** | Medir distribuição de cores vs. vendas e cruzar com poluição de tingimento | % catálogo por cor; correlação cor × `units_sold` | Q3 |
| **SMART 4** | Comparar vendas e GMV de produtos bem avaliados vs. mal avaliados | Média `units_sold` e GMV para rating ≥ 4 vs. < 4 | Q4 |
| **SMART 5** | Quantificar insatisfação em produtos baratos e estimar têxtil em risco de descarte | `negative_rating_pct` por faixa de preço; kg com rating < 3,5 | Q5 |
---
## SECÇÃO 2 — TABELA PRINCIPAL: PERGUNTAS
| ID | Pergunta | Tema | Colunas Dataset | Colunas Calculadas | Fontes Ext. | Métrica | Python | Insight Esperado | Valor Negócio |
|---|---|---|---|---|---|---|---|---|---|
| **Q1** | Qual o impacto da concentração geográfica? | 🌍 Ambiental | `origin_country`, `countries_shipped_to`, `badge_local_product` | `origin_country_fix`, `distance_km` | Tabela distâncias (CN→Paris 9200km) | 96,4% CN; `corr(countries_shipped_to, units_sold)` ≈ 0; 100% "locais" são CN | `df['origin_country'].value_counts(normalize=True)` | Cadeia mono-origem: 96,4% CN. Badge "local" é greenwashing. Alcance global não aumenta vendas | Risco logístico concentrado; base para política de diversificação de sourcing |
| **Q2** | Qual o impacto ambiental do transporte? | 🌍 Ambiental | `origin_country`, `units_sold`, `price` | `origin_country_fix`, `distance_km` | `CO2_transporte.csv` (244 g CO₂/pkm avião, 15 navio) | Ton CO₂ total por modo × faixa de preço | `merge(CO2_transporte)`, `groupby(['price_tier','modo'])['co2_ton'].sum()` | Avião emite 16× mais CO₂ que navio por km. Modo de transporte é o maior fator de diferenciação | Base para taxa de carbono no frete; evidência para regulamentar modal de envio |
| **Q3** | As cores que mais vendem são as mais poluentes? | 🌍 Ambiental | `product_color`, `units_sold`, `price`, `rating` | `product_color_fix` | Literatura de tingimento têxtil (Ellen MacArthur, Greenpeace) | % vendas por cor; top 5: black, white, yellow, blue, pink | `df.groupby('product_color_fix')['units_sold'].sum().sort_values(ascending=False)` | Cores mais vendidas (preto, branco) estão entre as mais intensivas em recursos de tingimento | Evidência para rotulagem ambiental por cor; base para repensar portfolio |
| **Q4** | Produtos bem avaliados vendem mais e geram mais lucro? | 💼 Económico | `rating`, `units_sold`, `price`, `badge_product_quality`, `uses_ad_boosts`, `badges_count` | `units_sold_tier` | — | GMV médio rating≥4 vs <4; com badge vendem +54% | `df.groupby(pd.cut(df['rating'],[1,3,4,5]))['gmv'].mean()` | Qualidade e vendas correlacionadas. Badge amplifica. Ad boost vende independentemente da qualidade | Evidência de que qualidade compensa financeiramente |
| **Q5** | Preço baixo = peça descartada mais rapidamente? | 🌍 Ambiental / Social | `price`, `rating`, `units_sold`, `rating_one_count`, `rating_two_count`, `has_urgency_banner` | `negative_rating_pct`, `units_sold_tier`, `has_urgency_banner_fix` | Peso médio/peça ~300g | `negative_rating_pct` por faixa de preço; kg têxtil com rating < 3,5 | `df.groupby('price_tier')['negative_rating_pct'].mean()` | Rating médio varia pouco, mas taxa 1★+2★ é desproporcionalmente alta nos <€5. Consumidor compra apesar da insatisfação | Proxy de consumismo insustentável; base para política de qualidade mínima |
| **Q-EXT1** | Porque é que europeus (ainda) não pagam mais pelo ambiente? | 🌍 Ambiental / Social | — (pesquisa externa) | — | Eurobarometer, Nielsen, Ellen MacArthur, estudos comportamento consumidor | Síntese: gap entre intenção declarada (>70% quer sustentabilidade) e comportamento real (preço domina) | — | Contexto: pandemia 2020 gerou pressão económica que sobrepôs valores ambientais. O dado mostra o comportamento, esta SQ explica o porquê | Transforma análise de "relatório de dados" em "argumento de negócio"; fundamenta recomendações |
| **Q-EXT2** | Que leis europeias regulam este comportamento? | ⚖️ Governança | — (pesquisa externa) | — | EU Green Deal (2019), Estratégia Têxtil Sustentável (2022), DSA (2022), Ecodesign Regulation (2024) | Timeline: em agosto 2020 nenhum destes diplomas estava em vigor — o dataset é baseline *antes* da regulação | — | Dados representam comportamento pré-regulação. A distância temporal é o que dá valor histórico ao dataset | Contexto para recomendações: "o que os dados mostram que acontecia antes — e o que a regulação veio corrigir" |
---
## SECÇÃO 3 — MATRIZ COLUNAS ↔ PERGUNTAS
| Coluna | Q1 | Q2 | Q3 | Q4 | Q5 | Classificação |
|---|---|---|---|---|---|---|
| `price` | | ✅ | ✅ | ✅ | ✅ | ✅ Análise |
| `retail_price` | | | | | | 🔧 Fix → `discount_pct_fix` |
| `units_sold` | ✅ | ✅ | ✅ | ✅ | ✅ | 🔧 Fix → `units_sold_tier` |
| `rating` | | | ✅ | ✅ | ✅ | ✅ Análise |
| `rating_count` | | | | ✅ | | ✅ Análise |
| `rating_five_count` | | | | ✅ | | ✅ Análise |
| `rating_four_count` | | | | ✅ | | ✅ Análise |
| `rating_three_count` | | | | ✅ | | ✅ Análise |
| `rating_two_count` | | | | ✅ | ✅ | ✅ Análise |
| `rating_one_count` | | | | ✅ | ✅ | ✅ Análise |
| `origin_country` | ✅ | ✅ | | | | 🔧 Fix → `origin_country_fix` |
| `countries_shipped_to` | ✅ | | | | | ✅ Análise |
| `shipping_option_price` | | ✅ | | | | ✅ Análise |
| `shipping_is_express` | | ✅ | | | | ✅ Análise |
| `uses_ad_boosts` | | | | ✅ | | ✅ Análise |
| `has_urgency_banner` | | | | | ✅ | 🔧 Fix → `has_urgency_banner_fix` |
| `urgency_text` | | | | | ✅ | ✅ Análise |
| `badge_product_quality` | | | | ✅ | | ✅ Análise |
| `badge_local_product` | ✅ | | | | | 🔧 Fix (limitação declarada) |
| `badge_fast_shipping` | | ✅ | | | | ✅ Análise |
| `badges_count` | | | | ✅ | | ✅ Análise |
| `product_variation_inventory` | | | | | | ✅ Análise (descritiva) |
| `product_color` | | | ✅ | | | 🔧 Fix → `product_color_fix` |
| `product_variation_size_id` | | | | | | ✅ Análise (descritiva) |
| `merchant_rating` | | | | ✅ | | ✅ Análise |
| `merchant_rating_count` | | | | ✅ | | ✅ Análise |
| `merchant_has_profile_picture` | | | | | | ✅ Análise |
| `title_orig` | | | | | | ✅ Análise (qualitativa) |
| `discount_pct_fix` (calc) | | | | | ✅ | 🔧 Calculada |
| `units_sold_tier` (calc) | ✅ | ✅ | ✅ | ✅ | ✅ | 🔧 Calculada |
| `has_urgency_banner_fix` (calc) | | | | | ✅ | 🔧 Calculada |
| `origin_country_fix` (calc) | ✅ | ✅ | | | | 🔧 Calculada |
| `distance_km` (calc) | ✅ | ✅ | | | | 📦 Externa |
| `negative_rating_pct` (calc) | | | | ✅ | ✅ | 🔧 Calculada |
| `estimated_textile_kg` (calc) | | | | | ✅ | 📦 Externa |
| `estimated_weight_g` (calc) | | | | | ✅ | 📦 Externa |
---
## SECÇÃO 4 — CATÁLOGO COMPLETO DE MÉTRICAS (M001–M149)
> ✅ **Selecionar** = coluna para marcares as métricas que vamos usar na análise final.
---
### BLOCO A — Faturamento
| ID | Nome | Categoria | Fórmula | Python | SQ | ✅ |
|---|---|---|---|---|---|---|
| **M001** | Gross Merchandise Volume (GMV) | Faturamento | Σ(price × units_sold) | `df['gmv'] = df['price'] * df['units_sold']; df['gmv'].sum()` | Geral | |
| **M002** | Receita Bruta Potencial (Retail GMV) | Faturamento | Σ(retail_price × units_sold) | `df['retail_gmv'] = df['retail_price'] * df['units_sold']; df['retail_gmv'].sum()` | Geral | |
| **M003** | Total de Unidades Vendidas | Faturamento | Σ units_sold | `df['units_sold'].sum()` | Q5, Geral | |
| **M004** | Ticket Médio (AOV) | Faturamento | GMV / Σ units_sold | `(df['price']*df['units_sold']).sum() / df['units_sold'].sum()` | Geral | |
| **M005** | Preço Médio de Venda (ASP) | Faturamento | Média price | `df['price'].mean()` | Geral | |
| **M006** | Preço Médio de Varejo Original | Faturamento | Média retail_price | `df['retail_price'].mean()` | Geral | |
| **M007** | Faturamento Médio por Lojista | Faturamento | GMV / N merchants | `df.groupby('merchant_id').apply(lambda x: (x['price']*x['units_sold']).sum()).mean()` | Geral | |
| **M008** | Mediana de Unidades Vendidas | Faturamento | Mediana units_sold | `df['units_sold'].median()` | Geral | |
| **M035** | Coef. Variação do Faturamento | Faturamento | σ / μ | `df['price'].std() / df['price'].mean()` | Geral | |
| **M037** | Curtose de Unidades Vendidas | Faturamento | 4º momento padronizado | `df['units_sold'].kurt()` | Geral | |
| **M041** | Margem Contribuição Teórica | Faturamento | price - shipping_price | `df['contribution'] = df['price'] - df['shipping_option_price']` | Q2 | |
| **M044** | Receita Ajustada ao Risco | Faturamento | GMV × (rating/5) | `df['revenue_adj'] = (df['price']*df['units_sold'])*(df['rating']/5)` | Q4, Q5 | |
| **M104** | Pareto Top 20% GMV | Analítica | 1 se GMV ≥ P80(GMV) | `df['is_pareto_top'] = (df['gmv'] >= df['gmv'].quantile(0.80)).astype(int)` | Geral | |
---
### BLOCO B — Precificação
| ID | Nome | Categoria | Fórmula | Python | SQ | ✅ |
|---|---|---|---|---|---|---|
| **M009** | Desconto Absoluto Médio | Precificação | Média(retail_price - price) | `(df['retail_price'] - df['price']).mean()` | Geral | |
| **M010** | Desconto Percentual Médio | Precificação | Média((retail-price)/retail × 100) | `df['disc_perc'] = (df['retail_price']-df['price'])/df['retail_price']*100; df['disc_perc'].mean()` | Q4, Q5 | |
| **M011** | Elasticidade-Preço Relativa | Precificação | Corr(price, units_sold) | `df['price'].corr(df['units_sold'])` | Q5 | |
| **M012** | Índice Desconto Agressivo | Precificação | % produtos com desconto > 50% | `df['is_aggressive'] = ((df['retail_price']-df['price'])/df['retail_price'])>0.5; df['is_aggressive'].mean()` | Q5 | |
| **M034** | Desvio Padrão dos Preços | Precificação | σ price | `df['price'].std()` | Geral | |
| **M039** | Taxa de Desconto Máximo | Precificação | max(desconto %) | `((df['retail_price']-df['price'])/df['retail_price']).max()*100` | Geral | |
| **M042** | Índice Rejeição Preço Elevado | Precificação | % price > μ + 2σ | `threshold = df['price'].mean()+2*df['price'].std(); (df['price']>threshold).mean()*100` | Q5 | |
| **M048** | Volatilidade Descontos intra-Cat | Precificação | Var(desconto) por categoria | `df.groupby('product_category')['disc_perc'].var()` | Geral | |
| **M069** | Sobretaxa de Frete (Shipping Premium) | Precificação | shipping_price / price | `df['shipping_premium'] = df['shipping_option_price'] / df['price']` | Q2 | |
| **M070** | Proporção Frete Grátis | Precificação | % shipping_price == 0 | `(df['shipping_option_price']==0).mean()*100` | Q2 | |
| **M085** | Volatilidade Preço Varejo | Precificação | σ retail_price | `df['retail_price'].std()` | Geral | |
| **M086** | Fator Ancoragem Psicológica | Marketing | retail_price / price | `df['anchor_factor'] = df['retail_price'] / df['price']` | Q5 | |
| **M095** | Razão Varejo/Frete (Distorção) | Precificação | shipping_price / retail_price | `df['retail_shipping_ratio'] = df['shipping_option_price'] / df['retail_price']` | Q2 | |
| **M100** | Penetração Preço Psicológico | Precificação | 1 se price termina em .99/.90/.00 | `df['is_psych_price'] = (df['price']%1).isin([0.99,0.90,0.00]).astype(int)` | Geral | |
| **M103** | Z-Score de Preço | Estatística | (price - μ) / σ | `df['z_score_price'] = (df['price']-df['price'].mean())/df['price'].std()` | Geral | |
| **M106** | Amplitude Interquartil Preço | Estatística | Q3 - Q1 | `df['price'].quantile(0.75) - df['price'].quantile(0.25)` | Geral | |
| **M114** | Assimetria de Preços | Estatística | Skewness | `df['price'].skew()` | Geral | |
| **M115** | Curtose de Preços | Estatística | Kurtosis | `df['price'].kurtosis()` | Geral | |
| **M134** | Desconto Fake Extremo | Precificação | 1 se retail > 10× price | `df['extreme_fake_discount'] = (df['retail_price'] > 10*df['price']).astype(int)` | Q5 | |
| **M141** | Elasticidade Preço-Rating | Analítica | Corr(price, rating) | `df['price'].corr(df['rating'])` | Q5 | |
---
### BLOCO C — Avaliações / Qualidade
| ID | Nome | Categoria | Fórmula | Python | SQ | ✅ |
|---|---|---|---|---|---|---|
| **M014** | Média de Rating | Avaliações | Média rating | `df['rating'].mean()` | Q4, Geral | |
| **M015** | Volume Total de Avaliações | Avaliações | Σ rating_count | `df['rating_count'].sum()` | Q4 | |
| **M016** | Taxa Engajamento Feedback | Avaliações | Σ rating_count / Σ units_sold | `df['rating_count'].sum() / df['units_sold'].sum()` | Q4 | |
| **M017** | Proporção Avaliações 5★ | Avaliações | Σ rating_five / Σ rating_count | `df['rating_five_count'].sum() / df['rating_count'].sum()` | Q4 | |
| **M018** | Taxa de Detração (1★+2★) | Avaliações | Σ(rating_one+rating_two) / Σ rating_count | `(df['rating_one_count'].sum()+df['rating_two_count'].sum())/df['rating_count'].sum()` | Q4, Q5 | |
| **M019** | Índice Qualidade Ajustado (Bayes) | Avaliações | Rating bayesiano c/ peso amostral | `C=df['rating_count'].quantile(0.25); m=df['rating'].mean(); df['bayes_rating']=(df['rating_count']*df['rating']+m*C)/(df['rating_count']+C)` | Q4 | |
| **M036** | Assimetria de Avaliações | Avaliações | Skewness rating | `df['rating'].skew()` | Q4 | |
| **M043** | Concentração Melhores Notas | Avaliações | % volume vendido com rating > 4.5 | `df[df['rating']>4.5]['units_sold'].sum()/df['units_sold'].sum()*100` | Q4 | |
| **M058** | Satisfação Consumidor (CSAT) | ESG - Social | Σ rating_five / Σ rating_count | `df['rating_five_count'].sum() / df['rating_count'].sum()` | Q4 | |
| **M059** | Frustração Consumidor Ponderada | ESG - Social | (rating_one/rating_count) × price | `df['frustration_idx'] = (df['rating_one_count']/df['rating_count'])*df['price']` | Q5 | |
| **M063** | Autenticidade Rating Lojista | ESG - Gov | rating - merchant_rating | `df['rating_discrepancy'] = df['rating'] - df['merchant_rating']` | Q4 | |
| **M072** | Confiança de Conversão | Avaliações | units_sold / rating_count | `df['sales_per_review'] = df['units_sold']/(df['rating_count']+1)` | Q4 | |
| **M073** | Polarização do Produto | Avaliações | (rating_five+rating_one)/rating_count | `df['polarization'] = (df['rating_five_count']+df['rating_one_count'])/df['rating_count']` | Q5 | |
| **M074** | Nota Média Fria (Mediocridade) | Avaliações | rating_three / rating_count | `df['mediocrity_rate'] = df['rating_three_count']/df['rating_count']` | Q4 | |
| **M084** | Tração de Vendas Ativa | Performance | ln(units_sold+1)/ln(rating_count+1) | `df['log_traction'] = np.log(df['units_sold']+1)/np.log(df['rating_count']+1)` | Q4 | |
| **M096** | Conversão Boas Avaliações | Performance | (rating_four+rating_five)/units_sold | `df['good_review_conv'] = (df['rating_four_count']+df['rating_five_count'])/df['units_sold']` | Q4 | |
| **M101** | Limite Inferior Wilson Score | Estatística | Limite inferior proporção positivas (binomial) | `z=1.96; n=df['rating_count']; p=(df['rating_four_count']+df['rating_five_count'])/n; df['wilson_score']=(p+z**2/(2*n)-z*np.sqrt((p*(1-p)/n)+z**2/(4*n**2)))/(1+z**2/n)` | Q4 | |
| **M102** | Z-Score Volume Vendas | Estatística | (units_sold - μ)/σ | `df['z_score_sales'] = (df['units_sold']-df['units_sold'].mean())/df['units_sold'].std()` | Geral | |
| **M105** | Intensidade Rejeição Relativa | Analítica | rating_one / (rating_one+rating_five) | `df['relative_rejection'] = df['rating_one_count']/(df['rating_one_count']+df['rating_five_count'])` | Q5 | |
| **M110** | Cash Cow (BCG) | Matriz BCG | Vendas > P75 e Rating < média | `df['is_cash_cow'] = ((df['units_sold']>df['units_sold'].quantile(0.75))&(df['rating']<df['rating'].mean())).astype(int)` | Q5 | |
| **M111** | Estrela (BCG) | Matriz BCG | Vendas > P75 e Rating > P75 | `df['is_star_product'] = ((df['units_sold']>df['units_sold'].quantile(0.75))&(df['rating']>df['rating'].quantile(0.75))).astype(int)` | Q4 | |
| **M112** | Abacaxi/Dog (BCG) | Matriz BCG | Vendas < P25 e Rating < P25 | `df['is_dog_product'] = ((df['units_sold']<df['units_sold'].quantile(0.25))&(df['rating']<df['rating'].quantile(0.25))).astype(int)` | Q5 | |
| **M113** | Propensão a Fake Reviews | Governança | rating_count/units_sold > 0.5 | `df['suspicious_reviews'] = ((df['rating_count']/df['units_sold'].replace(0,1))>0.5).astype(int)` | Q4 | |
| **M118** | Quiet Quitters (Compradores Silenciosos) | Analítica | 1 - (rating_count/units_sold) | `df['quiet_buyer_rate'] = 1-(df['rating_count']/df['units_sold'].replace(0,1))` | Q5 | |
| **M131** | Concentração Opinião (Ame/Odeie) | Avaliações | (rating_one+rating_five)/rating_count | `df['love_hate_ratio'] = (df['rating_one_count']+df['rating_five_count'])/df['rating_count']` | Q5 | |
| **M132** | Middle-Ground Bias | Avaliações | (rating_three+rating_four)/rating_count | `df['middle_ground_bias'] = (df['rating_three_count']+df['rating_four_count'])/df['rating_count'].replace(0,1)` | Q5 | |
| **M143** | Taxa Avaliação Oculta | Avaliações | rating_count - Σ(rating_1..5) | `df['omitted_ratings'] = df['rating_count']-(df['rating_five_count']+df['rating_four_count']+df['rating_three_count']+df['rating_two_count']+df['rating_one_count'])` | Q4 | |
---
### BLOCO D — Logística / Transporte
| ID | Nome | Categoria | Fórmula | Python | SQ | ✅ |
|---|---|---|---|---|---|---|
| **M024** | Adoção Logística Expressa | Logística | % shipping_is_express = 1 | `df['shipping_is_express'].mean()*100` | Q2 | |
| **M025** | Preço Médio do Frete | Logística | Média shipping_option_price | `df['shipping_option_price'].mean()` | Q2 | |
| **M026** | Peso do Frete no Custo Total | Logística | Média(shipping/(price+shipping)×100) | `df['ship_weight'] = df['shipping_option_price']/(df['price']+df['shipping_option_price'])*100; df['ship_weight'].mean()` | Q2 | |
| **M051** | Risco Pegada Carbono Expresso | ESG - Ambiental | % shipping_is_express | `df['shipping_is_express'].mean()*100` | Q2 | |
| **M054** | Milhas Logísticas Estimadas | ESG - Ambiental | % origin_country = CN | `(df['origin_country']=='CN').mean()*100` | Q1 | |
| **M068** | Índice de Multinações (Global Reach) | Logística | Média countries_shipped_to | `df['countries_shipped_to'].mean()` | Q1, Q2 | |
| **M087** | Impacto Fast Shipping | Performance | GMV(badge_fast=1) vs GMV(badge_fast=0) | `gmv_fast = df[df['badge_fast_shipping']==1]['gmv'].mean(); gmv_slow = df[df['badge_fast_shipping']==0]['gmv'].mean(); gmv_fast/gmv_slow` | Q2 | |
| **M088** | Risco Falso Selo Expresso | Governança | (express=1) & (shipping<2) | `df['fake_express_risk'] = ((df['shipping_is_express']==1)&(df['shipping_option_price']<2)).astype(int)` | Q2 | |
| **M107** | Fator Atrito de Frete | Logística | shipping_price / price | `df['shipping_friction'] = df['shipping_option_price']/df['price']` | Q2 | |
| **M108** | Custo Aquisição Logística Absoluto | Logística | shipping_price × units_sold | `df['total_shipping_revenue'] = df['shipping_option_price']*df['units_sold']` | Q2 | |
| **M126** | Coef. Inflação Inventário | Logística | product_variation_inventory / inventory_total | `df['inventory_inflation_ratio'] = df['product_variation_inventory']/df['inventory_total']` | Geral | |
| **M133** | Eficiência Relativa do Frete | Logística | GMV / (shipping × units_sold) | `df['shipping_roi'] = df['gmv']/(df['shipping_option_price']*df['units_sold'])` | Q2 | |
| **M139** | Escassez Tática no Inventário | Logística | 1 se inventory_total < 5 | `df['tactical_scarcity'] = (df['inventory_total']<5).astype(int)` | Geral | |
---
### BLOCO E — ESG Ambiental
| ID | Nome | Categoria | Fórmula | Python | SQ | ✅ |
|---|---|---|---|---|---|---|
| **M050** | Índice Produção Local | ESG - Ambiental | % GMV com badge_local=1 | `gmv_local = df.loc[df['badge_local_product']==1,'gmv'].sum(); gmv_local/df['gmv'].sum()` | Q1 | |
| **M052** | Proxy Desperdício Têxtil | ESG - Ambiental | (inventory - units_sold)/inventory | `df['waste_risk'] = (df['inventory_total']-df['units_sold'])/df['inventory_total']; df['waste_risk'].mean()` | Q5 | |
| **M053** | Presença Materiais Ecológicos | ESG - Ambiental | 1 se tags contém termos eco | `eco_terms = ['cotton','eco','bamboo','recycled']; df['is_eco'] = df['tags'].str.lower().apply(lambda x: int(any(t in str(x) for t in eco_terms)))` | Q3 | |
| **M128** | Risco Falso Local (Geo-Spoofing) | Governança | (badge_local=1) & (origin=CN) | `df['geo_spoof_risk'] = ((df['badge_local_product']==1)&(df['origin_country']=='CN')).astype(int)` | Q1 | |
---
### BLOCO F — ESG Social
| ID | Nome | Categoria | Fórmula | Python | SQ | ✅ |
|---|---|---|---|---|---|---|
| **M055** | Densidade Badge Qualidade | ESG - Social | % badge_product_quality=1 | `df['badge_product_quality'].mean()*100` | Q4 | |
| **M056** | Índice Inclusividade Tamanho | ESG - Social | % tags contém "plus size" | `df['is_plus_size'] = df['tags'].str.lower().str.contains('plus size',na=False).astype(int); df['is_plus_size'].mean()*100` | Q-EXT1 | |
| **M057** | Risco Trabalho Injusto | ESG - Social | Σ units_sold onde price < 2 | `df.loc[df['price']<2,'units_sold'].sum()` | Q-EXT1 | |
| **M093** | Score de Confiança Base (Trust) | ESG - Social | 0.4×MR + 0.4×R + 0.2×Pic×5 | `df['trust_score'] = 0.4*df['merchant_rating'] + 0.4*df['rating'] + 0.2*df['merchant_has_profile_picture']*5` | Geral | |
| **M135** | Coef. Performance Vendedor | Lojista | % GMV com rating≥4 por lojista | `df['is_high_rated'] = df['rating']>=4; merchant_perf = df.groupby('merchant_id').apply(lambda x: x[x['is_high_rated']]['gmv'].sum()/x['gmv'].sum())` | Q4 | |
| **M140** | LTV Proxy Lojista | Financeiro | ASP × (merchant_rating/5) | `df['merchant_ltv_proxy'] = df.groupby('merchant_id')['price'].transform('mean')*(df['merchant_rating']/5)` | Geral | |
---
### BLOCO G — ESG Governança / Dark Patterns
| ID | Nome | Categoria | Fórmula | Python | SQ | ✅ |
|---|---|---|---|---|---|---|
| **M060** | Exposição a Dark Patterns (Urgency) | ESG - Gov | % has_urgency_banner=1 | `df['has_urgency_banner'].mean()*100` | Q5 | |
| **M061** | Lift Conversão por Escassez | ESG - Gov | mean(units_sold) c/ banner / sem banner | `mean_q_urg = df[df['has_urgency_banner_fix']==1]['units_sold'].mean(); mean_q_nourg = df[df['has_urgency_banner_fix']==0]['units_sold'].mean(); mean_q_urg/mean_q_nourg` | Q4 | |
| **M062** | Transparência Identidade Lojista | ESG - Gov | % merchants com foto perfil | `df.groupby('merchant_id')['merchant_has_profile_picture'].first().mean()*100` | Geral | |
| **M064** | Dependência Ad Boosts | ESG - Gov | % uses_ad_boosts=1 | `df['uses_ad_boosts'].mean()*100` | Q4 | |
| **M065** | Eficácia Ad Boost | Performance | mean(units_sold) c/ boost - sem boost | `ad_eff = df[df['uses_ad_boosts']==1]['units_sold'].mean() - df[df['uses_ad_boosts']==0]['units_sold'].mean()` | Q4 | |
| **M066** | Discrepância Qualidade em Ads | ESG - Gov | mean(rating) c/ boost - sem boost | `ad_rating_diff = df[df['uses_ad_boosts']==1]['rating'].mean() - df[df['uses_ad_boosts']==0]['rating'].mean()` | Q4 | |
| **M067** | Engajamento Texto Urgência | Marketing | Len(urgency_text) | `df['urgency_text_len'] = df['urgency_text'].str.len().fillna(0)` | Q5 | |
| **M077** | Intensidade de Badges | Atributos | Média badges_count | `df['badges_count'].mean()` | Q4 | |
| **M079** | Inventário "Fake" Limitado | Governança | % product_variation_inventory == 50 | `(df['product_variation_inventory']==50).mean()*100` | Geral | |
| **M119** | Rácio Impulsionamento (CAC Proxy) | Marketing | GMV / (1+AdBoost) | `df['ad_gmv_efficiency'] = df['gmv']/df['uses_ad_boosts'].replace(0,np.nan)` | Q4 | |
| **M124** | Tração Urgency Text | Marketing | mean(units_sold) c/ urgency_text | `df[df['urgency_text'].notna()]['units_sold'].mean()` | Q5 | |
| **M125** | Diferencial Ad Boost | Marketing | units_sold(boost=1) - median(units_sold(boost=0)) | `med = df[df['uses_ad_boosts']==0]['units_sold'].median(); df['ad_value_add'] = np.where(df['uses_ad_boosts']==1, df['units_sold']-med, 0)` | Q4 | |
| **M127** | Vantagem Competitiva Selos | Marketing | Slope regressão badges_count × units_sold | `from scipy.stats import linregress; badge_adv = linregress(df['badges_count'], df['units_sold']).slope` | Q4 | |
| **M137** | Freeloader Index (Lojistas) | Governança | % GMV em ads / GMV total por lojista | `merchant_ad_dep = df.groupby('merchant_id').apply(lambda x: x[x['uses_ad_boosts']==1]['gmv'].sum()/x['gmv'].sum())` | Q4 | |
---
### BLOCO H — Atributos / Lojista
| ID | Nome | Categoria | Fórmula | Python | SQ | ✅ |
|---|---|---|---|---|---|---|
| **M020** | Média Produtos Listados/Vendedor | Lojista | Média listed_products p/ merchant | `df.groupby('merchant_id')['listed_products'].first().mean()` | Geral | |
| **M021** | Índice Reputação Lojista | Lojista | Média merchant_rating | `df.groupby('merchant_id')['merchant_rating'].first().mean()` | Geral | |
| **M022** | Concentração Mercado (HHI) | Lojista | Σ(market_share%)² | `m_gmv = df.groupby('merchant_id').apply(lambda x: (x['price']*x['units_sold']).sum()); shares = (m_gmv/m_gmv.sum())*100; (shares**2).sum()` | Geral | |
| **M023** | Eficiência Vendas/Catálogo | Lojista | Σ units_sold / Σ listed_products | `merchant_stats = df.groupby('merchant_id').agg({'units_sold':'sum','listed_products':'first'}); merchant_stats['units_sold'].sum()/merchant_stats['listed_products'].sum()` | Geral | |
| **M027** | Penetração Badge Local | Logística | % badge_local_product=1 | `df['badge_local_product'].mean()*100` | Q1 | |
| **M028** | Taxa Badge Qualidade | Logística | % badge_product_quality=1 | `df['badge_product_quality'].mean()*100` | Q4 | |
| **M029** | Variedade Tamanhos | Atributos | N unique product_variation_size_id | `df['product_variation_size_id'].nunique()` | Geral | |
| **M030** | Dominância Cores Catálogo | Atributos | % cor mais frequente | `df['product_color'].value_counts(normalize=True).iloc[0]*100` | Q3 | |
| **M031** | Densidade de Tags | Atributos | Média comprimento lista tags | `df['tag_count'] = df['tags'].apply(lambda x: len(str(x).split(','))); df['tag_count'].mean()` | Geral | |
| **M032** | Conversão por Foto Lojista | Atributos | mean(units_sold) c/ foto vs sem | `df.groupby('merchant_has_profile_picture')['units_sold'].mean()` | Geral | |
| **M033** | Índice Sucesso Vendas Verão | Atributos | 1 se units_sold > P75 | `df['is_top_seller'] = (df['units_sold']>df['units_sold'].quantile(0.75)).astype(int)` | Geral | |
| **M082** | Diversidade Oferta Lojista | Lojista | N unique product_id por merchant | `df.groupby('merchant_id')['product_id'].nunique()` | Geral | |
| **M083** | Lojistas Nicho Único | Lojista | N merchants com 1 produto | `merchant_diversity = df.groupby('merchant_id')['product_id'].nunique(); (merchant_diversity==1).sum()` | Geral | |
| **M089** | Popularidade Cor Preta/Branca | Atributos | % cor em [black,white] | `df['is_basic_color'] = df['product_color'].isin(['black','white']).astype(int); df['is_basic_color'].mean()` | Q3 | |
| **M116** | Variância Qualidade Catálogo | Lojista | Var(rating) por merchant | `df.groupby('merchant_id')['rating'].var().fillna(0)` | Q4 | |
| **M120** | Retenção Qualidade Vendedor | Lojista | rating / merchant_rating | `df['product_merchant_rating_ratio'] = df['rating']/df['merchant_rating']` | Q4 | |
| **M121** | Entropia de Cores | Estatística | -Σ p(c) × ln(p(c)) | `color_probs = df['product_color'].value_counts(normalize=True); -(color_probs*np.log(color_probs)).sum()` | Q3 | |
| **M122** | Entropia de Tamanhos | Estatística | -Σ p(s) × ln(p(s)) | `size_probs = df['product_variation_size_id'].value_counts(normalize=True); -(size_probs*np.log(size_probs)).sum()` | Geral | |
| **M123** | Gini de Faturamento | Estatística | Índice Gini sobre GMV merchants | `v = df.groupby('merchant_id')['gmv'].sum().sort_values().values; n=len(v); gini = (2*np.sum(np.arange(1,n+1)*v))/(n*np.sum(v))-(n+1)/n` | Geral | |
| **M136** | Velocidade Avaliação (Review Vel.) | Analítica | rating_count / ln(merchant_rating_count) | `df['review_velocity_proxy'] = df['rating_count']/np.log(df['merchant_rating_count']+2)` | Geral | |
| **M138** | Saturação Cores Primárias | Atributos | % cor em [red,blue,yellow] | `primary_colors = ['red','blue','yellow']; df['is_primary_color'] = df['product_color'].str.lower().isin(primary_colors).astype(int)` | Q3 | |
---
### BLOCO I — Externas / Constantes (sem coluna na tabela)
| ID | Nome | Categoria | Fórmula | Python | SQ | ✅ |
|---|---|---|---|---|---|---|
| **M040** | Proporção Títulos Traduzidos | Atributos | % title != title_orig | `df['has_translation'] = (df['title']!=df['title_orig']).astype(int); df['has_translation'].mean()*100` | Geral | |
| **M075** | Penetração Moeda Forte | Financeiro | % currency_buyer == EUR | `(df['currency_buyer']=='EUR').mean()*100` | Geral | |
| **M080** | Sazonalidade Focada | Atributos | % theme == summer | `(df['theme']=='summer').mean()*100` | Geral | |
| **M081** | Sobrecarga Título (Spam SEO) | Marketing | 1 se len(title) > 100 | `df['seo_spam'] = (df['title'].str.len()>100).astype(int)` | Geral | |
| **M090** | Padronização Título Lojista | Lojista | 1 se merchant_title == merchant_name | `df['merchant_name_match'] = (df['merchant_title']==df['merchant_name']).astype(int)` | Geral | |
| **M091** | Maturidade Lojista | Lojista | Média merchant_rating_count | `df.groupby('merchant_id')['merchant_rating_count'].first().mean()` | Geral | |
| **M092** | Otimização Imagem Principal | Atributos | 1 se product_picture contém 'contestimg' | `df['valid_cdn'] = df['product_picture'].str.contains('contestimg').astype(int)` | Geral | |
| **M094** | Elasticidade de Tags | SEO | Corr(tag_count, GMV) | `corr_tags_gmv = df['tag_count'].corr(df['gmv'])` | Geral | |
| **M097** | Sobrecarga Legenda Lojista | Marketing | Len(merchant_info_subtitle) | `df['merchant_subtitle_len'] = df['merchant_info_subtitle'].str.len().fillna(0)` | Geral | |
| **M098** | Índice Repetição Nome | SEO | 1 se merchant_name in title | `df['brand_in_title'] = df.apply(lambda x: 1 if str(x['merchant_name']).lower() in str(x['title']).lower() else 0, axis=1)` | Geral | |
| **M099** | Eficiência Coleta Scraper | Governance | Σ currency_buyer nulo | `df['currency_buyer'].isna().sum()` | Geral | |
| **M117** | Fator Inflação Título | NLP | len(title)/len(title_orig) | `df['title_inflation_ratio'] = df['title'].str.len()/df['title_orig'].str.len().replace(0,1)` | Geral | |
| **M129** | Densidade Palavras-Chave Título | NLP | N palavras no título | `df['title_word_count'] = df['title'].str.split().str.len()` | Geral | |
| **M130** | Repetição Tags "women" | NLP | % tags com "women" | `df['women_tag_ratio'] = df['tags'].str.lower().apply(lambda x: str(x).count('women')/max(1,len(str(x).split(','))))` | Geral | |
| **M142** | Gap Tradução e Engajamento | NLP | GMV(traduzido) - GMV(não traduzido) | `gmv_t = df[df['title']!=df['title_orig']]['gmv'].mean(); gmv_nt = df[df['title']==df['title_orig']]['gmv'].mean(); gmv_t - gmv_nt` | Geral | |
| **M144** | Sobrecarga Subtítulo Promocional | Marketing | len(merchant_info_subtitle)/100 | `df['merchant_subtitle_load'] = df['merchant_info_subtitle'].str.len().fillna(0)/100` | Geral | |
---
## SECÇÃO 5 — MAPA SMART → PERGUNTAS → MÉTRICAS
| SMART | Pergunta | ID Métricas Prioritárias |
|---|---|---|
| **SMART 1** — Concentração geográfica | Q1 | M027, M050, M054, M068, M128 |
| **SMART 2** — CO₂ transporte por modo e preço | Q2 | M025, M026, M051, M069, M107, M108, M133 |
| **SMART 3** — Cores vs. poluição de tingimento | Q3 | M030, M089, M121, M138 |
| **SMART 4** — Rating elevado = mais lucro? | Q4 | M014, M018, M028, M043, M055, M061, M065, M077, M127 |
| **SMART 5** — Preço baixo = descarte rápido? | Q5 | M003, M011, M044, M052, M059, M073, M105, M110, M118 |
### Mapa Visual: Qual métrica responde a que pergunta
| Q | Métricas Core | Métricas Secundárias |
|---|---|---|
| **Q1** | M050, M054, M068, M128 | M027, M051, M087 |
| **Q2** | M025, M026, M051, M069, M107 | M024, M068, M070, M088, M095, M108, M133 |
| **Q3** | M030, M089, M138 | M121 |
| **Q4** | M014, M018, M028, M043, M055, M061, M065, M077 | M015, M017, M019, M036, M044, M058, M063, M072, M084, M096, M101, M116, M120, M127, M135 |
| **Q5** | M011, M044, M052, M059, M105, M110, M118 | M003, M012, M042, M073, M113, M131, M132 |
---
> **Nota:** Este documento consolida tudo o que está disperso por 7+ ficheiros (`business_goal.md`, `analysis_subquestions.md`, `variables_definition.md`, `data_treatment_log.md`, `types.md`, `checklist_metricas_formulas.md`, `observacoes_externas.md`) num único sítio. Usa a coluna ✅ para ires selecionando as métricas que farão parte da análise final.
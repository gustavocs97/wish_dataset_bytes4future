# Relatório de Tratamento de Dados
**Projeto Final — Data Analyst Junior · Bytes4Future**
**Dataset:** Sales of Summer Clothes — Wish Platform (Kaggle, agosto 2020)
**Ferramenta:** Power Query (Excel / Power BI)
**Data:** 19 de maio de 2025

---

## O que é este documento

Explica, passo a passo, cada transformação aplicada ao dataset original.
Para cada passo: o que foi feito, porquê foi feito, e qual coluna foi criada.

**Regra seguida em todos os passos:**
Os dados originais nunca foram apagados.
Cada correcção criou uma coluna nova com o sufixo `Fix`.
O ficheiro `raw/` permanece intocável.

---

## Resumo Geral — O que entrou e o que saiu

| | Antes | Depois |
|---|---|---|
| Linhas | 1.573 | 1.341 *(duplicados removidos)* |
| Colunas originais | 43 | 39 *(4 removidas)* |
| Colunas Fix criadas | 0 | 20 |
| Colunas totais no dataset limpo | 43 | 59 |

---

## PASSO 1 — Carregar o ficheiro

**O que foi feito:**
O ficheiro `Summer_Products.csv` foi importado com encoding UTF-8.

**Porquê UTF-8:**
O dataset foi extraído com interface francesa — contém caracteres
não-ASCII como `é`, `à`, `ê` nos títulos e textos.
Sem UTF-8, esses caracteres aparecem corrompidos.

**Resultado:** 1.573 linhas · 43 colunas carregadas correctamente.

---

## PASSO 2 — Corrigir tipos de dados

**O que foi feito:**
Cada coluna recebeu o tipo de dado correcto.

| Coluna | Tipo atribuído | Porquê |
|---|---|---|
| `price` | Número decimal | Tem casas decimais (ex: €3.99) |
| `retail_price` | Número inteiro | Sempre valor inteiro |
| `units_sold` | Número inteiro | Buckets sem decimais |
| `rating` | Número decimal | Ex: 3.84, 4.56 |
| `rating_count` | Número inteiro | Contagem de avaliações |
| `rating_*_count` | Número inteiro | Contagem por estrela |
| `badges_count` | Número inteiro | Soma de badges (0, 1, 2 ou 3) |
| `shipping_option_price` | Número inteiro | Preço de frete sem decimais |
| `countries_shipped_to` | Número inteiro | Contagem de países |
| `merchant_rating` | Número decimal | Ex: 4.03 |
| `merchant_rating_count` | Número inteiro | Contagem de avaliações |
| `product_id` | Texto | Identificador — não é número |
| `merchant_id` | Texto | Identificador — não é número |
| `crawl_month` | Data | Formato YYYY-MM |

**Porquê isto importa:**
Se `price` ficasse como Texto, não seria possível calcular descontos.
Se `product_id` ficasse como número, zeros à esquerda seriam perdidos.

---

## PASSO 3 — Adicionar índice

**O que foi feito:**
Criada coluna `Index_novo` com numeração sequencial de 1 a 1.573.

**Porquê:**
Permite rastrear a posição original de cada linha antes de qualquer
ordenação ou filtro. Útil para auditoria e validação de resultados.

---

## PASSO 4 — Remover duplicados

**O que foi feito:**
Aplicado `Table.Distinct` com base na coluna `product_id`.
1.573 linhas → **1.341 linhas** (232 duplicados removidos).

**Porquê existem duplicados:**
O criador do dataset fez o scraping em múltiplos momentos da mesma
pesquisa. O Wish (baseado em Elasticsearch) repete produtos ao longo
do scroll da página. Além disso, o Wish faz testes A/B constantes —
o mesmo produto pode aparecer com e sem urgency banner em linhas diferentes.

**Regra de negócio aplicada:**
Mantida a linha com `urgency_text` preenchido quando existe duplicado.
Motivo: o objectivo é analisar o impacto de mecanismos de impulso de compra
— a versão com banner é a mais relevante para esse fim.

**Alternativa rejeitada:**
Manter a primeira ocorrência sem critério — perderia informação de banners.

---

## PASSO 5 — `units_sold_EscalaFix` — Escala ordinal de vendas

**Coluna original:** `units_sold`
**Coluna criada:** `units_sold_EscalaFix`

**Problema:**
`units_sold` não são valores reais — são buckets que o Wish usa para
mostrar popularidade (10, 50, 100, 1000, 10000...).
Tratar como número contínuo geraria correlações matematicamente correctas
mas analiticamente falsas.

**O que foi feito:**
Convertido para escala ordinal de 6 níveis:

| Nível | Intervalo | Interpretação |
|---|---|---|
| 1. Micro(10) | ≤ 10 | Volume muito baixo |
| 2. Baixo(100) | 11 – 100 | Volume baixo |
| 3. Médio(1000) | 101 – 1.000 | Volume médio |
| 4. Alto(10000) | 1.001 – 10.000 | Volume alto |
| 5. Muito Alto(20000) | 10.001 – 20.000 | Volume muito alto |
| 6. Crítico(>20000) | > 20.000 | Volume crítico |

**Alternativa rejeitada:**
Log transform — não resolve o problema de origem. Os valores são
categorias disfarçadas de números, não medições reais.

---

## PASSO 6 — `rating_Base1000Fix` — Rating normalizado

**Coluna original:** `rating`
**Coluna criada:** `rating_Base1000Fix`

**O que foi feito:**
`rating × 100 × 2` — converte a escala de 0–5 para 0–1000.

**Porquê:**
Facilita comparações visuais em gráficos e dashboards.
Um rating de 3.5 → 700 pontos. Mais intuitivo para o espectador
sem conhecimento técnico.

**Nota:** o `rating` original é mantido para análises directas.

---

## PASSO 7 — `product_color_GroupedColourFix` — Agrupamento simples de cores

**Coluna original:** `product_color`
**Coluna criada:** `product_color_GroupedColourFix`

**Problema:**
101 valores únicos de cor — impossível analisar sem agrupar.
Exemplos: "coolblack", "offblack", "Black", "BLACK" são todos preto.

**O que foi feito:**
Agrupamento por família de cor em 12 categorias:

| Grupo | Exemplos incluídos |
|---|---|
| Preto | black, coolblack, offblack |
| Branco | white, offwhite, ivory |
| Cinzento | gray, grey, lightgray, silver |
| Vermelho | red, wine, claret, burgundy, rosered |
| Azul | blue, navy, darkblue, skyblue, prussianblue |
| Verde | green, army, darkgreen, armygreen, jasper |
| Rosa | pink, rose, rosegold, lightpink |
| Roxo | purple, violet |
| Laranja/Amarelo | orange, yellow, gold |
| Tons Neutros | beige, khaki, brown, coffee, camel, tan, nude |
| Multicor/Estampado | &, stripe, print, multicolor, floral, camouflage |
| Não Informado | vazio ou null |

---

## PASSO 8 — `product_color_GroupedByImpactFix` — Agrupamento por impacto

**Coluna criada:** `product_color_GroupedByImpactFix`

**O que foi feito:**
Mesmo agrupamento do Passo 7 mas com lógica mais granular —
inclui casos específicos adicionais como `leopard`, `rainbow`, `star`.

**Porquê duas colunas de cor:**
`GroupedColourFix` — análise geral de distribuição de cores.
`GroupedByImpactFix` — análise de impacto ambiental por cor
(tinturaria, processos de acabamento, materiais envolvidos).

---

## PASSO 9 — `urgency_textTierFix` — Tipo de banner de urgência

**Coluna original:** `urgency_text`
**Coluna criada:** `urgency_textTierFix`

**O que foi feito:**
Categorizado o texto bruto do banner em 4 tipos:

| Tier | Texto original | Significado |
|---|---|---|
| Scarcity | "Quantité limitée !" | Pressão por escassez — "quase esgotado" |
| Bulk_Purchase | "Réduction sur les achats en gros" | Desconto por quantidade |
| None | vazio / null | Sem banner |
| Others | qualquer outro texto | Texto não mapeado |

**Porquê:**
O texto bruto em francês não é utilizável directamente em análises.
A categorização permite comparar o impacto de cada tipo de pressão
de compra no volume de vendas.

---

## PASSO 10 — Badges como booleanos

**Colunas originais:** `badges_count`, `badge_local_product`,
`badge_product_quality`, `badge_fast_shipping`, `uses_ad_boosts`

**Colunas criadas:** `badges_countFix`, `badge_local_productFix`,
`badge_product_qualityFix`, `badge_fast_shippingFix`, `uses_ad_boostsFix`

**O que foi feito:**
Convertidas de número inteiro (0/1) para tipo lógico (TRUE/FALSE).

**Porquê:**
Facilita filtragem e visualização em Power BI.
Um gráfico de "% com badge" é mais imediato com booleano do que com 0/1.

**Atenção documentada:**
`badges_countFix` NÃO deve ser usado simultaneamente com as colunas
individuais em modelos — são a mesma informação (multicolinearidade).
`badge_fast_shipping` é atributo do merchant, não do produto.
As outras duas são atributos do produto individual.

---

## PASSO 11 — `shipping_option_nameFix` — Nome do frete normalizado

**Coluna original:** `shipping_option_name`
**Coluna criada:** `shipping_option_nameFix`

**Problema:**
O mesmo tipo de frete aparece em múltiplos idiomas:
"Livraison standard" (FR), "Spedizione standard" (IT),
"Standardversand" (DE), "Envio padrão" (PT)...

**O que foi feito:**
Normalizado para 3 categorias em inglês:
- `Standard Delivery` — frete padrão
- `Express Delivery` — frete expresso
- `Standard Shipping` — variações de padrão em outros idiomas

**Porquê:**
Sem normalização, uma análise de tipo de frete teria 15+ categorias
para o mesmo conceito — impossível de visualizar.

---

## PASSO 12 — `shipping_option_priceFix` — Escalas de preço de frete

**Coluna original:** `shipping_option_price`
**Coluna criada:** `shipping_option_priceFix`

**O que foi feito:**
Preço do frete categorizado em 4 níveis:

| Nível | Intervalo | Interpretação |
|---|---|---|
| 1. Grátis | €0 | Frete gratuito |
| 2. Barato | €1 – €5 | Frete económico |
| 3. Médio | €6 – €15 | Frete médio |
| 4. Caro | > €15 | Frete premium |

**Porquê:**
Facilita comparações visuais no dashboard.
O valor exacto do frete tem pouco significado isolado —
a categoria comunica melhor a relação custo/distância.

---

## PASSO 13 — `shipping_is_expressFix` — Tipo de envio

**Coluna original:** `shipping_is_express`
**Coluna criada:** `shipping_is_expressFix`

**O que foi feito:**
Convertido de número (0/1) para texto com ordem:
- `1. Express` — envio expresso (geralmente aéreo)
- `2. Normal` — envio padrão

**Nota:**
Apenas 4 produtos (0.3%) têm envio expresso — estatisticamente
irrelevante mas mantido para completude da análise.

---

## PASSO 14 — `product_variation_size_idFix` — Tamanhos normalizados

**Coluna original:** `product_variation_size_id`
**Coluna criada:** `product_variation_size_idFix`

**Problema:**
O mesmo tamanho aparece em dezenas de formatos:
"S", "s", "Size S", "SIZE S", "Size-S", "S.", "S..", "US-S"...

**O que foi feito:**
Normalizado em 17 categorias ordenadas:

| Categoria | Exemplos |
|---|---|
| 00. Não Informado | vazio, "choose a size" |
| 01. Infantil | child, baby, years |
| 02. Tamanho Único | one size |
| 03. PP (XXXS) | XXXS |
| 04. PP (XXS) | XXS, Size XXS |
| 05. P (XS) | XS, Size-XS |
| 06. P (S) | S, Size S, SIZE S, US-S |
| 07. M | M, Size M |
| 08. G (L) | L, Size-L, SizeL |
| 09. GG (XL) | XL |
| 10. XG (2XL) | XXL, 2XL |
| 11. Plus Size (3XL) | 3XL, XXXL |
| 12–14. Plus Size (4–6XL) | 4XL, 5XL, 6XL |
| 15. Calçados/Numerações | EU35, US6, 36, 29... |
| 16. Outros Itens | cm, pcs, ml, objetos |
| 17. Outros | casos não mapeados |

---

## PASSO 15 — `tagsTypesFix` — Tipo de peça de roupa

**Coluna original:** `tags`
**Coluna criada:** `tagsTypesFix`

**Problema:**
A coluna `tags` é texto livre com múltiplas tags separadas por vírgula.
Não existe coluna de categoria no dataset — as tags são a única forma
de identificar o tipo de produto.

**O que foi feito:**
Dicionário de 100+ tags mapeadas para categorias de peça:
Vestido, Camiseta, Blusa, Shorts, Biquíni, Moda Praia, Pijama,
Cardigan, Macacão, Regata, Top, Colete, Camisa, Jeans, etc.

**Lógica:**
Para cada produto, percorre todas as suas tags e devolve
as categorias correspondentes separadas por vírgula.

**Limitação declarada:**
Tags são preenchidas pelos sellers — podem estar incorrectas ou
ambíguas (RFIX_002). Resultado é uma estimativa, não classificação exacta.

---

## PASSO 16 — `tagsMaterialFix` — Material estimado da peça

**Coluna original:** `tags`
**Coluna criada:** `tagsMaterialFix`

**O que foi feito:**
Dicionário de 200+ tags mapeadas para materiais/fibras têxteis prováveis:

| Material | Tags que indicam |
|---|---|
| Algodão | cotton, t-shirt, casual, military |
| Poliéster | chiffon, print, party dress, ruffled |
| Nilon/Elastano | bikini, swimwear, sportwear, yoga |
| Viscose | maxi dress, loose dress, kimono |
| Denim | jeans, denim, overalls |
| Renda | lace, lace top, lace shirts |
| Misto | a maioria das peças — combinações |

**Porquê isto é central para a análise ESG:**
Permite estimar a composição de fibras do dataset —
fibras sintéticas (poliéster, nilon) têm impacto ambiental
significativamente maior na produção e no descarte.
Esta coluna liga os dados de produto ao objectivo de negócio.

**Limitação declarada:**
É uma estimativa por tags — não é o material declarado pelo seller.
Usado como proxy, não como facto verificado.

---

## PASSO 17 — `has_urgency_bannerFix` — Banner de urgência

**Coluna original:** `has_urgency_banner`
**Coluna criada:** `has_urgency_bannerFix`

**O que foi feito:**
Convertido de número (0/1/null) para booleano (TRUE/FALSE).
Null → FALSE (ausência de banner, não dado em falta).

**Porquê:**
`has_urgency_banner` é uma flag criada pelo próprio autor do dataset
para facilitar o tratamento de nulos de `urgency_text`.
As duas colunas representam a mesma informação —
não usar ambas simultaneamente em modelos.

---

## PASSO 18 — `origin_countryFix` — País de origem

**Coluna original:** `origin_country`
**Coluna criada:** `origin_countryFix`

**O que foi feito:**
17 registos com valor vazio → substituídos por `nao_informado`.

**Porquê "nao_informado" e não "CN":**
96% dos produtos são chineses — imputar CN seria especular.
Para o cálculo de distância de frete, estes 17 registos são excluídos.

---

## PASSO 19 — `retail_price_DifFix` — Relação price vs retail_price

**Colunas originais:** `price`, `retail_price`
**Coluna criada:** `retail_price_DifFix`

**O que foi feito:**
Categorização da relação entre os dois preços:
- `retail_maior` — retail_price > price (desconto real)
- `price_maior` — price > retail_price (bug de moedas — RFIX_021)
- `iguais` — sem desconto

**Porquê:**
Em 35% dos casos `price > retail_price`.
O criador do dataset confirmou: é um bug de moedas misturadas
durante o scraping — não é estratégia de preço nem efeito COVID.
Esta coluna identifica claramente os três casos para que a análise
de desconto exclua os casos de bug.

---

## PASSO 20 — `retail_price_DIFP_Fix` — Percentagem de diferença de preço

**Coluna criada:** `retail_price_DIFP_Fix`

**O que foi feito:**
`((retail_price - price) / price) × 100`
Calcula a percentagem de diferença entre retail e price.

**Nota:**
Diferente de `discount_pct` — aqui a base é o `price`, não o `retail_price`.
Mede o quanto o retail_price está acima do price em termos relativos.
Útil para analisar a magnitude da "ilusão de desconto" percebida pelo consumidor.

---

## PASSO 21 — Colunas removidas

**O que foi feito:**
Removidas colunas sem valor analítico para o objectivo do projecto:

| Coluna removida | Motivo |
|---|---|
| `title` | Substituída por `title_orig` |
| `currency_buyer` | 100% EUR — sem variação |
| `has_urgency_banner` | Substituída por `has_urgency_bannerFix` |
| `urgency_text` | Substituída por `urgency_textTierFix` |
| `product_variation_size_id` | Substituída por `product_variation_size_idFix` |
| `origin_country` | Substituída por `origin_countryFix` |
| `merchant_info_subtitle` | Texto bruto em francês — não analítico |
| `merchant_title` | Não relevante para a análise |
| `merchant_name` | Não relevante para a análise |
| `shipping_option_name` | Substituída por `shipping_option_nameFix` |
| `badges_count` | Substituída por `badges_countFix` |
| `badge_local_product` | Substituída por `badge_local_productFix` |
| `badge_product_quality` | Substituída por `badge_product_qualityFix` |
| `badge_fast_shipping` | Substituída por `badge_fast_shippingFix` |
| `shipping_option_price` | Substituída por `shipping_option_priceFix` |
| `shipping_is_express` | Substituída por `shipping_is_expressFix` |
| `merchant_id` | Identificador — não analítico |
| `merchant_has_profile_picture` | Não central para a análise |
| `merchant_profile_picture` | 85.6% nulos — sem valor |
| `product_url` | URL — não analítico |
| `product_picture` | URL — não analítico |
| `theme` | 100% "summer" — sem variação |
| `crawl_month` | 100% "2020-08" — sem variação |

---

## PASSO 22 — Reordenação de colunas

**O que foi feito:**
Colunas reorganizadas em ordem lógica:
1. Identificadores (`product_id`, `Index_novo`)
2. Dados do produto (preço, vendas, rating)
3. Dados de seller (merchant_rating)
4. Tags (tipo e material)
5. Colunas Fix (todas as correcções)

**Porquê:**
Facilita a navegação no Power BI e nas análises SQL.
Analistas e apresentadores encontram rapidamente o que procuram.

---

## Resumo Final — Todas as Colunas Fix Criadas

| Coluna Fix | Baseada em | O que resolve |
|---|---|---|
| `units_sold_EscalaFix` | `units_sold` | Buckets → escala ordinal de 6 níveis |
| `rating_Base1000Fix` | `rating` | Escala 0-5 → escala 0-1000 |
| `product_color_GroupedColourFix` | `product_color` | 101 cores → 12 grupos |
| `product_color_GroupedByImpactFix` | `product_color` | 101 cores → grupos por impacto |
| `urgency_textTierFix` | `urgency_text` | Texto bruto → 4 categorias |
| `badges_countFix` | `badges_count` | Int → booleano |
| `badge_local_productFix` | `badge_local_product` | Int → booleano |
| `badge_product_qualityFix` | `badge_product_quality` | Int → booleano |
| `badge_fast_shippingFix` | `badge_fast_shipping` | Int → booleano |
| `uses_ad_boostsFix` | `uses_ad_boosts` | Int → booleano |
| `shipping_option_nameFix` | `shipping_option_name` | 15+ idiomas → 3 categorias EN |
| `shipping_option_priceFix` | `shipping_option_price` | Preço → 4 níveis |
| `shipping_is_expressFix` | `shipping_is_express` | Int → texto ordenado |
| `product_variation_size_idFix` | `product_variation_size_id` | Caos → 17 categorias |
| `tagsTypesFix` | `tags` | Tags livres → tipo de peça |
| `tagsMaterialFix` | `tags` | Tags livres → material estimado |
| `has_urgency_bannerFix` | `has_urgency_banner` | Int/null → booleano |
| `origin_countryFix` | `origin_country` | Null → "nao_informado" |
| `retail_price_DifFix` | `price` + `retail_price` | Relação price vs retail |
| `retail_price_DIFP_Fix` | `price` + `retail_price` | % diferença de preço |

---

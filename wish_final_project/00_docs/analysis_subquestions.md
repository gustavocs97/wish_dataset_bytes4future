# Analysis Subquestions
**Projeto Final — Data Analyst Junior**
**Grupo:** Letícia · Ricardo · Gustavo
**Dataset:** Sales of Summer Clothes — Wish Platform (Kaggle, agosto 2020)
**Data:** 21 de maio de 2026
---
## Questão Principal
> *"Analisar os padrões de consumo na plataforma Wish que geram impacto
> ambiental negativo e definir métricas sustentáveis capazes de orientar
> práticas mais ecológicas sem comprometer o lucro."*
As 5 subquestões abaixo decompõem esta questão em análises específicas,
cada uma respondível com os dados disponíveis e/ou fontes externas declaradas.
---
## Q1 — Qual o impacto desta concentração geográfica?
**Pergunta:**
*"96,4% dos produtos vêm da China. O que significa esta concentração
para a cadeia de abastecimento, para o consumidor europeu e para o
ambiente?"*
**Hipótese:**
A dependência quase total de um único país de origem (CN) expõe a
plataforma a risco logístico, concentra a pegada carbónica numa rota
única (~9.200 km) e contradiz o conceito de "produto local".
**Colunas usadas:**
`origin_country_fix` · `countries_shipped_to` · `badge_local_product`
· `distance_km`
**Notebook:** `Pergunta_1.ipynb`
**Dados de suporte:**
| País | % produtos | Distância até Paris |
|---|---|---|
| CN | 96,4% (1.516) | 9.200 km |
| US | 2,0% (31) | 8.500 km |
| Outros | 1,6% (26) | Variável |
| Desconhecido | 17 registos | N/A |
- `countries_shipped_to` médio: 40,46 países
- Produtos "locais" (`badge_local_product` = 1) são 100% chineses
- Correlação `countries_shipped_to` × `units_sold`: praticamente nula
**Métricas M relevantes:** M054 (milhas logísticas), M068 (índice
multinações), M050 (produção local), M128 (risco falso local)
**Visualização sugerida:**
Gráfico de barras: % de produtos por país de origem, com destaque
para a dominância da China. Segundo gráfico: distribuição de
`countries_shipped_to` (alcance global).
**Conclusão esperada:**
A cadeia de abastecimento do Wish é mono-origem. O badge "local"
não corresponde à realidade — é marketing, não sustentabilidade.
O risco ambiental e logístico está concentrado numa única rota.
---
## Q2 — Qual o impacto ambiental do transporte?
**Pergunta:**
*"Que volume de CO₂ está associado ao transporte dos produtos Wish
até ao consumidor europeu — e como varia por modo de transporte e
faixa de preço?"*
**Hipótese:**
O transporte aéreo (usado em envios expressos ou de curta distância)
emite significativamente mais CO₂ por km do que o marítimo. O impacto
ambiental do transporte não é homogéneo — depende do modo, da distância
e do volume de vendas.
**Colunas usadas:**
`origin_country_fix` · `distance_km` · `price` · `units_sold`
**Fonte externa:**
`CO2_transporte.csv` — fatores de emissão por modo de transporte
(avião: 244 g CO₂/pkm, comboio: 31 g CO₂/pkm, navio: 15 g CO₂/pkm,
camisão: 62 g CO₂/pkm)
**Notebook:** `Pergunta_co2.ipynb`
**Dados de suporte:**
- 96,4% dos produtos percorrem ~9.200 km (China → Europa)
- Matriz CO₂ total estimado por faixa de preço × modo de transporte
- Produtos mais baratos (< €5) tendem a usar transporte marítimo
  (menos CO₂ por km, mas maior volume absoluto)
**Métricas M relevantes:** M025 (preço médio frete), M026 (peso do
frete no custo total), M051 (risco pegada carbono expresso)
**Visualização sugerida:**
Heatmap/matriz: faixa de preço (eixo X) × modo de transporte (eixo Y)
com total de CO₂ em toneladas (cor). Destacar o contraste avião vs.
marítimo dentro da mesma faixa de preço.
**Conclusão esperada:**
O CO₂ do transporte é dominado por uma combinação de distância
(CN → Europa ~9.200 km) e volume de vendas. O modo de transporte
(navio vs. avião) é o maior fator de diferenciação por kg de CO₂.
---
## Q3 — As cores que mais vendem são as mais poluentes?
**Pergunta:**
*"As cores mais vendidas no Wish (preto, branco) exigem processos de
tingimento com maior impacto ambiental — e a plataforma privilegia
estas cores no seu catálogo?"*
**Hipótese:**
Cores escuras (preto) e branco dominam as vendas. O tingimento de
preto exige mais água e produtos químicos; o branco exige mais
branqueadores. A optimização de portfolio da plataforma favorece
cores de alto impacto ambiental sem o refletir no preço.
**Colunas usadas:**
`product_color_fix` · `units_sold` · `price` · `rating`
· `rating_one_count` · `rating_two_count`
**Notebook:** `Pergunta_5.ipynb`
**Dados de suporte:**
- Top 5 cores: black (302), white (254), yellow (105), blue (99), pink (99)
- Cores neutras/básicas (preto+branco) representam ~35% do catálogo
- Correlação entre cor e taxa de reclamação (1★+2★)
**Métricas M relevantes:** M030 (dominância cores catálogo), M089
(popularidade cor preta/branca), M138 (saturação cores primárias)
**Visualização sugerida:**
Gráfico de barras: unidades vendidas por cor, ordenado por volume.
Sobreposição: índice de "poluição" estimado por cor (baseado em
literatura de tingimento têxtil).
**Conclusão esperada:**
As cores mais vendidas (preto, branco) estão entre as mais intensivas
em recursos de tingimento. O portfolio da Wish está alinhado com
produção de alto impacto ambiental — mas o consumidor não tem
visibilidade deste custo.
---
## Q4 — Produtos bem avaliados vendem mais e geram mais lucro?
**Pergunta:**
*"Produtos com rating elevado (≥ 4) vendem em maior volume e geram
mais receita — ou o mercado do Wish é dominado por volume baixo
independentemente da qualidade?"*
**Hipótese:**
A qualidade percebida (rating alto) está positivamente correlacionada
com volume de vendas e receita. Produtos bem avaliados não só vendem
mais como geram maior GMV — a qualidade compensa economicamente.
**Colunas usadas:**
`rating` · `units_sold` · `price` · `rating_five_count`
· `rating_one_count` · `rating_two_count` · `badge_product_quality`
· `badges_count` · `uses_ad_boosts`
**Notebooks:** `Pergunta_2.ipynb`, `Pergunta_4.ipynb`, `Pergunta_badge.ipynb`
**Dados de suporte:**
| Faixa de rating | N produtos | Units_sold médio | Preço médio |
|---|---|---|---|
| < 3,0 | ~115 | ... | ... |
| 3,0–3,9 | ~665 | ... | ... |
| 4,0–4,5 | ~570 | ... | ... |
| > 4,5 | ~223 | ... | ... |
- Produtos com badge de qualidade vendem +54% que os sem badge
- Proporção de itens "críticos" (rating < 3) vs. "saudáveis" no
  faturamento e nos envios
- Impacto dos badges (qualidade, local, envio rápido) nas vendas
**Métricas M relevantes:** M014 (média rating), M018 (taxa detração),
M043 (concentração melhores notas), M055 (densidade badge qualidade),
M061 (lift conversão por escassez), M065 (eficácia ad boost)
**Visualização sugerida:**
Matriz de correlação: rating × units_sold × price × badges_count.
Gráfico de barras comparativo: receita total de produtos com rating
≥ 4 vs. rating < 4. Impacto incremental de cada badge nas vendas.
**Conclusão esperada:**
Qualidade e volume de vendas estão positivamente correlacionados.
Produtos bem avaliados geram mais receita — a qualidade compensa.
Badges de qualidade amplificam este efeito. O ad boost, por outro
lado, vende volume independentemente da qualidade.
---
## Q5 — Preço baixo = peça descartada mais rapidamente?
**Pergunta:**
*"Produtos com preço inferior a €5 têm maior taxa de insatisfação
(avaliações 1★ e 2★) — indicando menor durabilidade e descarte
precoce — mas continuam a vender em volume?"*
**Hipótese:**
O preço baixo atrai compra por impulso, mas a qualidade percebida
(proxy: rating baixo + avaliações negativas) sugere que estas peças
são descartadas mais rapidamente, gerando mais resíduo têxtil.
**Colunas usadas:**
`price` · `rating` · `units_sold` · `rating_one_count`
· `rating_two_count` · `negative_rating_pct` · `discount_pct_fix`
· `has_urgency_banner_fix`
**Notebooks:** `Pergunta_2.ipynb`, `Pergunta_4.ipynb`, `Pergunta_5.ipynb`
**Dados de suporte:**
| Faixa de preço | Rating médio | Avaliações 1★ (média) | N produtos |
|---|---|---|---|
| < €5 | 3,79 | 71 | 323 |
| €5–10 | 3,83 | 111 | 762 |
| €10–20 | 3,82 | 89 | 479 |
| > €20 | 3,93 | 42 | 9 |
- Taxa de reclamação (1★+2★) é desproporcionalmente alta nos
  produtos mais baratos
- Volume de vendas mantém-se alto mesmo com rating baixo —
  evidência de consumo insustentável por preço
**Métricas M relevantes:** M011 (elasticidade-preço), M018 (taxa
detração), M044 (receita ajustada ao risco), M052 (proxy desperdício
têxtil), M059 (frustração consumidor ponderada), M105 (intensidade
rejeição relativa)
**Visualização sugerida:**
Scatter plot: preço (eixo X) × rating (eixo Y), cor = volume de
vendas, tamanho = taxa de reclamação. Zona crítica: preço < €5 +
rating < 3,5 destacada como "zona de descarte provável".
**Conclusão esperada:**
Rating médio varia pouco por faixa de preço, mas a taxa de
insatisfação (1★+2★) é significativamente maior nos produtos
mais baratos. O consumidor compra apesar da má qualidade —
indicador de consumo insustentável por preço, não por necessidade.
---
## Mapa Perguntas → Notebooks → Slides
| Q | Tema | Notebook(s) | Slides |
|---|---|---|---|
| Q1 | Concentração geográfica | `Pergunta_1.ipynb` | 1–2 |
| Q2 | Impacto ambiental do transporte | `Pergunta_co2.ipynb` | 1–2 |
| Q3 | Cores mais vendidas = mais poluentes? | `Pergunta_5.ipynb` | 1 |
| Q4 | Boas avaliações = mais lucro? | `Pergunta_2.ipynb`, `Pergunta_4.ipynb`, `Pergunta_badge.ipynb` | 2–3 |
| Q5 | Preço baixo = descarte rápido? | `Pergunta_2.ipynb`, `Pergunta_4.ipynb`, `Pergunta_5.ipynb` | 2 |
| — | Inconsistências (suporte) | `Pergunta_inconsistencias.ipynb` | — |
| — | Insights consolidados | `INSIGHTS.ipynb` | 1 |
**Total estimado: 8–11 slides de análise** dentro dos 15 minutos disponíveis.
---
## Subquestões de Contexto Externo (SQ-EXT)
*Não respondíveis com os dados do dataset. Entram na análise como contexto.*
### SQ-EXT1 — Porque é que os europeus (ainda) não pagam mais pelo ambiente?
**Fontes:** Eurobarometer, Nielsen, Ellen MacArthur Foundation
**Ligação aos dados:** Os dados mostram o comportamento (preço domina); esta SQ explica o porquê — gap entre intenção declarada e ação real.
### SQ-EXT2 — Que leis europeias regulam este comportamento?
**Timeline:** EU Green Deal (2019) → Estratégia Têxtil (2022) → DSA (2022) → Ecodesign (2024)
**Valor:** Em agosto 2020 nenhum destes diplomas estava em vigor. O dataset é baseline pré-regulação.
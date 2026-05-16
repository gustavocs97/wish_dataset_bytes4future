

----------


# Analysis Subquestions
**Projeto Final — Data Analyst Junior**
**Grupo:** Letícia · Ricardo · Gustavo
**Dataset:** Sales of Summer Clothes — Wish Platform (Kaggle, agosto 2020)
**Responsável:** Gustavo (estrutura e dados) · Ricardo (formulação e contexto)
**Data:** 16 de maio de 2025

---

## Questão Principal

> **"Analisar os padrões de consumo na plataforma Wish que geram impacto
> ambiental negativo e definir métricas sustentáveis capazes de orientar
> práticas mais ecológicas sem comprometer o lucro."**

As subquestões abaixo decompõem esta questão em análises específicas,
cada uma respondível com os dados disponíveis ou com fontes externas
declaradas. Organizadas em dois grupos: **dados diretos** e **contexto externo**.

---

## GRUPO A — Subquestões Respondíveis com os Dados

---

### SQ1 — Distância de Origem × Frete Pago: o custo real está no preço?

**Pergunta:**
*"Produtos que percorrem maior distância até ao consumidor europeu
cobram proporcionalmente mais pelo frete — ou o impacto ambiental
do transporte está subsidiado?"*

**Hipótese:**
O frete de longa distância (CN → Europa, ~9.200 km) custa ao consumidor
o mesmo ou menos do que produtos de origem próxima — o custo ambiental
real do transporte não se reflete no preço pago.

**Colunas usadas:**
`origin_country_fix` · `distance_km` (calculada) · `shipping_option_price`
· `shipping_is_express` · `countries_shipped_to`

**Dados de suporte:**
- Frete médio de produtos CN (96% do dataset, 9.200 km): **€2.35**
- Frete médio de produtos US (8.500 km): **€2.52**
- Frete médio de produtos AT (1.050 km): **€2.00**
- Frete médio geral: **€2.35** para percorrer em média **~9.100 km**
- Correlação distância × preço frete: praticamente nula

**Metodologia de distância — justificação:**
Metodologia A escolhida (distância fixa por país de origem até Paris).
`countries_shipped_to` é um número, não uma lista de países — impossível
calcular distâncias reais por destino. Ver `data_treatment_log.md` secção
"Destino assumido" para justificação completa.

**Visualização sugerida (Letícia):**
Gráfico de bolhas: eixo X = distância km, eixo Y = preço frete,
tamanho da bolha = volume de produtos. Destaque: CN no canto superior
esquerdo (longe, barato).

**Conclusão esperada:**
O preço do frete não reflete a distância percorrida. O consumidor europeu
não paga o custo ambiental real do transporte — está implicitamente subsidiado
pela plataforma e pelo modelo de negócio de fast fashion extremo.

---

### SQ2 — Preço Baixo × Avaliações: o barato é descartável?

**Pergunta:**
*"Produtos com preço abaixo de €5 têm sistematicamente pior qualidade
percebida — e ainda assim vendem em volume?"*

**Hipótese:**
Produtos baratos têm mais avaliações negativas e menor rating médio,
mas continuam a registar alto volume de vendas — evidência de consumo
insustentável por preço, não por qualidade.

**Colunas usadas:**
`price` · `rating` · `rating_one_count` · `units_sold_tier`
· `badge_product_quality` · `discount_pct_fix`

**Dados de suporte:**

| Tier de preço | Rating médio | Avaliações 1★ médias | N produtos |
|---|---|---|---|
| < €5 | 3.79 | 71 | 323 |
| €5–10 | 3.83 | 111 | 762 |
| €10–20 | 3.82 | 89 | 479 |
| > €20 | 3.93 | 42 | 9 |

*Nota: o rating varia pouco entre tiers de preço — mas as avaliações de
1 estrela são proporcionalmente mais altas nos produtos baratos quando
normalizadas pelo rating_count total.*

**Visualização sugerida (Letícia):**
Scatter plot: eixo X = preço, eixo Y = rating, cor = units_sold_tier.
Zona de risco: preço < €5 + rating < 3.5 destacada.

**Conclusão esperada:**
O rating médio varia pouco por preço — mas o volume de insatisfação
(1 estrela) é desproporcionalmente alto nos produtos mais baratos.
O consumidor continua a comprar apesar da insatisfação registada.

---

### SQ3 — Stock × Vendas: existe desperdício de produção?

**Pergunta:**
*"Que proporção de produtos tem stock elevado e vendas muito baixas —
indício de sobreprodução e potencial desperdício têxtil?"*

**Hipótese:**
Uma fração significativa dos produtos tem stock próximo do máximo (50)
e volume de vendas muito baixo — proxy de produção em excesso.

**Colunas usadas:**
`product_variation_inventory` · `units_sold_tier` · `rating`
· `price` · `badge_product_quality`

**Dados de suporte:**
- Produtos com `units_sold` ≤ 100 e `product_variation_inventory` ≥ 40:
  **321 produtos (20.4% do dataset)**
- Estes representam stock elevado com vendas mínimas — candidatos a
  desperdício de produção

**Limitação declarada:**
`inventory_total` está no máximo (50) em 99.4% dos registos — tecto da
plataforma, não stock real. `product_variation_inventory` tem mais variação
mas ainda assim limitada. Os números são proxy, não medição direta.

**Visualização sugerida (Letícia):**
Heatmap: eixo X = `units_sold_tier`, eixo Y = `product_variation_inventory`
em quintis, cor = densidade de produtos. Quadrante superior esquerdo
(alto stock, baixas vendas) é a zona de desperdício.

**Conclusão esperada:**
1 em cada 5 produtos mostra sinais de sobreprodução. Sem dados de
devoluções ou destruição de stock, é um limite da análise — declarado
como estimativa conservadora.

---

### SQ4 — Estimativa de Resíduos Têxteis: quanto lixo geraram estas vendas?

**Pergunta:**
*"Qual o volume estimado de têxtil em circulação neste dataset —
e que proporção tem alto risco de descarte precoce?"*

**Hipótese:**
O volume total de unidades vendidas representa toneladas de têxtil,
uma fração significativa das quais tem rating suficientemente baixo
para indicar descarte antes do fim de vida útil esperado.

**Colunas usadas:**
`units_sold` · `rating` · `price`

**Fontes externas necessárias:**
- Peso médio por peça de roupa de verão: ~300g (t-shirt/vestido)
  *(Ellen MacArthur Foundation — "A New Textiles Economy", 2017)*
- Vida útil média de peça de fast fashion: ~3 anos
  *(European Environment Agency)*

**Dados de suporte:**

| Métrica | Valor |
|---|---|
| Total de unidades vendidas (dataset) | 6.825.255 |
| Estimativa de têxtil total | **~2.048 toneladas** |
| Units com rating < 3.5 (risco descarte) | 780.142 (11.4%) |
| Têxtil em risco de descarte precoce | **~234 toneladas** |

*Peso médio assumido: 300g/peça. Estimativa por excesso — `units_sold`
são buckets arredondados para cima.*

**Visualização sugerida (Letícia):**
Infográfico de impacto: "X toneladas de roupa vendidas em agosto de 2020
— equivalente a Y caminhões cheios". Destacar a fatia em risco de descarte.
É o slide que fica na memória do avaliador.

**Conclusão esperada:**
O dataset de um único mês numa única plataforma representa ~2.000 toneladas
de têxtil. 11% com rating baixo indica descarte provável antes do fim de
vida — número conservador, limitado pelos proxies disponíveis.

---

### SQ5 — O consumidor paga mais por qualidade certificada?

**Pergunta:**
*"Produtos com badge de qualidade vendem a preço mais alto —
e vendem mais ou menos volume?"*

**Hipótese:**
Se o consumidor europeu valoriza qualidade, produtos certificados devem
vender a preço premium com volume competitivo. Se não — o preço continua
a dominar a decisão de compra.

**Colunas usadas:**
`badge_product_quality` · `price` · `units_sold_tier` · `rating`
· `uses_ad_boosts` · `discount_pct_fix`

**Dados de suporte:**

| Grupo | Preço médio | Units_sold médio | N |
|---|---|---|---|
| Com badge qualidade | €8.46 | 6.424 | 117 |
| Sem badge qualidade | €8.31 | 4.171 | 1.456 |

*Produtos com badge de qualidade vendem em média 54% mais unidades
com apenas €0.15 de diferença de preço.*

**Visualização sugerida (Letícia):**
Gráfico de barras comparativo: com badge vs sem badge em preço médio
e volume médio. A diferença de volume é o achado — não o preço.

**Conclusão esperada:**
O consumidor não paga significativamente mais por qualidade certificada
— mas os produtos certificados vendem mais. A qualidade converte,
o preço premium não. Implicação para marcas sustentáveis: focar na
certificação e visibilidade, não no pricing.

---

### SQ6 — Mecanismos de Impulso: ad boosts e urgency banners distorcem a qualidade?

**Pergunta:**
*"Produtos com publicidade paga e banners de urgência vendem mais
independentemente da sua qualidade — evidência de consumo por impulso?"*

**Hipótese:**
O volume de vendas de produtos promovidos artificialmente não é explicado
pela qualidade — é explicado pela visibilidade forçada.

**Colunas usadas:**
`uses_ad_boosts` · `has_urgency_banner_fix` · `units_sold_tier`
· `rating` · `badge_product_quality` · `price`

**Visualização sugerida (Letícia):**
Matriz 2×2: eixo X = usa ad boost (sim/não), eixo Y = rating acima/abaixo
de 3.5, cor = volume médio de vendas. Quadrante "boost + baixa qualidade"
é o achado central.

**Conclusão esperada:**
Produtos com baixa qualidade e ad boost vendem comparável a produtos com
boa qualidade sem boost — o mecanismo de plataforma neutraliza o sinal
de qualidade. É a prova do consumo por impulso nos dados.

---

### SQ7 — Alcance de Envio × Volume: mais países = mais vendas?

**Pergunta:**
*"Produtos enviados para mais países vendem proporcionalmente mais —
ou o alcance global não se traduz em volume?"*

**Hipótese:**
Maior alcance geográfico não garante maior volume de vendas — e implica
sempre maior impacto ambiental de transporte.

**Colunas usadas:**
`countries_shipped_to` · `units_sold_tier` · `origin_country_fix`
· `distance_km`

**Dados de suporte:**

| Alcance (países) | N produtos | Units_sold médio |
|---|---|---|
| 1–10 | 18 | 5.738 |
| 11–20 | 104 | 3.941 |
| 21–30 | 245 | 2.516 |
| 31–40 | 505 | 4.974 |
| 41–50 | 539 | 4.832 |
| 51–75 | 86 | 4.411 |
| 76+ | 76 | 2.635 |

**Correlação `countries_shipped_to` × `units_sold`: -0.014** (praticamente nula)

**Metodologia — justificação obrigatória:**
`countries_shipped_to` é uma variável numérica (contagem de países),
não uma lista. Não é possível identificar quais países, calcular distâncias
reais por destino, ou segmentar por região geográfica.

Metodologia escolhida: tratar como proxy de **alcance global** —
número de rotas de transporte activadas, não destinos específicos.

Metodologia rejeitada: geocoding por país destino — impossível sem a lista.
Metodologia rejeitada: assumir distribuição uniforme por continente —
especulação sem fundamento nos dados.

**Visualização sugerida (Letícia):**
Heatmap de correlação: `countries_shipped_to` × `units_sold_tier`.
Mostrar que a correlação é quase nula — mais alcance não compra mais vendas,
mas acumula mais impacto ambiental de transporte.

**Conclusão esperada:**
Alcance global e volume de vendas são independentes. Produtos que enviam
para 76+ países não vendem mais do que produtos de alcance regional —
mas geram múltiplas rotas de transporte desnecessárias.

---

## GRUPO B — Subquestões de Contexto Externo

*Estas subquestões não são respondíveis com os dados do dataset.
Entram na análise como contexto e nas recomendações como argumento.
Responsável: Ricardo — pesquisa e redação.*

---

### SQ-EXT1 — Porque é que os europeus (ainda) não pagam mais pelo ambiente?

**Pergunta:**
*"O que explica o gap entre a intenção declarada de consumo sustentável
do público europeu e o comportamento real mostrado nos dados?"*

**Fontes sugeridas:**
- Eurobarometer — inquéritos de atitudes ambientais (2020, 2022)
- Nielsen Global Sustainability Report
- Ellen MacArthur Foundation — consumer behavior studies
- Contexto pandemia 2020: pressão económica sobre decisões de consumo

**Ligação aos dados:**
Os dados mostram o comportamento (preço domina, qualidade é secundária).
Esta subquestão explica o porquê — e é o que transforma a análise
de "relatório de dados" em "argumento de negócio".

---

### SQ-EXT2 — Que leis europeias regulam este comportamento?

**Pergunta:**
*"A regulação europeia existente em 2020 era suficiente para travar
os padrões identificados — e o que mudou desde então?"*

**Fontes a pesquisar (Ricardo):**

| Diploma | Ano | Âmbito |
|---|---|---|
| EU Green Deal | 2019 | Toda a UE — meta 2050 |
| Estratégia Têxtil Sustentável | 2022 | Toda a UE — têxteis |
| Digital Services Act | 2022 | Toda a UE — plataformas |
| Ecodesign Regulation | 2024 | Toda a UE — durabilidade |
| Regulação nacional variável | — | Por país — complementar |

**Nota importante:**
Em agosto 2020 (data do dataset), nenhum destes diplomas estava em vigor.
Os dados representam o comportamento *antes* da regulação.
É esta distância temporal que dá valor ao dataset como baseline histórico.

**Ligação à apresentação:**
Slide de recomendações: "O que os dados mostram que acontecia antes —
e o que a regulação veio (tentar) corrigir."

---

## Mapa de Subquestões → Slides

| SQ | Tema | Slides sugeridos | Responsável visual |
|---|---|---|---|
| SQ1 | Distância × Frete | 1–2 slides | Letícia — gráfico de bolhas |
| SQ2 | Preço × Qualidade | 1–2 slides | Letícia — scatter plot |
| SQ3 | Stock × Vendas | 1 slide | Letícia — heatmap |
| SQ4 | Resíduos têxteis | 1 slide impacto | Letícia — infográfico |
| SQ5 | Qualidade certificada | 1 slide | Letícia — barras comparativas |
| SQ6 | Impulso de compra | 1–2 slides | Letícia — matriz 2×2 |
| SQ7 | Alcance × Volume | 1 slide | Letícia — heatmap correlação |
| SQ-EXT1 | Comportamento europeu | 1 slide contexto | Ricardo — texto + dado externo |
| SQ-EXT2 | Legislação europeia | 1 slide | Ricardo — timeline regulação |

**Total estimado: 10–13 slides de análise** dentro dos 15 minutos disponíveis.


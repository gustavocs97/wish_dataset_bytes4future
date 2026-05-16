# Business Goal
**Projeto Final — Data Analyst Junior**
**Grupo:** Letícia · Ricardo · Gustavo
**Dataset:** Sales of Summer Clothes — Wish Platform (Kaggle, agosto 2020)
**Data:** 16 de maio de 2025

---

## Declaração de Propósito

Identificar padrões de consumo na plataforma Wish que contribuem para impacto
ambiental negativo, e propor métricas que poderiam orientar práticas mais
sustentáveis.

A forma como consumimos está a mudar — especialmente na Europa. O consumidor
europeu está a transitar para um modelo de **compra pelos valores**: escolhe com
base em critérios ESG (Ambientais, Sociais e de Governança), privilegia qualidade
sobre quantidade, e responsabiliza as plataformas pelos produtos que distribuem.

A análise de dados tem valor não só pelo que os números revelam, mas pelo que
permitem questionar: **como agregar valor fora dos dados em si** — usando os
padrões encontrados para orientar decisões de negócio mais conscientes, sem
comprometer o lucro.

---

## Questão de Negócio

> **"Analisar os padrões de consumo na plataforma Wish que geram impacto
> ambiental negativo e definir métricas sustentáveis capazes de orientar
> práticas mais ecológicas sem comprometer o lucro."**

---

## Objetivo da Análise

Examinar o dataset de produtos de verão da Wish para compreender:
- Que padrões de consumo geram maior impacto ambiental negativo
- Se os mecanismos da plataforma (preço baixo, urgência, publicidade paga)
  conduzem a comportamentos de consumo insustentável
- Que métricas podem servir de base para práticas mais sustentáveis —
  tanto para vendedores como para a própria plataforma

---

## Cliente de Negócio

**Quem pagaria por esta análise e porquê:**

| Cliente | Necessidade | Valor que retira |
|---|---|---|
| Marcas de moda europeia | Reposicionamento sustentável com evidência de comportamento real | Argumento baseado em dados para justificar pricing premium |
| Plataformas de e-commerce | Adaptação à regulação europeia (DSA, Green Deal) | Identificar onde a sua operação cria risco regulatório |
| Reguladores / Policy-makers UE | Evidência comportamental para calibrar legislação | Baseline de comportamento pré-regulação para medir impacto futuro |
| Investidores ESG | Due diligence de plataformas de fast fashion | Métricas de risco ambiental quantificadas |

---

## Framework 5W2H

### WHAT — O quê?
Analisar padrões de consumo insustentável no Wish: produtos de baixo preço e
baixa qualidade com alto volume de vendas, frete de longa distância (China →
Europa), consumo por impulso induzido por urgency banners e ad boosts, e
excesso de stock como proxy de sobreprodução.

Propor métricas sustentáveis derivadas dos dados que possam orientar práticas
mais ecológicas sem comprometer a viabilidade comercial.

### WHO — Para quem?
Marcas, plataformas e reguladores europeus que precisam de compreender o gap
entre a intenção de consumo sustentável do público europeu e o comportamento
real nos dados.

### WHERE — Onde?
Mercado europeu — confirmado pelos dados:
- `currency_buyer` = EUR em 100% dos registos
- `shipping_option_name` = "Livraison standard" em 96% dos casos
- Destino inferido: Europa Ocidental / interface francesa do Wish
*(Declarado como limitação — não é dado geográfico explícito)*

### WHEN — Quando?
Dataset de agosto de 2020 — em plena pandemia de COVID-19, e anterior à
Estratégia Têxtil Sustentável da UE (2022).

Este contexto é duplo e relevante:

**Pandemia como acelerador do e-commerce:** O confinamento europeu deslocou
o consumo para plataformas digitais a uma velocidade sem precedentes. O Wish,
com preços extremamente baixos, beneficiou diretamente deste momento — os
dados capturam um pico de comportamento de consumo online impulsionado pela
crise, não um padrão estável.

**Pandemia como ponto de viragem de valores:** Paradoxalmente, a COVID-19
também acelerou a reflexão europeia sobre consumo consciente, cadeias de
abastecimento frágeis e dependência de produtos de origem asiática. O debate
ESG ganhou nova urgência precisamente neste período.

Os dados funcionam assim como um **duplo baseline**: o comportamento de consumo
no pico do e-commerce pandémico, imediatamente antes da regulação europeia
que se seguiu. Um retrato do antes — tanto do excesso como da mudança que
estava prestes a acontecer.

### WHY — Porquê?
O consumidor europeu está a mudar. A compra pelos valores — ESG, durabilidade,
origem local, impacto ambiental — está a ganhar peso nas decisões de compra.
Mas os dados mostram que plataformas como o Wish continuam a operar com
mecanismos que contrariam essa tendência.

Quantificar este gap tem valor direto: para quem quer liderar a mudança e para
quem precisa de regular o que ficou para trás.

### HOW — Como?
Análise dos 1.573 registos com:
- **SQL** — validação, segmentação, agregações
- **Python** — limpeza, colunas calculadas, correlações
- **Power BI** — dashboard interativo para apresentação
- **Excel** — validações pontuais

Métricas calculadas com os dados existentes, complementadas por fontes externas
onde necessário: distâncias geográficas, peso médio têxtil por peça, legislação
europeia vigente.

### HOW MUCH — Que valor gera?
**Custo ambiental estimado a quantificar na análise:**
- `units_sold` × peso médio por peça → kg de têxtil em circulação
- Proporção com `rating` < 3.5 → proxy de descarte precoce
- Distância CN → Europa × volume vendido → proxy relativo de emissões de frete

**Valor para o cliente:**
Evidência quantitativa do gap entre consumo real e consumo sustentável —
base para decisões de produto, pricing, posicionamento e legislação.

---

## Objetivos SMART

| # | Objetivo | M — Como se mede |
|---|---|---|
| 1 | Quantificar a proporção de produtos com preço < €5 e rating < 3.5 sobre o total de vendas | % de `units_sold` nesse segmento |
| 2 | Estimar o volume de têxtil vendido com risco de descarte precoce | kg calculados por `units_sold` × peso médio por peça |
| 3 | Medir se produtos com urgency banner e ad boost vendem mais independentemente da qualidade | Diferença de médias de `units_sold` por grupo |
| 4 | Comparar produtos `badge_local_product` vs importados em preço, qualidade e alcance | Médias de `price`, `rating`, `countries_shipped_to` por grupo |
| 5 | Estimar distância média de frete por produto e cruzar com preço pago | km médios por `origin_country` × `shipping_option_price` |

Todos os objetivos são:
- **Específicos** — coluna e métrica definidas
- **Mensuráveis** — valor calculável com os dados disponíveis
- **Atingíveis** — dentro do dataset e fontes externas acessíveis
- **Relevantes** — respondem diretamente à questão de negócio
- **Temporais** — dataset fixo de agosto 2020, análise entregue a 22 mai 2025

---

## Limitações Declaradas

| Limitação | Impacto | Tratamento |
|---|---|---|
| `countries_shipped_to` é um número, não uma lista de países | Destino exato desconhecido | Proxy de alcance global; destino assumido como Europa Ocidental |
| Peso das peças não está nos dados | Cálculo de kg é estimativa | Fonte externa: peso médio por categoria têxtil (Ellen MacArthur Foundation) |
| Dataset de agosto 2020 em plena pandemia | Comportamento pode refletir pico atípico de e-commerce pandémico, não padrão estável | Declarado como duplo baseline: pandemia + pré-regulação EU 2022 |
| `units_sold` são buckets arredondados | Não são valores reais contínuos | Tratados como variável ordinal (`units_sold_tier`) |
| Pegada de carbono real não calculável | Sem dados de emissões diretas | Estimativa relativa por distância — não valor absoluto |

---

## Contexto Regulatório Europeu

*(A desenvolver por Ricardo com fontes primárias)*

- **EU Green Deal** — neutralidade carbónica 2050
- **Estratégia para Têxteis Sustentáveis e Circulares (2022)** — proíbe
  destruição de têxteis não vendidos, exige durabilidade mínima
- **Digital Services Act (2022)** — responsabiliza plataformas pelos produtos
  que distribuem no mercado europeu
- **Ecodesign for Sustainable Products Regulation (2024)** — em vigor

---

*Documento vivo — atualizar conforme a análise avança.*
*Última atualização: 16 mai 2025 — Gustavo*
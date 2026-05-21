wish_final_project/00_docs/business_goal.md
# Business Goal
**Projeto Final — Data Analyst Junior**
**Grupo:** Letícia · Ricardo · Gustavo
**Dataset:** Sales of Summer Clothes — Wish Platform (Kaggle, agosto 2020)
**Data:** 21 de maio de 2026
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
Examinar o dataset de produtos de verão da Wish para responder a 5 perguntas:
1. **Qual o impacto da concentração geográfica?** — 96,4% dos produtos vêm da China
2. **Qual o impacto ambiental do transporte?** — CO₂ por modo e faixa de preço
3. **As cores que mais vendem são as mais poluentes?** — tingimento têxtil
4. **Produtos bem avaliados vendem mais e geram mais lucro?** — qualidade compensa?
5. **Preço baixo = peça descartada mais rapidamente?** — insatisfação por faixa de preço
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
Analisar 5 dimensões de impacto ambiental no Wish:
- **Concentração geográfica** — dependência de um único país de origem
- **Transporte** — CO₂ emitido por modo e distância
- **Cores** — relação entre cores mais vendidas e poluição do tingimento
- **Qualidade percebida** — rating elevado traduz-se em mais vendas e receita?
- **Preço baixo** — preço baixo está associado a maior insatisfação e descarte?
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
### WHEN — Quando?
Dataset de agosto de 2020 — em plena pandemia de COVID-19, e anterior à
Estratégia Têxtil Sustentável da UE (2022).
**Pandemia como acelerador do e-commerce:** O Wish, com preços extremamente
baixos, beneficiou diretamente do confinamento europeu.
**Pandemia como ponto de viragem de valores:** A COVID-19 acelerou a reflexão
europeia sobre consumo consciente, cadeias de abastecimento frágeis e
dependência de produtos asiáticos.
Os dados funcionam como **duplo baseline**: pico do e-commerce pandémico +
pré-regulação europeia.
### WHY — Porquê?
O consumidor europeu está a mudar para a compra por valores. Mas os dados
mostram que plataformas como o Wish continuam a operar com mecanismos que
contrariam essa tendência. Quantificar este gap tem valor direto: para quem
quer liderar a mudança e para quem precisa de regular o que ficou para trás.
### HOW — Como?
Análise dos 1.573 registos com:
- **Python** — limpeza, colunas calculadas, correlações, visualizações
- **Excel** — dataset limpo (`limpos_final.xlsm`), validações pontuais
Métricas calculadas com os dados existentes, complementadas por fontes externas
declaradas: `CO2_transporte.csv`, distâncias geográficas, peso médio têxtil,
legislação europeia.
### HOW MUCH — Que valor gera?
**Custo ambiental estimado a quantificar:**
- Concentração CN → risco logístico e pegada de transporte concentrada
- CO₂ total por modo de transporte × faixa de preço
- Volume de têxtil em risco de descarte (preço baixo + rating baixo)
**Valor para o cliente:**
Evidência quantitativa do gap entre consumo real e sustentável — base para
decisões de produto, pricing, posicionamento e legislação.
---
## Objetivos SMART
| # | Objetivo | M — Como se mede | Pergunta |
|---|---|---|---|
| 1 | Quantificar a concentração geográfica: % de produtos CN, % de produtos "locais" que são CN, e relação entre alcance global e vendas | % `origin_country` = CN; % `badge_local_product` = 1 com `origin_country` = CN; correlação `countries_shipped_to` × `units_sold` | Q1 |
| 2 | Estimar o CO₂ total do transporte por modo (avião, navio, comboio) e por faixa de preço | Toneladas de CO₂ calculadas com `CO2_transporte.csv` × `distance_km` × `units_sold`, segmentado por `price` | Q2 |
| 3 | Medir a distribuição de cores no catálogo e nas vendas, e cruzar com índice estimado de poluição de tingimento | % de produtos por cor; correlação cor × `units_sold`; revisão bibliográfica do impacto ambiental por cor têxtil | Q3 |
| 4 | Comparar volume de vendas e GMV de produtos com rating ≥ 4 vs. < 4, com e sem badges de qualidade | Média de `units_sold` e GMV por grupo; diferença com/sem `badge_product_quality` | Q4 |
| 5 | Quantificar a taxa de insatisfação (1★+2★) em produtos < €5 vs. ≥ €5 e estimar volume têxtil em risco de descarte precoce | `negative_rating_pct` por faixa de preço; kg estimados de têxtil com rating < 3,5 | Q5 |
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
| `countries_shipped_to` é um número, não lista de países | Destino exato desconhecido | Proxy de alcance global; destino assumido Europa Ocidental |
| Peso das peças não está nos dados | Cálculo de kg é estimativa | Fonte externa: peso médio por categoria têxtil |
| Dataset agosto 2020 em plena pandemia | Comportamento pode refletir pico atípico | Declarado como duplo baseline |
| `units_sold` são buckets arredondados | Não são valores reais contínuos | Tratados como ordinal + estimativa por excesso |
| Pegada de carbono real não calculável | Sem dados de emissões diretas | Estimativa relativa por modo de transporte e distância |
| Impacto ambiental do tingimento por cor | Não há dados de processo têxtil por produto | Análise qualitativa com base em literatura |
---
## Contexto Regulatório Europeu
- **EU Green Deal** — neutralidade carbónica 2050
- **Estratégia para Têxteis Sustentáveis e Circulares (2022)** — proíbe
  destruição de têxteis não vendidos, exige durabilidade mínima
- **Digital Services Act (2022)** — responsabiliza plataformas pelos produtos
  que distribuem no mercado europeu
- **Ecodesign for Sustainable Products Regulation (2024)** — em vigor
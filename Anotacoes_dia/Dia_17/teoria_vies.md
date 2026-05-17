# Teoria da Análise — Escopo, Viés e Epistemologia dos Dados
**Projeto Final — Data Analyst Junior**
**Grupo:** Letícia · Ricardo · Gustavo
**Data:** 16 de maio de 2025

---

## O Paradoxo Fundamental

> *"Um conjunto de dados é sempre uma janela — nunca uma parede de vidro."*

Quando analisas dados, não estás a analisar a realidade.
Estás a analisar **um recorte da realidade**, feito por alguém,
num momento específico, com um método específico, para um fim específico.

O dataset do Wish é:
- Uma pesquisa pela palavra "summer"
- Feita em agosto de 2020
- Com interface francesa
- Por um único criador com um crawler específico
- Num momento de pandemia global

Cada uma destas escolhas **inclui algumas coisas e exclui outras**.
Não é erro — é a natureza de qualquer dado.

---

## 1. Os Três Tipos de Escopo

### Escopo A — Dentro do dataset (o que temos)
Analisar apenas o que está nos dados, sem extrapolar.

**O que podemos dizer:**
- "Neste dataset, em agosto de 2020, X% dos produtos têm rating < 3.5"
- "Nesta amostra, produtos com ad boost têm volume médio Y"
- "Nos dados recolhidos, 96% dos produtos têm origem CN"

**O que NÃO podemos dizer:**
- "O Wish em geral funciona assim"
- "Todos os produtos de fast fashion europeu são assim"
- "Em 2021 o comportamento continuou igual"

**Quando usar:** Para conclusões técnicas, métricas, correlações.
**Risco:** Ser demasiado restrito — perder o contexto.

---

### Escopo B — Com contexto externo declarado
Usar fontes externas para dar contexto aos dados, declarando sempre a origem.

**O que podemos dizer:**
- "Os dados mostram X — segundo o Eurobarometer 2020, o contexto europeu era Y"
- "O volume estimado de têxtil é Z — segundo a Ellen MacArthur Foundation,
  87% do têxtil descartado vai para aterro"
- "O dataset foi recolhido durante a pandemia — estudos mostram que
  o e-commerce cresceu 30% em 2020 na Europa"

**O que NÃO podemos dizer:**
- Apresentar dados externos como se fossem do nosso dataset
- Usar correlações de outras fontes como prova do nosso dataset

**Quando usar:** Para slides de contexto, recomendações, enquadramento ESG.
**Risco:** Confundir o que os dados provam com o que outras fontes sugerem.

---

### Escopo C — Extrapolação com probabilidade declarada
Fazer inferências além dos dados, declarando explicitamente que são
probabilidades, não certezas.

**O que podemos dizer:**
- "É provável que este padrão se mantenha em outros meses de verão,
  dado que o comportamento de fast fashion é sazonal"
- "Com base na tendência regulatória europeia, é razoável assumir
  que estas práticas serão restringidas até 2030"
- "O padrão de compra por impulso identificado sugere que
  consumidores com informação de origem comprariam de forma diferente"

**O que NÃO podemos dizer:**
- Extrapolar sem declarar que é suposição
- Usar "prova" ou "demonstra" para inferências além dos dados

**Quando usar:** Nas recomendações e na discussão de tendências.
**Risco:** Passar suposições por factos — o maior erro analítico.

---

## 2. A Escala de Certeza

```
CERTEZA          ← Os dados mostram exactamente isto
PROBABILIDADE    ← Os dados sugerem que isto é provável
SUPOSIÇÃO        ← Com base nos dados, é razoável assumir
ACHISMO          ← Parece que... / Deve ser que...
CONVICÇÃO        ← Acredito que... (opinião pessoal, não dado)
```

**Regra de ouro para a apresentação:**
Cada afirmação tem de saber onde está nesta escala.
O avaliador vai perguntar "como sabem isso?" — a resposta tem de ser honesta.

---

## 3. O Paradoxo da Pandemia

O dataset é de agosto de 2020. Isto cria um paradoxo duplo:

**Argumento para analisar SÓ como dado de 2020:**
- Os dados são o que são — um snapshot de um momento
- Tirar conclusões fora deste momento é extrapolar sem base
- A pandemia criou condições únicas que não se repetem igual
- Análise limpa: "isto é o que acontecia naquele momento"

**Argumento para contextualizar ALÉM de 2020:**
- Dados sem contexto são números sem significado
- O comportamento de fast fashion não começou em 2020
- A regulação europeia que se seguiu só faz sentido com este contexto
- O dataset é mais poderoso como "baseline do antes" do que como retrato isolado

**A resposta não é um dos dois — é declarar qual usas e porquê:**

```
Para análises quantitativas  → Escopo A (dentro do dataset)
Para slides de contexto      → Escopo B (com fontes declaradas)
Para recomendações           → Escopo C (probabilidade declarada)
```

---

## 4. O Viés do Objeto de Estudo

Todo o estudo tem viés. Não é um problema — é uma característica a declarar.

**Vieses identificados no nosso dataset:**

| Viés | Origem | Impacto | Como declarar |
|---|---|---|---|
| Viés de pesquisa | Palavra-chave "summer" | Só produtos de verão — não representa todo o e-commerce | "Os dados representam produtos de verão, não o mercado geral" |
| Viés geográfico | Interface francesa | Preços em EUR, nomes em francês | "Mercado inferido: Europa Ocidental" |
| Viés temporal | Agosto 2020 | Pandemia, pico de e-commerce | "Momento atípico — baseline pré-regulação" |
| Viés de plataforma | Só o Wish | Fast fashion extremo — não representa outras plataformas | "O Wish é um caso limite, não a norma" |
| Viés de scraping | Elasticsearch + scroll | Produtos repetidos, não é base de dados limpa | "Snapshot de página de resultados, não catálogo completo" |
| Viés de seleção | Só produtos visíveis | Produtos com baixa visibilidade não aparecem | "Análise de produtos com suficiente exposição para aparecer na pesquisa" |

---

## 5. O que Podemos e Não Podemos Dizer

### ✅ CERTEZAS — os dados provam directamente

- X% dos produtos no dataset têm `rating` < 3.5
- O frete médio é €2.35 para uma distância média de ~9.200 km
- 96.4% dos produtos têm origem CN
- 43.3% dos produtos usam `uses_ad_boosts`
- Apenas 7.4% têm `badge_product_quality`
- `units_sold` são buckets — não valores reais contínuos
- `price > retail_price` em 35.5% dos casos — confirmado como bug de moedas

---

### 🔵 PROBABILIDADES — os dados sugerem fortemente

- Produtos com `rating` < 3.5 têm maior probabilidade de descarte precoce
  *(não temos dados de descarte real — é uma proxy)*
- Produtos com ad boost vendem mais independentemente da qualidade
  *(correlação nos dados — não prova causalidade)*
- O frete não reflecte o custo ambiental real do transporte
  *(o custo ambiental real não está nos dados — é inferência)*

---

### 🟡 SUPOSIÇÕES — razoáveis mas não provadas pelos dados

- O padrão de agosto 2020 é representativo de outros meses de verão
- O consumidor europeu tomaria decisões diferentes com mais informação de origem
- A regulação europeia de 2022 foi parcialmente motivada por comportamentos como os deste dataset
- Produtos chineses com "badge local" representam greenwashing intencional

---

### 🔴 FORA DO ALCANCE — o dataset não consegue responder

- Qual o impacto ambiental real em CO₂ do transporte
- Quantas peças foram efectivamente descartadas
- O que o consumidor sabia sobre a origem do produto quando comprou
- Como o comportamento mudou após 2020
- Se os padrões se repetem em outras plataformas
- A margem de lucro real dos sellers
- Impactos pós-pandemia ou para uma próxima pandemia

---

## 6. Abordagens por Coluna — Tabela de Decisão

| Coluna | Abordagem A — Restrita | Abordagem B — Contextualizada | Abordagem C — Extrapolada | Qual usar |
|---|---|---|---|---|
| `units_sold` | Contar por tier — sem inferir velocidade | Comparar tiers com benchmark de mercado externo | Projectar como tendência de consumo | **A** para métricas · **B** para contexto |
| `price` | Média/distribuição no dataset | Comparar com preço médio de roupa sustentável (fonte externa) | Inferir poder de compra do consumidor | **A + B** |
| `rating` | Distribuição real no dataset | Comparar com padrões de satisfação de e-commerce europeu | Inferir qualidade e vida útil do produto | **A** para análise · **C** declarada para ESG |
| `origin_country` | 96% CN — facto do dataset | Contexto de dependência europeia de supply chain asiática | Inferir impacto de regulação de origem | **A + B** |
| `distance_km` | Calculada — estimativa por país | Comparar com benchmarks de emissões de frete | Projectar custo ambiental real | **A** + **B** com fonte · **C** declarada |
| `has_urgency_banner_fix` | % de produtos com banner no dataset | Comparar com psicologia do consumidor e dark patterns | Inferir impacto em decisão de compra inconsciente | **A + B** |
| `badge_product_quality` | 7.4% têm badge — facto | Comparar com taxas de certificação em outras plataformas | Inferir o que aconteceria com mais certificações | **A** para análise · **C** para recomendações |
| `badge_local_product` | 100% CN com badge local — contradição nos dados | Contexto de greenwashing no e-commerce europeu | Inferir intenção do seller | **A** para o achado · **B** para contexto |
| `inventory_total` | Excluída — cap artificial de 50 | — | — | **Excluída** — RFIX_017 |
| `product_variation_inventory` | Usar apenas valores ≤ 49 para escassez real | — | — | **A** restrita — RFIX_018 |
| `merchant_rating` | Distribuição no dataset | Comparar com padrões de reputação de marketplace | — | **A** |
| `discount_pct_fix` | Distribuição sem negativos | Comparar com psicologia de desconto | Inferir manipulação de preço percebido | **A + B** |
| `shipping_option_price` | Média no dataset | Comparar com custo real de frete internacional | Inferir subsídio implícito | **A + B** |
| `countries_shipped_to` | Proxy de alcance — número, não lista | Contexto de globalização do fast fashion | — | **A** com limitação declarada |
| `negative_rating_pct` | % calculada no dataset | Comparar com taxas de devolução em e-commerce | Inferir insatisfação e descarte | **A** + **C** declarada |

---

## 7. Para a Apresentação — Como Falar de Cada Tipo

**Quando o dado prova:**
> *"Os dados mostram que..."* · *"No dataset, X% dos produtos..."*

**Quando é probabilidade:**
> *"Os dados sugerem que..."* · *"É provável que, dado que..."*

**Quando é suposição razoável:**
> *"Com base nos dados, é razoável assumir que..."*
> *"Não podemos provar, mas os padrões indicam..."*

**Quando é recomendação:**
> *"Os dados não provam X, mas justificam recomendar Y porque..."*

**Quando está fora do alcance:**
> *"Isto está além do que os dados conseguem responder —
> seria necessário [fonte / estudo / dado adicional]."*

---

## 8. Resposta ao Paradoxo Original

> *"Este dataset deve ser analisado só como dado de 2020
> ou fora de 2020?"*

**Resposta:** As duas coisas — em camadas separadas e declaradas.

```
Camada 1 — O que os dados provam     → agosto 2020, plataforma Wish, interface FR
Camada 2 — O contexto que explica    → pandemia, regulação EU, tendência ESG
Camada 3 — O que podemos recomendar  → baseado em 1 + 2, declarando probabilidade
```

O valor do dataset não está em ser representativo de tudo.
Está em ser um retrato preciso de um momento específico —
e esse momento foi a charneira entre o consumo sem regras
e a regulação que se seguiu.

Isso é suficiente para uma análise com impacto.

---

*Documento de referência teórica — não é um entregável do curso,
é uma bússola para as decisões analíticas do grupo.*
*Última actualização: 16 mai 2025 — Gustavo*
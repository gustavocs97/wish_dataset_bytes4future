# Observações Externas — Dataset Wish Summer Products
**Fonte:** Fóruns Kaggle + discussões com o criador Jeffrey Mvutu Mabilama
**Responsável:** Gustavo
**Data:** 16 de maio de 2025

---

## Como usar este ficheiro

Cada item tem:
- **Código único** — para referenciar no `data_treatment_log.md`
- **Tipo de problema** — classificação do problema
- **Descoberta** — o que foi identificado no fórum
- **Ação obrigatória** — o que fazer no código / análise
- **Status** — `[ ]` por fazer · `[x]` feito · `[!]` impacta análise ESG

---

## BLOCO 1 — Estrutura e Regras de Negócio

| Código | Status | Tipo | Descoberta | Ação Obrigatória |
|---|---|---|---|---|
| RFIX_001 | [ ] | Estrutura de Dados | O dataset não tem categorias fixas. É baseado na busca por 'summer' e nas tags criadas livremente pelos vendedores. | Não agrupar por coluna de 'categoria' — não existe. Focar na coluna `tags` para identificar nichos. |
| RFIX_002 | [ ] | Viés de Origem | Tags preenchidas manualmente por vendedores não nativos em inglês — podem estar incorretas ou ambíguas. | Validar os termos mais frequentes da coluna `tags`. Usar o ficheiro auxiliar de frequência de tags disponibilizado pelo criador. |
| RFIX_003 | [ ] | Regra de Negócio | `units_sold × price` dá o GMV (Gross Merchandise Volume), não o lucro do vendedor. | Nunca usar esta fórmula como proxy de lucro. Declarar sempre como GMV — não temos custo de fabricação. |
| RFIX_004 | [ ] | Regra de Negócio | `retail_price` não é preço de custo nem de atacado. É o preço de referência de mercado — o "De:" riscado. | Proibido usar `retail_price` para calcular lucro. Serve exclusivamente para calcular `discount_pct`. |
| RFIX_005 | [!] | Sanidade / Consistência | Em ~1/3 do dataset, `price` > `retail_price`. Confirmado pelo criador como bug de moedas misturadas durante o scraping — a página alternava o câmbio abruptamente. | Criar coluna booleana `price_above_retail` para identificar estes casos. Não interpretar como estratégia de preço — é erro de captura. Ver RFIX_021. |
| RFIX_006 | [!] | Qualidade dos Dados | `units_sold` não é contínuo — são faixas de sucesso agregadas pelo Wish (10, 50, 100, 1000, 10000...). | Tratar como variável ordinal categórica. Nunca usar para cálculos de velocidade de vendas. Ver também RFIX_022. |
| RFIX_007 | [ ] | Integridade | Existem duplicados porque o scraping foi feito em diferentes momentos da mesma pesquisa. | Executar `drop_duplicates(subset=['product_id'])` antes de qualquer agregação de vendas para não inflar o GMV. |
| RFIX_008 | [ ] | Qualidade / UI | `has_urgency_banner` é uma flag binária criada pelo próprio criador do dataset para facilitar o tratamento de nulos de `urgency_text`. | Não tratar ambas como features independentes em modelos — são a mesma informação (multicolinearidade perfeita). |

---

## BLOCO 2 — Duplicados e Testes A/B

| Código | Status | Tipo | Descoberta | Ação Obrigatória |
|---|---|---|---|---|
| RFIX_009 | [ ] | Viés de Amostragem | O mesmo produto pode aparecer duplicado porque o Wish exibe em posição orgânica E em posição patrocinada (ad boost). | Para análises de performance orgânica, isolar ou remover as linhas de posição patrocinada. |
| RFIX_010 | [!] | Testes A/B | Um mesmo `product_id` tem linhas duplicadas — numa há `urgency_text`, na outra não. O Wish faz A/B tests constantes na UI. | Ao fazer `drop_duplicates`, definir regra de negócio clara: **priorizar a linha COM banner** se o objetivo é analisar gatilhos de escassez. |
| RFIX_011 | [ ] | Limitação Técnica | O motor de busca do Wish (Elasticsearch) sacrifica precisão para velocidade, repetindo produtos ao longo do scroll. O dataset é um snapshot dessa busca. | Lembrar que este não é um espelho limpo do banco de dados do Wish — é uma página de resultados real com todas as suas imperfeições. |
| RFIX_012 | [ ] | Plágio de Catálogo | Vendedores diferentes vendem o mesmo produto físico clonando thumbnails mas mudando preços, títulos e tags. | Não agrupar concorrentes apenas por título similar. Cruzar imagens clonadas com variações de `price` para identificar produtos iguais de sellers diferentes. |

---

## BLOCO 3 — Badges e Métricas de Seller

| Código | Status | Tipo | Descoberta | Ação Obrigatória |
|---|---|---|---|---|
| RFIX_013 | [ ] | Estrutura de Dados | `badge_local_product`, `badge_product_quality` e `badge_fast_shipping` são flags binárias. `badges_count` é a soma das três. Confirmado pelo criador. | Tratar os três badges como variáveis dummy/booleanas. **Nunca usar `badges_count` simultaneamente com as colunas individuais** em modelos — multicolinearidade perfeita. |
| RFIX_014 | [!] | Escopo das Métricas | `badge_fast_shipping` é concedido ao nível do **vendedor (merchant)**. Os outros dois são ao nível do **produto individual**. | Ao agregar por seller: `badge_fast_shipping` é atributo fixo do merchant. `badge_local_product` e `badge_product_quality` devem ser analisados por SKU. |

---

## BLOCO 4 — Merchant e Idioma

| Código | Status | Tipo | Descoberta | Ação Obrigatória |
|---|---|---|---|---|
| RFIX_015 | [ ] | Qualidade / Idioma | `merchant_info_subtitle` contém texto bruto em francês (e por vezes português/outros idiomas por bugs de tradução). | Evitar regex baseado num único idioma. Recomendado: descartar a coluna para análises automatizadas de texto. |
| RFIX_016 | [ ] | Testes A/B | ~18% das linhas em `merchant_info_subtitle` não têm a percentagem de feedbacks positivos — omissão por testes A/B visuais do Wish. | Não calcular taxa de feedback positivo a partir do texto bruto. Usar directamente `merchant_rating_count` e `merchant_rating`. |

---

## BLOCO 5 — Inventário e Stock

| Código | Status | Tipo | Descoberta | Ação Obrigatória |
|---|---|---|---|---|
| RFIX_017 | [!] | Regra de Negócio | O limite de 50 nas colunas de inventário significa **≥ 50**, não exactamente 50. É uma trava da plataforma para evitar compras abusivas por um único utilizador. O stock real pode ser de milhares. | **Proibido** usar inventário = 50 para inferir capacidade real do vendedor. Nunca calcular volumetria de stock quando o valor for exactamente 50. |
| RFIX_018 | [ ] | Granularidade | `product_variation_inventory` = stock de uma variação específica (ex: M + Azul). `inventory_total` = soma de todas as variações. Ambas com cap em 50. | Para análises de escassez real, filtrar apenas linhas com `product_variation_inventory <= 49`. |

---

## BLOCO 6 — Qualidade dos Dados e Encoding

| Código | Status | Tipo | Descoberta | Ação Obrigatória |
|---|---|---|---|---|
| RFIX_019 | [ ] | Localização / Encoding | Dados extraídos com interface francesa — introduziu caracteres não-ASCII (é, à, ê) na coluna `title`. | Garantir `encoding='utf-8'` ao carregar o CSV em Python/Pandas para evitar erros de parsing. |
| RFIX_020 | [!] | Viés de Algoritmo | Produtos com `rating = 5.0` e `rating_count = 0` — confirmado pelo criador como boost artificial do Wish para produtos novos sem avaliações reais. | Criar flag `is_new_product_boost` = 1 quando `rating = 5.0` AND `rating_count = 0`. Substituir `rating` por `NaN` nesses casos para não distorcer médias de satisfação. |
| RFIX_021 | [!] | Erro de Carga | `price` > `retail_price` em ~1/3 dos casos — confirmado como bug de moedas misturadas no scraping (USD/EUR alternavam abruptamente). Não é estratégia de preço nem efeito COVID. | Nas versões 2021 do dataset existem colunas `discount_price_currency` e `retail_price_currency` para validar. Na versão 2020 (a nossa): criar flag `price_above_retail` e excluir estes registos de análises de desconto. |

---

## BLOCO 7 — Janela Temporal e Versões do Dataset

| Código | Status | Tipo | Descoberta | Ação Obrigatória |
|---|---|---|---|---|
| RFIX_022 | [!] | Janela Temporal | `units_sold` é o volume acumulado de **toda a vida útil do anúncio** — não semanal, mensal ou anual. A data de criação do anúncio não está disponível. | **Proibido** usar `units_sold` para calcular velocidade de vendas, run-rate ou projeções temporais. É acumulado lifetime sem janela definida. |
| RFIX_023 | [ ] | Definição de Variável | `countries_shipped_to` é um número inteiro — quantidade de países onde o produto está disponível. Não é uma lista de países. Confirmado pelo criador. | Tratar exclusivamente como métrica de **alcance logístico**. Não usar para geolocalização ou análise por país destino. |
| RFIX_024 | [ ] | Versão do Dataset | Nas versões 2021 do dataset foram adicionadas colunas `nb_cart_orders_approx` e `nb_units_purchased_approx` para mitigar as imprecisões de `units_sold`. | A nossa versão é 2020 — não temos estas colunas. Se alguém usar o ficheiro 2021, priorizar `nb_units_purchased_approx` sobre `units_sold`. |

---

## Impacto na Análise ESG — Resumo dos [!]

| Código | Impacto directo na análise ESG |
|---|---|
| RFIX_005 | Bug de moedas: os 559 casos `price > retail` não são estratégia — são erro. Muda a interpretação do `discount_pct_fix`. |
| RFIX_006 | `units_sold` ordinal: o cálculo de kg de têxtil é estimativa por faixas, não por unidades exactas. Declarar na SQ4. |
| RFIX_010 | Regra de duplicados: ao analisar urgency banners, manter a linha COM banner. |
| RFIX_014 | `badge_fast_shipping` é do merchant, não do produto — não usar como proxy de sustentabilidade por SKU. |
| RFIX_017 | Inventário = 50 significa ≥ 50 — a análise de desperdício de produção (SQ3) usa `<= 49` como proxy de escassez real. |
| RFIX_020 | 45 produtos com rating artificial 5.0 — excluir ou flagar antes de calcular médias de qualidade. |
| RFIX_021 | Confirma que `price > retail` é bug técnico, não comportamento de mercado. Justificação do `discount_pct_fix` actualizada. |
| RFIX_022 | `units_sold` lifetime: a estimativa de kg de têxtil representa acumulado histórico, não produção de agosto 2020. Declarar na SQ4. |


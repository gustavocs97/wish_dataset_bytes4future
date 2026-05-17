# Guião Power Query — Limpeza de Dados
**Projeto Final — Data Analyst Junior**
**Dataset:** Sales of Summer Clothes — Wish Platform

---

## Como usar este guião

Lê um passo, executa no Power Query, passa ao seguinte.
Cada passo diz **o quê**, **porquê** e **como** — não saltes o porquê,
é ele que justifica as decisões na apresentação.

**Regra de ouro:** nunca alteras a fonte original.
Tudo o que fizeres aqui cria colunas novas ou remove colunas inúteis —
os dados brutos ficam intactos em `01_data/raw/`.

---

## FASE 0 — Carregar o ficheiro

**O quê:** Abrir o CSV no Power Query sem alterar nada ainda.

**Como:**
1. Excel ou Power BI → `Obter Dados` → `De Ficheiro` → `CSV`
2. Selecionar `Summer_Products.csv` da pasta `01_data/raw/`
3. Na janela de pré-visualização → clicar `Transformar Dados`
   *(não clicar "Carregar" — isso carrega sem limpeza)*
4. Verificar que aparece **1.573 linhas** e **43 colunas**
   Se o número for diferente, algo correu mal na importação.

**Nota:** O Power Query cria automaticamente um passo chamado
`Origem` — é o teu ponto de partida. Nunca o apagues.

---

## FASE 1 — Perceber o que tens antes de mexer em nada

**O quê:** Primeiro olhar ao dataset — tipos de dados, nulos visíveis, estrutura.

**Como:**
1. Activar `Vista de Perfil de Coluna`:
   Menu `Ver` → activar `Distribuição de Colunas` + `Perfil de Colunas`
   Isto mostra para cada coluna: valores únicos, nulos, distribuição.

2. Verificar os tipos de dados atribuídos automaticamente.
   O Power Query pode ter errado — confirmar:

| Coluna | Tipo esperado | Tipo errado comum |
|---|---|---|
| `price` | Número decimal | Texto (se vírgula/ponto mal lido) |
| `retail_price` | Número inteiro | — |
| `units_sold` | Número inteiro | — |
| `rating` | Número decimal | — |
| `has_urgency_banner` | Número decimal | — |
| `crawl_month` | Texto | Data (não é uma data útil) |
| `product_id` | Texto | — |
| `merchant_id` | Texto | — |

3. Anotar mentalmente o que vês:
   - `has_urgency_banner` tem muitos nulos? ✅ esperado — 1.100 nulos
   - `merchant_profile_picture` parece quase vazio? ✅ esperado — 85% nulos
   - `currency_buyer` parece sempre "EUR"? ✅ correcto

---

## FASE 2 — Remover colunas inúteis

**O quê:** Eliminar colunas que não têm valor analítico para o nosso objectivo.
Menos colunas = modelo mais rápido + apresentação mais limpa.

**Porquê estas e não outras:**
- Colunas constantes (mesmo valor em todas as linhas) não têm poder analítico
- URLs e IDs são identificadores, não dados para analisar
- `title` é redundante com `title_orig`

**Como:**
Seleccionar cada coluna abaixo → botão direito → `Remover`
*(ou seleccionar todas de uma vez com Ctrl+Click e remover juntas)*

| Coluna | Motivo |
|---|---|
| `currency_buyer` | 100% EUR — sem variação |
| `theme` | 100% "summer" — sem variação |
| `crawl_month` | 100% "2020-08" — sem variação |
| `title` | Substituída por `title_orig` (mais limpa) |
| `product_url` | URL — não analítico |
| `product_picture` | URL — não analítico |
| `merchant_profile_picture` | 85.6% nulos — sem valor analítico |
| `merchant_info_subtitle` | Texto não estruturado em francês |
| `inventory_total` | 99.4% no valor máximo (50) — sem variação útil |

**Verificar:** depois de remover, deves ter **34 colunas**.

---

## FASE 3 — Tratar duplicados

**O quê:** Identificar linhas repetidas pelo `product_id`.

**Porquê:** O dataset tem 1.573 linhas mas apenas 1.341 `product_id` únicos.
232 linhas são repetições — podem ser variações de tamanho/cor do mesmo produto.
Não são erros — mas precisas de saber que existem e decidir como tratar.

**Como — opção A (manter tudo, trabalhar ao nível de listing):**
Não fazes nada aqui. Documentas que trabalhas com 1.573 linhas (listings)
e não 1.341 produtos únicos. Quando precisares de contar produtos distintos,
usas `product_id` com remoção de duplicados nessa análise específica.
→ **Recomendado para esta análise.**

**Como — opção B (remover duplicados agora):**
Seleccionar coluna `product_id` → Menu `Base` → `Remover Linhas` →
`Remover Duplicados`
→ Fica com 1.341 linhas. Perdes informação de variações.

**Documentar no `data_treatment_log.md`:** qual opção escolheste e porquê.

---

## FASE 4 — Corrigir tipos de dados

**O quê:** Garantir que cada coluna tem o tipo certo antes de criar colunas calculadas.

**Como:**
Clicar no ícone do tipo de dados à esquerda do nome da coluna e seleccionar o correcto.

| Coluna | Tipo correcto no Power Query |
|---|---|
| `price` | Número Decimal |
| `retail_price` | Número Inteiro |
| `units_sold` | Número Inteiro |
| `rating` | Número Decimal |
| `rating_count` | Número Inteiro |
| `rating_five_count` | Número Decimal *(tem nulos)* |
| `rating_four_count` | Número Decimal *(tem nulos)* |
| `rating_three_count` | Número Decimal *(tem nulos)* |
| `rating_two_count` | Número Decimal *(tem nulos)* |
| `rating_one_count` | Número Decimal *(tem nulos)* |
| `shipping_option_price` | Número Inteiro |
| `countries_shipped_to` | Número Inteiro |
| `has_urgency_banner` | Número Decimal *(tem nulos — não mudar para inteiro ainda)* |
| `merchant_rating` | Número Decimal |
| `merchant_rating_count` | Número Inteiro |
| `product_id` | Texto |
| `merchant_id` | Texto |

**Atenção:** se o Power Query pedir para confirmar troca de tipo,
escolher `Substituir actual` (não adicionar novo passo de conversão).

---

## FASE 5 — Tratar nulos: has_urgency_banner

**O quê:** Substituir os 1.100 nulos de `has_urgency_banner` por `0`.

**Porquê:** Nulo aqui não significa "dado em falta" — significa "sem banner".
A plataforma só preenche o campo quando há banner. Ausência = sem urgência.

**Como:**
1. Seleccionar coluna `has_urgency_banner`
2. Menu `Transformar` → `Substituir Valores`
3. Valor a localizar: `null` | Substituir por: `0`
4. Confirmar → a coluna passa a ter apenas `0` e `1`
5. Alterar tipo da coluna para `Número Inteiro`
6. Renomear coluna: botão direito → `Renomear` → `has_urgency_banner_fix`

**Verificar:** a coluna não deve ter mais nulos. Total de `1` = 473.

---

## FASE 6 — Tratar nulos: product_color

**O quê:** Substituir os 41 nulos de `product_color` por "unknown".

**Porquê:** Cor ausente pode ser produto sem variação de cor ou campo não
preenchido pelo seller. Não imputamos uma cor — marcamos como desconhecida.

**Como:**
1. Seleccionar coluna `product_color`
2. `Transformar` → `Substituir Valores`
3. Valor a localizar: `null` | Substituir por: `unknown`
4. Renomear para `product_color_fix`

---

## FASE 7 — Tratar nulos: origin_country

**O quê:** Substituir os 17 nulos de `origin_country` por "unknown".

**Porquê:** Não imputamos "CN" (mesmo sendo 96% do dataset) — seria especular.
Para o cálculo de distância de frete, estes 17 registos serão excluídos.

**Como:**
1. Seleccionar coluna `origin_country`
2. `Transformar` → `Substituir Valores`
3. Valor a localizar: `null` | Substituir por: `unknown`
4. Renomear para `origin_country_fix`

---

## FASE 8 — Criar coluna: discount_pct_fix

**O quê:** Calcular a percentagem de desconto real, sem valores negativos.

**Porquê:** Em 559 casos (35%), `price` > `retail_price` — desconto negativo.
Tratamos esses casos como "sem desconto" (valor 0), não como dado errado.

**Como:**
1. Menu `Adicionar Coluna` → `Coluna Personalizada`
2. Nome: `discount_pct_fix`
3. Fórmula:
```
if [retail_price] = 0 then 0
else if [price] > [retail_price] then 0
else Number.Round(([retail_price] - [price]) / [retail_price] * 100, 2)
```
4. Confirmar → verificar que não há valores negativos na coluna nova
5. Tipo da coluna: `Número Decimal`

**Verificar:** mínimo = 0, máximo ≈ 96.9.
Se aparecerem negativos, a fórmula tem erro — rever.

---

## FASE 9 — Criar coluna: units_sold_tier

**O quê:** Converter `units_sold` numa variável ordinal de 5 níveis.

**Porquê:** `units_sold` não é contínuo — são buckets do Wish
(100, 1000, 5000...). Tratar como número dá correlações falsas.
Convertemos para níveis comparáveis.

**Níveis:**

| Tier | Intervalo | Significado |
|---|---|---|
| 1 | ≤ 10 | Volume muito baixo |
| 2 | 11 a 100 | Volume baixo |
| 3 | 101 a 1.000 | Volume médio |
| 4 | 1.001 a 10.000 | Volume alto |
| 5 | > 10.000 | Volume muito alto |

**Como:**
1. `Adicionar Coluna` → `Coluna Personalizada`
2. Nome: `units_sold_tier`
3. Fórmula:
```
if [units_sold] <= 10 then 1
else if [units_sold] <= 100 then 2
else if [units_sold] <= 1000 then 3
else if [units_sold] <= 10000 then 4
else 5
```
4. Tipo da coluna: `Número Inteiro`

**Verificar:** valores possíveis = apenas 1, 2, 3, 4, 5. Nenhum nulo.

---

## FASE 10 — Criar coluna: distance_km

**O quê:** Atribuir a distância estimada em km de cada produto até à Europa
(Paris como ponto de referência), com base no país de origem.

**Porquê:** `origin_country` tem o país mas não a distância.
Adicionamos a distância como coluna calculada para usar nas análises de frete.

**Metodologia:** distância fixa por país de origem até Paris.
Ver `data_treatment_log.md` para justificação da escolha desta metodologia.

**Como:**
1. `Adicionar Coluna` → `Coluna Personalizada`
2. Nome: `distance_km`
3. Fórmula:
```
if [origin_country_fix] = "CN" then 9200
else if [origin_country_fix] = "US" then 8500
else if [origin_country_fix] = "VE" then 8300
else if [origin_country_fix] = "SG" then 10200
else if [origin_country_fix] = "AT" then 1050
else if [origin_country_fix] = "GB" then 340
else null
```
4. Tipo da coluna: `Número Inteiro`

**Verificar:** 17 registos com `origin_country_fix = "unknown"` devem ter `null`.
Os restantes devem ter um dos valores da tabela acima.

---

## FASE 11 — Criar coluna: negative_rating_pct

**O quê:** Percentagem de avaliações negativas (1★ e 2★) sobre o total.

**Porquê:** O `rating` médio esconde a distribuição. Um produto com
rating 3.5 pode ter 40% de avaliações de 1 estrela — sinal de descarte.
Esta coluna mostra a insatisfação real.

**Como:**
1. `Adicionar Coluna` → `Coluna Personalizada`
2. Nome: `negative_rating_pct`
3. Fórmula:
```
if [rating_count] = 0 or [rating_count] = null then null
else if [rating_one_count] = null then null
else Number.Round(
    ([rating_one_count] + [rating_two_count]) / [rating_count] * 100,
    2
)
```
4. Tipo: `Número Decimal`

**Verificar:** 45 registos sem breakdown de rating terão `null` — esperado.
Valores entre 0 e 100. Nenhum valor negativo ou acima de 100.

---

## FASE 12 — Criar coluna: total_badges

**O quê:** Soma dos três badges de cada produto (0 a 3).

**Porquê:** Proxy de confiança certificada pela plataforma.
Um produto com os 3 badges tem o máximo de selos de qualidade disponíveis.

**Como:**
1. `Adicionar Coluna` → `Coluna Personalizada`
2. Nome: `total_badges`
3. Fórmula:
```
[badge_local_product] + [badge_product_quality] + [badge_fast_shipping]
```
4. Tipo: `Número Inteiro`

**Verificar:** valores possíveis = 0, 1, 2, 3. Maioria deve ser 0 (90%+).

---

## FASE 13 — Verificação final antes de carregar

**O quê:** Confirmar que tudo está correcto antes de fechar o Power Query.

**Checklist obrigatório:**

```
[ ] Total de linhas: 1.573 (ou 1.341 se removeste duplicados — documentar)
[ ] Total de colunas: ~34 originais + 6 novas = ~40 colunas
[ ] has_urgency_banner_fix: sem nulos, apenas 0 e 1
[ ] product_color_fix: sem nulos, "unknown" nos 41 casos
[ ] origin_country_fix: sem nulos, "unknown" nos 17 casos
[ ] discount_pct_fix: sem negativos, entre 0 e 100
[ ] units_sold_tier: apenas valores 1, 2, 3, 4, 5
[ ] distance_km: null apenas nos 17 "unknown", resto com valores km
[ ] negative_rating_pct: null nos 45 sem breakdown, resto entre 0-100
[ ] total_badges: apenas 0, 1, 2 ou 3
[ ] Nenhuma coluna da lista da Fase 2 aparece no dataset final
```

**Verificar tipos de dados finais:**
Menu `Ver` → `Barra de Fórmulas` activada
Clicar em cada coluna nova e confirmar o tipo no cabeçalho.

---

## FASE 14 — Carregar o dataset limpo

**O quê:** Exportar o resultado para usar na análise.

**No Power BI:**
Menu `Base` → `Fechar e Aplicar`
O dataset limpo fica disponível como tabela no modelo.

**No Excel:**
Menu `Base` → `Fechar e Carregar Para...`
→ Escolher `Tabela` numa nova folha chamada `processed`
→ Guardar como `summer_products_clean.xlsx` em `01_data/processed/`

**No Python (alternativa):**
Exportar como CSV: Menu `Base` → `Fechar e Carregar Para...` →
`Apenas Ligação` → depois usar script Python para exportar.
*(ver `03_analysis/python/01_cleaning.ipynb` para o equivalente em Pandas)*

---

## Resumo de Colunas Criadas

| Coluna nova | Baseada em | O que resolve |
|---|---|---|
| `has_urgency_banner_fix` | `has_urgency_banner` | 1.100 nulos → 0 |
| `product_color_fix` | `product_color` | 41 nulos → "unknown" |
| `origin_country_fix` | `origin_country` | 17 nulos → "unknown" |
| `discount_pct_fix` | `price` + `retail_price` | 559 descontos negativos → 0 |
| `units_sold_tier` | `units_sold` | Buckets → ordinal 1-5 |
| `distance_km` | `origin_country_fix` | País → km até Paris |
| `negative_rating_pct` | `rating_one_count` + `rating_two_count` | % insatisfação real |
| `total_badges` | 3 colunas badge | Confiança agregada 0-3 |

---

## Erros Comuns e Como Resolver

| Erro | Causa provável | Solução |
|---|---|---|
| `price` lido como Texto | Separador decimal errado na importação | Alterar locale na origem: `Origem` → opções → locale PT ou EN |
| Fórmula devolve `Error` | Coluna referenciada com nome errado | Verificar maiúsculas/minúsculas no nome da coluna |
| Nulos não substituídos | `Substituir Valores` não reconhece `null` | Usar `null` (minúsculas) na caixa de diálogo |
| Coluna nova com tipo errado | Power Query inferiu errado | Clicar no ícone do tipo e forçar manualmente |
| Número de linhas errado | Filtro aplicado acidentalmente | Verificar painel de passos aplicados à direita |

---

## Passos Aplicados — O que deves ver no painel direito

No final, o painel `Passos Aplicados` do Power Query deve mostrar
(por esta ordem):

```
1. Origem
2. Tipo Alterado
3. Colunas Removidas
4. Tipos Corrigidos
5. Nulos Substituídos - has_urgency_banner
6. Coluna Renomeada - has_urgency_banner_fix
7. Nulos Substituídos - product_color
8. Coluna Renomeada - product_color_fix
9. Nulos Substituídos - origin_country
10. Coluna Renomeada - origin_country_fix
11. Coluna Personalizada Adicionada - discount_pct_fix
12. Coluna Personalizada Adicionada - units_sold_tier
13. Coluna Personalizada Adicionada - distance_km
14. Coluna Personalizada Adicionada - negative_rating_pct
15. Coluna Personalizada Adicionada - total_badges
```

Se a ordem for diferente pode causar erros — os passos dependem uns dos outros
(ex: `distance_km` precisa que `origin_country_fix` já exista).

---

*Última atualização: 16 mai 2025 — Gustavo*
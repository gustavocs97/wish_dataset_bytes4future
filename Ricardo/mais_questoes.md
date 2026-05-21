## Novas Subquestões de Negócio

### 1. O Impacto Ecológico das Cores e Tinturarias vs. Performance de Vendas

* **A questão:** O teu dataset já categoriza o impacto da cor (`product_color_GroupedByImpactFix`). O uso de cores com maior impacto químico/ambiental traduz-se em maior volume de vendas ou os tons neutros/baixo impacto são igualmente rentáveis?
* **O que a base responde:** Cruzar a coluna de impacto da cor com `units_sold` e `price` para perceber se a moda sustentável (em termos de tingimento) prejudica ou beneficia a receita.

### 2. A Eficiência Ecológica dos Anúncios Pagos (Ad Boosts)

* **A questão:** O investimento em publicidade (`uses_ad_boosts`) está a ser usado para escoar produtos de baixa qualidade (gerando desperdício de transporte) ou está a impulsionar produtos eco-eficientes e de alto rating?
* **O que a base responde:** Analisar a taxa de conversão/vendas de produtos com `uses_ad_boosts = 1` vs. o seu `rating` e `badges_countFix`. Se os anúncios promovem produtos maus, a empresa está a gastar dinheiro para gerar devoluções e pegada de carbono desnecessária.

### 3. "Gatilhos de Urgência" vs. Consumo Consciente e Devoluções

* **A questão:** O uso de banners de urgência (`has_urgency_bannerFix` e `urgency_textTierFix`) incentiva o consumo por impulso. Esse impulso traduz-se em maior rentabilidade líquida ou resulta em avaliações mais baixas (frustração do cliente)?
* **O que a base responde:** Comparar produtos com e sem urgência ativada em relação ao seu `rating` final e `units_sold`. O marketing agressivo pode aumentar as vendas imediatas, mas destruir a fidelização e a sustentabilidade da marca.

### 4. O Prémio de Preço da Qualidade (Análise de Descontos e Margem)

* **A questão:** A diferença entre o preço de retalho recomendado e o preço real praticado (`retail_price_DifFix`) afeta a perceção de qualidade do produto? Descontos demasiado agressivos atraem um volume de vendas que compensa a perda de margem e o potencial descarte rápido do produto?
* **O que a base responde:** Correlacionar a diferença de preço (`retail_price_DifFix` ou `retail_price_DIFP_Fix`) com o `rating` e o volume de vendas. Descobrir se o "desconto ilusório" gera pior qualidade percebida.

### 5. Selos de Qualidade (`Badges`) como Alavanca de Margem Verde

* **A questão:** Os produtos que conquistaram crachás de qualidade ou envio rápido (`badge_product_qualityFix`, `badge_local_productFix`) conseguem sustentar preços mais altos (`price`) e maior rentabilidade, reduzindo a necessidade de volume massivo para gerar lucro?
* **O que a base responde:** Validar se a presença de `badges_countFix` permite praticar um preço médio mais elevado sem sacrificar as `units_sold`, provando que o investimento em qualidade/logística local é economicamente viável.
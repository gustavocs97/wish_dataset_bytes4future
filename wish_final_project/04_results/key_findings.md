# key_findings — Conclusões Principais
> 5–6 conclusões consolidadas que respondem diretamente à questão de negócio.
---
## 1. Preço baixo ≠ má qualidade (mas há exceções)
- **O que os dados mostram:** produtos com preço > 15€ têm avaliações médias superiores, mas há outliers com preço baixo e boa classificação.
- **Colunas:** `price`, `rating`, `units_sold`
- **Para o slide:** "Barato nem sempre é descartável — mas o consumidor que paga mais recebe melhor."
## 2. Distância de origem não se reflete no frete
- **O que os dados mostram:** não há correlação entre distância do país de origem e valor do frete pago. O custo ambiental do transporte não está internalizado no preço.
- **Colunas:** `distance_km`, `shipping_price`, `origin_country`
- **Para o slide:** "O ambiente não tem preço — porque o frete não o reflete."
## 3. Resíduos têxteis concentrados em poucos produtos
- **O que os dados mostram:** top 10% dos produtos em `units_sold` geram ~40% do peso estimado de resíduos têxteis.
- **Colunas:** `estimated_textile_kg`, `units_sold`, `product_type`
- **Para o slide:** "Poucos produtos, muito impacto — concentrar esforços nos best-sellers."
## 4. Banners de urgência não sinalizam qualidade
- **O que os dados mostram:** produtos com `has_urgency_banner` não têm rating médio diferente dos sem banner. A urgência é tática, não informativa.
- **Colunas:** `has_urgency_banner`, `rating`, `units_sold`
- **Para o slide:** "Urgência não é qualidade — é pressão de compra."
## 5. CO₂ do transporte aéreo domina emissões
- **O que os dados mostram:** o avião emite ~8× mais CO₂ que o transporte marítimo por km. Produtos enviados de países com voos diretos (China→Europa) têm pegada muito superior.
- **Colunas:** `distance_km`, `origin_country`, `CO2_emissions`
- **Para o slide:** "O maior poluidor não está no produto — está no caminho até cá."
## 6. Sustentabilidade e rentabilidade podem coexistir
- **O que os dados mostram:** produtos com bom rating e preço médio têm `units_sold` comparável ou superior a produtos baratos. Qualidade percebida não reduz vendas.
- **Colunas:** `price`, `rating`, `units_sold`, `negative_rating_pct`
- **Para o slide:** "A Wish pode vender melhor sem vender mais lixo."
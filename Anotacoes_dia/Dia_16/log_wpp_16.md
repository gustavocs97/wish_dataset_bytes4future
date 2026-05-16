# Diário de Bordo do Projeto - 16 de Maio de 2026

## 1. Resumo do Dia
O dia foi altamente produtivo e estratégico. O grupo superou imprevistos logísticos (saúde de um integrante e trânsito na cidade do Porto devido a festividades) e realizou uma **pivotagem crucial no escopo do projeto**: a transição de uma análise de vendas tradicional para uma estratégia focada em **Sustentabilidade e Impacto Ambiental (ESG)** atrelada ao lucro do negócio. Além disso, foi resolvida uma inconsistência na importação dos dados e estabelecida a infraestrutura técnica (GitHub, Deepnote, Figma).

---

## 2. Estrutura 5W2H da Discussão

* **O quê (What):**
    * Redefinição do Objetivo de Negócio (*Business Goal*) focando em padrões de consumo sustentável na plataforma Wish.
    * Resolução do bug de quebra de linhas do dataset no Power BI.
    * Criação do *Data Treatment Log* e definição das camadas de *storytelling* unindo as competências do grupo.
* **Por quê (Why):**
    * *Estratégia:* Para criar um diferencial real no projeto final utilizando *storytelling* avançado. O consumidor moderno (especialmente o europeu) compra baseado em valores ESG, tornando o tema financeiramente atraente e inovador.
    * *Técnico:* A linha 1555 estava a corromper a estrutura de colunas do Power BI devido a configurações de delimitadores.
* **Quem (Who):**
    * *Gustavo:* Puxou a frente de Estrutura, Normas, Tratamento de Dados e Git/Deepnote.
    * *Ricardo:* Puxou as Definições, Escrita do Objetivo de Negócio e Argumentação de Lucro sustentável.
    * *Letícia:* Puxou a ideia de Impacto Ambiental, Análise de Cultura/Design e correção visual/técnica no Power BI.
* **Onde (Where):** Reunião híbrida. Ricardo remotamente via Microsoft Teams (por motivos de saúde) e Letícia/Gustavo presencialmente na República (Porto), enfrentando restrições de estacionamento pelas festas do Porto nos Aliados.
* **Quando (When):** 16/05/2026, das 07h27 às 23h20.
* **Como (How):**
    1. *Pivotagem para ESG:* Cruzamento de variáveis de logística (`shipping_is_express`, `origin_country`), qualidade (`rating`) e preço (`price`) com o volume de vendas para entender desperdício e emissão de CO₂.
    2. *Correção do Dado:* O arquivo foi importado no Google Sheets (onde abriu corretamente), confirmando que o erro era de configuração do Power BI. Resolvido ativando a opção de "ignorar quebra de linhas" na importação.
    3. *Infraestrutura:* Criação do repositório Git, ambiente de Preview de Markdown, projeto no Deepnote e rascunho dos slides no Figma.
* **Quanto (How Much):** A estratégia ESG foca em provar que práticas eco-friendly geram lucro através da atração de consumidores conscientes, captação de investimentos ESG globais e redução de custos logísticos ineficientes (ex: mitigar envios expressos que não geram pico real de vendas).

---

## 3. Motivação e Justificativa das Decisões

### O Storytelling Unificado
O grupo rejeitou a separação silada de tarefas ("um faz slides, outro escreve, outro valida"). Decidiu-se que o *storytelling* é o fio condutor: a análise técnica do Gustavo alimenta o contexto e o argumento do Ricardo, que por sua vez direciona o design de impacto da Letícia.

### A Escolha do Tema ESG/Sustentabilidade
A Wish peca criticamente em logística comparada à Temu (que consolida pedidos em embalagens únicas). A Wish envia pacotes individuais e fragmentados. O grupo percebeu que mapear este impacto negativo, propondo um "Score de Sustentabilidade" sem canibalizar o lucro, daria ao projeto o nível de maturidade exigido para uma banca avaliadora.

### Regra de Ouro no Tratamento de Dados
Estabeleceu-se que os dados originais na pasta `raw/` são **intocáveis**. Qualquer correção (como o tratamento de casos onde `price > retail_price` em 35% da base) será documentada no *Data Treatment Log* e executada em novas colunas fixadas, garantindo a reprodutibilidade da análise para a mentoria com a Bia no dia seguinte.


## 📋 Checklist de Execução: Análise de Dados (Wish Summer Dataset)

### 1. Higiene e Confiança dos Dados (O Contexto Inicial)

* [ ] **Mapear e remover duplicados:** Identificar registros repetidos usando a chave primária (`product_id`) e aplicar o `.drop_duplicates()`.
* [ ] **Tratar valores nulos:** Tratar nulos estruturais (como a ausência de texto em `urgency_text`, transformando-os em flag binária `0` ou `1`) em vez de simplesmente deletar linhas.
* [ ] **Validar consistência lógica:** Verificar se existem anomalias matemáticas básicas (ex: `price` maior que `retail_price`).
* [ ] **Nota de transparência:** Escrever um parágrafo curto no início explicando ao leitor que os dados foram saneados e estão prontos/confiáveis para análise.

### 2. Rigor Analítico e Investigação (O "Porquê")

* [ ] **Ir além do óbvio:** Explicar a causa raiz do comportamento dos dados (ex: por que faixas específicas de desconto convertem mais).
* [ ] **Mapear Casos Extremos (*Edge Cases*):** Identificar e explicar anomalias (ex: produtos com anúncios pagos (`uses_ad_boosts`) que vendem menos do que a média orgânica devido a avaliações ruins).
* [ ] **Revisão dupla:** Validar se as agregações (`.groupby()`, `.mean()`, `.median()`) fazem sentido lógico antes de tirar conclusões.

### 3. Filosofia Unix & Código Minimalista

* [ ] **Funções de escopo único:** Criar funções onde cada uma faz apenas uma coisa (ex: uma função exclusiva para limpeza, outra exclusiva para engenharia de atributos/criação de colunas).
* [ ] **Evitar *Over-engineering*:** Utilizar métodos nativos e eficientes do Pandas (como `pd.cut()` para faixas de rating ou operadores vetorizados), evitando loops `for` desnecessários.
* [ ] **Uso de cópias explícitas:** Garantir o uso de `.copy()` dentro das funções para evitar o aviso de `SettingWithCopyWarning`.
* [ ] **Isolamento do código:** Posicionar todo o bloco de código estritamente no final da resposta, garantindo que ele não interrompa o fluxo de leitura do texto explicativo.

### 4. Comunicação Humana, Visual e Escaneável

* [ ] **Introdução acolhedora:** Começar com uma breve contextualização humana e empática sobre o dataset e o mercado do Wish.
* [ ] **Linguagem acessível:** Traduzir termos técnicos do código para conceitos de negócios legíveis por qualquer pessoa de outra área.
* [ ] **Formatação rica:**
* Usar **negrito** para destacar métricas cruciais, volumes de vendas ou insights de impacto.
* Utilizar *bullet points* para listar hipóteses e conclusões.
* Construir tabelas Markdown simples para resumir e comparar dados agrupados.


* [ ] **Explicação de Gráficos:** Ao citar ou plotar um gráfico com Seaborn/Matplotlib, detalhar claramente o que os eixos representam e qual a conclusão direta que o leitor deve extrair dele.


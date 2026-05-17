Li tudo. Para segunda (Reunião 1 — 18 mai) o curso exige exactamente isto:

---

## O que precisa de estar pronto para segunda

**1. Objetivo de negócio** — definido como questão
✅ Feito — `business_goal.md`

**2. Variáveis definidas** — colunas relevantes, calculadas e externas
✅ Feito — `variables_definition.md`

**3. Dados testados quanto a exactidão e viabilidade** — isto é o foco principal da Reunião 1:
- Identificar e classificar cada variável: categórica ou contínua
- Localizar valores anómalos: extremos, nulos, incorretos
- Decidir como tratar cada um
- Criar colunas `ColNameFix` com os valores tratados
- Documentar: o quê, como, porquê, e porquê não outro método

✅ Documentado — `data_treatment_log.md`
❌ Não executado ainda — o código de limpeza real não existe

**4. Subquestões formuladas** — a questão principal dividida em sub
✅ Feito — `analysis_subquestions.md`

---

## O que falta mesmo para segunda

São três coisas concretas, por ordem de prioridade:

**Prioridade 1 — O código de limpeza executado**
O `data_treatment_log.md` documenta as decisões mas o código que as executa não existe. Para segunda precisas de ter o dataset processado em `01_data/processed/` — seja via Power Query ou Python. Sem isto não tens dados limpos para analisar.

**Prioridade 2 — Tratar o RFIX_020**
45 produtos com `rating = 5.0` e `rating_count = 0` — boost artificial do Wish. Não está tratado no código nem na documentação de forma completa. É fácil de fazer mas tem de estar feito e documentado.

**Prioridade 3 — A regra de duplicados**
Tens 232 duplicados. Tens de definir e executar a regra: ao fazer `drop_duplicates`, qual linha manter quando um `product_id` tem uma versão com urgency banner e outra sem. Está documentado no `observacoes_externas.md` mas não executado.

---

## O que não precisa de estar pronto para segunda

O código de análise das subquestões — isso é Reunião 2 (terça).
Os slides — isso é Reunião 3 (quinta).
O dashboard final — isso é para quinta também.

---

## Resumo dos 15 minutos de segunda

O professor vai perguntar três coisas:

*"Qual é a vossa questão de negócio?"* → `business_goal.md` responde.

*"Que variáveis vão usar e porquê?"* → `variables_definition.md` responde.

*"Como trataram os dados anómalos?"* → `data_treatment_log.md` responde — mas tens de conseguir mostrar o dataset processado com as colunas Fix criadas. Se não tens o ficheiro `processed/` com as colunas novas, a documentação existe mas a execução não.

O único risco real para segunda é não ter o código de limpeza executado. Queres que faça já o `01_cleaning.ipynb` completo e pronto para correr?
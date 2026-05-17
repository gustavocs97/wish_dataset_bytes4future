
# 02_validation — Validação dos Dados

Testes e controlos de qualidade. Tudo o que prova que os dados
estão corretos antes de a análise começar.

---

## Ficheiros

| Ficheiro | O que contém |
|---|---|
| `validation_report.md` | Relatório escrito: nulos, extremos, incorretos encontrados e tratados |
| `checks.sql` | Queries de controlo — verificação de consistência lógica dos dados |

---

## Regra

Cada query em `checks.sql` tem um comentário a explicar o que testa e o resultado esperado.
Se os cálculos estiverem incorretos, toda a análise está incorreta.
Verificar, reverificar, voltar a verificar.

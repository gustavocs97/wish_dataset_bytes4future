Exato. O storytelling não é uma fase — é o fio que atravessa tudo desde o início.

O problema da estrutura anterior é que separa demais: "Letícia faz os slides, Ricardo escreve, Gustavo valida". Mas um projeto com diferencial real é aquele onde o design já está a pensar na narrativa quando os dados ainda estão a ser limpos, e o escritor já está a formular as subquestões com o analista.

Deixa-me repensar do zero.

---

**O eixo central: uma história com 3 camadas**

Cada fase do projeto tem 3 dimensões simultâneas:

| Dimensão | Quem puxa | O que garante |
|---|---|---|
| **O que os dados dizem** | Gustavo | Rigor, estrutura, verdade dos números |
| **O que isso significa** | Ricardo | Linguagem, contexto, argumento |
| **Como isso chega ao outro** | Letícia | Impacto, clareza visual, memória |

Nenhuma dimensão espera pela outra. As três correm em paralelo em cada fase.

---

**A estrutura revista — fases, não pastas isoladas:**

```
wish_final_project/
│
├── 00_docs/                        
│   ├── business_goal.md            
│   │   # Gustavo: que colunas sustentam a questão
│   │   # Ricardo: formula a questão como problema real de negócio
│   │   # Letícia: define o tom visual e o público-alvo da apresentação
│   │
│   ├── variables_definition.md     
│   │   # Gustavo: seleciona e classifica as colunas
│   │   # Ricardo: escreve o porquê de cada variável importar
│   │   # Letícia: anota quais variáveis vão precisar de visualização
│   │
│   ├── data_treatment_log.md       
│   │   # Gustavo: documenta o quê e como foi tratado
│   │   # Ricardo: justifica o porquê de cada decisão em linguagem clara
│   │   # Letícia: sinaliza onde anomalias viram insight visual
│   │
│   └── analysis_subquestions.md   
│       # Gustavo: define o que é tecnicamente respondível
│       # Ricardo: formula cada subquestão como narrativa
│       # Letícia: esboça como cada resposta vai ser mostrada
│
├── 01_data/
│   ├── raw/                        # Gustavo tutela — ninguém edita
│   └── processed/                  # Gustavo executa a limpeza
│
├── 02_validation/                  
│   ├── validation_report.md        
│   │   # Gustavo: checks técnicos e ColNameFix
│   │   # Ricardo: transforma achados em linguagem de relatório
│   │   # Letícia: identifica quais anomalias merecem destaque visual
│   │
│   └── checks.sql
│
├── 03_analysis/                    
│   ├── sql/                        # Gustavo escreve
│   ├── excel/                      # partilhado
│   ├── powerbi/                    # Letícia e Gustavo em conjunto
│   └── python/                     # Gustavo escreve
│   
│   # A cada subquestão resolvida:
│   # Ricardo escreve 1 parágrafo do que o resultado significa
│   # Letícia esboça como esse resultado vai aparecer no slide
│
├── 04_results/                     
│   ├── charts/                     
│   ├── dashboard_screenshots/      
│   └── key_findings.md             
│       # Gustavo: valida que os números nos findings estão certos
│       # Ricardo: redige as 5-6 conclusões com argumento
│       # Letícia: decide a ordem — qual conclusão abre, qual fecha
│
└── 05_presentation/                
    ├── slides/
    │   └── final_presentation.pptx
    │   # Letícia: design, layout, hierarquia visual
    │   # Ricardo: texto dos slides e guião falado
    │   # Gustavo: revê cada número e gráfico que aparece
    │
    ├── assets/
    └── script.md                   
        # Ricardo escreve, Letícia marca os momentos visuais,
        # Gustavo confirma que nenhum dado está errado no guião
```

---

**Comando:**

```bash
mkdir -p wish_final_project/{00_docs,01_data/{raw,processed},02_validation,03_analysis/{sql,excel,powerbi,python},04_results/{charts,dashboard_screenshots},05_presentation/{slides,assets}} && touch wish_final_project/00_docs/{business_goal.md,variables_definition.md,data_treatment_log.md,analysis_subquestions.md} wish_final_project/02_validation/{validation_report.md,checks.sql} wish_final_project/03_analysis/sql/{01_subquestion_1.sql,02_subquestion_2.sql,03_subquestion_3.sql} wish_final_project/03_analysis/python/{01_cleaning.ipynb,02_eda.ipynb,03_visualization.ipynb} wish_final_project/04_results/key_findings.md wish_final_project/05_presentation/script.md
```

---

O diferencial real não está em quem faz o quê — está em que **nenhuma fase termina sem as três perspetivas terem passado por ela**. O Gustavo não entrega um resultado sem o Ricardo lhe ter dado linguagem e a Letícia ter pensado como vai aparecer. É isso que separa uma análise correta de uma análise que convence.
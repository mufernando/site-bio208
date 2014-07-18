template: page.html

### Cronograma


Aula         Diurno     Noturno     Professor    Conteúdo
---------   --------   ---------   -----------   -------------------------------------------------------------------------------
1            04-Aug     05-Aug      DM           Introdução, contagem de alelos, equilibrio de Hardy-Weinberg
2            11-Aug     12-Aug      DM           Deriva, prática com feijões
3            18-Aug     19-Aug      DM           Modelo básico de seleção natural, simulação de seleção no populus
4            25-Aug     26-Aug      DM           Interação entre deriva e seleção, simulação de deriva e seleção e fluxo gênico
5            01-Sep     02-Sep      DM           Desequilíbrio de ligação, evolução do genoma
Feriado      08-Sep     09-Sep
6            15-Sep     16-Sep      DM           Teoria neutra da evolução molecular
7            22-Sep     23-Sep      Glauco
8            29-Sep     30-Sep                   Prova 1
Temática     06-Oct     07-Oct
9            13-Oct     14-Oct      GM           Adaptação e genética quantitativa 1
10           20-Oct     21-Oct      GM           Adaptação e genética quantitativa  2
Feriado      27-Oct     28-Oct
11           03-Nov     04-Nov      GM           Unidadade de seleção
12           10-Nov     11-Nov      GM           Conceito de espécie
13           17-Nov     18-Nov      GM           Coevolução e macroevolução
14           24-Nov     25-Nov      GM           Evolução e desenvolvimento
15           01-Dec     02-Dec                   Prova 2

<script>
    $(function () {
        $('tbody tr:nth-child(6)').addClass('feriado');
        $('tbody tr:nth-child(13)').addClass('feriado');
        $('tbody tr:nth-child(10)').addClass('tematica');
        $('tbody tr:nth-child(9)').addClass('prova');
        $('tbody tr:nth-child(18)').addClass('prova');
    });
</script>

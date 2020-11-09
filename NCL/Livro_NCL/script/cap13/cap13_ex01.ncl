; Nome do script: cap13_ex01.ncl

begin

year            = ispan(2000,2015,1) ; Cria um vetor de 2000 a 2015
                                     ; com incremento 1.
year@_FillValue = -999               ; Defini o valor indefinido.

year_exc  = (/2001,2005,2007,2010,2014/) ; Anos que serão excluídos.
                                         ; A ideia é obter o índice
                                         ; dos anos que estão fora 
                                         ; desta lista.

i = get1Dindex_Collapse(year,year_exc) ; Obtenção dos índices
                                       ; sem os anos da variável
                                       ; year_exc.
     
print( " i = " + i + "  " + year(i) ) ; Mostra na tela o resultado.

end

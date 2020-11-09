; Nome do script: cap14_ex14.ncl

begin

f = addfile("../../dados/prec.1986.1989.nc","r")

ppt = f->precip ; [time | 48] x [lat | 28] x [lon | 24]

printVarSummary(ppt)

pptmes = ppt * 30 ; Conversão de mm/dia para mm/mês.
                  ; Ao multiplicar por 30 as informações 
                  ; de dimensões e coordenadas foram perdidas.
                  ; Basta usar a função copy_VarCoords para 
                  ; copiar o nome das dimensões e coordenadas 
                  ; da variável "ppt" para "pptmes".
                  ; Sem as informações das dimensões e das 
                  ; coordenadas será impossível gerar a figura.

printVarSummary(pptmes) ; Observe que não há o nome das 
                        ; dimensões e nem das coordenadas.
                
copy_VarCoords(ppt,pptmes) ; Copia as dimensões e coordenadas 
                           ; da variável ppt para pptmes.

printVarSummary(pptmes) ; Note que a variável pptmes agora 
                        ; apresenta as informações das 
                        ; dimensões e das coordenadas.
end

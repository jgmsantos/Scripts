; Nome do script: cap14_ex12.ncl

begin

f = addfile("../../dados/tar.mensal.1979.1988.nc","r")

;***********************************************************
; Leitura do dado
;*********************************************************** 

t = short2flt(f->air) 

; Descompacta o dado para o tipo float porque ele 
; é short. Essa informação foi vista com o ncl_filedump.
; A variável apresenta a seguinte disposição das dimensões
; [time | 120] x [level | 3] x [lat | 73] x [lon | 144].
; Para usar a função de climatologia, as dimensões precisam 
; estar na seguinte ordem: 
; [level | 3] x [lat | 73] x [lon | 144] x [time | 120]
; em que a dimensão time tem que ser a última porque a 
; função será aplicada nessa dimensão. Para isso, será 
; necessário reordenar as dimensões.

; Com o uso do operador "|:" foi possível reordenar as dimensões.
; A nova ordem será:
; [level | 3] x [lat | 73] x [lon | 144] x [time | 120]

t_ord = t(level|:,lat|:,lon|:,time|:) 
                                      
;***********************************************************
; Calcula a climatologia
;***********************************************************
tClm = clmMonLLLT(t_ord) ; Climatologia.
                         ; Será retornado uma variável
                         ; com 12 tempos (meses).

printVarSummary(tClm)

end

; Nome do script: cap14_ex18.ncl

begin

f1 = addfile("../../dados/gpcp.nc","r")
f2 = addfile("../../dados/cmip5.CCSM4.nc","r")

ppt_obs = f1->pc1 ; float pc1(time, lat, lon).
ppt_mod = f2->pc1 ; float pc1(time, lat, lon).
                  ; Índices das dimensões: 0 1 2.
                  ; Os dois arquivos são do tipo
                  ; [time | 27] x [lat | 1] x [lon | 1] que 
                  ; representa a série temporal de precipitação
                  ; observada e simulada.

; Calculando a diferença da raiz quadrada média da precipitação. 
; O cálculo será feito na dimensão tempo ou no índice 0.

rmsdTime = dim_rmsd_n_Wrap(ppt_obs,ppt_mod,0)

; Como o cálculo foi feito na dimensão tempo, restam apenas 
; duas dimensões (lat e lon). Como foi usado a função que tem 
; "_Wrap", não há necessidade de criar as dimensões e coordenadas

printVarSummary(rmsdTime) ; Dimensions and sizes: [lat | 1] x [lon | 1].
                          ; Tem apenas um ponto de lat/lon porque 
                          ; é uma série temporal

print("RMSD = " + rmsdTime) ; RMSD = 1.73723

end 

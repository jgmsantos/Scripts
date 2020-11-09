; Nome do script: cap14_ex13.ncl

begin

f1 = addfile("../../dados/psfc.mensal.1979.1988.nc","r")
f2 = addfile("../../dados/tar.mensal.1979.1988.nc","r")

psfc = short2flt(f1->pres) 
tar  = short2flt(f2->air)  

; Variáveis do tipo short precisam ser descompactadas.
; para float. Informação vista com o ncl_filedump.
; short air ( time, level, lat, lon )
; short pres ( time, lat, lon )

printVarSummary(psfc) ; [time | 120] x [lat | 73] x [lon | 144]
printVarSummary(tar)  ; [time | 120] x [level | 3] x [lat | 73] x [lon | 144]

; 0 (time), 2 (lat) e 3 (lon) são as dimensões de "tar" que correspondem  
; a "psfc"

psfc_conform = conform(tar,psfc,(/0,2,3/)) 

printVarSummary(psfc_conform) 

; A variável "psfc_conform" não possui informações sobre as 
; coordenadas e nome das dimensões.
; Dimensions and sizes:	[120] x [3] x [73] x [144]

copy_VarCoords(tar,psfc_conform) 
; Copiando as coordenadas e as dimensões de "tar" para "psfc_conform"
; [time | 120] x [level | 3] x [lat | 73] x [lon | 144]

printVarSummary(psfc_conform) 
; verificando se as coordenadas e as dimensões foram
; copiadas para "psfc_conform"

end

; Nome do script: cap14_ex15.ncl

begin

f1 = addfile("../../dados/ur.mensal.1979.1988.nc","r")
f2 = addfile("../../dados/tar.mensal.1979.1988.nc","r")

; Variáveis do tipo short precisam ser descompactadas
; para float. Informação vista com o ncl_filedump.

ur = short2flt(f1->rhum) ; short rhum ( time, level, lat, lon )
tk = short2flt(f2->air)  ; short air ( time, level, lat, lon )

td = dewtemp_trh(tk,ur) ; As informações das coordenadas e dimensões 
                        ; de "td" foram perdidas. Basta usar o 
                        ; copy_VarCoords para resolver esse problema.

printVarSummary(td)     
; Dimensions and sizes: [120] x [3] x [73] x [144]

copy_VarCoords(ur,td)   ; Poderia usar no lugar de "ur" o "tk" porque o 
                        ; número de dimensões é o mesmo.

; Dimensions and sizes: [time | 120] x [level | 3] x [lat | 73] x [lon | 144]

printVarSummary(td) 

end

; Nome do script: cap14_ex33.ncl

begin

f = addfile("../../dados/tar.pres.uwnd.vwnd.nc","r")

                            ; Índices    0      1     2    3
tar     = short2flt(f->air) ; short air(time, level, lat, lon), 
                            ; por isso, o uso da função short2flt.
z       = f->level          ; Níveis de pressão em hPa. A variável 
                            ; "level" pertence ao arquivo aberto.

                                ; Lembrando que z = hPa e tar = K.
pt1  = pot_temp(z,tar,1,False)  ; Cálculo da temperatura potencial.
                                ; O valor 1 refe-se a dimensão de
                                ; "tar" que corresponde a "z".

printVarSummary(pt1) 

end 

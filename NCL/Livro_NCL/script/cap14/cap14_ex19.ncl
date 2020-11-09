; Nome do script: cap14_ex19.ncl

begin

f = addfile("../../dados/olr.jan2000.dez2009.nc","r")

olr = short2flt(f->olr) ; [time | 120] x [lat | 73] x [lon | 144]
                        ; short olr ( time, lat, lon )

olr_desv = dim_rmvmean_n_Wrap(olr,0) ; Calcula o desvio em relação 
                                     ; a média para a dimensão 
                                     ; tempo (0) e retém as coordenadas
                                     ; e dimensões.

; Dimensions and sizes: [time | 120] x [lat | 73] x [lon | 144]

printVarSummary(olr_desv) 

end

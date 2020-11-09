; Nome do script: cap14_ex22.ncl

begin

f = addfile("../../dados/gpcp.mensal.1979.2012.nc","r")

ppt = f->precip ; float precip ( time, lat, lon )
                ; [time | 408] x [lat | 72] x [lon | 144]
                ; Dado mensal de precipitação.

xStdTime = dim_stddev_n_Wrap(ppt,0) ; Calcula o desvio padrão 
                                    ; na dimensão tempo (0).

; Dimensions and sizes: [lat | 72] x [lon | 144]
printVarSummary(xStdTime) 

end

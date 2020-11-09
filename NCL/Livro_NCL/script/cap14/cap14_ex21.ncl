; Nome do script: cap14_ex21.ncl

begin

f = addfile("../../dados/gpcp.mensal.1979.2012.nc","r")

ppt = f->precip ; float precip ( time, lat, lon )
                ; [time | 408] x [lat | 72] x [lon | 144]
                ; Dado mensal de precipitação.

opt          = True 
opt@spi_type = 3 ; Calcula o spi usando a distribuição de Pearson III.

spi = dim_spi_n(ppt,12,opt,0)   ; São necessários 4 argumentos:
                                ; 1) a variável precipitação (ppt).
                                ; 2) o valor para calcular o SPI (12).
                                ; Lembrando que neste caso os 11 primeiros
                                ; tempos serão indefinidos.
                                ; O opt usa a distribuição de Pearson III.
                                ; E "0" define qual a dimensão será 
                                ; aplicada a função, neste caso, será a 
                                ; dimensão tempo (0).

printVarSummary(spi) ; Ao calcular o spi as informações das coordenadas
                     ; e dimensões foram perdidas.
                     ; Dimensions and sizes: [408] x [72] x [144]

copy_VarCoords(ppt,spi) ; Por isso, é necessário copiar as coordenadas e
                        ; dimensões de "ppt" para "spi"

printVarSummary(spi) 
; O spi possui as coordenadas e dimensões corretas
; Dimensions and sizes: [time | 408] x [lat | 72] x [lon | 144]

end

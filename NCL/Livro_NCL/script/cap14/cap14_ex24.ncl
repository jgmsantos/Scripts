; Nome do script: cap14_ex24.ncl

begin

f = addfile("../../dados/gpcp.mensal.1979.2012.nc","r")

ppt = f->precip ; float precip ( time, lat, lon )
                ; [time | 408] x [lat | 72] x [lon | 144]
                ; Dado mensal de precipitação.

info_ppt = dimsizes(ppt) ; Informações sobre o tamanho das 
                         ; dimensões da variável info_ppt.

print(info_ppt) ; Serão retornadas as seguintes informações:
		; (0) 408 => número de tempos.
		; (1) 72  => número de pontos de lat.
		; (2) 144 => número de pontos de lon.
end

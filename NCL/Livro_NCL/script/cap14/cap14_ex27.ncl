; Nome do script: cap14_ex27.ncl

begin

f = addfile("../../dados/tar.mensal.1979.1988.nc","r")

lat = f->lat ; float lat(lat). Variável que está no arquivo.
lon = f->lon ; float lon(lon). Variável que está no arquivo.
             ; A variável "lon" esta no formato 0-360.
             ; O nome foi visto com o ncl_filedump.

rlat = (/-1.5  , 45.0/)  ; Qual a lat/lon que está mais próxima
rlon = (/307.0 , 271.0/) ; destes pontos ( (-1.5,307) e (45,271) )?

i_rlat = ind_nearest_coord(rlat,lat,0) ; Calcula o índice da latitude 
                                       ; mais próximo dos pontos 
                                       ; -1.5 e 45.0.

i_rlon = ind_nearest_coord(rlon,lon,0) ; Calcula o índice da longitude 
                                       ; mais próximo dos pontos 
                                       ; 300 e 270.

print("rlat = " + rlat + " i_rlat = " + i_rlat + \ 
      " lat = " + lat(i_rlat) + " lon = " + lon(i_rlon))

; Resposta:
; (0)	rlat = -1.5 i_rlat = 37 lat = -2.5 lon = 307.5
; (1)	rlat = 45 i_rlat = 18 lat = 45 lon = 270

end

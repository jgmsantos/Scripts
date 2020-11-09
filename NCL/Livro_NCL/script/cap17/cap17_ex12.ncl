; Nome do script: cap17_ex12.ncl

begin

f = addfile("../../dados/wrfout_d01_2010-03-15_00_00_00","r")

lat2d  = f->XLAT(0,:,:) ; Importa a variável XLAT. Essa variável será 
                        ; utilizada na interpolação.

lon2d  = f->XLONG(0,:,:) ; Importa a variável XLON. Essa variável será 
                         ; utilizada na interpolação. 

t2 = wrf_user_getvar(f,"T2",-1) ; float T2(Time, south_north, west_east). 
                                ; O valor -1 quer dizer para ler todos 
                                ; os tempos.

; float XLAT(Time, south_north, west_east). 
; O valor 0 quer dizer para ler apenas o primeiro tempo.
t2@lat2d = wrf_user_getvar(f,"XLAT",0)  

; float XLONG(Time, south_north, west_east). 
;O valor 0 quer dizer para ler apenas o primeiro tempo.
t2@lon2d = wrf_user_getvar(f,"XLONG",0)

; (0)	TEMP at 2 M: min=272.116   max=308.423
printMinMax(t2,0) ; Mostra o mínimo e máximo valor da variável t2.

; (0)	LATITUDE, SOUTH IS NEGATIVE: min=-19.3722   max=19.3722
printMinMax(lat2d,0) ; Mostra o mínimo e máximo valor da variável lat2d.

; 0)	LONGITUDE, WEST IS NEGATIVE: min=-88.9592   max=-21.0408
printMinMax(lon2d,0) ; Mostra o mínimo e máximo valor da variável lon2d.

; Seleção de um domínio global para interpolar o dado. 
; Resolução espacial de 2.5° (lat x lon).
; 180°/2.5° = 73 pontos de latitude. 90° graus do HN e 90° do HS = 180°
; 360°/2.5° = 144 pontos de longitude. 360° quer dizer todas as longitudes.

; Criação das coordenadas para interpolar o dado. Mesmo sendo um dado 
; regional, a interpolação é feita em um domínio global e na hora de gerar 
; a figura, basta aplicar um zoom na área de interesse. Os dados somente 
; serão interpolados onde tiver dados. Essa informação será utilizada como 
; nova grade da variável.

; Cria um vetor do tipo float de -90 a 90 com 73 valores.
lat = fspan(-90,90,73)           
; Cria um vetor do tipo float de -178.75 a 178.75 com 144 valores.
lon = fspan(-178.75,178.75,144)  

; Interpola de uma grade curvilinear para uma grade rectilinear de 2.5°x2.5°. 

t2_rect = rcm2rgrid(lat2d,lon2d,t2,lat,lon,0)

printVarSummary(t2_rect)

; Criação das dimensões e coordendas da variável t2_rect.
t2_rect!0         = "time"
t2_rect!1         = "lat"
t2_rect!2         = "lon"
t2_rect&lat       = lat
t2_rect&lon       = lon
t2_rect&lat@units = "degrees_north"
t2_rect&lon@units = "degrees_east"

printVarSummary(t2_rect)

end

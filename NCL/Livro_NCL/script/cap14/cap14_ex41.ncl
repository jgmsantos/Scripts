; Nome do script: cap14_ex41.ncl

begin

;                 442   72  144
; float precip ( time, lat, lon )

f = addfile("../../dados/precip.mon.mean.nc","r") 

lat = f->lat                ; Importação da variável lat.
ppt = f->precip             ; Importação da variável precip.

rad  = 4.0*atan(1.0)/180.0  ; Para radianos => 0.01745329
clat = cos(lat*rad)         ; Pesos que serão utilizados.

; Média sem ponderação.
pptma1 = wgt_areaave_Wrap(ppt,1.0,1.0,0)  

; Média com ponderação na latitude.
pptma2 = wgt_areaave_Wrap(ppt,clat,1.0,0) 

; Imprime na tela apenas o primeiro tempo (0) => 2.223029
print( pptma1(0) ) 

; Imprime na tela apenas o primeiro tempo (0) => 2.703792
print( pptma2(0) ) 

; Resultado obtido com o GrADS: 2.70379
; Resultado obtido com o CDO: 2.70388

end

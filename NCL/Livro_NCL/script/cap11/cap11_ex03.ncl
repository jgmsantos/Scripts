; Nome do script: cap11_ex03.ncl

begin

; As informações abaixo são do comando ==> ncdump prec.2005.nc
;
;netcdf prec.2005 {
;dimensions:
;	lon = 1 ;
;	lat = 1 ;
;	time = UNLIMITED ; // (12 currently)
;variables:
;	double lon(lon) ;
;		lon:standard_name = "longitude" ;
;		lon:long_name = "longitude" ;
;		lon:units = "degrees_east" ;
;		lon:axis = "X" ;
;	double lat(lat) ;
;		lat:standard_name = "latitude" ;
;		lat:long_name = "latitude" ;
;		lat:units = "degrees_north" ;
;		lat:axis = "Y" ;
;	double time(time) ;
;		time:standard_name = "time" ;
;		time:long_name = "time" ;
;		time:units = "days since 1900-1-1 00:00:00" ;
;		time:calendar = "standard" ;
;		time:axis = "T" ;
;	double pre(time, lat, lon) ;
;		pre:long_name = "precipitation" ;
;		pre:units = "mm" ;
;		pre:_FillValue = 9.96920996838687e+36 ;
;		pre:missing_value = 9.96920996838687e+36 ;
;		pre:correlation_decay_distance = 450. ;
;data:
;
; lon = 0 ;
;
; lat = 0 ;
;
; time = 38366, 38396, 38425, 38456, 38486, 38517, 38547, 38578, 38609, 
;        38639, 38670, 38700 ;
;
; pre =
;  5.31968154222574,
;  5.59480643916749,
;  6.4032231783253,
;  5.18781546763753,
;  4.98682642410234,
;  3.40967712475132,
;  2.50282044695336,
;  2.63375088184085,
;  2.59883242095348,
;  3.97419849336847,
;  4.22262434923237,
;  5.93353982877502 ;
;}

; Abertura do arquivo para edição ("w").
f = addfile("../../dados/prec.2005.nc","w") 

lat_n = -10 ; Alterando o valor da latitude que antes era "0".
lon_n = 300 ; Alterando o valor da longitude que antes era "0".

; São os novos valores alterados.
prec_n = (/6.2,6.4,7.0,4.0,3.5,2.0,8.3,3.2,5.5,1.8,0.4,3.6/) 

; O nome "pre" é o nome da variável existente no arquivo que receberá 
; o novo conteúdo da variável "prec_n".

f->pre = (/prec_n/) ; O símbolo (/.../) apenas salva os valores da 
f->lat = (/lat_n/)  ; variável.
f->lon = (/lon_n/)

end

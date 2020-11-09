; Nome do script: cap17_ex11.ncl

begin

a    = addfile("../../dados/trmm.2009.mensal.nc","r")
prec = a->r

; Como o dado apresenta valores ausentes, é necessário definir 
; o atributo para valores ausentes.

prec@_FillValue = getFillValue(prec) ; Defino o valor ausente do dado.
                                     ; A função getFillValue guarda 
                                     ; o valor ausente 
                                     ; da variável prec (-9999).

printVarSummary(prec) ; lat: [-49.875..49.875]
                      ; lon: [-179.875..179.875]
                      ; Resolução espacial de 0.25° lat x 0.25° lon.

; Criação das coordenadas de latitude e de longitudes da nova váriavel 
; interpolada. A função fspan cria um vetor de valores do tipo float. 
; Serão criados 144 valores variando de -178.75 a 178.75. O valor 144 
; é o número de pontos do GPCP. O mesmo raciocínio é aplicado para a 
; latitude, isto é, serão criados 72 valores de latitude variando 
; de -49.875 a 49.875.

new_lat = fspan(-49.875,49.875,72)
new_lon = fspan(-178.75,178.75,144)

; Realiza a interpolação bilinear. A variável prec_interp é a variável 
; que será interpolada.
; prec&lon: Acessa os valores das coordenadas de longitude. O nome lon é 
; a dimensão do arquivo aberto. As dimensões são time, lat e lon. Caso o 
; arquivo aberto tenha o nome longitude, altere o nome para 
; prec&longitude.
; prec&lat: Acessa os valores das coordenadas de latitude. O mesmo 
; raciocínio da longitude se aplica para a latitude.
; prec: É a variável do arquivo que foi aberto.
; True: Porque o dado é global.
; new_lon: São as coordenadas de longitude criadas acima.
; new_lat: São as coordenadas de latitude criadas acima.
; 0: Não tem nenhum uso.

prec_interp = linint2_Wrap(prec&lon,prec&lat,prec,True,new_lon,new_lat,0)

printVarSummary(prec_interp) ; [time | 12] x [LAT | 72] x [LON | 144]
                             ;    0            1             2       

; O resultado do comando printVarSummary(prec_interp):

;Coordinates: 
; time: [96432..104448]
; LAT: [-49.875..49.875] => O NCL não gosta do nome LAT em maiúsculo. 
;                           Tem que ser lat.
; LON: [-178.75..178.75] => O NCL não gosta do nome LON em maiúsculo. 
;                           Tem que ser lon.

; Renomeando as dimensões de LON para lon e LAT para lat e atribuindo 
; uma unidade para cada uma delas.

; A posição 0 é a dimensão tempo.
prec_interp!1         = "lat"
prec_interp!2         = "lon"
prec_interp&lat@units = "degrees_north"
prec_interp&lon@units = "degrees_east"

printVarSummary(prec_interp)

end

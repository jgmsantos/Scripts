; Nome do script: cap17_ex09.ncl

begin

; Este script interpola os dados de uma grade gaussiana para uma grade 
; fixa e retém os metadados. Caso seja encontrado algum valor ausente, 
; para este determinado ponto não será feita a interpolação e será 
; retornado o valor ausente.

; Esta função é utilizada apenas para dados globais e não deve ser 
; utilizada para dados regionais. 

; São necessários dois parâmetros para essa função:

; 1) O dado de entrada precisa ser uma variável com 2 ou mais dimensões 
; em que as dimensões mais a direita são latitude e longitude. 
; Os valores estar devem na ordem ascendente de latitude.

; 2) Um arranjo indicando a grade de saída das dimensões mais a direita, 
; onde a primeira informação é a latitude e a segunda, a longitude.

a = addfile("../../dados/MCGA.1985.nc","r") 

prec = a->prec

printVarSummary(prec)

; Resultadod do comando printVarSummary(prec):
;
;Variable: prec
;Type: float
;Total Size: 73728 bytes
;            18432 values
;Number of Dimensions: 3
;Dimensions and sizes:	[time | 1] x [lat | 96] x [lon | 192]
;Coordinates: 
;            time: [   0..   0]
;            lat: [88.57217..-88.57217] => latitude de norte para sul
;            lon: [   0..358.125]

; Interpola de uma grade gaussiana para uma grade fixa com as seguintes 
; dimensões 72 lat x 144 lon. 
; (:,::-1,:) => Inversão da latitude como requisito da função que 
; foi explicado acima.

prec_interp = g2fsh_Wrap(prec(:,::-1,:),(/72,144/))   

printVarSummary(prec_interp)

; Resultado do comando printVarSummary(prec_interp)
;
;Variable: prec_interp
;Type: float
;Total Size: 41472 bytes
;            10368 values
;Number of Dimensions: 3
;Dimensions and sizes:	[time | 1] x [lat | 72] x [lon | 144]
;Coordinates: 
;            time: [   0..   0]
;            lat: [-90..90]      => Latitude de sul para norte
;            lon: [ 0..357.5]

end

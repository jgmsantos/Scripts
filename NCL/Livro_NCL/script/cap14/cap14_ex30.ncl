; Nome do script: cap14_ex30.ncl

begin

f = addfile("../../dados/tar.mensal.1979.1988.nc","r")

t = f->air ; O nome das dimensões da variável 
           ; "air" são time, level, lat e lon

; O "t" é a variável que foi importada do arquivo "f".
; A função checará se a variável "t" é do tipo float. 
; Caso seja verdade, retornará como resultado True, 
; caso contrário, False.

check = isfloat(t)

print(check) ; A resposta será:
             ; (0) False
end

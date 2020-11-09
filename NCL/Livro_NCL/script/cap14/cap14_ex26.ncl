; Nome do script: cap14_ex26.ncl

begin

; Exemplo1:

; Define um vetor qualquer.
a            = (/1,2,3,4,5,5,4,3,2,1,1,2,3,4,5/) 
a@_FillValue = 5 ; Define o valor indefinido igual a 5.

; Retorna os índices onde os valores são indefinidos.
b = ( ind( ismissing(a) ) ) 
 
print(b) ; Motra na tela os índices.
         ; Resposta: 4, 5 e 14. 
         ; Lembrando que no NCL o índice
         ; inicia em zero e não em 1.

; Exemplo2:

c = ind( a .eq. 4 ) ; Qual é o índice no vetor "a" que 
                    ; é igual a 4?

print(c) ; Resposta: 3, 6 e 13.

end

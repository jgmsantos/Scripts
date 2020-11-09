; Nome do script: cap14_ex32.ncl

begin

f = addfile("../../dados/omega.pressao.tar.R1.nc","r")

omega   = f->omega ; (Pa/s) => float omega(time, level, lat, lon)
pressao = f->pres  ; (Pa)   => float pres(time, lat, lon)
tar     = f->air   ; (K)    => float air(time, level, lat, lon)

; Lembrando que as variáveis devem ter o mesmo número de dimensões
; e a mesma forma. A variável pressão não apresenta as mesmas
; dimensões das demais variáveis (omega e tar). Para resolver isso, 
; será utilizada a função conform para uniformizar todas as dimensões.
; As dimensões da variável "omega" que coincidem com as dimensões da
; variável "pressao" são: 0 = tempo, 2 = latitude e 3 = longitude.
 
; A variável "pressao_N" possui as mesmas coordenadas e dimensões de 
; "omega". Houve perda das informações de coordenadas e dimensões.
pressao_N = conform(omega,pressao,(/0,2,3/)) 

printVarSummary(pressao_N)      

; Dimensions and sizes: [5] x [12] x [73] x [144]

; Copia as coordenadas e dimensões da variável "omega" para "pressao_N".
copy_VarCoords(omega,pressao_N) 

printVarSummary(pressao_N) 

; Dimensions and sizes: [time | 5] x [level | 12] x [lat | 73] x [lon | 144]

w = omega_to_w(omega,pressao_N,tar) ; Cálculo de w (m/s)

printVarSummary(w) 

; Dimensions and sizes: [time | 5] x [level | 12] x [lat | 73] x [lon | 144]

end

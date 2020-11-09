; Nome do script: cap17_ex05.ncl

begin

f = addfile("../../dados/olr.jan2000.dez2009.nc","r")

olr = short2flt(f->olr)

printVarSummary(olr) ; [time | 120] x [lat | 73] x [lon | 144]
                     ; time: [1753152..1840080]
                     ; lat: [90..-90] => latitude de norte para sul.
                     ; lon: [ 0..357.5]

; A latitude deve ser de sul para norte ("::-1").
; 181 pontos na direção y (latitude) e 360 pontos na direção x (longitude).
olrR = f2fsh_Wrap(olr(:,::-1,:),(/181,360/)) 

printVarSummary(olrR) ; [time | 120] x [lat | 181] x [lon | 360]
                      ; time: [1753152..1840080]
                      ; lat: [-90..90] => latitude de sul para norte.
                      ; lon: [ 0..359]

end

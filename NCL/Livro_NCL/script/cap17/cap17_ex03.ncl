; Nome do script: cap17_ex03.ncl

begin

f = addfile("../../dados/olr.jan2000.dez2009.nc","r")

olr = short2flt(f->olr)

printVarSummary(olr) ; [time | 120] x [lat | 73] x [lon | 144]
                     ; time: [1753152..1840080]
                     ; lat: [90..-90] => latitude de norte para sul.
                     ; lon: [ 0..357.5]

; A latitude deve ser de sul para norte ("::-1").
olrR = f2fosh_Wrap(olr(:,::-1,:)) 

printVarSummary(olrR) ; [time | 120] x [lat | 72] x [lon | 144]
                      ; time: [1753152..1840080]
                      ; lat: [-88.75..88.75] => latitude de sul 
                      ; para norte.
                      ; lon: [1.25..358.75]

end

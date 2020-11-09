; Nome do script: cap17_ex07.ncl

begin

f = addfile("../../dados/precip.mon.mean.nc","r")

ppt = f->precip

printVarSummary(ppt)    ; [time | 442] x [lat | 72] x [lon | 144]
                        ; time: [65378..78800]
                        ; lat: [88.75..-88.75]
                        ; lon: [1.25..358.75]

pptR = fo2fsh_Wrap(ppt) ; Realiza a interpolação.

printVarSummary(pptR)   ; [time | 442] x [lat | 73] x [lon | 144]
                        ; time: [65378..78800]
                        ; lat: [-90..90]   => Nova latitude interpolada
                        ; lon: [ 0..357.5] => Nova longitude interpolada
end

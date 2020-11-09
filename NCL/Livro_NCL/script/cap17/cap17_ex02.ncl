; Nome do script: cap17_ex02.ncl

begin

f = addfile("../../dados/zg_hadgem2_200501.nc","r")

zgeo = f->zg ; float zg ( time, plev, lat, lon )

; [time | 1] x [plev | 17] x [lat | 144] x [lon | 192]
printVarSummary(zgeo) 

is_cyclic = True    ; Dado global.
guess     = 1       ; Usa média zonal.
nscan     = 1000    ; Número máximo de iterações a ser usado.
epsx      = 1.0e-2  ; Variável dependente.
relc      = 0.6     ; Coeficiente de relaxação.
opt       = 0       ; Não usado.

; Preenchimento dos dados ausentes.
poisson_grid_fill(zgeo,is_cyclic,guess,nscan,epsx,relc,opt) 

; [time | 1] x [plev | 17] x [lat | 144] x [lon | 192]
printVarSummary(zgeo) 

; Em seguida, basta realizar o plot utilizando a variável zgeo.

end

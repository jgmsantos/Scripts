; Nome do script: cap14_ex40.ncl

begin

f = addfile("../../dados/tar.pres.uwnd.vwnd.nc","r")

u    = short2flt(f->uwnd) ; short vwnd ( time, level, lat, lon )
v    = short2flt(f->vwnd) ; short vwnd ( time, level, lat, lon )
                          ; A latitude está em ordem ascendente:
                          ; lat: [90..-90] e o dado é global.

vrt = uv2vrF_Wrap(u, v)  ; Calcula a vorticidade (1/s).
uvr = vr2uvF_Wrap(vrt)   ; Calcula o rotacional das componentes 
                         ; do vento (m/s).

printVarSummary(uvr)

; Resultado do comando printVarSummary(uvr):
; Dimensions and sizes:	[component | 2] x [time | 3] x [level | 12] x 
;                       [lat | 73] x [lon | 144]
; Onde: [component | 2] quer dizer que o índice 0 é o rotacional 
; da componente zonal e 1 é o rotacional da componente meridional.

end

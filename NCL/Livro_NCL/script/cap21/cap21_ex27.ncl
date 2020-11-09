; Nome do script: cap21_ex27.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r") 

 ; [time | 3] x [level | 12] x [lat | 73] x [lon | 144]
u = short2flt(f->uwnd)
v = short2flt(f->vwnd)

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex27")

; Como o dado é 4D (time,level,lat,lon) é necessário que ele seja do 
; tipo 2D (lat,lon) para gerar a figura. Por isso, a redução de 
; dimensão de 4 para 2, isto é, lat e lon mediante a fixação do 
; tempo (0) e nível vertical em 850hPa (detalhe para o uso do símbolo 
; "{}").

; O gráfico será gerado sem nenhuma formatação, por isso, o False.

plot = gsn_csm_streamline_map_ce(wks,u(0,{850},:,:), \ 
                                     v(0,{850},:,:),False)

end

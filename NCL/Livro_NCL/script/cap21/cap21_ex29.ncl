; Nome do script: cap21_ex29.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r") 

 ; [time | 3] x [level | 12] x [lat | 73] x [lon | 144]
u   = short2flt(f->uwnd)
v   = short2flt(f->vwnd)
vel = sqrt(u^2+v^2)

copy_VarCoords(u,vel)

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex29")

res                       = True
res@stArrowLengthF        = 0.008  ; Tamanho das flechas dos vetores.
res@stMinArrowSpacingF    = 0.001  ; Espaçamento dos vetores da mesma
                                   ; linha.
res@stArrowStride         = 1      ; Número de vetores em cada linha,
                                   ; quanto menor o valor, mais vetores.
res@stLineThicknessF      = 1.5    ; Espessura da linha.
res@stLineColor           = "red"  ; Cor da linha.
res@mpMinLonF             = -110.0 ; Aplica 
res@mpMaxLonF             = -10.0  ; um zoom
res@mpMinLatF             = -60.0  ; na área de
res@mpMaxLatF             =  20.0  ; interesse.
res@gsnLeftString         = ""     ; Título do lado esquerdo. Caso não
                                   ; queira plotar nada, basta colocar "".
res@gsnCenterString       = "Linhas de corrente e velocidade (colorido)"
res@gsnRightString        = ""     ; Título do lado direito.
res@gsnMajorLonSpacing    = 10     ; Espaçamento do eixo x da longitude.
res@gsnMajorLatSpacing    = 10     ; Espaçamento do eixo y da latitude.
res@tmXBMinorOn           = False  ; Desabilita os traços secundários dos 
res@tmYLMinorOn           = False  ; eixos x e y.
res@mpFillOn              = False ; Mapa sem preenchimento (fundo branco).
res@mpOutlineBoundarySets = "National" ; Mostra divisão dos países.
res@mpDataSetName         = "Earth..4" ; Para a mostrar a divisão dos 
res@mpDataBaseVersion     = "MediumRes"; estados brasileiros, são 
res@mpOutlineSpecifiers   = (/"Brazil:states"/) ; necessárias estas três 
                                       ; linhas.
res@stLevelSpacingF       = 10.0       ; Espaçamento entre as linhas das 
                                       ;linhas de corrente.

; Como o dado é 4D (time,level,lat,lon) é necessário que ele seja do 
; tipo 2D (lat,lon) para gerar a figura. Por isso, a redução de dimensão
; de 4 para 2, isto é, lat e lon mediante a fixação do tempo (0) e 
; nível vertical em 850hPa (detalhe para o uso do símbolo "{}").

nivel = 200 ; Nível vertical de interesse.

plot = gsn_csm_streamline_scalar_map(wks,u(0,{nivel},:,:),\
                                         v(0,{nivel},:,:),\
                                         vel(0,{nivel},:,:),res)

end

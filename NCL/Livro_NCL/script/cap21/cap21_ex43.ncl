; Nome do script: cap21_ex43.ncl

begin

f = addfile("../../dados/olr.01jan2000a31dez2004.nc","r")

timeUnits = f->time@units
ti        = cd_inv_calendar(2000,11,01,00,0,0,timeUnits,0)
tf        = cd_inv_calendar(2000,12,31,00,0,0,timeUnits,0)

latS = 2.5  ; Latitude de interesse
latN = 15.0 ; para fazer a média.

olr  = short2flt(f->olr({ti:tf},{latS:latN},:))

; Média na dimensão latitude (1) entre 2.5N e 15N. 
; Com isso, restam apenas as dimensões [time | 61] x [lon | 144]
olrM = dim_avg_n_Wrap(olr,1)

timeUnits = "days since 1800-01-01 00:00:00"
olr&time  = ut_convert(olrM&time,timeUnits )

cmap = read_colormap_file("BlueDarkRed18")

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex43")

res                      = True
res@gsnMaximize          = True
res@cnFillOn             = True  ; Habilita o preechimento.
res@cnLineLabelsOn       = False ; Sem rótulos nas isolinhas.
res@cnInfoLabelOn        = False ; Sem informações da variável.
res@cnLinesOn            = False ; Não mostra as isolinhas.
res@cnFillPalette        = cmap(9::-1,:) ; Seleciona um subconjunto 
                                         ; da escala de cores e 
                                         ; inverte as cores.
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/160,180,200,220,240/) ; Valores que desejo.
res@trYReverse           = True                    ; Inverte o eixo y.
res@gsnLeftString        = ""
res@gsnCenterString      = ""
res@gsnRightString       = "(W m~S~-2~N~)"
res@tiMainString         = "ROL : M"+eacute+"dia entre " + \ 
                           latS + "N e " + latN+"N"
res@tiYAxisString        = "Dias"

; Fixa recursos especiais para o eixo do tempo.
resTick                = True
resTick@ttmFormat      = "%d%c%Y" ; dMmmAAAA => Exemplo: 1Jan2000
resTick@ttmAxis        = "YL"     ; Formata o eixo y da esquerda.
resTick@ttmMajorStride = 5        ; Espaçamento das datas no eixo y.

time_axis_labels(olrM&time,res,resTick)

plot = gsn_csm_hov(wks,olrM(:,{120:320}),res)

end

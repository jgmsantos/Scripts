; Nome do script: cap21_ex54.ncl

begin

f = addfile("../../dados/uv.10m.jan1979.dez2014.nc","r")

u = short2flt(f->uwnd(:,0,0,0)) 
v = short2flt(f->vwnd(:,0,0,0)) 

dirv = wind_direction(u,v,0) ; Calcula a direção do vento em graus.
velv = wind_speed(u,v)       ; Calcula a velocidade do vento (m/s).

numPetals = 8

circFr    = 10.0  ; Frequência com que os círculos aparecem na figura.
spdBounds = (/2.,3.,4.,5./)*1.0 ; Limites de velocidade para 
                                ; a linha mais espessa.

colorBounds = (/"blue","green","yellow","red"/) 

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex54")

res              = True
res@tiMainString = "Rosa dos ventos - Jan/1979 a dez/2014"
res@gsnFrame     = False

plot = WindRoseColor(wks,velv,dirv,numPetals,circFr,spdBounds, \ 
                     colorBounds,res)  
 
; Criação da legenda da velocidade.
   
lbres                    = True          
lbres@lbAutoManage       = False ; Necessário para controlar o tamanho.
lbres@vpWidthF           = 0.05  ; Largura da legenda.
lbres@vpHeightF          = 0.15  ; Altura da legenda.
lbres@vpXF               = 0.78  ; Posição da legenda na direção x.
lbres@vpYF               = 0.58  ; Posição da legenda na direção y.
lbres@lbBoxMajorExtentF  = 0.80  ; Adiciona espaço entre a legenda.
lbres@lbFillColors       = colorBounds ; Cores das caixas da legenda.
lbres@lbMonoFillPattern  = True  ; Caixas com preenchimento sólido.
lbres@lbLabelFontHeightF = 0.015 ; Tamanho da fonte.
lbres@lbPerimOn          = False ; Sem linhas ao redor da legenda.
lbres@lbTitleString      ="Velocidade do vento (m/s)"
lbres@lbTitleFontHeightF = 0.01  ; Tamanho do título da legenda.

; Cria os rótulos da legenda.

nbar   = dimsizes(spdBounds)
labels = new(nbar,string)
labels(0) = 0 + "-" + spdBounds(0)

do i=1,nbar-1
   labels(i) = spdBounds(i-1) + "-" +spdBounds(i)
end do

lbid = gsn_create_labelbar(wks,nbar,labels,lbres) ; Adiciona a legenda.
  
draw(lbid)
frame(wks)

end

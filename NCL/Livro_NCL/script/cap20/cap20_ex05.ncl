; Nome do script: cap20_ex05.ncl

begin

; jan1979 a out2015.
; [time | 442] x [lat | 72] x [lon | 144]

f = addfile("../../dados/precip.mon.mean.nc","r") 

yrStrt = 198001              ; Data inicial => AAAAMM.
yrLast = 198112              ; Data final   => AAAAMM.
TIME   = f->time             ; Importação da variável time do arquivo f.
YYYY   = cd_calendar(TIME,-1); Tempo no formato AAAAMM (opção -1). 
ti     = ind(yrStrt.eq.YYYY) ; Seleciona o índice do primeiro tempo.
tf     = ind(yrLast.eq.YYYY) ; Seleciona o índice do último tempo.

ppt    = f->precip ; Importação da variável de interesse do arquivo f.

; Remove os arquivos tmp.*.png e anima.gif.
system("rm -f ../../figuras/cap20/tmp.*.png "+ \ +" 
             "../../figuras/cap20/anima.gif") 

res                      = True
res@cnFillOn             = True
res@cnFillMode           = "RasterFill"
res@cnLinesOn            = False
res@gsnLeftString        = ""
res@gsnRightString       = ""
res@gsnCenterString      = ""
res@cnLinesOn            = False
res@cnLineLabelsOn       = False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = ispan(2,20,2)
res@cnFillColors         = ispan(2,18,1) 
res@mpCenterLonF         = 180.0

do t = ti,tf
   print(" " + YYYY(t))
   wks = gsn_open_wks("png","../../figuras/cap20/tmp."+YYYY(t))
   gsn_define_colormap(wks,"prcp_1")
   res@tiMainString         = "Precipita"+cedil+atilde+"o "+YYYY(t)
   plot = gsn_csm_contour_map_ce(wks,ppt(t,:,:),res) 
end do

print("")
print("Criando a animacao")
print("")

; 30 é o tempo entre um frame e outro. Quanto menor o valor, mais rápida
; será a transição entre as figuras. O comando system chama os comandos 
; do UNIX para serem executados.
; O convert é um comando do programa ImageMagick. Nesse caso, junta 
; todos os ".png" em um único arquivo gif.

system("convert -delay 30 ../../figuras/cap20/*.png "+ \ +"
                         "../../figuras/cap20/anima.gif")
system("rm -f ../../figuras/cap20/tmp.*.png")

end

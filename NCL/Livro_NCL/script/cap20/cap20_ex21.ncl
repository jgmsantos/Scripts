; Nome do script: cap20_ex21.ncl

begin

f = addfile("../../dados/prec.2005.nc","r") ; Abertura do arquivo.
 
ppt = f->pre ; Importação da variável.

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex21")

res                 = True   ; Habilita personalização.
res@gsnFrame        = False  ; Não avança o frame.
res@gsnDraw         = False  ; Não desenha a figura.

plot=gsn_csm_y(wks,ppt(:,0,0),res) ; Gera o gráfico de linha.

txres               = True         ; Habilita a personalização do texto.
txres@txFontHeightF = 0.03         ; Tamanho da fonte do texto a ser 
                                   ; inserido no gráfico.
txres@txJust        = "CenterLeft" ; Alinhamento do texto no 
                                   ; centro/esquerda. 
                                   ; O texto será escrito após o ponto
                                   ; (x,y) definido pelo usuário por 
                                   ; meio da função gsn_add_text.

; O texto será inserido na posição x=4.0 e y=8.0. Ou seja, no valor do 
; eixo x=4 e eixo y=8.
; O texto ficará centralizado na posição x=4.0. É possível alinhar o 
; texto para obter o que se deseja.

dum = gsn_add_text(wks,plot,"Adicionando texto",4.0,8.0,txres)

draw(plot)
frame(wks)

end

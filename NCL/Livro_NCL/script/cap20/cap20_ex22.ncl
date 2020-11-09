; Nome do script: cap20_ex22.ncl

begin

f = addfile("../../dados/prec.2005.nc","r") ; Abertura do arquivo.
 
ppt = f->pre ; Importação da variável.

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex22")

drawNDCGrid(wks) ; Desenha as linhas de grade para adicionar o 
                 ; texto na posição correta.

res                 = True   ; Habilita personalização.
res@gsnFrame        = False  ; Não avança o frame.

plot=gsn_csm_y(wks,ppt(:,0,0),res) ; Gera o gráfico de linha.

txres               = True   ; Habilita a personalização do texto.
txres@txFontHeightF = 0.03   ; Tamanho da fonte.

; O texto será inserido na posição x=0.2 e y=0.9 que representa 
; as coordenadas NDC. O texto ficará centralizado na posição x=0.2. 
; É possível alinhar o texto para obter o que se deseja.

gsn_text_ndc(wks,"Adicionando texto",0.2,0.9,txres)

frame(wks)

end

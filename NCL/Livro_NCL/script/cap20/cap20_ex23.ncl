; Nome do script: cap20_ex23.ncl

begin

f = addfile("../../dados/prec.2005.nc","r")
 
ppt = f->pre ; Importação da variável.

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex23")

res                 = True   ; Habilita personalização.

; Basta usar ~C~ para adicionar quebra de linha. Para alinhar 
; o texto deve-se inserir espaços até conseguir o efeito que se deseja.

res@tiMainString    = "Adicionando quebra de ~C~         linha no texto" 

plot=gsn_csm_y(wks,ppt(:,0,0),res) ; Gera o gráfico de linha.

end

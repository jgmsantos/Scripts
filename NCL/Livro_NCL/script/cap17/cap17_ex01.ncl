; Nome do script: cap17_ex01.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r")

xiu = short2flt(f->uwnd)
xiv = short2flt(f->vwnd)

printVarSummary(xiu) 
; [time | 3] x [level | 12] x [lat | 73] x [lon | 144]

; Para usar essa função com dados de mais de uma dimensão, é necessário 
; que a dimensão level seja a dimensão mais a direita, por isso, é feita 
; a reordenação delas.

; Reordenação das dimensões.

; Dimensão level sendo a dimensão mais a direita.
xiu_n = xiu(time|:,lat|:,lon|:,level|:) 
xiv_n = xiv(time|:,lat|:,lon|:,level|:)

; É preciso importar os níveis verticais do arquivo pois eles serão 
; utilizados na função. A variável level existe no arquivo.

; São os níveis verticais do arquivo: 1000, 925, 850, 700, 600, 500, 
; 400, 300

pi = f->level 

; É preciso também os novos níveis verticais para realizar a interpolação. 
; O dado será interpolado para os níveis verticais abaixo:

po = (/1000.,950.,925.,850.,800.,750.,700.,650.,600.,550.,500., \
        400.,300./)

; Tipo de interpolação a ser feito. Se o valor for igual a 1, realiza 
; interpolação linear e se for diferente de 1, realiza interpolação log. 
; Caso o valor seja negativo, ocorre a extrapolação para além dos níveis 
; selecionados. Utilize a extrapolação com cuidado.

linlog = 2 ; Tipo de interpolação.

; Interpola u para os novos níveis verticais.
xou = int2p_Wrap (pi,xiu_n,po,linlog) 
; Interpola v para os novos níveis verticais.
xov = int2p_Wrap (pi,xiv_n,po,linlog) 

printVarSummary(xou)

; Nota: Na linha 55 são os valores originais (8 níveis verticais) 
; da variável e na linha 56 são os valores gerados pela interpolação 
; (13 níveis verticais). Foram criados mais 5 níveis verticais.

; 1000,      925, 850,           700,      600,      500, 400, 300
; 1000, 950, 925, 850, 800, 750, 700, 650, 600, 550, 500, 400, 300

end

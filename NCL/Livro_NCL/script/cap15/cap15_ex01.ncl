; Nome do script: cap15_ex01.ncl

begin

f = addfile("../../dados/prec.2014.nc","r") ; Arquivo de precipitação.

; Arquivo que contém as máscaras. Vem junto com a instalação do NCL.
g = addfile("/usr/local/ncarg/lib/ncarg/data/cdf/landsea.nc","r") 

ppt   = f->precip ; lat: [88.75..-88.75]. Essa variável está de norte
                  ; para sul e o mapa sairá invertido. Para resolver 
                  ; isso, basta inverter a dimensão latitude da seguinte
                  ; forma "::-1".

; lat: [-88.75..88.75]. Latitude de sul para norte.
ppt   = ppt(:,::-1,:) 

; Importação da variável de máscaras do arquivo landsea.nc.
maskv = g->LSMASK 

; Opções para mascarar:
; 0 = oceano, 1 = continente, 2 = lagos, 3 = pequenas ilhas e 
; 4 = camada de  gelo.

; Cria a máscara.
; Dimensions and sizes: [lat | 72] x [lon | 144]
mascara  = landsea_mask(maskv,ppt&lat,ppt&lon) 

; Mascara o dado, isto é, apenas o continente (1).
; Dimensions and sizes: [12] x [72] x [144]
so_oceano = mask(ppt,mascara.eq.1,False)   

; A variável so_oceano não tem informações das dimensões e 
; coordenadas e ao plotar esse gráfico o resultado estará errado. 
; Como essa variável possui as mesmas dimensões de ppt, é possível
; copiar as coordenadas e dimensões de ppt para so_oceano.

copy_VarCoords(ppt,so_oceano) 

wks = gsn_open_wks("pdf","../../figuras/cap15/cap15_ex01")

res                  = True     ; Habilita personalização da figura.  
res@cnFillOn         = True     ; Habilita gráfico preenchido.
res@cnLinesOn        = False    ; Desabilita as isolinhas.
res@mpLandFillColor  = "white"  ; O mapa com fundo branco.
res@tiMainString     = "Somente oceano" ; Título da figura.

plot = gsn_csm_contour_map(wks,so_oceano(3,:,:),res)

end

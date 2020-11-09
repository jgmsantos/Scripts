; Nome do script: cap15_ex02.ncl

begin

f = addfile("../../dados/prec.2014.nc","r") ; Arquivo de precipitação.

ppt   = f->precip ; lat: [88.75..-88.75] Essa variável está de norte 
                  ; para sul e o mapa sairá invertido. Para resolver 
                  ; isso, basta inverter a dimensão latitude 
                  ; da seguinte forma "::-1".
; Dimensions and sizes: [time | 12] x [lat | 72] x [lon | 144]

ppt   = ppt(:,::-1,:) ; lat: [-88.75..88.75]. Agora a latitude está 
                      ; de sul para norte.

; Mascara o dado, isto é, mostra apenas os valores de precipitação 
; maiores que 2. Os valores menores que 2 são indefinidos.
; Dimensions and sizes: [12] x [72] x [144]
ppt_mask = mask(ppt,(ppt.gt.2),True)

; A variável ppt_mask não tem informações das dimensões e 
; coordenadas e ao plotar esse gráfico o resultado estará errado. 
; Como essa variável possui as mesmas dimensões de ppt, é possível 
; copiar as coordenadas e dimensões de ppt ppt_mask.

; Dimensions and sizes: [time | 12] x [lat | 72] x [lon | 144]
copy_VarCoords(ppt,ppt_mask) 

wks = gsn_open_wks("pdf","../../figuras/cap15/cap15_ex02")

res                  = True             ; Habilita personalização.
res@cnFillOn         = True             ; Habilita gráfico preenchido.
res@cnLinesOn        = False            ; Desabilita as isolinhas.
res@mpLandFillColor  = "white"          ; O mapa com fundo branco.
res@tiMainString     = "Mascarando valores menores que 2 mm/dia"

plot = gsn_csm_contour_map(wks,ppt_mask(3,:,:),res)

end

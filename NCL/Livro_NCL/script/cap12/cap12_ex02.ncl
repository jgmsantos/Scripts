; Nome do script: cap12_ex02.ncl

begin

f = addfile("../../dados/GPOSNMC19701201001971010100P.fct.TQ0062L028.grb","r")

names = getfilevarnames(f) ; Obtém uma lista de todas as variáveis 
                           ; do arquivo aberto.

print(names) ; Imprime o nome das variáveis.

file_out = "../../dados/saida.nc" ; Nome do arquivo NetCDF a ser criado.

; Variáveis específicas para salvar no NetCDF.

namesVar = (/"ZGEO_GDS4_ISBL","UVEL_GDS4_ISBL","VVEL_GDS4_ISBL"/) 

; Troca dos nomes de "ZGEO_GDS4_ISBL" para "zgeo", "UVEL_GDS4_ISBL" para 
; "uvel" e "VVEL_GDS4_ISBL" para "vvel".

novo_nome = (/"zgeo","uvel","vvel"/) 

; Cria o nome do arquivo NetCDF.

system("rm -f "+file_out) ; Remove qualquer arquivo existente.

ncdf_out = addfile(file_out,"c") ; Cria o NetCDF.

; Faz o loop de todas as variáveis e salva no arquivo NetCDF.

do i = 0, dimsizes(namesVar)-1
   ncdf_out->$novo_nome(i)$ = f->$namesVar(i)$
end do

end

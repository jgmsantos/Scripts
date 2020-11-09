; Nome do script: cap12_ex01.ncl

begin

f = addfile("../../dados/GPOSNMC19701201001971010100P.fct.TQ0062L028.grb","r")

file_out = "../../dados/saida.nc" ; Nome do arquivo NetCDF a ser criado.

names = getfilevarnames(f) ; Obtém uma lista de todas as variáveis 
                           ; do arquivo aberto.

print(names) ; Imprime uma lista com o nome das variáveis.

; Cria o nome do arquivo NetCDF.

system("rm -f "+file_out) ; Remove qualquer arquivo existente. 
                          ; Sem essa linha gera erro.

ncdf_out = addfile(file_out,"c") ; Cria o NetCDF.

; Faz o loop de todas as variáveis e salva no arquivo NetCDF.

do i = 0, dimsizes(names)-1
   ncdf_out->$names(i)$ = f->$names(i)$
end do

end

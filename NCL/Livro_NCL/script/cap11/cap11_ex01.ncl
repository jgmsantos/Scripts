; Nome do script: cap11_ex01.ncl

begin

f = addfile("../../dados/tair.2011.2012.nc","r") ; Abertura do arquivo.

t = short2flt(f->air) ; Descompactando o dado (short) para o tipo float.

tc = t-273.15 ; Converte de Celsius para Kelvin.

copy_VarCoords(t,tc) ; Copia as coordenadas da variável original "t" para 
                     ; a nova variável "tc". A variável "tc" não possui 
                     ; nenhuma coordenada associada, por 
                     ; isso utilizou-se essa função.

system("rm -f ../../dados/temp.celsius.nc") ; Remove o arquivo caso ele exista.

; Arquivo NetCDF a ser criado ("c") no seu computador.
nc = addfile("../../dados/temp.celsius.nc" ,"c") 
                                                 
filedimdef(nc,"time",-1,True) ; Possibilidade de aumentar o número de tempos
                              ; da dimensão time. 

nc->tar = tc ; "tar" é o nome da nova variável do arquivo netCDF que será 
             ; criado e "tar" receberá o conteúdo da variável "tc" que foi 
             ; calculada na linha 7.
end

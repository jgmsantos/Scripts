; Nome do script: cap21_ex45.ncl

begin

a = addfile("../../dados/precip.mon.mean.nc","r")

vNames   = getfilevarnames(a)
print(vNames)         ; Verificar a posição do nome da variável
                      ; e trocar aqui pelo valor inteiro.
                      ; (0)	lat
                      ; (1)	lon
                      ; (2)	precip => Usar este índice "2"
                      ; (3)	time
nome_var = vNames(2)  ; Nome da variável.

time   = a->time
YYYYMM = cd_calendar(time,-1)
anoi   = 197901                  ; Data inicial no formato AAAAMM.
anof   = 197912                  ; Data final no formato AAAAMM.
istr   = ind( YYYYMM .eq. anoi ) ; Índice que será utilizado
iend   = ind( YYYYMM .eq. anof ) ; para selecionar o período de 
                                 ; interesse.

p      = a->$nome_var$ ; Importação da variável de interesse.
p&lon  = p&lon-360     ; O dado precisa estar no formato -180 a 180
                       ; por causa do shapefile que trabalha apenas
                       ; neste formato.

lat  = a->lat               ; Importação da variável lat.
rad  = 4.0*atan(1.0)/180.0  ; Para radianos => 0.01745329
clat = cos(lat*rad)         ; Pesos que serão utilizados no 
                            ; cálculo da média.

fout = "../../dados/prec.bacia.amaz.txt" ; Nome do arquivo de saída que 
                                         ; terá duas colunas
                                         ; no formato ==> AAAAMM VALOR

system("/bin/rm -f " + fout) ; remove o arquivo caso ele exista 
                             ; para evitar qualquer erro.

do i = istr,iend
   data      = YYYYMM(i)
   data_mask = shapefile_mask_data(p(i,:,:),\
               "../../dados/bacia_amaz/amazlm_1608.shp",True)
   med_area  = wgt_areaave_Wrap(data_mask,clat,1.0,1)
   write_table(fout,"a",[/data,med_area/],"%6i %4.2f")
   print(data + " " + med_area)
end do

end

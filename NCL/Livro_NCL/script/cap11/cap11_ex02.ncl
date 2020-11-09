; Nome do script: cap11_ex02.ncl

begin

f = addfile("../../dados/tair.2011.2012.nc","r") ; Abertura do arquivo.

T  = short2flt(f->air) ; Descompactando o dado (short) para o tipo float.

Tc = T-273.15 ; Converte de Celsius para Kelvin.

x = dimsizes(T) ; (0)	24  => Número de tempos              x(0).
                ; (1)	12  => Número de níveis verticais    x(1).
                ; (2)	73  => Número de pontos de latitude  x(2).
                ; (3)	144 => Número de pontos de longitude x(3).
nlat = x(2)
nlon = x(3)
nlev = x(1)

time  = f->time  ; Importando as variáveis
level = f->level ; para serem utilizadas
lat   = f->lat   ; para criar as coordenadas
lon   = f->lon   ; e dimensões.

system("rm -f ../../dados/tc.MA.nc") ; Remove o arquivo caso ele exista.

; Arquivo NetCDF a ser criado ("c") no seu computador. 
nc = addfile("../../dados/tc.MA.nc" ,"c") 

setfileoption(nc,"DefineMode",True)

; Criação de atributos globais.
fAtt               = True
fAtt@title         = "Criação eficiente de um arquivo netCDF"  
fAtt@source_file   = "tair.2011.2012.nc"
fAtt@Conventions   = "Nenhum convenção adotada"   
fAtt@contact       = "Meu e-mail para contato"
fAtt@creation_date = systemfunc ("date")
fileattdef(nc,fAtt)    ; Copia os atributos globais para o arquivo 
                       ; que será gerado (tc.MA.nc).

; Predefinição das coordenadas das variáveis. A opção "-1" é usada 
; para a dimensão time para ser definida como UNLIMITED (possibilidade 
; de aumentar o número de tempos).
dimNames = (/"time", "lat", "lon", "level"/)  
dimSizes = (/ -1   ,  nlat,  nlon, nlev /) 
dimUnlim = (/ True , False, False, False/)   
filedimdef(nc,dimNames,dimSizes,dimUnlim)

; Predefinição dos nomes das variáveis, tipos e dimensões do arquivo 
; a ser gerado.
filevardef(nc,"time" ,typeof(time) ,getvardims(time)) 
filevardef(nc,"level",typeof(level),getvardims(level))
filevardef(nc,"lat"  ,typeof(lat)  ,getvardims(lat))                          
filevardef(nc,"lon"  ,typeof(lon)  ,getvardims(lon))                          
filevardef(nc,"tc"   ,typeof(T)    ,getvardims(T))    

filevarattdef(nc,"tc"  ,T)     ; Copia os atributos de T para "Tc".
filevarattdef(nc,"time",time)  ; Copia os atributos de time para "time".
filevarattdef(nc,"level",level); Copia os atributos de lev para "level".
filevarattdef(nc,"lat" ,lat)   ; Copia os atributos de lat para "lat".
filevarattdef(nc,"lon" ,lon)   ; Copia os atributos de lon para "lon".

; Escrita das variáveis no novo arquivo tc.MA.nc. O símbolo (/.../) 
; significa copiar somente os valores da variável que estão entre (/.../) 
; para as novas variáveis, uma vez que, elas foram predefinidas ao 
; longo do programa.

nc->time  = (/time/)     
nc->level = (/level/)
nc->lat   = (/lat/)
nc->lon   = (/lon/) 
nc->tc    = (/Tc/)

end

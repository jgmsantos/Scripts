; Nome do script: cap21_ex46.ncl

begin

; Link para os dados de radiossondagem:
; http://weather.uwyo.edu/upperair/sounding.html

; As informações no topo do skewt são:
; Cape  -  Convective Available Potential Energy [J]
; Pwat  -  Precipitable Water [cm]
; Shox  -  Showalter Index (stability)
; Plcl  -  Pressure of the lifting condensation level [hPa]
; Tlcl  -  Temperature at the lifting condensation level [C]

; Para alterar o nome das palavras "Temperature (C)" ou 
; "Temperature (F)" para "Temperatura (°C)" ou "Temperatura (°F)", 
; altere as linhas 314 e 316. E para alterar o nome "Height (Km)" para 
; "Altura (Km)" altere a linha 370 da função skewt_func.ncl. Basta 
; copiar e colar o comando abaixo no seu terminal para editar o arquivo.
; gedit "$NCARG_ROOT/lib/ncarg/nclscripts/csm/skewt_func.ncl"

; Nome do arquivo de entrada.
nome_arq   = "../../dados/radiossondagem_belem_12Z_27mar2016.txt" 
; Nome do arquivo temporário.
arq_tmp    = "../../dados/tmp.txt"                                
; Altere o nome do local aqui.
nome_local = "Bel"+eacute+"m/PA - 27/03/2016 - 1200Z" 

; o trecho abaixo gera um arquivo temporário chamado tmp.txt porque esta
; função lê os dados de 1000hPa até 100hPa mesmo que o arquivo possua mais 
; níveis verticais.

; A função "system" chama um comando do Unix para ser executado.

; Checa (fileexists) se o arquivo existe no diretório. Caso não exista, 
; sai do script.

if ( fileexists(nome_arq) ) then
   ; Seleciona apenas as linhas que contém os níveis verticais de 
   ; 1000-100hPa.
   system("sed -n '/1000.0/,/100.0/p' " + nome_arq + " > " + arq_tmp + "")
   nlin = numAsciiRow(arq_tmp) ; Número de linhas do arquivo.
   ncol = numAsciiCol(arq_tmp) ; Número de colunas do arquivo.
   dado = asciiread (arq_tmp,(/nlin,ncol/),"float") ; Leitura do arquivo.
else
   print("")
   print(" O arquivo não existe! Saindo do script! ")
   print("")
   exit
end if

; Leitura das variáveis do arquivo.
p      = dado (:,0)     ; Pressão [mb/hPa]. 
z      = dado (:,1)     ; Altura [m].
tc     = dado (:,2)     ; Temperatura [C].
tdc    = dado (:,3)     ; Ponto de orvalho [C].
wdir   = dado (:,6)     ; Direção do vento em graus.
wspdk  = dado (:,7)     ; Velocidade do vento [knots].

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex46")

; Opções do Skew-t.
skewtOpts                   = True
skewtOpts@DrawIsotherm      = True       ; Linhas das isotermas.
skewtOpts@DrawIsobar        = True       ; Linhas das isobáras.
skewtOpts@DrawMixRatio      = True       ; Linhas da razão de mistura.
skewtOpts@DrawDryAdiabat    = True       ; Linhas da adibática seca.
skewtOpts@DrawMoistAdiabat  = True       ; Linhas da adibática úmida.
skewtOpts@DrawWind          = True       ; Desabilita a velocidade do 
                                         ; vento.
skewtOpts@DrawStandardAtm   = True       ; Atmosfera padrão.
skewtOpts@DrawColLine       = True       ; Colore ou não as linhas do 
                                         ; skew-t.
skewtOpts@DrawColAreaFill   = True       ; Preenchimento do fundo do 
                                         ; skew-t.
skewtOpts@DrawFahrenheit    = False      ; Eixo x em Celsius (°C).
skewtOpts@DrawHeightScale   = True       ; Habilita a escala de altura.
skewtOpts@DrawHeightScaleFt = False      ; True = Feet | False = Km
skewtOpts@tiMainString      = nome_local ; Título da radiossondagem.

; Personalização do dado.
dataOpts                        = True       
dataOpts@colTemperature         = "red"   ; Cor da linha da 
                                          ; temperatura (T).
dataOpts@colDewPt               = "blue"  ; Cor da linha da temperatura 
                                          ; do ponto de orvalho (Td).
dataOpts@colCape                = "black" ; Cor da linha do CAPE.
dataOpts@colWindP               = "blue"  ; Cor da barbela do vento.
dataOpts@linePatternTemperature = 0       ; Estilo de linha da 
                                          ; temperatura.
dataOpts@linePatternDewPt       = 0       ; Estilo de linha da 
                                          ; temperatura do 
                                          ; ponto de orvalho.
dataOpts@linePatternCape        = 2       ; Estilo de linha para o CAPE
dataOpts@xpWind                 = 45      ; Deslocamento na direção "x" 
                                          ; da barbela do vento. O 
                                          ; padrão é 45.
dataOpts@WspdWdir               = True    ; A partir da direção e 
                                          ; velocidade, desenha a 
                                          ; barbela do vento.
dataOpts@hemisphere             = "SH"    ; Hemisfério da radiossonda.
dataOpts@Wthin                  = 1       ; Espaçamento da barbela do 
                                          ; vento.

skewt_bkgd = skewT_BackGround (wks,skewtOpts)
skewt_data = skewT_PlotData   (wks,skewt_bkgd,p,tc,tdc,z,wspdk, \ 
                               wdir,dataOpts)

draw (skewt_bkgd)
draw (skewt_data)

system("rm -f " + arq_tmp + "") ; Remove o arquivo temporário.

end

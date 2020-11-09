; Nome do script: cap21_ex47.ncl

begin

; Radiossondagem 1. Nome do arquivo 1.
nome_arq1   = "../../dados/radiossondagem_belem_12Z_27mar2016.txt" 
arq_tmp1    = "../../dados/tmp1.txt"     ; Nome do arquivo temporário 1.
nome_local1 = "Bel"+eacute+"m/PA (preto)"; Altere o nome do local aqui.

; Radiossondagem 2
nome_arq2   = "../../dados/radiossondagem_porto_alegre_12Z_27mar2016.txt"
arq_tmp2    = "../../dados/tmp2.txt"
nome_local2 = "Porto Alegre/RS (vermelho)"

data        = "27/03/2016 - 1200Z" ; Considerando que a data é a mesma 
                                   ; para as duas radiossondagens.

; o trecho abaixo gera um arquivo temporário chamado tmp*.txt porque 
; esta função lê dados de 1000hPa até 100hPa mesmo que o arquivo possua
; mais níveis verticais.

; A função "system" chama um comando do Unix para ser executado.

; Checa (fileexists) se o arquivo existe no diretório. Caso não exista, 
; sai do script.

if ( fileexists(nome_arq1) .and. fileexists(nome_arq2) ) then

   ; Seleciona apenas as linhas que contém os níveis verticais de 
   ; 1000-100hPa.
   system("sed -n '/1000.0/,/100.0/p' " + nome_arq1 + " > " + \ 
          arq_tmp1 + " ")
   system("sed -n '/1000.0/,/100.0/p' " + nome_arq2 + " > " + \ 
          arq_tmp2 + " ")

   nlin1 = numAsciiRow(arq_tmp1) ; Número de linhas do arquivo 1.
   ncol1 = numAsciiCol(arq_tmp1) ; Número de colunas do arquivo 1.
   dado1 = asciiread (arq_tmp1,(/nlin1,ncol1/),"float")

   nlin2 = numAsciiRow(arq_tmp2)
   ncol2 = numAsciiCol(arq_tmp2)
   dado2 = asciiread (arq_tmp2,(/nlin2,ncol2/),"float")
else
   print("")
   print(" O arquivo não existe! Saindo do script! ")
   print("")
   exit
end if

; Leitura das variáveis do radiossondagem 1.
p1    = dado1(:,0)    ; Pressão [mb / hPa].
z1    = dado1(:,1)    ; Altura [m]. 
tc1   = dado1(:,2)    ; Temperatura [C].    
tdc1  = dado1(:,3)    ; Ponto de orvalho [C].   
wdir1 = dado1(:,6)    ; Direção do vento em graus.   
wspd1 = dado1(:,7)    ; Velocidade do vento [knot].    

; Leitura das variáveis do radiossondagem 2.
p2    = dado2(:,0)    ; Pressão [mb / hPa]. 
z2    = dado2(:,1)    ; Geopotential [gpm]. 
tc2   = dado2(:,2)    ; Temperatura [C].    
tdc2  = dado2(:,3)    ; Ponto de orvalho [C].   
wdir2 = dado2(:,6)    ; Direção do vento em graus.   
wspd2 = dado2(:,7)    ; Velocidade do vento [knot].    

p1@_FillValue    = -999 ; Definindo valores ausentes (-999)
z1@_FillValue    = -999 ; caso a radiossondagem possua. Não esqueça
tc1@_FillValue   = -999 ; de preencher no seu dado com os valores -999.
tdc1@_FillValue  = -999
wdir1@_FillValue = -999
wspd1@_FillValue = -999

p2@_FillValue    = -999
z2@_FillValue    = -999
tc2@_FillValue   = -999
tdc2@_FillValue  = -999
wdir2@_FillValue = -999
wspd2@_FillValue = -999

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex47")

skewtOpts                   = True
skewtOpts@DrawColAreaFill   = True    ; Preenchimento do fundo 
                                      ; (cor verde) do skew-t.
skewtOpts@tiMainString      = nome_local1 + " e " + nome_local2 + \ 
                              "~C~        " + data
skewtOpts@DrawFahrenheit    = False   ; Eixo x em Celsius (C).
skewtOpts@DrawHeightScale   = True    ; Habilita a escala de altura, 
                                      ; lado direito.
skewtOpts@DrawHeightScaleFt = False   ; True = Feet | False = Km.

dataOpts                   = True     ; 
dataOpts@colTemperature    = "black"  ; Cor da linha da temperatura (T).
dataOpts@colDewPt          = "black"  ; Cor da linha da temperatura 
                                      ; do ponto de orvalho (Td).
dataOpts@colWindP          = "black"  ; Cor da barbela do vento.
dataOpts@PrintZ            = False    ; Não mostra a altura do lado 
                                      ; esquerdo.
dataOpts@ThermoInfo        = False    ; Não mostra as infomações 
                                      ; termodinâmicas. 
                                      ; no topo do diagrama.
dataOpts@xpWind            = 45       ; Deslocamento na direção "x" da
                                      ; barbela do vento. 
                                      ; O padrão é 45.
dataOpts@WspdWdir          = True     ; A partir da direção e 
                                      ; velocidade, desenha 
                                      ; a barbela do vento.
dataOpts@hemisphere        = "SH"     ; Hemisfério usado: "NH" ou "SH".
dataOpts@Wthin             = 2        ; Espaçamento da barbela do vento.

dataOpts@linePatternTemperature = 0   ; Estilo de linha para a 
                                      ; temperatura.
dataOpts@linePatternDewPt       = 1   ; Estilo de linha para a  
                                      ; temperatura do 
                                      ; ponto de orvalho.

skewt_bkgd = skewT_BackGround (wks, skewtOpts)

draw (skewt_bkgd)

; Gera a primeira radiossondagem - Belém
skewt_data = skewT_PlotData(wks,skewt_bkgd,p1,tc1,tdc1,z1,wspd1, \ 
                            wdir1,dataOpts)

draw (skewt_data)

dataOpts@Wthin             = 2     ; Espaçamento da barbela do vento.
dataOpts@xpWind            = 42    ; Localização do eixo do vento.
dataOpts@colTemperature    = "red"
dataOpts@colDewPt          = "red"
dataOpts@colWindP          = "red"

; Gera a segunda radiossondagem - Porto Alegre
skewt_data = skewT_PlotData(wks,skewt_bkgd,p2,tc2,tdc2,z2,wspd2, \ 
                            wdir2,dataOpts)

draw (skewt_data)
frame(wks)

system("rm -f " + arq_tmp1 + "") ; Remove o arquivo temporário.
system("rm -f " + arq_tmp2 + "")

end

; Nome do script: cap21_ex05.ncl

begin

; Abertura do arquivo txt com 12 linhas e 6 colunas do tipo float.
f = asciiread("../../dados/barcarena.txt",(/12,6/),"float") 


prec = f(:,0)  ; Importação da precipitação (mm/mês).
u    = f(:,4)  ; Importação da componente zonal do vento (m/s).
v    = f(:,5)  ; Importação da componente meridional do vento (m/s).
vel  = wind_speed(u,v) ; Calcula a velocidade do vento (m/s) dado u e v.

; Criação de uma variável que contém as 3 colunas de temperatura 
; (mínima, média e máxima em Celsius).

; temp é nome da variável que vai armazenar as 3 colunas de temperatura.
; As dimensões são: 3 colunas de temperatura com 12 o valores mensais 
; cada uma.
temp = new((/3,12/),float)                            
temp(0,:) = f(:,1) ; A segunda coluna [f(:,1)] do arquivo f é igual a 
                   ; temperatura mínima.
temp(1,:) = f(:,2) ; A terceira coluna [f(:,2] do arquivo f é igual a 
                   ; temperatura média.
temp(2,:) = f(:,3) ; A quarta coluna [f(:,3)] do arquivo f é igual a
                   ; temperatura máxima.

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex05")

; Personalização do eixo direito do gráfico (temp. mín, med e máx).
resD1                        = True ; Habilita para formatação.
resD1@xyDashPattern          = 0    ; Tipo de linha do gráfico.
resD1@xyMarkLineMode         = "MarkLines"  ; Gráfico com marcadores.
resD1@xyMarkers              = (/16,16,16/) ; Tipo de marcador para cada
                                            ; curva.
resD1@xyMarkerColors         = (/"blue","black","red"/)
resD1@xyLineColors           = (/"blue","black","red"/)
resD1@xyLineThicknesses      = (/2,2,2/)
resD1@xyLineColors           = (/"blue","black","red"/)
resD1@xyExplicitLegendLabels = (/"Tm"+iacute+"n","Tm"+eacute+"d", \
                                 "Tm"+aacute+"x"/)
resD1@trYMaxF                = 34.0    ; Valor máximo do eixo y.
resD1@trYMinF                = 20.0    ; Valor mínimo do eixo y.
resD1@pmLegendDisplayMode    = "Always"; Habilita a legenda.
resD1@pmLegendWidthF         = 0.1     ; Largura da legenda.
resD1@pmLegendHeightF        = 0.1     ; Altura da legenda.
resD1@pmLegendOrthogonalPosF = -1.07   ; Deslocamento da legenda 
                                       ; para cima ou para baixo.
resD1@pmLegendParallelPosF   =  0.12   ; Deslocamento da legenda 
                                       ; para direita ou esquerda. 
resD1@lgPerimOn              = False   ; Sem linhas em torno da legenda.
resD1@lgLabelFontHeightF     = 0.02    ; Tamanho da fonte da legenda.
resD1@tmYRMinorOn            =  False  ; Desabilita os traços 
                                       ; secundários do eixo (Y) da 
                                       ; direita (R).
resD1@tiYAxisOffsetXF        = -0.013  ; Deslocamento do título do eixo 
                                       ; y para direita ou esquerda.
resD1@tiMainString           = "Climatologia para Barcarena/PA"  
resD1@tiYAxisString          = "Temperatura (~S~o~N~C)"

; Personalização do eixo direito do gráfico (velocidade do vento).
resD2                        = True
resD2@xyDashPattern          = 0              
resD2@xyMarkLineMode         = "MarkLines"    
resD2@xyMarkers              = 16
resD2@xyMarkerColors         = "green"
resD2@xyLineColors           = "green"
resD2@tiYAxisString          = "Velocidade do vento (m s ~S~-1~N~)"
resD2@xyLineThicknesses      = 2
resD2@trYMaxF                = 3.0
resD2@trYMinF                = 0.0
resD2@xyLineColors           = "green"
resD2@tmYRMinorOn            =  False
resD2@pmLegendDisplayMode    = "NoCreate" ; Não cria legenda.
resD2@tiYAxisFontColor       = "green"
resD2@tmYRLabelFontColor     = "green"

; Personalização do eixo esquerdo do gráfico (precipitação).
resE                        = True
resE@gsnXYBarChart          = True      ; Habilita gráfico de barras.
resE@gsnXYBarChartColors    = "orange"  ; Cor da barra.
resE@trYMaxF                = 600.0
resE@trYMinF                = 0.0
resE@tmYLMode               = "Manual"  ; Formatação do eixo y esquerdo.
resE@tmYLTickStartF         = resE@trYMinF
resE@tmYLTickSpacingF       = 50
resE@tmYLTickEndF           = resE@trYMaxF
resE@tmXBMode               = "Explicit" ; Formatação do eixo x do 
                                         ; meu jeito.
; Valores necessários para o eixo x. São os valores dos meses.
resE@tmXBValues             = (/1,2,3,4,5,6,7,8,9,10,11,12/) 
; Cada valor acima recebe uma string.
resE@tmXBLabels             = (/"J","F","M","A","M","J","J","A","S",\
                                "O","N","D"/)
resE@tiYAxisString          = "Precipita"+cedil+atilde+ \ 
                              "o (mm m"+ecirc+"s~S~-1~N~)"
resE@gsnXYBarChartBarWidth  = 0.75
resE@tmYLMinorOn            = False
resE@gsnDraw                = False
resE@gsnFrame               = False
resE@vpWidthF               = 0.55
resE@vpHeightF              = 0.45
resE@tiYAxisFontColor       = "orange"
resE@tmYLLabelFontColor     = "orange"

; Plota os dados. A variável prec será personalizada com a opção resE, 
; temp com a opção resD1 e vel com a opção resD2. 
; Essa ordem é muito importante.

plot = gsn_csm_xy3(wks,ispan(1,12,1),prec,temp,vel,resE,resD1,resD2) 

draw(plot)

end

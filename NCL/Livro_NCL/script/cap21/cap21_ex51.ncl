; Nome do script: cap21_ex51.ncl

load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"
load "../../dados/CMIP5/taylor_diagram_enoble.ncl"

begin

observado = (/"GPCP"/) ; Nome do dado observado.

modelos   = (/"ACCESS1-0","BCC-CSM1.1","CANESM2","CCSM4",   \
              "CNRM-CM5","CSIRO-MK3-6-0","FGOALS-G2","GFDL-CM3", \
              "HADGEM2-CC","HADGEM2-ES"/) ; Nome dos modelos.

; Nome das variáveis de cada modelo.
nome_var  = (/"pr","pr","pr","pr","pr","pr","pr","pr","pr","pr","pr"/)

; Usado no nome dos arquivos => prec.djf.ACCESS1-0.nc e também no nome 
; das legendas (DJF, MAM, JJA e SON).
estacao   = (/"djf","mam","jja","son"/) 

; Criação de novas variáveis.
pptm = new((/dimsizes(modelos),78,1,1/),float)
ppto = new((/dimsizes(observado),78,1,1/),float)
std  = new((/dimsizes(modelos),1,1,1/),float)
r    = new((/dimsizes(modelos),1,1,1/),float)
stdo = new((/dimsizes(estacao)/),float) 
rms  = new((/dimsizes(modelos),1,1,1/),float)
bias = new((/dimsizes(modelos),1,1,1/),float)
rmsN = new((/dimsizes(modelos),1,1,1/),float)

; O comando system acessa comandos dos Shell e neste caso, os arquivos 
; estão sendo removidos caso eles existam.

system("rm -f tmp_????.txt")
system("rm -f l2c_????.txt")
system("rm -f plot_????.txt")
system("rm -f plot_???.txt")

do k = 0,dimsizes(estacao)-1
   do i = 0,dimsizes(modelos)-1
          ; Abertura do aquivo observado.
      f = addfile("../../dados/CMIP5/netcdf/prec."+estacao(k)+"."+modelos(i)+".nc","r")  
         ; Abertura dos aquivos dos modelos.
      g = addfile("../../dados/CMIP5/netcdf/prec."+estacao(k)+"."+observado(0)+".nc","r")
                     ; Importação da variável observada.
      pptm(i,:,0,0) = f->pr(:,0,0)
                     ; Importação das variáveis dos modelos.
      ppto(0,:,0,0) = g->pr(:,0,0)
                     ; Cálculo do desvio padrão observado.
      stdo(k)       = stddev(ppto(0,:,0,0))
                     ; Cálculo do desvio padrão dos modelos divido 
                     ; pela observação.
      std(i,:,0,0)  = stddev(( pptm(i,:,0,0))/stdo(k))
                     ; Cálculo da correlação de Pearson.
      r(i,:,0,0)    = escorc(ppto(0,:,0,0),pptm(i,:,0,0))
                     ; Cálculo do RMSE.
      rms(i,:,0,0)  = dim_rmsd(ppto(0,:,0,0),pptm(i,:,0,0))
                     ; Cálculo do bias.
      bias(i,:,0,0) = dim_avg_n(ppto(0,:,0,0)-pptm(i,:,0,0),0)
                     ; Cálculo do RMSE normalizado.
;      rmsN(i,:,0,0) = sqrt((rms(i,:,0,0)^2 - bias(i,:,0,0)^2))
      rmsN(i,:,0,0) = rms(i,:,0,0)/( max(pptm(i,:,0,0)))-min(pptm(i,:,0,0))
   end do
      ; Mostra os valores mínimo e máximo.
      print("Min: "+min(rmsN) + " Max: " + max(rmsN)) 
      ; Escreve no arquivo os valores do desvio padrão.
      write_table("tmp_std"+k+".txt","a",[/std/],"%f")
      ; Escreve no arquivo os valores da correlação.
      write_table("tmp_cor"+k+".txt","a",[/r/],"%f")  

      ; Transforma coluna em linha.
      system("cat tmp_std"+k+".txt | xargs > l2c_std"+k+".txt")
      ; Salva no arquivo texto os valores do desvio padrão.
      system("cat l2c_std"+k+".txt >> plot_std.txt ")

      ; Transforma coluna em linha.
      system("cat tmp_cor"+k+".txt | xargs > l2c_cor"+k+".txt")
      ; Salva no arquivo texto os valores da correlação.
      system("cat l2c_cor"+k+".txt >> plot_cor.txt ")
end do

; Cria as variáveis que serão utilizadas para gerar o plot do diagrama 
; de Taylor. As variáveis precisam ter duas dimensões em que a primeira
; dimensão é o experimento e a segunda são os valores do desvio padrão
; e da correlação.

desvio = new ((/dimsizes(estacao),dimsizes(modelos)/),float)  
corr   = new ((/dimsizes(estacao),dimsizes(modelos)/),float) 

; Os arquivos texto de desvio padrão e correlação foram gerados acima
; e agora serão lidos e estão prontos para serem utilizados na função 
; do plot do diagrama de Taylor.

desvio = asciiread("plot_std.txt",(/dimsizes(estacao), \ 
         dimsizes(modelos)/),"float")
corr   = asciiread("plot_cor.txt",(/dimsizes(estacao), \ 
         dimsizes(modelos)/),"float")

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex51")

res               = True
res@Markers       = (/16,16,16,16/)   ; Tipo de marcadador para cada 
                                      ; experimento.
res@Colors        = (/"red","green","blue","orange"/) ; Cores para cada 
                                                      ; experimento.
res@varLabels     = modelos                           ; Nome dos modelos.
res@centerDiffRMS = True                  ; Habilitas as linhas do RMSE.
res@stnRad        = (/0.25,0.5,0.75,1.25,1.50/); Linhas dos desvio padrão. 
res@ccRays        = (/0.2,0.4,0.6,0.8,0.9/)    ; Linhas da correlação.
res@caseLabels    = str_upper(estacao); Converte para maiúsculo os 
                                      ; nomes da variável estacao. 
                                      ; Essa linha refere-se aos rótulos 
                                      ; da legenda.
res@caseLabelsFontHeightF = 0.10   ; Tamanho do texto da legenda
                                   ; do diagrama.
res@varLabelsFontHeightF  = 0.015  ; Tamanho da fonte do nome dos 
                                   ; modelos.
res@varLabelsYloc         = 1.7    ; Desloca para cima ou para baixo 
                                   ; o nome dos modelos.
res@gsMarkerSizeF         = 0.015  ; Tamanho do marcador da legenda.
res@tiMainFontHeightF     = 0.025  ; Tamanho da fonte do título da 
                                   ; figura
res@tiMainString          = "Precipita"+cedil+atilde+ \ 
                            "o dos modelos do CMIP5: 1979 - 2005"

plot = taylor_diagram(wks,desvio,corr,res) ; Geração da figura.

; Remove os arquivos desnecessários.
system("rm -f tmp_????.txt")
system("rm -f l2c_????.txt")
system("rm -f plot_????.txt")
system("rm -f plot_???.txt")

end

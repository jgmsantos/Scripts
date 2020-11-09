; Nome do script: cap21_ex49.ncl

begin

; Média espacial da precipitação mensal sobre 
; a América do Sul.
f = addfile("../../dados/SA.GPCP.prec.1979.2013.nc","r") 

; float precip ( time, lat, lon ) = 420, 1, 1
ppt       = f->precip 

; Calcula a Climatologia. [month | 12] x [lat | 1] x [lon | 1]
ppt_clima = clmMonTLL(ppt) 

; Cálculo sazonal.
djf = ppt_clima(11,:,:) + ppt_clima(0,:,:) + ppt_clima(1,:,:)
mam = ppt_clima(2,:,:)  + ppt_clima(3,:,:) + ppt_clima(4,:,:)
jja = ppt_clima(5,:,:)  + ppt_clima(6,:,:) + ppt_clima(7,:,:)
son = ppt_clima(8,:,:)  + ppt_clima(9,:,:) + ppt_clima(10,:,:)

; Soma total.
soma = dim_sum_n_Wrap(ppt_clima,0)

; Cálculo sazonal em porcentagem (%).
djf_pct   = (djf(0,0) * 100.0)/soma(0,0)
mam_pct   = (mam(0,0) * 100.0)/soma(0,0)
jja_pct   = (jja(0,0) * 100.0)/soma(0,0)
son_pct   = (son(0,0) * 100.0)/soma(0,0)

; Armazena os valores em um arranjo de 4 linhas e 1 coluna.
estacao      = new((/4,1/),"float") 
estacao(0,:) = djf_pct
estacao(1,:) = mam_pct
estacao(2,:) = jja_pct
estacao(3,:) = son_pct

; Meses que vão aparecer na legenda.
mes = (/"DJF","MAM","JJA","SON"/) 

; Cor para cada uma das estações.
cor = (/"red","green","orange","yellow"/) 

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex49")

pcRes             = True
pcRes@gsnMaximize = True ; A figura ocupa toda a tela.

pcRes@tiMainString  = "Precipita"+cedil+atilde+ \
                      "o sazonal (%) sobre a Am"+eacute+"rica do Sul"

plot = pie_chart(wks,estacao(:,0),mes,cor,pcRes)

end

; Nome do script: cap14_ex03.ncl

begin

;***********************************************************
; Abertura do arquivo. Lembrando que neste dado 
; (maio1979 a abr2012), os meses do primeiro e do último 
; ano não estão completos, por isso, foi selecionado um perído
; em que todos os meses estão completos, isto é, de janeiro 
; de 1980 a dezembro de 2011. Poderia ser qualque período desde 
; que os meses não estejam faltando.
;***********************************************************
f   = addfile("../../dados/gpcp.mensal.051979.042012.nc","r")
;***********************************************************

time   = f->time              
YYYYMM = cd_calendar(time,-1) ; Converte uma data do calendário 
                              ; juliano/gregoriano
                              ; para o formato AAAAMM (opção -1) 
                              ; da variável time.
anoi   = 198001               ; Data inicial no formato AAAAMM.
anof   = 201112               ; Data final no formato AAAAMM.
istr   = ind(YYYYMM.eq.anoi ) ; Índice que será utilizado
iend   = ind(YYYYMM.eq.anof ) ; para selecionar o período de interesse.
ppt = f->precip(istr:iend,:,:); Escolha do período de interesse
                              ; com base nas datas (linhas 21 e 22).
;***********************************************************
; Calcula a climatologia no período de 198001 a 201112
;***********************************************************
clima = clmMonTLL(ppt)
;***********************************************************
; Calcula a anomalia mensal usando a climatologia
;***********************************************************
pptAnom = calcMonAnomTLL(ppt,clima)
;***********************************************************

printVarSummary(pptAnom)

end

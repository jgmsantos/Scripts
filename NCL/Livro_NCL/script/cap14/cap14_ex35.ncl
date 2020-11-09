; Nome do script: cap14_ex35.ncl

begin

f = addfile("../../dados/SA.umidade.q.psfc.R1.2010.nc","r")

q    = f->shum  ; g/kg => float shum ( time, level, lat, lon )
z    = f->level ; hPa  => float level ( level ) 
psfc = f->pres  ; hPa  => float pres(time, lat, lon)
q    = q/1000.0 ; g/kg->kg/kg
ptop = 300      ; Até onde será integrado (hPa).

dp = dpres_plevel_Wrap(z,psfc,ptop,0) ; Calculo da espessura da camada 
                                      ; em hPa.
dp = dp*100 ; hPa->Pa. dp será utilizado para o cálculo de "pw".

	
dp_N = dp(time|:,lat|:,lon|:,level|:) ; Reordenamento das dimemsões. 
                                      ; A dimensão level tem que ser a 
                                      ; dimensão mais a direita.

q_N  = q(time|:,lat|:,lon|:,level|:)  ; A dimensão "level" precisar
                                      ; estar mais a direita. Por isso,
                                      ; foi feita a reordenação da 
                                      ; dimensões.

; "q_N" possui agora a seguinte ordem das dimensões:
; Dimensions and sizes:	[time | 12] x [lat | 73] x [lon | 144] x [level | 8]

pw = prcwater_dp(q_N,dp_N) ; pw (kg/m2)
                           ; Dimensions and sizes: [12] x [73] x [144]
                           ; A variável "pw" não tem as coordenadas.
                           ; Será criada uma variável auxiliar para 
                           ; resolver isso.

q_aux = q(:,0,:,:) ; Artifício para copiar as coordenadas de "q_aux" para 
                   ; "pw". Ao fixar qualquer nível vertical, ocorre a 
                   ; redução de dimensões. Neste caso, restaram apenas as 
                   ; dimensões tempo, lat e lon que serão copiadas para 
                   ; a variável "pw" que contém apenas 3 dimensões.

copy_VarCoords(q_aux,pw) ; Copia as coordenadas e dimensões de "q_aux" 
                         ; para "pw".

printVarSummary(pw) 
; Dimensions and sizes: [time | 12] x [lat | 73] x [lon | 144]

end

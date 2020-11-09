; Nome do script: cap14_ex39.ncl

begin

f = addfile("../../dados/tar.pres.uwnd.vwnd.nc","r")

u    = short2flt(f->uwnd) ; short vwnd ( time, level, lat, lon )
v    = short2flt(f->vwnd) ; short vwnd ( time, level, lat, lon )
                          ; A latitude está em ordem ascendente:
                          ; lat: [90..-90] e o dado é global.

tempo = f->time  ; Será utilizado para criar a coordenada de tempo
                 ; da variável vrdvx.
nivel = f->level ; Será utilizado para criar a coordenada de nível
                 ; vertical da variável vrdvx.

; Calcula a vorticidade e a divergência. A 
; disposição das dimensões da variável vrdvx são: 
; Dimensions and sizes: [2] x [3] x [12] x [73] x [144].
; A nova dimensão [2] quer dizer que o primeiro índice  
; é a vorticidade e o segundo índice é a divergência.
; [3], [12], [73] e [144] são as dimensões:
; tempo, nível vertical, lat e lon, respectivamente.
; Essa variável não possui o nome das dimensões e 
; coordenadas, por isso a necessidade de criação delas.

vrdvx = uv2vrdvF(u,v)

; Nome das dimensões para a variável vrdvx.
vrdvx!0 = "var"   ; Os nomes selecionados
vrdvx!1 = "time"  ; são escolhidos pelo
vrdvx!2 = "level" ; usuário. Agora, há 5 
vrdvx!3 = "lat"   ; dimensões. O ideal é manter
vrdvx!4 = "lon"   ; o mesmo nome das dimensões das variáveis originais.

; Criação das coordendas da variável vrdvx.
vrdvx&time  = tempo
vrdvx&level = nivel
vrdvx&lat   = latGlobeF(73,"lat","latitude","degrees_north")
vrdvx&lon   = lonGlobeF(144,"lon","longitude","degrees_east")

printVarSummary(vrdvx)

; O resultado do comando acima mostra que a variável está com suas 
; dimensões e coordenadas:
; Dimensions and sizes:	[var | 2] x [time | 3] x [level | 12] x 
;                       [lat | 73] x [lon | 144]

end

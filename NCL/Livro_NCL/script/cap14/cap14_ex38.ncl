; Nome do script: cap14_ex38.ncl

begin

f = addfile("../../dados/tar.pres.uwnd.vwnd.nc","r")

u    = short2flt(f->uwnd) ; short vwnd ( time, level, lat, lon )
v    = short2flt(f->vwnd) ; short vwnd ( time, level, lat, lon )
                          ; A latitude está em ordem ascendente:
                          ; lat: [90..-90] e o dado é global.

tempo = f->time  ; Será utilizado para criar a coordenada de tempo
                 ; da variável sfpv.
nivel = f->level ; Será utilizado para criar a coordenada de nível
                 ; vertical da variável sfpv.

sfvp = uv2sfvpF(u,v) ; Calcula a função de corrente e a velocidade 
                     ; potencial.

; A disposição das dimensões da variável sfvp são: 
; Dimensions and sizes: [2] x [3] x [12] x [73] x [144].
; A nova dimensão [2] quer dizer que o primeiro valor 
; é a função de corrente e o segundo valor é a velocidade
; potencial. [3], [12], [73] e [144] são as dimensões:
; tempo, nível vertical, lat e lon, respectivamente.
; Essa variável não possui o nome das dimensões e 
; coordenadas, por isso a necessidade de criação delas.

; Nome das dimensões para a variável sfvp.
sfvp!0 = "var"   ; Os nomes selecionados
sfvp!1 = "time"  ; são escolhidos pelo
sfvp!2 = "level" ; usuário. Agora, há 5 
sfvp!3 = "lat"   ; dimensões. O ideal é manter
sfvp!4 = "lon"   ; o mesmo nome das dimensões da variável original.

; Criação das coordendas da variável sfvp.
sfvp&time  = tempo
sfvp&level = nivel
sfvp&lat   = latGlobeF(73,"lat","latitude","degrees_north")
sfvp&lon   = lonGlobeF(144,"lon","longitude","degrees_east")

printVarSummary(sfvp)

; Dimensions and sizes:	[var | 2] x [time | 3] x [level | 12] x 
;                       [lat | 73] x [lon | 144]

end

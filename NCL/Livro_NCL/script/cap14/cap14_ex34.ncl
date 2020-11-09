; Nome do script: cap14_ex34.ncl

begin

f = addfile("../../dados/tar.pres.uwnd.vwnd.nc","r")

u    = short2flt(f->uwnd) ; (m/s). short air(time, level, lat, lon), 
v    = short2flt(f->vwnd) ; (m/s). short air(time, level, lat, lon), 
t    = short2flt(f->air)  ; (K). short air(time, level, lat, lon), 
                          ; por isso, o uso da função short2flt.

lev  = f->level           ; Níveis de pressão em hPa. A variável 
                          ; "level" pertence ao arquivo aberto.
lev  = lev*100            ; Converte os níveis verticais de 
                          ; hPa para Pa.

lat  = f->lat             ; As coordenadas de latitude. A variável
                          ; "lat" pertence ao arquivo aberto.

gridType = 0    ; 0 = grade gaussiana e 1 = grade fixa (regular).
opt      = 0    ; 0 = calcula a vorticidade potencial.
                ; 1 = retorna uma lista de variáveis:
                ; vorticidade potencial, estabilidade estática e 
                ; temperatura potencial.

; Caso o dado não esteja na disposição sul->norte, será retornada 
; a seguinte mensagem: 
; (0)	pot_vort_isobaric: data must be in S-N order.
; Para resolver isso, basta inverter a latitude utilizando o operador ":".
; Por exemplo, "::-1", com isso, o dado passa a ser orientado de sul->norte.

; Calcula a PV e inverte as coordenadas de sul->norte.

PV = pot_vort_isobaric(lev,u(:,:,::-1,:),v(:,:,::-1,:),t(:,:,::-1,:),\
                      lat(::-1),gridType,opt) 

printVarSummary(PV) 

end

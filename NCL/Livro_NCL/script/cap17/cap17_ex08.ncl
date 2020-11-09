; Nome do script: cap17_ex08.ncl

begin

f = addfile("../../dados/uwnd.vwnd.R1.nc","r")

u = short2flt(f->uwnd)
v = short2flt(f->vwnd)

printVarSummary(u)

printVarSummary(v)

nt = 3   ; Número de tempos do arquivo.
nz = 12  ; Número de níveis verticais do arquivo.
ny = 73  ; Número de pontos de latitude do arquivo. 
         ; Lembrando que a latitude terá um ponto a mais 
         ; em relação ao dado original que têm 72 pontos.
nx = 144 ; Número de pontos de longitude do arquivo.

; Cria uma nova variável para alocar a variável interpolada.
uN = new((/nt,nz,ny,nx/),typeof(u)) 
vN = new((/nt,nz,ny,nx/),typeof(v)) 

; Não é possível utilizar a função copy_VarCoords porque o número
; de pontos de latitude da variável de entrada não é o mesmo da 
; variável de saída. 
; As coordenadas serão criadas na manualmente. 
; Copia apenas as duas dimensões mais a esquerda, isto é, time e level.
copy_VarCoords_2(u,uN)
copy_VarCoords_2(v,vN)

printVarSummary(uN) ; [time | 3] x [level | 12] x [73] x [144]
printVarSummary(vN) ; [time | 3] x [level | 12] x [73] x [144]

; Criação manual das coordendas.
uN!2         = "lat"
uN!3         = "lon"
uN&lat       = fspan(-90.,90.,ny)
uN&lon       = fspan(0.,357.5,nx)
uN&lat@units = "degrees_north"
uN&lon@units = "degrees_east"

; Criação manual das coordendas.
vN!2         = "lat"
vN!3         = "lon"
vN&lat       = fspan(-90.,90.,ny)
vN&lon       = fspan(0.,357.5,nx)
vN&lat@units = "degrees_north"
vN&lon@units = "degrees_east"

; A latitude deve ser de sul para norte ("::-1").
fo2fshv_Wrap(u(:,:,::-1,:),v(:,:,::-1,:),uN,vN)

printVarSummary(uN) ; [time | 3] x [level | 12] x [lat | 73] x [lon | 144]
                    ; time: [1569072..1570488]
                    ; level: [1000..100]
                    ; lat: [-90..90] => Latitude com mais um ponto (73)
                    ; lon: [ 0..357.5]

printVarSummary(vN) ; [time | 3] x [level | 12] x [lat | 73] x [lon | 144]
                    ; time: [1569072..1570488]
                    ; level: [1000..100]
                    ; lat: [-90..90] => Latitude com mais um ponto (73)
                    ; lon: [ 0..357.5]

end

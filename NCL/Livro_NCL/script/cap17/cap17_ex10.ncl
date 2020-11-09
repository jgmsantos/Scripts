; Nome do script: cap17_ex10.ncl

begin

f = addfile("../../dados/MCGA.1985.nc","r")

u = f->uvel
v = f->vvel

printVarSummary(u) 

printVarSummary(v) 

nt = 1   ; Número de tempos do arquivo.
nz = 18  ; Número de níveis verticais do arquivo.
ny = 73  ; Número de pontos de latitude a ser interpolado.
nx = 144 ; Número de pontos de longitude a ser interpolado.

; Cria uma nova variável para alocar a variável interpolada. 
; 73x144 corresponde a uma grade de 2.5° lat x 2.5° lon. 
; Essa escolha é feita de acordo com a necessidade do usuário.
uN = new((/nt,nz,ny,nx/),typeof(u)) 
vN = new((/nt,nz,ny,nx/),typeof(v)) 

; Não é possível utilizar a função copy_VarCoords porque o número de 
; pontos de latitude da variável de entrada não é o mesmo da variável
; de saída. As coordenadas serão criadas na manualmente.

; Copia apenas as duas dimensões mais a esquerda (time e level).
copy_VarCoords_2(u,uN) 
; Copia apenas as duas dimensões mais a esquerda (time e level).
copy_VarCoords_2(v,vN) 

printVarSummary(uN) ; [time | 1] x [lev | 18] x [73] x [144]
printVarSummary(vN) ; [time | 1] x [lev | 18] x [73] x [144]

; Criação manual das coordendas de latitude.
uN!2         = "lat"
uN!3         = "lon"
uN&lat       = fspan(-90.,90.,ny)
uN&lon       = fspan(0.,357.5,nx)
uN&lat@units = "degrees_north"
uN&lon@units = "degrees_east"

; Criação manual das coordendas de latitude.
vN!2         = "lat"
vN!3         = "lon"
vN&lat       = fspan(-90.,90.,ny)
vN&lon       = fspan(0.,357.5,nx)
vN&lat@units = "degrees_north"
vN&lon@units = "degrees_east"

; A latitude deve ser de sul para norte ("::-1").
g2fshv_Wrap(u(:,:,::-1,:),v(:,:,::-1,:),uN,vN)

printVarSummary(uN) ; [time | 1] x [lev | 18] x [lat | 73] x [lon | 144]
                    ; time: [   0..   0]
                    ; lev: [1000..   3]
                    ; lat: [-90..90] => Latitude com espaçamento de 2.5°.
                    ; lon: [ 0..357.5]

printVarSummary(vN) ; [time | 1] x [lev | 18] x [lat | 73] x [lon | 144]
                    ; time: [   0..   0]
                    ; lev: [1000..   3]
                    ; lat: [-90..90] => Latitude com espaçamento de 2.5°.
                    ; lon: [ 0..357.5]

end

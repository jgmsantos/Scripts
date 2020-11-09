; Nome do script: cap4_ex01.ncl

begin

; Lista todos os arquivos (mes.01.nc, mes.02.nc, ..., mes.12.nc).
all_files = systemfunc("ls ../../dados/mes.*.nc") 

; Note para o "s" na função addfiles, isto é, lê vários arquivos.
fall = addfiles(all_files, "r")       

; Concatena os arquivos que é o padrão.
ListSetType(fall, "cat") 

; Uso da sintaxe [:]. O precip é o nome da variável do arquivo. 
ppt = fall[:]->precip    

printVarSummary(ppt)

end

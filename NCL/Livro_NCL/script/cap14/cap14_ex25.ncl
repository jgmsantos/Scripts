; Nome do script: cap14_ex25.ncl

begin

dir      = "../../dados/" ; Diretório corrente, onde está o dado.
filename = "gpcp.nc"      ; Nome do arquivo.

if ( fileexists ( dir+filename ) ) then
    print("O ARQUIVO ==> " + filename + " <== EXISTE")
else
    print("O ARQUIVO ==> " + filename + " <== NAO EXISTE")
end if

end

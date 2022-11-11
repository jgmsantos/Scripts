import xarray as xr
import sys

# Função que retorna a categoria do risco de fogo:
def categoria_risco(valorRF):
     if valorRF <= 0.15:
        categoria = "Minimo"
     elif valorRF > 0.15 and valorRF <= 0.40:
        categoria = "Baixo"
     elif valorRF > 0.40 and valorRF <= 0.70:
        categoria = "Medio"
     elif valorRF > 0.70 and valorRF <= 0.95:
        categoria = "Alto"
     elif valorRF > 0.95:
        categoria = "Critico"
     return categoria

# Habilitar o ambiente virtual infoqueima para executar o script:
# conda activate infoqueima

#####################################################
# Objetivo: Retornar o valor do risco de fogo em uma 
# determinada latitude e longitude.
#####################################################

# Para executar o script. São necessários 3 parâmetros: data, longitude e latitude, respectivamente.
# python get_risco_pontual.py YYYYMMDD LONGITUDE LATITUDE
# Onde: YYYY = ano, MM = mês, DD = dia, LONGITUDE e LATITUDE = float ou integer.
# Exemplo: python get_risco_pontual.py 20221110 -60 -34

data = sys.argv[1] # Primeiro parâmetro: Data a ser avaliada. É o parâmetro que será usado para executar o script.
ano = data[0:4]
mes = data[4:6]
longitude = sys.argv[2] # Segundo parâmetro: Valor da Longitude.
latitude = sys.argv[3] # Terceiro parâmetro: Valor da Latitude.

print("----------------------------")
print(f"Processando a data: {data}")
print("----------------------------")

DIR_INPUT = f"/mnt/vol_queimadas_2/INPE_FireRiskModel/data/output/2.2/FireRisk-2_2/{ano}/{mes}"
NOME_ARQUIVO = f"INPE_FireRiskModel_2.2_FireRisk_{data}.nc"

# checa se o arquivo existe, caso contrário retorna uma mensagem 
# de que ele não existe.
try:
     ds = xr.open_dataset(f"{DIR_INPUT}/{NOME_ARQUIVO}")
     rf = ds['rf'][0,:,:] # Importa a variável. Só tem um tempo.
     # Extrai o valor do RF na longitude e na latitude de interesse.
     # Os nomes "lon" e "lat" são os nomes das dimensões do arquivo.
     rf_pontual = rf.sel(lon=longitude, lat=latitude, method='nearest').values.round(2)
except Exception as error:
     print(f"O arquivo não existe! \nError: {error}")
     sys.exit() 

print(categoria_risco(rf_pontual)) # Chama a função e mostra na tela o resultado.
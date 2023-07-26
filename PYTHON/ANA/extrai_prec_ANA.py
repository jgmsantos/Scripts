import pandas as pd
import xarray as xr
import numpy as np


# Script que lê um arquivo no formato '.csv' que possui a seguinte estrutura:
# Estacao,nome_arquivo,EDMs,cod.ANA,latitude,longitude,datafinal,datainicia,dias_com_d
# 1,3RS0001,ETP00001.EDM,3253003,-32.9539,-53.1189,1980,2014,12166
# 2,3RS0002,ETP00002.EDM,3252025,-32.9444,-52.7733,2000,2014,4900

# A partir dos valores de latitude e de longiute, extrais os valores de precipitação
# de um arquivo NetCDF e salva o resultado em um arquivo '.csv' cujo nome é de acordo com a coluna
# 'nome_arquivo' do '.csv' original e que posui o seguinte formato: 
# YYYY-MM-DD,latitude,longitude,precipitacao
# como mostrado no exemplo abaixo:
# 2012-12-31,-32.9539,-53.1189,90.22
# 2013-01-01,-32.9539,-53.1189,0.0
# 2013-01-02,-32.9539,-53.1189,0.0
# 2013-01-03,-32.9539,-53.1189,0.0

# Autor: Guilherme Martins - jgmsantos@gmail.com
# 12/07/2023 - 09h48.

# Abertura do arquivo csv.
# Faz uma checagem para saber se o arquivo existe. Caso negativo, 
# para a execução do script.
try:
    df = pd.read_csv('./input/arquivo_lat_lon.csv')
except:
    print('--' * 30)
    print('O arquivo .csv não existe. Saindo do script.')
    print('--' * 30)
    quit()

# Abertura do arquivo NetCDF.
try:
    ds = xr.open_dataset('./input/chuva.nc')
except:
    print('--' * 30)
    print('O arquivo NetCDF não existe. Saindo do script.')
    print('--' * 30)
    quit()

# Remove a dimensão 'bnds'.
ds_drop = ds.drop_dims('bnds')

# Organiza as dimensões para ficarem corretas. A ordem correta é: time, lat, lon.
ds_transpose = ds_drop.transpose('time', 'lat', 'lon')

# Número de linhas do arquivo.
numero_linhas, _ = df.shape

# Loop em cada linha de latitude e de longitude.
for linha, nome_estacao, lat, lon in zip(range(0, numero_linhas), df['nome_arquivo'], df['latitude'], df['longitude']):
    
    # Trata as estações sem nome para que elas sejam geradas.
    # O valor retornado é nan que possui 3 caracteres, por isso, 
    # a condição abaixo.
    if len(str(nome_estacao)) == 3:
        # Quando o nome da estação estiver vazio, o nome do arquivo
        # será Estacao{LinhaDoArquivoOrginalCSv}.csv.
        novo_nome_estacao = f'Estacao{linha+1}'.zfill(4)
    else:
        novo_nome_estacao = nome_estacao
    
    print(f'Linha: {linha+1} | Posto: {novo_nome_estacao} | Latitude: {lat} | Longitude: {lon}')
    
    # Valores de latitude/longitude para ficar com o mesmo número de linhas da precipitação.
    latitude = ''.join(str(lat)).split() * len(ds_transpose['time'])
    longitude = ''.join(str(lon)).split() * len(ds_transpose['time'])
    
    # Valor em cada ponto de grade com duas casas decimais.
    # precipitationCal: nome da variável do arquivo.
    # lon e lat são os nomes das coordenadas do arquivo.
    ds_ponto = ds_transpose['precipitationCal'].sel(lon=lon, lat=lat, method='nearest').round(2)
    
    # Formata a data: YYYY-MM-DD.
    data = ds_ponto.time.dt.strftime('%Y-%m-%d')
    
    # Salva cada resultado em um DataFrame.
    df_final = pd.DataFrame(np.column_stack((data, latitude, longitude, ds_ponto)))
    
    # Salva no arquivo '.csv' para cada posto de acordo com a coluna 'nome_arquivo'.
    df_final.to_csv(f'./output/{novo_nome_estacao}.csv', index=False , header=False)
# Shell

**01lat_lon.txt**: Arquivo texto a ser utilizado com o script 01loop.sh.

**01loop.sh**: Uso do loop read while para ler um arquivo texto.

**02get_data_NASA_GRACE.sh**: Realiza o download dos dados de umidade do solo do GRACCE/NASA, conserta a data e gera o NetCDF.

**03limpa_cmip5.sh**: Adiciona os dias 31 ao meses que possuem esse número de dias e remove datas duplicadas do modelo HADGEM2-ES para os cenários historical, rcp26 e rcp85.

**04_limpa_IMERG.sh**: Utiliza o parallel para juntar os arquivos diários do IMERG/NASA para depois fazer o recorte dos dados sobre o Brasil.

**05ajunta.sh**: Junta os arquivos diários em meses e recorta sobre o domínio do Brasil. Esses dados serão utilizados pelo script "05bindice_climatico.sh".

**05bindice_climatico.sh**: Realiza o cálculo do índice eca_dd, extrai a série temporal e salva no formato texto para várias áreas.

**05cindice_climatico.sh**: Realiza o cálculo do índice eca_dd, extrai a série temporal e salva no formato texto para apenas uma área.

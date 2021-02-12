import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import netCDF4 as nc
import xarray as xr

fn = './input/SPI_pantanal.nc'

ds = nc.Dataset(fn)

largura_barra = 0.25  # Largura da barra.
maximo_valor_y = 3.0  # Máximo valor do eixo y.
minimo_valor_y = -2.5  # Mínimo valor do eixo y.
tamanho_fonte_texto = 7
x = np.arange(21)  # Desde 01/2019 a 09/2020 = 21 meses.
datas = ['201901', '201902', '201903', '201904', '201905', '201906', '201907', '201908', '201909', '201910', '201911', '201912', '202001', '202002', '202003', '202004', '202005', '202006', '202007', '202008', '202009']

# Seleciona o SPI de interesse:
# Formato: spi(time, spi, lat, lon) = (492, 6, 1, 1)
# Valor  => spi = 1, 3, 6, 12, 24, 36 meses
# Índice => spi = 0, 1, 2,  3,  4,  5 
y = ds['spi'][468:489, 0, 0, 0]

# Separa os valores mínimos e máximos.
above_threshold = np.maximum(y - 0, 0)
below_threshold = np.minimum(y, 0)

# Gera o plot com base nos limiares e separa o que é positivo (negativo) com vermelho (azul).
fig, ax = plt.subplots(figsize=(6,3))  # Largua e altura da figura.

ax.bar(x, below_threshold, 0.75, color="r")
ax.bar(x, above_threshold, 0.75, color="b", bottom=below_threshold)

plt.axhline(linestyle='--', y=2, linewidth=0.5, color='black')  # Linha no valor zero, espessura = 0.5 e cor = black.
plt.axhline(linestyle='--', y=1.5, linewidth=0.5, color='black')  # Linha no valor zero, espessura = 0.5 e cor = black.
plt.axhline(linestyle='--', y=1, linewidth=0.5, color='black')  # Linha no valor zero, espessura = 0.5 e cor = black.
plt.axhline(linestyle='-', y=0, linewidth=0.5, color='black')  # Linha no valor zero, espessura = 0.5 e cor = black.
plt.axhline(linestyle='--', y=-2, linewidth=0.5, color='black')  # Linha no valor zero, espessura = 0.5 e cor = black.
plt.axhline(linestyle='--', y=-1.5, linewidth=0.5, color='black')  # Linha no valor zero, espessura = 0.5 e cor = black.
plt.axhline(linestyle='--', y=-1, linewidth=0.5, color='black')  # Linha no valor zero, espessura = 0.5 e cor = black.

# Linhas horizontal dos valores positivos de SPI.
plt.text(-0.3, 2.05, 'Extremamente Úmido', fontsize=tamanho_fonte_texto)
plt.text(-0.3, 1.55, 'Muito Úmido', fontsize=tamanho_fonte_texto)
plt.text(-0.3, 1.05, 'Moderadamente Úmido', fontsize=tamanho_fonte_texto)
plt.text(-0.3, 0.80, 'Próximo do normal', fontsize=tamanho_fonte_texto)

# Linhas horizontal dos valores negativos de SPI.
plt.text(-0.3, -2.18, 'Extremamente seco', fontsize=tamanho_fonte_texto)
plt.text(-0.3, -1.68, 'Severamente seco', fontsize=tamanho_fonte_texto)
plt.text(-0.3, -1.18, 'Moderadamente seco', fontsize=tamanho_fonte_texto)
plt.text(-0.3, -0.92, 'Próximo do normal', fontsize=tamanho_fonte_texto)

#  Formatação do eixo y:
plt.ylabel('SPI (Adimensional)', fontsize=10)  # Tamanho do título do eixo y.
plt.ylim(minimo_valor_y, maximo_valor_y-0.5)  # Define o mínimo e máximo valor do eixo y.
plt.yticks(np.arange(minimo_valor_y, maximo_valor_y, step=0.5), fontsize=7)  # Define o mínimo e máximo valor do eixo y, tamanho dos seus rótulos.
plt.tick_params(axis='y', right=True)  # Habilita o tickmark do eixo direito.

#  Formatação do eixo x:
plt.xlim(-0.5, 20.5)  # Define o mínimo e o máximo valor do eixo x.
plt.xticks(np.arange(21), datas, fontsize=7, rotation='vertical')  # Rótulos do eixo x, tamanho e orientação.

#  Salva a figura:
plt.savefig('ex03.jpg', transparent=True, dpi=300, bbox_inches='tight', pad_inches=0)  # Salva a figura no formato ".jpg" com dpi=300 e remove espaços excedentes.

#  Mostra o gráfico na tela:
#plt.show()

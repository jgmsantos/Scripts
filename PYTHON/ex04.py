import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import netCDF4 as nc
import xarray as xr
import geopandas as gpd
import shapefile as shp

fn2019 = './input/GRACE.2019.pantanal.nc'
fn2020 = './input/GRACE.2020.pantanal.nc'

ds2019 = xr.open_dataset(fn2019, decode_times=False)
ds2020 = xr.open_dataset(fn2020, decode_times=False)

ds2019.sel(time='0').sfsm.plot()
ds2020.sel(time='0').sfsm.plot()

numero_colunas = 3
numero_linhas = 3
mes = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro']

#fig, axs = plt.subplots(numero_colunas, numero_linhas, figsize=(3,3))
fig, axs = plt.subplots(numero_colunas, numero_linhas)

fig.suptitle('Título da figura')  # Título principal da figura.

for i in range(1, 10):
    plt.subplot(numero_colunas, numero_linhas, i)  # Onde gerar cada figura com base na coluna e linha.
    plt.xticks(())  # Desabilita as informações do eixo x.
    plt.yticks(())  # Desabilita as informações do eixo y.
    plt.title(mes[i-1], fontsize=7)  # Título de cada figura e o seu tamanho.
    plt.pcolor(ds2019['sfsm'][i-1,:,:], cmap='Blues', vmin=0, vmax=100)
    cbar = plt.colorbar(ticks=[5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 98], label='(%)', orientation='horizontal', fraction=0.1)
    cbar.ax.tick_params(labelsize=7)  # Tamanho dos rótulos da legenda da figura.

plt.tight_layout()

#  Salva a figura:
plt.savefig('ex04.jpg', transparent=True, dpi=300, bbox_inches='tight', pad_inches=0)  # Salva a figura no formato ".jpg" com dpi=300 e remove espaços excedentes.

#plt.show()
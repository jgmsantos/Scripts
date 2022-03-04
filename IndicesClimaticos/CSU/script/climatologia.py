import proplot as plot
import xarray as xr
import numpy as np
import cartopy.crs as crs
import matplotlib.pyplot as plt

from cartopy.feature import ShapelyFeature
from cartopy.io.shapereader import Reader

# A linha abaixo evita a mensagem de aviso:
# ProplotWarning: rc setting 'large' was renamed to 'font.largesize' in version 0.6.
plot.rc['font.large'] = 35

# Abertura do arquivo NetCDF.
ds = xr.open_dataset('../processado/csu.climatologia.1981.2010.nc')

# Importando as variáveis de coordenadas para serem utilizadas na geração do mapa. 
lat = ds['latitude']
lon = ds['longitude']

# Domínio de interesse.
LatS = -35
LatN = 7
LonW = -75
LonE = -33

# Valores que vão aparecer na legenda.
EscalaValores = [1, 2, 4, 6, 8, 10, 15, 20, 25, 30]

# Nome de cada mapa.
VetorMeses = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez']

# Linhas dos estados do Brasil.
EstadosBrasil = ShapelyFeature(Reader('../../../shapefiles/shape/Brasil/Brasil_estados/BRUFE250GC_SIR.shp').geometries(), 
                               crs.PlateCarree(), 
                               facecolor='none')

# Define como será a disposição do painel de figuras.
fig, ax = plot.subplots(axheight=5,
                        nrows=int(len(VetorMeses)/4), 
                        ncols=int(len(VetorMeses)/3), 
                        tight=True, 
                        proj='pcarree', 
                        hspace=7)

# Formatação do mapa.
ax.format(coast=False,
          borders=False,
          labels=False,
          grid=False,
          latlim=(LatS, LatN), 
          lonlim=(LonW, LonE), 
          linewidth=0,
          suptitle='Climatologia (1981-2010) do Número de Dias Consecutivos com Temperatura >=30°C', 
          suptitlepad=40)
          
for i in np.arange(0, len(VetorMeses)):

        # Plot da variável.
        map = ax[i].pcolormesh(lon, lat, ds['csu'][i,:,:], 
                               cmap='RdYlBu_r', 
                               levels=EscalaValores, 
                               extend='neither')

        # Insere o mês em cada figura.
        ax[i].set_title(VetorMeses[i], fontsize=30)
 
        # Adiciona o contorno dos estados no mapa.
        ax[i].add_feature(EstadosBrasil, linewidth=4., edgecolor='k')
  
#  Adiciona a barra de cores.
x = fig.colorbar(map, loc='b', width='80px', extendsize='140px', shrink=1, ticks=EscalaValores)

plt.tick_params(labelsize=30)  # Tamanho da fonte da barra de cores.

# Unidade da barra de cores.
x.set_label('(Número de Dias)', fontsize=30)

# Salva a figura no formato ".jpg" com dpi=300.
fig.save(f'../figuras/csu.climatologia.png', dpi=300, bbox_inches='tight', pad_inches=0.1)
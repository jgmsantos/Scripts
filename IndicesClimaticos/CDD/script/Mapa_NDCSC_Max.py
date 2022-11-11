import proplot as plot
import xarray as xr
import numpy as np
import cartopy.crs as crs

from cartopy.feature import ShapelyFeature
from cartopy.io.shapereader import Reader

NumeroDias = [10, 20, 30]
ListaDatas = ["08/02 a 17/02", "29/01 a 17/02", "19/01 a 17/02"]
EscalaValores = [[2, 4, 6, 8, 10], 
                 [2, 4, 6, 8, 10, 15, 20],
                 [2, 4, 6, 8, 10, 15, 20, 25, 30]]

Cores = [['#003c30', '#2e9189', '#d9efeb', '#f6edd5', '#b87928', '#543004'],
         ['#003c30', '#2e9189', '#89d1c6', '#d9efeb', '#f6edd5', '#e1c583', '#b87928', '#543004'],
         ['#003c30', '#00564c', '#2e9189', '#89d1c6', '#d9efeb', '#f6edd5', '#e1c583', '#b87928', '#754409', '#543004']]

for i, NumDias, DataString, NumeroCor in zip(np.arange(0, len(NumeroDias)), NumeroDias, ListaDatas, Cores):

    print(i, NumDias, DataString)

    # Abertura do arquivo NetCDF.
    ds = xr.open_dataset(f'../tmp/NDCSC_Max_{NumDias}Dias.nc')
     
    # Importando as variáveis do arquivo.
    lat = ds['latitude']
    lon = ds['longitude']
    
    # Domínio de interesse.
    latS = -35
    latN = 7
    lonW = -75
    lonE = -33
    
    # Linhas dos estados do Brasil.
    EstadosBrasil = ShapelyFeature(Reader(f'../../shapefiles/shape/Brasil/Brasil_estados/BRUFE250GC_SIR.shp').geometries(), 
                                           crs.PlateCarree(), 
                                           facecolor='none')
    
    fig, ax = plot.subplots(proj='pcarree')    
    
    # Formatação do mapa.
    ax.format(coast=False, borders=False,
              labels=True, grid=False, latlines=5, lonlines=5,
              latlim=(latS, latN), lonlim=(lonW, lonE), small='9px', large='10px',
              title=f'Número de Dias Sem Chuva - {DataString} ({NumDias} dias)', labelpad=10)
          
    # Plot da variável.
    map = ax.pcolormesh(lon, lat, ds['ndsc'][0,:,:], cmap=NumeroCor, 
                      levels=EscalaValores[i], extend='min')
          
    # Barra de cores.
    fig.colorbar(map, loc='b', width='15px', shrink=1, label='Número de Dias Sem Chuva', 
                 labelsize=5, ticklabelsize=4.6)
          
    # Adiciona o contorno dos estados e países.
    ax.add_feature(EstadosBrasil, linewidth=0.5, edgecolor="k")
    
    # 
    ax.annotate("Fonte: MERGE/CPTEC (10 km)", xy=(-74, -34), fontsize=5)
    
    # Salva a figura no formato ".jpg" com dpi=300.
    fig.save(f'../figuras/ndsc{NumDias}dias.png', dpi=300, bbox_inches='tight', pad_inches=0.1)
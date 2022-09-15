import numpy as np
import xarray as xr
import proplot as pplt
from cartopy.util import add_cyclic_point

# Autor: Lanzoerques Gomes da Silva Júnior
# lanzoerques@gmail.com

dsetlgm = xr.open_dataset('../dados/atva_media_anual_lgm_850.nc').squeeze()

lon_idxlgm = dsetlgm['vargh'].dims.index('lon')
dset_lgm, lon = add_cyclic_point(dsetlgm['vargh'], coord=dsetlgm['lon'], axis=lon_idxlgm)

lgm = (dsetlgm['vargh'])

fig, ax = pplt.subplots(axheight=3, tight=True, proj='spaeqd', facecolor='white')

ax.format(coast=True, borders=True, labels=True, fontsize=15)

ax.gridlines(color="black", linewidth=0.25, linestyle='--', xlocs=np.arange(-180, 180, 30), ylocs=np.arange(-90, 90, 30))

map1 = ax.contourf(lon, dsetlgm['lat'], dset_lgm, levels=pplt.arange(0, 7500, 750), extend='max', cmap='ylorbr')

ax.format(title='LGM')

fig.colorbar(map1, loc='b', label='(m$^2$)', shrink=1, ticklabelsize=14, labelsize=18)

fig.save('ex04.jpg', dpi=300)
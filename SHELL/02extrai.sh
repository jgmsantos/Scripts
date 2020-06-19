#/bin/bash

while read linha ; do
    lon=$(echo ${linha} | awk {'print $1'})
    lat=$(echo ${linha} | awk {'print $2'})
    id=$(echo ${linha} | awk {'print $3'} | awk '{printf("%.3d",$1)}')

    echo ${lat} ${lon} ${id}

    # Suas instruções...
done < lat_lon.txt


#!/bin/sh
file=isd-inventory.csv
if [ -f "$file" ]
then
    echo "Found $file" 1>&2
else
    echo "No $file. Downloading..." 1>&2
    curl ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-inventory.csv.z | zcat > $file
fi

cat $file | cut -d, -f1-3 | sed 's/"//g;s/,/-/g' | grep $1

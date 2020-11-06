#!/bin/bash
# data dictionary here:
# ftp://ftp.ncdc.noaa.gov/pub/data/noaa/ish-format-document.pdf

# first concatenate the passed ids into a regex
function join { local IFS="$1"; shift; echo "$*"; }

for var in "$@"
do
    IDS+="$var"
    IDS+="\|"
done
IDS=${IDS::-2}

echo 'date,source,temp,temp_quality'
zcat `find www -type f -not -empty | grep $1 | sort` | cut --output-delimiter=, -c 16-27,28,88-92,93

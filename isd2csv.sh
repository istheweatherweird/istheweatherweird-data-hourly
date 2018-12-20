#!/bin/bash
# data dictionary here:
# ftp://ftp.ncdc.noaa.gov/pub/data/noaa/ish-format-document.pdf
echo 'date,source,temp,temp_quality'
zcat `find www -type f -not -empty | grep $1 | sort` | cut --output-delimiter=, -c 16-27,28,88-92,93

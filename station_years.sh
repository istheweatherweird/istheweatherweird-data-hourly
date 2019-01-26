#!/bin/sh

# use awk so that we can repeat the year
cat isd-inventory.csv | cut -d, -f1-3 | sed 's/"//g;s/,/-/g' | grep $1

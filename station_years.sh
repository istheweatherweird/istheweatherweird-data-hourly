#!/bin/sh
file=www/isd-inventory.csv
if [[ ! -z "$1" ]]
  then
    cat $file | cut -d, -f1-3 | sed 's/"//g;s/,/-/' | grep $1 | cut -d, -f2
fi

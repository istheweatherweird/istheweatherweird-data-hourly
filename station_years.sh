#!/bin/sh
if [[ ! -z "$1" ]]
  then
    sed -nr 's/'$1'-([0-9]+).gz/\1/p' www/isd_inventory.txt
fi

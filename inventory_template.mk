# YEARS will get substituted by the master Makefile
YEARS := ${YEARS}

# sequence of all gz files
INVENTORIES = $(YEARS:%=www/inventories/%.txt)

$(INVENTORIES):
	curl -l ftp://ftp.ncdc.noaa.gov/pub/data/noaa/`basename $@ .txt`/ > $@

www/isd_inventory.txt: $(INVENTORIES)
	cat $^ > $@

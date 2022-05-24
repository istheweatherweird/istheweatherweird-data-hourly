# YEARS will get substituted by the master Makefile
YEARS := ${YEARS}

# sequence of all gz files
INVENTORIES = $(YEARS:%=www/inventories/%.txt)

$(INVENTORIES):
	curl -l ftp://ftp.ncdc.noaa.gov/pub/data/noaa/`basename $@ .txt`/ > $@

www/isd_inventory.txt: $(INVENTORIES)
	cat $^ > $@

# stations-in.csv is technically an input here in order to look up a potential station2
# but adding it would force rewriting the station makefiles after each station is added
# so if a station2 is added, its makefile will need to be explicitly rebuilt
$(MAKEFILES): template.mk www/isd_inventory.txt station_years.sh station2.py
	set -e; \
	export STATION=`basename $@ .mk`; \
	export YEARS=`./station_years.sh $$STATION | tr '\n' ' '`; \
	export STATION2=`python station2.py stations_in.csv $$STATION`; \
	export YEARS2=`./station_years.sh $$STATION2 | tr '\n' ' '`; \
	    cat $< | envsubst > $@

include $(MAKEFILES)

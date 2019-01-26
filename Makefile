STATIONS=724940-23234

$(shell mkdir -p www csv/$(STATIONS))

all: makefiles/$(STATIONS).mk $(STATIONS)

www/isd-inventory.csv:
	curl ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-inventory.csv > $@

makefiles/$(STATIONS).mk: template.mk www/isd-inventory.csv station_years.sh
	set -e; \
	export STATION=`basename $@ .mk`; \
	export YEARS=`./station_years.sh $$STATION | tr '\n' ' '`; \
	    cat $< | envsubst > $@

include makefiles/$(STATIONS).mk



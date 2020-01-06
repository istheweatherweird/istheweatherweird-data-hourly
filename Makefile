STATIONS=$(shell tail -n+2 stations_in.csv | cut -d, --output-delimiter='-' -f2,3)

$(shell mkdir -p www $(STATIONS:%=csv/%))

MAKEFILES=$(STATIONS:%=makefiles/%.mk)

all: $(MAKEFILES) $(STATIONS) csv/stations.csv

makefiles: $(MAKEFILES)

www/isd-inventory.csv:
	curl ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-inventory.csv > $@

www/isd-history.csv:
	curl ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv > $@

www/airports.dat:
	curl https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat > $@

csv/stations.csv: stations_out.py stations_in.csv www/isd-history.csv www/airports.dat
	python $^ > $@

# sequence of all day-of-year csv files                                                                                   
MONTHDAYS = $(shell python monthdays.py)

$(MAKEFILES): template.mk www/isd-inventory.csv station_years.sh
	set -e; \
	export STATION=`basename $@ .mk`; \
	export YEARS=`./station_years.sh $$STATION | tr '\n' ' '`; \
	    cat $< | envsubst > $@

include $(MAKEFILES)

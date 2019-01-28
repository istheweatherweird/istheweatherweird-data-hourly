STATIONS=724940-23234 725300-94846 723530-13967 744860-94789 726400-14839 725200-94823 724030-93738

$(shell mkdir -p www $(STATIONS:%=csv/%))

MAKEFILES=$(STATIONS:%=makefiles/%.mk)

all: $(MAKEFILES) $(STATIONS)

www/isd-inventory.csv:
	curl ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-inventory.csv > $@

# sequence of all day-of-year csv files                                                                                   
MONTHDAYS = $(shell python monthdays.py)

$(MAKEFILES): template.mk www/isd-inventory.csv station_years.sh
	set -e; \
	export STATION=`basename $@ .mk`; \
	export YEARS=`./station_years.sh $$STATION | tr '\n' ' '`; \
	    cat $< | envsubst > $@

include $(MAKEFILES)

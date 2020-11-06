# STATION and YEARS will get substituted by the master Makefile
STATION := ${STATION}
YEARS := ${YEARS}

# sequence of station-years, e.g. 724940-23234-1987
STATION_YEARS=$(YEARS:%=$(STATION)-%)

STATION2 := ${STATION2}
YEARS2 := ${YEARS2}
STATION_YEARS2=$(YEARS2:%=$(STATION2)-%)

# sequence of all gz files
GZS = $(STATION_YEARS:%=www/%.gz) $(STATION_YEARS2:%=www/%.gz)

# output csv files, one for each month-day
CSVS = $(MONTHDAYS:%=csv/$(STATION)/%.csv)

# use bash for the empty file check below
SHELL := /bin/bash
$(GZS):
	wget -nv -O $@ ftp://ftp.ncdc.noaa.gov/pub/data/noaa/`basename $@ .gz | cut -d- -f3`/$(@:www/%=%)
	[ -s $@ ] || { echo "wget wrote an empty file!"; exit 1; }

csv/$(STATION).csv: $(GZS) isd2csv.sh isd2csv.py
	./isd2csv.sh $$STATION $$STATION2 | python isd2csv.py > $@

$(CSVS): csv/$(STATION).csv isd2hourly.py
	# grep for header and matching dates
	grep '^\(date_hour\|[[:digit:]]\{4\}'`basename $@ .csv`'\)' $< | python isd2hourly.py > $@

# a phony target for this Makefile
$(STATION): $(CSVS) $(GZS) csv/$(STATION).csv

.PHONY: $(STATION)

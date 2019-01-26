# STATION and YEARS will get substituted by the master Makefile
STATION=${STATION}
YEARS=${YEARS}

# sequence of station-years, e.g. 724940-23234-1987
STATION_YEARS=$(YEARS:%=$(STATION)-%)

# sequence of all gz files
GZS = $(STATION_YEARS:%=www/%.gz)

# sequence of all day-of-year csv files
MONTHDAYS = $(shell python monthdays.py)
CSVS = $(MONTHDAYS:%=csv/$(STATION)/%.csv)

$(GZS):
	wget -nv -O $@ ftp://ftp.ncdc.noaa.gov/pub/data/noaa/$(@:www/$(STATION)-%.gz=%)/$(@:www/%=%)

csv/$(STATION).csv: $(GZS) isd2csv.sh isd2csv.py
	./isd2csv.sh $(STATION) | python isd2csv.py > $@

$(CSVS): csv/$(STATION).csv isd2hourly.py
	# grep for header and matching dates
	grep '^\(date_hour\|[[:digit:]]\{4\}'$(@:csv/$(STATION)/%.csv=%)'\)' $< | python isd2hourly.py > $@

# a phony target for this Makefile
$(STATION): $(CSVS) $(GZS) csv/$(STATION).csv

.PHONY: $(STATION)

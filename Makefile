#YEAR_MAX=2018

#ORD
#STATION=725300-94846
#YEAR_MIN=1946

# SFO
STATION=724940-23234
#YEAR_MIN=1973

# OKC
#STATION=723530-13967
#YEAR_MIN=1941

include default_profile
export

# sequence of all years
#YEARS=$(shell seq $(YEAR_MIN) $(YEAR_MAX))
STATION_YEARS=$(shell ./station_years.sh $(STATION))
$(info $(STATION_YEARS))

# sequence of all gz files
GZS = $(STATION_YEARS:%=www/%.gz)

# sequence of all day-of-year csv files
MONTHDAYS = $(shell python monthdays.py)
CSVS = $(MONTHDAYS:%=csv/$(STATION)/%.csv)

all: $(GZS) csv/$(STATION).csv $(CSVS)

$(GZS):
	mkdir -p `dirname $@`
	wget -nv -O www/`basename $@` ftp://ftp.ncdc.noaa.gov/pub/data/noaa/$(@:www/$(STATION)-%.gz=%)/$(@:www/%=%)

csv/$(STATION).csv: $(GZS) isd2csv.sh isd2csv.py
	mkdir csv
	./isd2csv.sh $(STATION) | python isd2csv.py > $@

$(CSVS): csv/$(STATION).csv isd2hourly.py
	mkdir -p `dirname $@`
	# grep for header and matching dates
	grep '^\(date_hour\|[[:digit:]]\{4\}'$(@:csv/$(STATION)/%.csv=%)'\)' $< | python isd2hourly.py > $@

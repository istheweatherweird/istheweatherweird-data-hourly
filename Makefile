STATION=724940-23234

# sequence of station-years, e.g. 724940-23234-1987, from the isd-inventory file
STATION_YEARS=$(shell ./station_years.sh $(STATION))
#$(info $(STATION_YEARS))

# sequence of all gz files
GZS = $(STATION_YEARS:%=www/%.gz)

# sequence of all day-of-year csv files
MONTHDAYS = $(shell python monthdays.py)
CSVS = $(MONTHDAYS:%=csv/$(STATION)/%.csv)

all: $(GZS) csv/$(STATION).csv $(CSVS)

$(GZS):
	mkdir -p www
	wget -nv -O www/`basename $@` ftp://ftp.ncdc.noaa.gov/pub/data/noaa/$(@:www/$(STATION)-%.gz=%)/$(@:www/%=%)

csv/$(STATION).csv: $(GZS) isd2csv.sh isd2csv.py
	mkdir -p csv
	./isd2csv.sh $(STATION) | python isd2csv.py > $@

$(CSVS): csv/$(STATION).csv isd2hourly.py
	mkdir -p `dirname $@`
	# grep for header and matching dates
	grep '^\(date_hour\|[[:digit:]]\{4\}'$(@:csv/$(STATION)/%.csv=%)'\)' $< | python isd2hourly.py > $@

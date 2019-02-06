# merge custom stations_in.csv with isd-history.csv from noaa ftp
import pandas as pd
import sys
import requests

stations_in = pd.read_csv(sys.argv[1], dtype='str')
isd_history = pd.read_csv(sys.argv[2], dtype='str')

stations = stations_in.merge(isd_history, on=['USAF','WBAN'])

STATION_URL = 'https://api.weather.gov/stations/'
for i, call in stations.ICAO.iteritems():
    response = requests.get(url=STATION_URL + call).json()
    stations.loc[i,'TZ'] = response['properties']['timeZone']

stations.to_csv(sys.stdout, index=False)


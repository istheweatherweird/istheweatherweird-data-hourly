# merge custom stations_in.csv with isd-history.csv from noaa ftp
import pandas as pd
import sys

stations_in = pd.read_csv(sys.argv[1], dtype='str')
isd_history = pd.read_csv(sys.argv[2], dtype='str')

stations_in.merge(isd_history, on=['USAF','WBAN']).to_csv(sys.stdout, index=False)


# print secondary identifier for station
import sys
import pandas as pd

stations = pd.read_csv(sys.argv[1], dtype=str)
if {'USAF2','WBAN2'}.issubset(stations.columns):
    id1 = sys.argv[2]
    USAF1, WBAN1 = id1.split('-')
    row = stations[(stations.USAF == USAF1) &
                   (stations.WBAN == WBAN1)].iloc[0]
    if pd.notnull(row.USAF2) & pd.notnull(row.WBAN2):
        print('%s-%s' % (row.USAF2, row.WBAN2))

import pandas as pd
import sys

df = pd.read_csv(sys.stdin, dtype=str)
df['dt'] = df.dt.astype(int)
df = df[df.temp != '+9999']

hourly = df.sort_values('dt').groupby('date_hour').temp.first().reset_index()

hourly['year'] = hourly.date_hour.str[:4]
hourly['hour'] = hourly.date_hour.str[8:10]

hourly[['year','hour','temp']].to_csv(sys.stdout, index=False)

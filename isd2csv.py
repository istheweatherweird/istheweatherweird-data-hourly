import pandas as pd
import sys

df = pd.read_csv(sys.stdin, dtype=str)
columns = list(df.columns)

date_format='%Y%m%d%H%M'
df['timestamp'] = pd.to_datetime(df.date, format=date_format, utc=True)

# nearest hour
df['date_hour'] = df.timestamp.dt.round('H')

# difference in minutes between date and nearest hour
df['dt'] = ((df.date_hour - df.timestamp) / pd.Timedelta(1, 'm')).astype(int)

# write with date_hour first, without timestamp
df[['date_hour', 'dt'] + columns].to_csv(sys.stdout, index=False, date_format=date_format)

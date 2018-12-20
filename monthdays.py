# print all monthdays (including 0229) separated by spaces
# 0101 0102 ...
from datetime import datetime, timedelta

t = datetime(2000,1,1)
t1 = datetime(2001,1,1)
dt = timedelta(days=1)

monthdays = []
while (t < t1):
    monthdays.append('%02g%02g' % (t.month, t.day))
    t = t + dt

print(str.join(' ', monthdays))

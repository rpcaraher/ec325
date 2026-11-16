NYC traffic speeds by zone, Oct 2019 - Aug 2025 (EC 325 Concept Check 10)
==========================================================================

File: zone_speeds.csv
One row = one zone in one month. 213 rows: 3 zones x 71 months.

Variables
---------
month      First day of the month (e.g., 2024-03-01)
year       Year
month_num  Month of the year, 1 (January) to 12 (December)
zone       "CBD"          the toll zone: Manhattan at and below 60th Street
           "CBD Adjacent" taxi zones near the toll zone: Manhattan from 60th
                          to about 125th Street, Roosevelt and Randalls
                          Islands, and nearby parts of Brooklyn and Queens
           "Greater NYC"  the rest of New York City
speed      Average traffic speed in the zone, in miles per hour

Source
------
MTA Open Data, "MTA Central Business District Taxi and For-Hire Vehicle
Speeds: Beginning October 2019" (data.ny.gov dataset 6p29-6xqn), collected
by the NYC Taxi and Limousine Commission. Downloaded Nov 16, 2026; August 2025
is the latest month available. Built by make_zone_speeds.R in this folder.

How speed is measured
---------------------
From the GPS tracks of taxis and ride-hail vehicles (Uber, Lyft): the miles
these vehicles drove in the zone while carrying passengers, divided by the
hours they spent driving in the zone. It measures how fast traffic moves.

Map
---
nyc_zones_map.png shows the three zones; make_zone_map.R builds it. Each zone
is a group of NYC Taxi and Limousine Commission taxi zones. The CBD zones come
from the MTA's "Central Business District Taxi Zones" dataset (yfdc-w5jh). The
MTA does not publish the list of CBD Adjacent zones; the 42 used here were
matched to the map in the MTA's documentation for the speeds dataset.

Notes
-----
- Congestion pricing began on January 5, 2025: most vehicles entering the CBD
  pay a toll ($9 for cars at peak hours). The FDR Drive and the West Side
  Highway are not tolled.
- January 2025 is counted as a toll month, although the toll started on the 5th.

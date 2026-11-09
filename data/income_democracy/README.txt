Income and Democracy, 1965-2015
===============================

Six files, one per decade: democracy_1965.csv, democracy_1975.csv,
democracy_1985.csv, democracy_1995.csv, democracy_2005.csv, democracy_2015.csv.
One row = one country in one year. 134 countries in all; 103 appear in all six
files. make_income_democracy.R (in this folder) rebuilds the files from the
sources below.

Variables
---------
country    Country name
iso3       Three-letter ISO country code
region     World Bank region
year       Year democracy is measured
democracy  V-Dem Electoral Democracy Index (v2x_polyarchy), multiplied by 100:
           0 = least democratic, 100 = most democratic
gdppc_lag  Real GDP per capita 5 years earlier, 2011 U.S. dollars
           (Maddison Project, rgdpnapc)
educ_lag   Average years of total schooling, ages 25 and older, 5 years
           earlier (Barro-Lee)

Income and schooling are measured 5 years before democracy: the 1995 file has
democracy in 1995 and income and schooling in 1990.

Sources
-------
- Democracy: Varieties of Democracy (V-Dem) project, Electoral Democracy Index,
  as distributed in the ccode_democracy data of the peacesciencer R package
  (version 1.2.0).
- Income: Maddison Project Database 2018 (Bolt, Inklaar, de Jong and van
  Zanden 2018), as distributed in the maddison R package (version 0.2).
- Schooling: Barro, Robert J. and Jong-Wha Lee (2013), "A New Data Set of
  Educational Attainment in the World, 1950-2010," Journal of Development
  Economics 104: 184-198. Indicator BAR.SCHL.25UP from the World Bank EdStats
  API.
- Region: World Bank regions, from the countrycode R package (version 1.9.0).

Coverage
--------
A country-year is included only when all three measures are available.
Countries that split or merged are included only when V-Dem and Maddison cover
the same territory:
- Russia appears from 1995 (V-Dem's Russia before 1992 is the USSR).
- Vietnam appears from 1985 (V-Dem's Vietnam before 1976 is North Vietnam).
- Pakistan appears from 1975 (V-Dem's Pakistan before 1972 includes today's
  Bangladesh, which Maddison reports separately).
- Germany appears from 1995 (West Germany has no matching code).
- Czechoslovakia, Yugoslavia, Serbia, and the two Yemens before unification
  are not included.

Values are rounded: democracy to 1 decimal, income to whole dollars, and
schooling to 2 decimals.

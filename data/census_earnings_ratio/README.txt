WOMEN'S EARNINGS AS A SHARE OF MEN'S, 1960-2025 (census_earnings_ratio)
=======================================================================

SOURCE
------
U.S. Census Bureau, "Income in the United States: 2025" (Current Population
Reports P60-289, September 2026), Table 12: "Number and Real Median Earnings
of Total Workers and Full-Time, Year-Round Workers With Earnings by Sex and
Female-to-Male Earnings Ratio: 1960 to 2025."
https://www2.census.gov/programs-surveys/demo/tables/p60/289/table12.xlsx

The estimates come from the Current Population Survey Annual Social and
Economic Supplement (CPS ASEC). This is one of the main sources of the widely
quoted "women earn X cents for every dollar men earn" statistic.

Read it from the course R Project with:

  ratio <- read_csv("data/census_earnings_ratio/census_earnings_ratio.csv")


STRUCTURE
---------
Unit of observation:  year
Rows:                 66 (1960-2025)
Columns:              4


VARIABLES
---------
year                   Calendar year the earnings were received
men_median_earnings    Median annual earnings of men who worked full-time,
                       year-round, in 2025 dollars
women_median_earnings  Median annual earnings of women who worked
                       full-time, year-round, in 2025 dollars
ratio                  Female-to-male earnings ratio, as published
                       (women_median_earnings / men_median_earnings)


NOTES AND CAVEATS
-----------------
- "Full-time, year-round" means working 35+ hours per week for 50+ weeks.
  Workers are 15 and older (14 and older before 1980). Before 1989,
  earnings are for civilian workers only.
- Dollar amounts were converted to 2025 dollars by the Census Bureau using
  the C-CPI-U (2000-2025) and the R-CPI-U-RS (before 2000).
- The survey changed over time (new questions, processing systems, and
  population controls), so small year-to-year changes should be read with
  care. For 2013 and 2017, Table 12 reports two estimates; this file keeps
  the one that is comparable with later years (2013: the redesigned income
  questions, ratio 0.776; 2017: the updated processing system, ratio 0.817).
  The other estimates are 0.783 (2013) and 0.805 (2017).
- These are ratios of medians of ANNUAL earnings. They differ from ratios of
  weekly or hourly pay (e.g., the Bureau of Labor Statistics' median weekly
  earnings series), from ratios of means, and from regression-adjusted gaps.


SUGGESTED CITATION
------------------
U.S. Census Bureau. 2026. Income in the United States: 2025. Current
Population Reports P60-289. Washington, DC: U.S. Government Publishing
Office.


USED IN
-------
Unit 7 slides (Dummy Variables and Non-Linear Models)

WAGES OF FULL-TIME WORKERS, AMERICAN COMMUNITY SURVEY 2024 (acs_wages)
=====================================================================

SOURCE
------
U.S. Census Bureau, American Community Survey (ACS), 2024 1-Year Public
Use Microdata Sample (PUMS), person files for the United States:
https://www2.census.gov/programs-surveys/acs/data/pums/2024/1-Year/csv_pus.zip

The ACS is the Census Bureau's largest household survey. The PUMS contains
individual survey responses (with identifying details removed).
acs_wages.csv is a random sample of 20,000 workers from the PUMS, built with
make_acs_wages.R (in this folder). Read it from the course R Project with:

  acs <- read_csv("data/acs_wages/acs_wages.csv")


STRUCTURE
---------
Unit of observation:  worker
Rows:                 20,000  (9,113 women and 10,887 men), in random order
Columns:              14
Survey year:          2024 (earnings are for the 12 months before the
                      interview, in 2024 dollars)


WHO IS IN THE SAMPLE
--------------------
Full-time, year-round wage and salary workers, ages 25 to 64:
  - civilian and employed at the time of the survey
  - an employee of a private company, a nonprofit, or a government
    (self-employed workers are excluded)
  - usually worked 35+ hours per week and 50+ weeks in the past year
  - positive wage and salary income
  - hourly wage of at least $5 (lower values are almost surely
    reporting errors)
  - wages, hours, and weeks were all reported by the respondent. When a
    person skips a question, the Census Bureau imputes (fills in) an
    answer; we drop anyone with an imputed wage, hours, or weeks value
    (about a quarter of full-time, year-round workers).

682,432 PUMS records meet these criteria. The 20,000 workers were drawn
from them with probability proportional to the ACS person weight (PWGTP).
Because of this, the sample is (approximately) "self-weighting": ordinary,
unweighted means and regressions on acs_wages.csv estimate the weighted
values for full-time, year-round workers whose wages, hours, and weeks were
reported. No weight variable is needed.

Dropping imputed records is common in wage research (imputed wages can
shrink measured gaps between groups), but it makes this population a
little different from all full-time, year-round workers. For example, the
gender gap in log wages is slightly larger here than when imputed records
are kept.


VARIABLES
---------
id          Row identifier (1 to 20,000)
state       State of residence (two-letter abbreviation; includes DC)
age         Age in years (25-64)
sex         "Female" or "Male"
race_eth    Race/ethnicity, five mutually exclusive groups:
              "Hispanic"  Hispanic or Latino, of any race
              "White"     White alone, not Hispanic
              "Black"     Black or African American alone, not Hispanic
              "Asian"     Asian alone, not Hispanic
              "Other"     all other non-Hispanic workers (American Indian or
                          Alaska Native, Native Hawaiian or Pacific Islander,
                          some other race, or two or more races)
married     1 = currently married, 0 = otherwise
educ        Years of schooling, converted from the highest degree or grade
            completed: no schooling, nursery school, or kindergarten = 0;
            grades 1-11 = 1-11; 12th grade with no diploma = 11; high
            school diploma or GED = 12; some college, less than 1 year =
            12; 1+ years of college, no degree = 13; associate's = 14;
            bachelor's = 16; master's = 18; professional degree (JD, MD,
            ...) = 19; doctorate = 20
degree      Highest degree: "Less than HS", "HS diploma" (includes GED),
            "Some college" (no degree), "Associate", "Bachelor's",
            "Graduate" (master's, professional, or doctorate)
exper       Potential experience in years = age - educ - 6 (set to 0 if
            negative). The ACS does not ask about work history, so this
            counts the years since a person (would have) left school.
hours       Usual hours worked per week in the past 12 months (35-99;
            99 means 99 or more)
weeks       Weeks worked in the past 12 months (50-52)
earnings    Annual wage and salary income in the past 12 months, in 2024
            dollars (rounded to the dollar)
wage        Hourly wage in 2024 dollars = earnings / (hours x weeks),
            rounded to the cent. It was computed before earnings were
            rounded, so recomputing it from the rounded earnings can differ
            by a cent.
occ_group   Occupation group: the 22 civilian major groups of the 2018
            Standard Occupational Classification (e.g., "Management",
            "Sales", "Healthcare Practitioners")


NOTES AND CAVEATS
-----------------
- Hourly wages are computed, not reported: they divide annual earnings by
  usual weekly hours times weeks worked, so they contain some reporting
  error in all three pieces.
- Very high earnings are top-coded in the public file: above a state-level
  cutoff, the Census Bureau replaces a person's earnings with the average
  for all top-coded workers in that state.
- Potential experience overstates actual experience for anyone who spent
  time out of the labor force, which is more common for women than men.
  Data sets with actual work histories (e.g., the PSID) avoid this problem.
- The ACS also surveys people living in group quarters (e.g., dorms or
  barracks); the few who meet the criteria above are included.
- Results will differ from published statistics that use other data or
  definitions. For example, the Census Bureau's widely cited
  female-to-male earnings ratio comes from a different survey (the Current
  Population Survey) and compares median annual earnings of full-time,
  year-round workers aged 15 and older.


SUGGESTED CITATION
------------------
U.S. Census Bureau. 2025. American Community Survey 2024 1-Year Public Use
Microdata Sample. https://www.census.gov/programs-surveys/acs/microdata.html


USED IN
-------
Unit 7 slides (Dummy Variables and Non-Linear Models)

VOTING AND CLOSE RACES, 2024 (voting_2024)
=====================================================================

This folder holds two files that are meant to be joined:

  citizens.csv       A sample of adult U.S. citizens from the November 2024
                     Current Population Survey
  state_margins.csv  How close the 2024 presidential race was in each state

Read them from the course R Project with:

  citizens      <- read_csv("data/voting_2024/citizens.csv")
  state_margins <- read_csv("data/voting_2024/state_margins.csv")


citizens.csv
---------------------------------------------------------------------

SOURCE
U.S. Census Bureau and Bureau of Labor Statistics, Current Population Survey
(CPS), November 2024 Voting and Registration Supplement:
https://www2.census.gov/programs-surveys/cps/datasets/2024/supp/nov24pub.csv

The CPS is the monthly government household survey behind the national
unemployment rate. In November of election years, it also asks adult U.S.
citizens whether they voted. Voting is reported by the person or by another
household member answering for them, and is not checked against voting records.

WHO IS IN THE SAMPLE
U.S. citizens ages 18 and up in the 50 states and DC, excluding Armed Forces
members, who have no CPS weight.

72,590 CPS records meet these criteria. The 20,000 people in citizens.csv were
drawn from them with probability proportional to the CPS weight (PWSSWGT).
Because of this, the sample is (approximately) "self-weighting": ordinary,
unweighted means and regressions on citizens.csv estimate the weighted values
for these adults. No weight variable is needed.

As a check, the weighted figures for the 72,590 records match the Census
Bureau's published Table 4a for November 2024: 236.1 million adult citizens,
154.3 million voters, and 65.3% turnout. All 51 state turnout rates match the
published rates to the 0.1 shown in the table.

VARIABLES
id        Row identifier (1 to 20,000)
state     State (two-letter abbreviation; includes DC)
age       Age in years (18-85; 80 means 80-84 and 85 means 85 or older)
college   = 1 if the person has a bachelor's degree or more, 0 otherwise
voted     = 1 if the person was reported as voting in the November 5, 2024
          election, 0 otherwise. As in the Census Bureau's tables, anyone who did not
          answer "yes" counts as 0 (this includes "no," "don't know," refused,
          and no response).


state_margins.csv
---------------------------------------------------------------------

SOURCE
Federal Election Commission, Official 2024 Presidential General Election
Results (January 16, 2025):
https://www.fec.gov/resources/cms-content/documents/2024presgeresults.xlsx

VARIABLES
state       State (two-letter abbreviation; includes DC)
state_name  State name
margin      The gap between the top two candidates (Donald Trump and Kamala
            Harris) in the state, as a percentage of all votes cast for
            president in the state, in percentage points. It has no sign: it
            says how close the race was, not who won.


BUILDING THE FILES
---------------------------------------------------------------------
make_voting_2024.R (in this folder) builds both files. The raw files are not
included in the repo.

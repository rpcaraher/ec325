ALLEGRETTO, DUBE, REICH, AND ZIPPERER (2017)
COUNTY-PAIR MINIMUM WAGE DATA
==============================================

SOURCE
------
Allegretto, S., Dube, A., Reich, M., and Zipperer, B. 2017. "Credible
Research Designs for Minimum Wage Studies: A Response to Neumark, Salas,
and Wascher." ILR Review 70(3): 559-592.

The authors extend the Card and Krueger (1994) cross-border comparison
between New Jersey and Pennsylvania to ALL contiguous county pairs in
the continental US that are separated by a state border. For each such
county pair, counties in states that did not raise their minimum wage
at a given time serve as the control for counties in states that did.

The dataset combines the Quarterly Census of Employment and Wages
(QCEW) restaurant-sector series (NAICS 722) with a panel of state-level
minimum wages (1990-2014). The version in this folder (ardz.csv) has
been pre-processed so that it is ready to be used directly in feols()
for the paper's main two-way fixed effects specification.


STRUCTURE
---------
Unit of observation:        county x year-quarter x county-pair
Rows:                       120,900
Unique counties:            568  (all border counties)
Time span:                  1990 Q1 - 2014 Q4  (100 year-quarters)
County-pair x year-quarter: 85,600 unique combinations

"Stacked" panel: a single county can appear in multiple rows within the
same year-quarter because it has more than one cross-border neighbor.
This is the standard Dube-Lester-Reich county-pair design: each border
pair is its own DiD "experiment," and counties are replicated as needed.


VARIABLES
---------
county_fips            integer    5-digit county FIPS code (panel unit ID).
year                   integer    Calendar year, 1990-2014.
quarter                integer    Calendar quarter, 1-4.
yr_qtr                 numeric    Year-quarter as a decimal
                                  (e.g., 2005.3 = Q3 of 2005). Use this
                                  as the TIME fixed effect.
county_pair_fips       character  Identifier for a unique cross-border
                                  county pair, formatted "fipsA-fipsB"
                                  where A and B are neighboring counties.
county_pair_fips_date  character  Identifier for a unique county-pair
                                  x year-quarter cell, formatted
                                  "fipsA-fipsB:yr_qtr". Use this as the
                                  county-pair x time fixed effect
                                  (gamma_pt in the paper).
logemp                 numeric    log of quarterly employment in the
                                  county's restaurant sector (NAICS 722).
logearn                numeric    log of average quarterly earnings per
                                  worker in the county's restaurant
                                  sector.
mw                     numeric    Effective minimum wage in the county's
                                  state for that quarter (the larger of
                                  the federal and state minimum, in
                                  nominal dollars).
logmw                  numeric    Natural log of mw.
logpop                 numeric    log of total county population (control
                                  variable).
logemp_private         numeric    log of total private-sector employment
                                  in the county (control variable).
mw_change              0/1        Treatment indicator: equals 1 if the
                                  county is in a state that raised its
                                  minimum wage in (or at any time before)
                                  quarter t, relative to the start of
                                  the sample. This is the main
                                  right-hand-side regressor of interest.


THE PREFERRED SPECIFICATION
---------------------------
The "credible" DiD specification in Allegretto et al. (2017) is:

    y_it = b1 * mw_change_it + b2 * logpop_it + b3 * logemp_private_it
           + alpha_i + tau_t + gamma_pt + mu_it

where alpha_i is a county FE (county_fips), tau_t is a year-quarter FE
(yr_qtr), and gamma_pt is a county-pair x year-quarter FE
(county_pair_fips_date). The gamma_pt term is what makes this design
"local" -- it forces the identifying variation to come only from
within-pair, within-quarter comparisons of neighboring counties that
happen to straddle a state border.

In R with fixest:

    feols(logemp ~ mw_change + logpop + logemp_private |
            county_fips + yr_qtr + county_pair_fips_date,
          vcov = "HC1",
          data = ardz)


NOTES AND CAVEATS
-----------------
- Because the same county is repeated across its several border pairs,
  a plain heteroskedasticity-robust standard error understates the true
  variability. The published paper clusters standard errors two-way on
  both state and border segment; for pedagogical purposes the problem
  set uses vcov = "HC1", which gives estimates that are close to but
  not identical to those in the published tables.
- This panel only contains border counties. Non-border counties have
  been dropped by construction.
- mw_change is the authors' treatment indicator and does NOT vary
  within a county-quarter; it is a function of the state the county
  sits in.


SUGGESTED CITATION
------------------
If you use this data in coursework or research, please cite the
original Allegretto, Dube, Reich, and Zipperer (2017) paper.

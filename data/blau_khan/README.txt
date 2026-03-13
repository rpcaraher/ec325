README: blau_khan_psid.csv
==========================

Overview
--------
This dataset contains individual-level data from the Panel Study of Income
Dynamics (PSID), constructed to replicate the analysis in:

  Blau, F.D. and Kahn, L.M. 2017. "The Gender Wage Gap: Extent, Trends,
  and Explanations." Journal of Economic Literature 55(3): 789-865.

The sample includes 27,848 observations of full-time workers across six
survey waves spanning 1981 to 2011. It is used in EC 325 (Econometrics)
at Colby College for Problem Set 2.


Variables
---------

Identifiers and Weights
  wave        Survey wave year (1981, 1990, 1999, 2007, 2009, 2011)
  wght        PSID sampling weight (range: 0-168)

Outcome
  lnwage      Natural log of hourly wage (range: 0.72-6.42)

Demographics
  sex         Sex of respondent ("male", "female")
  racehisp    Race/ethnicity ("whitenh", "blacknh", "hisp", "othernh")
  region      Census region ("northeast", "midwest", "south", "west")
  msa         Lives in a Metropolitan Statistical Area (1 = yes, 0 = no)

Human Capital
  edyrs       Years of education (0-18)
  colldeg     Has a college degree (1 = yes, 0 = no)
  advdeg      Has an advanced degree (1 = yes, 0 = no)
  expf        Years of full-time work experience (0-46)
  expfsq      Full-time experience squared
  expp        Years of part-time work experience (0-40)
  exppsq      Part-time experience squared

Job Characteristics
  union       Covered by a union contract (1 = yes, 0 = no)
  govt        Employed in government sector (1 = yes, 0 = no)
  ind         Industry category (15 categories; see below)
  occ         Occupation category (21 categories; see below)

Occupation Summary Indicators
  mgrocc      Managerial occupation (1 = yes, 0 = no)
  profocc     Professional occupation (1 = yes, 0 = no)
  maleprofaer Male-dominated professional occupation (1 = yes, 0 = no)


Industry Categories (ind)
-------------------------
admin, communications, durables, education, enterntainment, finance,
hospitality, medical, miningconstruction, nondurables, professional,
retail, transport, utilities, wholesale


Occupation Categories (occ)
---------------------------
admin, architect, artist, building, business, construct, financial,
foodcare, healthcare, healthsupport, lawyer, legaleduc, managerial,
postsecondaryeduc, production, sales, scientist, security, socialworker,
tech, transport


Notes
-----
- The "wave" variable refers to the PSID survey year. Because the PSID
  collects earnings from the prior year, the 1981 wave reflects 1980
  earnings, the 2011 wave reflects 2010 earnings, and so on.
- "enterntainment" appears to be a typo for "entertainment" in the
  original data; it has been left as-is for consistency.
- Some observations have missing values (coded as NA) for the govt
  variable.
- The squared experience terms (expfsq, exppsq) are pre-computed and
  included in the dataset for convenience.

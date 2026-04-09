CARD & KRUEGER (1994) -- NJ/PA FAST-FOOD DATA
==============================================

SOURCE
------
Card, D. and Krueger, A.B. 1994. "Minimum Wages and Employment: A Case
Study of the Fast-Food Industry in New Jersey and Pennsylvania." American
Economic Review 84(4): 772-793.

The original data were collected by telephone surveys of 410 fast-food
restaurants (Burger King, KFC, Roy Rogers, and Wendy's) in New Jersey and
eastern Pennsylvania. Wave 1 was conducted in February-March 1992, before
New Jersey's April 1, 1992 increase in its minimum wage from $4.25 to
$5.05; Wave 2 was conducted in November-December 1992, after the increase.
Restaurants in eastern Pennsylvania serve as the control group.

The version in this folder (ck_1994.csv) has been lightly reshaped into
LONG format so that each restaurant contributes two rows (one pre, one
post).


STRUCTURE
---------
Unit of observation: restaurant x survey wave
Panel structure:     short (T = 2) panel, indexed by rest_id and period
Rows:                820
Unique restaurants:  409 (one restaurant is missing a second-wave record)
Treatment group:     restaurants in New Jersey  (state == "NJ")
Control group:       restaurants in eastern PA  (state == "PA")
Pre period:          Feb-Mar 1992  (period == "pre",  post == 0, time == 1)
Post period:         Nov-Dec 1992  (period == "post", post == 1, time == 2)


VARIABLES
---------
rest_id    integer    Unique restaurant identifier (panel unit ID).
chain      character  Fast-food chain: BK, KFC, ROYS, WENDYS.
state      character  NJ (treated) or PA (control).
southj     0/1        1 if restaurant is in southern New Jersey.
centralj   0/1        1 if restaurant is in central New Jersey.
shore      0/1        1 if restaurant is on the NJ shore.
pa1        0/1        1 if restaurant is in PA region 1 (easternmost).
pa2        0/1        1 if restaurant is in PA region 2.
period     character  "pre" or "post".
empft      numeric    Number of full-time employees (>= 35 hours/week).
emppt      numeric    Number of part-time employees.
nmgrs      numeric    Number of managers/assistant managers.
stwage     numeric    Starting hourly wage at the restaurant (US dollars).
pentree    numeric    Price of an entree (US dollars).
fte        numeric    Full-time-equivalent employment:
                        empft + nmgrs + 0.5 * emppt.
                      This is the main outcome variable in Card and
                      Krueger (1994), Table 3.
time       integer    Wave indicator: 1 = pre, 2 = post.
post       0/1        Dummy = 1 for post period, 0 for pre.
treated    0/1        Dummy = 1 for NJ restaurants, 0 for PA.


NOTES AND CAVEATS
-----------------
- A small number of restaurants have missing values for fte (closed or
  refused to answer in the second wave). Use na.rm = TRUE when computing
  means, and note that feols() will automatically drop rows with NA on
  the left-hand side.
- stwage is also missing for some observations in both waves.
- To construct the treatment indicator for a DiD regression "by hand,"
  create treat_post = treated * post, or equivalently use
  case_when(state == "NJ" & period == "post" ~ 1, TRUE ~ 0).
- Because each restaurant is observed twice, you can also estimate the
  DiD via a two-way fixed effects regression with rest_id and post (or
  time) as fixed effects.


SUGGESTED CITATION
------------------
If you use this data in coursework or research, please cite the original
Card and Krueger (1994) paper.

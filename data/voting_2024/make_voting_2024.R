# =============================================================================
# make_voting_2024.R
# Builds the two EC 325 Concept Check 8 data files:
#   citizens.csv       a sample of 20,000 adult citizens from the November 2024 CPS
#   state_margins.csv  the margin in each state's 2024 presidential race
#
# Raw data (NOT included in the repo):
#   1. CPS November 2024 Voting and Registration Supplement (about 150 MB):
#      https://www2.census.gov/programs-surveys/cps/datasets/2024/supp/nov24pub.csv
#   2. FEC official 2024 presidential general election results:
#      https://www.fec.gov/resources/cms-content/documents/2024presgeresults.xlsx
# See README.txt for details.
# =============================================================================

library(tidyverse)
library(readxl)
# data.table::fread() reads only the columns we need; this file has about 400 columns.

cps_file <- "nov24pub.csv"
fec_file <- "2024presgeresults.xlsx"

vars <- c("GESTFIPS", "PRTAGE", "PRCITSHP", "PEEDUCA", "PES1", "PWSSWGT")

# Column names in the CSV are a mix of upper and lower case, so match on upper case.
header <- names(data.table::fread(cps_file, nrows = 0))
cps <- data.table::fread(cps_file, select = header[toupper(header) %in% vars])
cps <- as_tibble(setNames(cps, toupper(names(cps))))

state_key <- tibble(GESTFIPS = c(1, 2, 4:6, 8:13, 15:42, 44:51, 53:56),
                    state = c(state.abb[1:8], "DC", state.abb[9:50]),
                    state_name = c(state.name[1:8], "District of Columbia",
                                   state.name[9:50]))

# ---- 1. Sample: U.S. citizens ages 18 and up ------------------------------------
# These are the people eligible to be asked whether they voted. As in the Census Bureau's own
# tables, anyone who didn't answer "yes" counts as not having voted (this includes
# "no," "don't know," refused, and no response).
universe <- cps |>
  filter(PRTAGE >= 18,
         PRCITSHP %in% 1:4,                  # 5 = not a citizen
         PWSSWGT > 0) |>
  left_join(state_key, by = "GESTFIPS") |>
  mutate(age     = PRTAGE,
         college = as.integer(PEEDUCA >= 43),  # bachelor's degree or more
         voted   = as.integer(PES1 == 1))

# ---- 2. Draw 20,000 people with probability proportional to the CPS weight ------
# As in acs_wages, this makes the extract (approximately) self-weighting: plain,
# unweighted statistics on citizens.csv estimate the population values.
set.seed(325)
draw <- sample.int(nrow(universe), size = 20000, prob = universe$PWSSWGT)

citizens <- universe[draw, ] |>
  mutate(id = row_number()) |>
  select(id, state, age, college, voted)

write_csv(citizens, "citizens.csv")

# ---- 3. Margin in each state's presidential race --------------------------------
# margin = the gap between Trump and Harris as a percent of all votes cast in the
# state. It has no sign: it says how close the race was, not who won.
fec <- read_excel(fec_file)

state_margins <- fec |>
  transmute(state = STATE,
            harris = as.numeric(HARRIS),
            trump  = as.numeric(TRUMP),
            total  = as.numeric(`TOTAL VOTES`)) |>
  filter(state %in% state_key$state) |>
  mutate(margin = round(100 * abs(trump - harris) / total, 2)) |>
  left_join(select(state_key, state, state_name), by = "state") |>
  select(state, state_name, margin)

write_csv(state_margins, "state_margins.csv")

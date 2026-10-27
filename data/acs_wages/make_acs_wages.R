# =============================================================================
# make_acs_wages.R
# Builds acs_wages.csv (EC 325) from the 2024 ACS 1-year PUMS person files.
#
# Raw data (about 600 MB zipped, 2.4 GB unzipped; NOT included in the repo):
#   https://www2.census.gov/programs-surveys/acs/data/pums/2024/1-Year/csv_pus.zip
# The zip has no top-level folder, so unzip it into one:
#   unzip csv_pus.zip -d csv_pus
# and point `pums_dir` at that folder (it holds psam_pusa.csv and psam_pusb.csv).
# See README.txt for details.
# =============================================================================

library(tidyverse)
# data.table::fread() reads only the columns we need; read_csv() can run out
# of memory on files this wide (the PUMS person files have ~290 columns).

pums_dir <- "csv_pus"   # folder with psam_pusa.csv and psam_pusb.csv

vars <- c("SERIALNO", "SPORDER", "STATE", "ADJINC", "PWGTP", "AGEP", "COW",
          "MAR", "SCHL", "SEX", "WAGP", "WKHP", "WKWN", "ESR", "HISP", "RAC1P",
          "SOCP", "FWAGP", "FWKHP", "FWKWNP")

pums <- map(c("psam_pusa.csv", "psam_pusb.csv"), \(f)
  data.table::fread(file.path(pums_dir, f), select = vars,
                    colClasses = list(character = c("SERIALNO", "SOCP")))) |>
  data.table::rbindlist() |>
  as_tibble() |>
  mutate(across(-c(SERIALNO, SOCP), as.numeric))

# ---- 1. Sample: full-time, year-round wage and salary workers, ages 25-64 ----
universe <- pums |>
  filter(between(AGEP, 25, 64),            # prime working ages
         COW %in% 1:5,                     # employees: private, nonprofit, government
         ESR %in% 1:2,                     # civilian employed
         WKHP >= 35, WKWN >= 50,           # full-time (35+ hrs/wk), year-round (50+ wks)
         WAGP > 0,                         # positive wage and salary income
         FWAGP == 0, FWKHP == 0, FWKWNP == 0) |>  # drop imputed wages, hours, or weeks
  mutate(earnings = WAGP * ADJINC / 1e6,   # 2024 dollars
         wage     = earnings / (WKHP * WKWN)) |>
  filter(wage >= 5)                        # drop implausibly low hourly wages

# ---- 2. Variables ------------------------------------------------------------
years_school <- c(0, 0, 0, 1:11, 11, 12, 12, 12, 13, 14, 16, 18, 19, 20)  # SCHL = 1..24

soc_major <- c(
  "11" = "Management",                  "13" = "Business & Financial",
  "15" = "Computer & Math",             "17" = "Architecture & Engineering",
  "19" = "Life, Physical & Social Science", "21" = "Community & Social Service",
  "23" = "Legal",                       "25" = "Education & Library",
  "27" = "Arts, Media & Sports",        "29" = "Healthcare Practitioners",
  "31" = "Healthcare Support",          "33" = "Protective Service",
  "35" = "Food Preparation & Serving",  "37" = "Building & Grounds",
  "39" = "Personal Care & Service",     "41" = "Sales",
  "43" = "Office & Admin Support",      "45" = "Farming, Fishing & Forestry",
  "47" = "Construction & Extraction",   "49" = "Installation & Repair",
  "51" = "Production",                  "53" = "Transportation & Moving")

state_abb <- tibble(STATE = c(1, 2, 4:6, 8:13, 15:42, 44:51, 53:56),
                    state = c(state.abb[1:8], "DC", state.abb[9:50])) # FIPS -> USPS

universe <- universe |>
  left_join(state_abb, by = "STATE") |>
  mutate(
    sex      = if_else(SEX == 2, "Female", "Male"),
    race_eth = case_when(HISP != 1  ~ "Hispanic",   # Hispanic of any race
                         RAC1P == 1 ~ "White",      # the rest are non-Hispanic
                         RAC1P == 2 ~ "Black",
                         RAC1P == 6 ~ "Asian",
                         .default   = "Other"),
    married  = as.integer(MAR == 1),
    educ     = years_school[SCHL],
    degree   = case_when(SCHL <= 15 ~ "Less than HS",
                         SCHL <= 17 ~ "HS diploma",
                         SCHL <= 19 ~ "Some college",
                         SCHL == 20 ~ "Associate",
                         SCHL == 21 ~ "Bachelor's",
                         SCHL >= 22 ~ "Graduate"),
    exper    = pmax(AGEP - educ - 6, 0),        # potential experience
    occ_group = unname(soc_major[str_sub(SOCP, 1, 2)])
  )

# ---- 3. Draw 20,000 workers with probability proportional to the ACS weight --
# Sampling proportional to PWGTP makes the extract (approximately) self-weighting:
# plain, unweighted statistics on acs_wages.csv estimate the weighted values for
# the population defined in step 1. Rows stay in the (random) order they were drawn.
set.seed(325)
draw <- sample.int(nrow(universe), size = 20000, prob = universe$PWGTP)

acs_wages <- universe[draw, ] |>
  mutate(id = row_number(),
         earnings = round(earnings),
         wage = round(wage, 2)) |>
  select(id, state, age = AGEP, sex, race_eth, married, educ, degree, exper,
         hours = WKHP, weeks = WKWN, earnings, wage, occ_group)

write_csv(acs_wages, "acs_wages.csv")

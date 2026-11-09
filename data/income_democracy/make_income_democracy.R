# =============================================================================
# make_income_democracy.R
# Builds the income and democracy panel for the EC 325 panel data concept check.
#
# One file per decade, 1965-2015: democracy_1965.csv, ..., democracy_2015.csv.
# One row = one country in one year.
#
# Sources
# - Democracy: V-Dem Electoral Democracy Index (v2x_polyarchy), as distributed in
#   the `ccode_democracy` data of the peacesciencer R package.
# - Income: real GDP per capita (rgdpnapc, 2011 US dollars) from the Maddison
#   Project Database 2018, as distributed in the maddison R package.
# - Schooling: Barro-Lee average years of total schooling, ages 25+
#   (BAR.SCHL.25UP), World Bank EdStats API.
# - Region: World Bank region, from the countrycode R package.
#
# Income and schooling are measured 5 years before democracy (e.g., the 1995
# file has democracy in 1995 and income and schooling in 1990).
# =============================================================================

library(tidyverse)
library(countrycode)
library(jsonlite)

years <- seq(1965, 2015, by = 10)

# --- Democracy (V-Dem), by Correlates of War country code -------------------
data("ccode_democracy", package = "peacesciencer")

democracy <- ccode_democracy |>
  filter(year %in% years, !is.na(v2x_polyarchy)) |>
  mutate(iso3 = countrycode(ccode, "cown", "iso3c", warn = FALSE)) |>
  filter(!is.na(iso3)) |>
  # Keep a country only when V-Dem and Maddison cover the same territory:
  # V-Dem's Russia before 1992 is the USSR, its Vietnam before 1976 is North
  # Vietnam, and its Pakistan before 1972 includes today's Bangladesh, which
  # Maddison reports separately. (West Germany, Czechoslovakia, Yugoslavia/
  # Serbia and the two Yemens before 1990 have no matching code and drop out
  # above.)
  filter(!(iso3 == "RUS" & year < 1992),
         !(iso3 == "VNM" & year < 1976),
         !(iso3 == "PAK" & year < 1972)) |>
  transmute(iso3, year, democracy = 100 * v2x_polyarchy)

# --- Real GDP per capita (Maddison), 5 years earlier --------------------------
# Match on Maddison's own country code: the package also labels the former
# USSR aggregate (code SUN) with Russia's ISO code, so we drop rows where the
# two codes differ (SUN, Czechoslovakia and Yugoslavia).
income <- maddison::maddison |>
  filter(countrycode == iso3c, year %in% (years - 5), !is.na(rgdpnapc)) |>
  transmute(iso3 = iso3c, year = year + 5, gdppc_lag = rgdpnapc)

# --- Years of schooling (Barro-Lee), 5 years earlier --------------------------
bl_url <- paste0("https://api.worldbank.org/v2/country/all/indicator/BAR.SCHL.25UP",
                 "?source=12&format=json&per_page=20000&date=1960:2010")
schooling <- fromJSON(bl_url)[[2]] |>
  transmute(iso3 = countryiso3code, year = as.numeric(date) + 5, educ_lag = value) |>
  filter(year %in% years, !is.na(educ_lag), iso3 != "")

# --- Combine: keep country-years with all three measures ----------------------
panel <- democracy |>
  inner_join(income, by = c("iso3", "year")) |>
  inner_join(schooling, by = c("iso3", "year")) |>
  mutate(country = countrycode(iso3, "iso3c", "country.name"),
         region  = countrycode(iso3, "iso3c", "region"),
         democracy = round(democracy, 1),
         gdppc_lag = round(gdppc_lag),
         educ_lag  = round(educ_lag, 2)) |>
  filter(!is.na(region)) |>
  select(country, iso3, region, year, democracy, gdppc_lag, educ_lag) |>
  arrange(year, country)

stopifnot(!anyDuplicated(panel[c("iso3", "year")]))

# --- Write one file per year ---------------------------------------------------
for (y in years) {
  write_csv(filter(panel, year == y), paste0("democracy_", y, ".csv"))
}

# =============================================================================
# Builds zone_speeds.csv for EC 325 Concept Check 10 (Difference-in-Differences)
# Source: MTA Open Data, "MTA Central Business District Taxi and For-Hire Vehicle
#   Speeds: Beginning October 2019" (data.ny.gov dataset 6p29-6xqn)
#   https://data.ny.gov/Transportation/MTA-Central-Business-District-Taxi-and-For-Hire-Ve/6p29-6xqn
# Downloaded Nov 16, 2026 (latest month available: August 2025)
# One row = one zone in one month
# =============================================================================

library(tidyverse)

url <- "https://data.ny.gov/resource/6p29-6xqn.csv?$limit=5000"
raw <- read_csv(url, show_col_types = FALSE)

zone_speeds <- raw |>
  transmute(
    month     = as.Date(month),
    year      = as.integer(format(month, "%Y")),
    month_num = as.integer(format(month, "%m")),
    zone,
    speed     = zonal_speed
  ) |>
  arrange(zone, month)

# Checks: 3 zones, every month from Oct 2019 to Aug 2025, one row per zone-month
stopifnot(
  setequal(unique(zone_speeds$zone), c("CBD", "CBD Adjacent", "Greater NYC")),
  min(zone_speeds$month) == as.Date("2019-10-01"),
  max(zone_speeds$month) == as.Date("2025-08-01"),
  nrow(zone_speeds) == 3 * 71,
  nrow(distinct(zone_speeds, zone, month)) == nrow(zone_speeds),
  !anyNA(zone_speeds$speed)
)

write_csv(zone_speeds, "data/congestion_pricing/zone_speeds.csv")

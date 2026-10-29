# =============================================================================
# make_movies.R
# Builds movies.csv (EC 325) from the TidyTuesday "Horror Movies and Profit"
# data (week of 2018-10-23), which come from the-numbers.com.
# Run from this folder; it downloads the raw file (about 300 KB).
# See README.txt for details.
# =============================================================================

library(tidyverse)

url <- paste0("https://raw.githubusercontent.com/rfordatascience/tidytuesday/",
              "master/data/2018/2018-10-23/movie_profit.csv")

raw <- read_csv(url, col_select = -1,    # drop the unnamed row-number column
                name_repair = "unique_quiet", show_col_types = FALSE)

movies <- raw |>
  distinct() |>                          # the raw file repeats one row exactly
  mutate(release_date    = mdy(release_date),
         year            = year(release_date),
         budget          = production_budget / 1e6,   # $ millions
         domestic_gross  = domestic_gross / 1e6,      # $ millions
         worldwide_gross = worldwide_gross / 1e6) |>  # $ millions
  filter(year >= 2000,                   # films released 2000-2018
         worldwide_gross > 0) |>         # drop films with no recorded gross
  mutate(roi = worldwide_gross / budget) |>
  select(movie, release_date, year, genre, mpaa_rating, distributor,
         budget, domestic_gross, worldwide_gross, roi) |>
  arrange(release_date, movie)

write_csv(movies, "movies.csv")

MOVIE BUDGETS AND BOX-OFFICE GROSSES, 2000-2018 (movies)
========================================================

SOURCE
------
The Numbers (https://www.the-numbers.com/), as compiled for the TidyTuesday
project, week of 2018-10-23 ("Horror Movies and Profit"):
https://github.com/rfordatascience/tidytuesday/tree/master/data/2018/2018-10-23

TidyTuesday paired the data with FiveThirtyEight's article "Scary Movies Are
The Best Investment In Hollywood" (Walt Hickey). The article's own analysis
used a different data set, so its numbers will not match ours exactly.

movies.csv is built from the raw TidyTuesday file (movie_profit.csv) with
make_movies.R (in this folder). Read it from the course R Project with:

  movies <- read_csv("data/movies/movies.csv")


STRUCTURE
---------
Unit of observation:  film
Rows:                 2,435
Columns:              10
Years:                released 2000 to 2018


WHO IS IN THE SAMPLE
--------------------
Films in the raw file that were:
  - released in 2000 or later (the raw file covers 1936-2019)
  - recorded with a worldwide gross above zero (32 films released since 2000
    have a gross of $0 and are dropped)
The raw file repeats one row exactly; the duplicate is dropped.

Every film has one of five genres: Action, Adventure, Comedy, Drama, or
Horror. The raw file contains only these five.


VARIABLES
---------
movie            Film title
release_date     Release date (year-month-day)
year             Release year
genre            "Action", "Adventure", "Comedy", "Drama", or "Horror"
mpaa_rating      MPAA rating: "G", "PG", "PG-13", or "R"; missing (NA) for
                 6 films
distributor      Distribution company; missing (NA) for 17 films
budget           Production budget, millions of dollars
domestic_gross   Domestic (U.S. and Canada) box-office gross, millions of dollars
worldwide_gross  Box-office gross worldwide, millions of dollars
roi              Return on investment = worldwide_gross / budget (e.g., 3
                 means the film grossed three times its budget)


NOTES AND CAVEATS
-----------------
- Dollar amounts are nominal (not adjusted for inflation).
- Budgets in the raw file top out at $175 million, so the biggest
  blockbusters (e.g., Avatar) are not included. TidyTuesday does not say
  why.
- Gross is box-office revenue only. It ignores marketing costs, the share
  of ticket sales kept by theaters, and home-video and streaming income, so
  roi overstates a studio's actual profit.
- Production budgets are estimates; studios often do not disclose them.
- A few films have extreme returns (Paranormal Activity, 2009: $0.45
  million budget, $194 million worldwide), which drive much of the
  difference in average roi across genres.


SUGGESTED CITATION
------------------
The Numbers. Movie budgets and box-office data, compiled for TidyTuesday,
2018-10-23. https://github.com/rfordatascience/tidytuesday


USED IN
-------
Unit 9 slides (Heteroskedasticity)

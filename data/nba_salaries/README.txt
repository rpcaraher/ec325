NBA SALARIES, 2026-27, WITH 2025-26 PLAYER STATISTICS (nba_salaries)
=====================================================================

SOURCE
------
Basketball-Reference.com, accessed October 27, 2026:
  - Salaries: "2026-27 NBA Player Contracts"
    https://www.basketball-reference.com/contracts/players.html
  - Statistics: "2025-26 NBA Player Stats: Per Game"
    https://www.basketball-reference.com/leagues/NBA_2026_per_game.html
  - Experience: first NBA season from the player index
    https://www.basketball-reference.com/players/

Read it from the course R Project with:

  nba <- read_csv("data/nba_salaries/nba_salaries.csv")


HOW THE FILE WAS BUILT
----------------------
- Start from every player with a 2026-27 salary on the contracts page.
- Drop 6 players who appear more than once on the contracts page (mostly
  waived players), so a single salary can't be assigned: Damian Lillard, Bradley Beal, Kentavious Caldwell-Pope, Klay Thompson,
  Jonathan Isaac, Olivier-Maxence Prosper.
- Drop 7 listed salaries below $1,357,763, the smallest full-season salary
  on the page. Amounts below it are not full-season salaries.
- Match to 2025-26 per-game statistics by Basketball-Reference player ID. For
  players who were traded during 2025-26, the statistics are for the whole
  season (all teams combined). Players who did not play in 2025-26 (including
  2026 rookies) drop out.
- Keep players who played at least 20 games in 2025-26.


STRUCTURE
---------
Unit of observation:  player
Rows:                 369
Columns:              13
Sorted by salary, highest first.


VARIABLES
---------
player       Player's name
team         Team for 2026-27 (as of October 27, 2026)
salary       Salary for the 2026-27 season, in millions of dollars
age          Age during the 2025-26 season (Basketball-Reference's age as of
             February 1, 2026)
experience   Number of NBA seasons, counting 2026-27 (2 = the player's second
             season). Counted from the player's first NBA season, so seasons
             a player spent out of the league are included.
position     Position in 2025-26: PG, SG, SF, PF, or C
games        Games played in 2025-26
starts       Games started in 2025-26
minutes      Minutes per game in 2025-26
points       Points per game in 2025-26
rebounds     Rebounds per game in 2025-26
assists      Assists per game in 2025-26
all_star     = 1 if selected to the 2026 NBA All-Star Game, 0 otherwise


NOTES
-----
- Salaries are for the current season (2026-27); statistics are from the
  previous season (2025-26). Many contracts were signed before 2025-26.


USED IN
-------
Concept Check 7 (Dummy Variables, Nonlinear Models, and Interactions)

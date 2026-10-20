BIRTHS IN THE UNITED STATES, 2014 (births14)
============================================

SOURCE
------
OpenIntro, "births14" dataset (https://www.openintro.org/data/index.php?data=births14),
also distributed in the openintro R package. It is a random sample of 1,000
births from the 2014 U.S. natality data released by the CDC's National Center
for Health Statistics.

The file in this folder (births14.csv) is an unmodified copy of OpenIntro's CSV.
Read it from the course R Project with:

  births <- read_csv("data/births14/births14.csv")


STRUCTURE
---------
Unit of observation:  birth
Rows:                 1,000
Columns:              13


VARIABLES
---------
fage             Father's age in years (missing for 114 births)
mage             Mother's age in years
mature           Maturity status of mother ("mature mom" or "younger mom")
weeks            Length of pregnancy in weeks
premie           Whether the birth was premature ("premie" or "full term")
visits           Number of hospital visits during pregnancy
gained           Weight gained by the mother during pregnancy, in pounds
weight           Baby's birth weight, in pounds
lowbirthweight   Whether the baby was classified as low birth weight
sex              Sex of the baby
habit            Mother's smoking status ("smoker" or "nonsmoker")
marital          Whether the mother was married at birth
whitemom         Whether the mother is white


USED IN
-------
Concept Check 6 (Statistical Inference)

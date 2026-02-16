================================================================
README: Oregon Health Insurance Experiment Sample Data
================================================================

Source:       Oregon Health Insurance Experiment (OHIE)
              Finkelstein et al. (2012), Baicker et al. (2013)
Year:         2008
Unit:         Individual
Sample Size:  23,777 individuals

Description:
  This dataset contains a sample of individuals who signed up for
  Oregon's 2008 Medicaid lottery. In this lottery, the state of
  Oregon randomly selected individuals from a waiting list to
  receive the opportunity to enroll in the Oregon Health Plan
  (the state's Medicaid program). Individuals not selected
  remained uninsured. Because lottery winners were chosen
  randomly, comparing outcomes between winners and losers
  provides a valid causal estimate of the effect of health
  insurance access.

Files:
  ohie_sample.csv  - Main dataset
  README.txt       - This file (variable descriptions)

================================================================
CODEBOOK
================================================================

Variable        Type        Description
----------------------------------------------------------------
person_id       integer     Unique individual identifier

treatment       binary      Lottery assignment status
                            1 = selected in lottery
                            0 = not selected

female          binary      Sex
                            1 = female
                            0 = male

race            character   Race/ethnicity category
                            "white", "black", or "other"

hisp            binary      Hispanic ethnicity
                            1 = Hispanic
                            0 = non-Hispanic

educ            character   Highest education level
                            "lths"    = less than high school
                            "hsdeg"   = high school degree
                            "mths"    = more than high school
                            "colldeg" = college degree

hhinc           integer     Household income
                            (in thousands of dollars)

ever_medi       binary      Ever enrolled in Medicaid
                            1 = yes, 0 = no

any_hosp        binary      Any hospitalization
                            1 = yes, 0 = no

any_doc         binary      Any doctor visit
                            1 = yes, 0 = no

good_health     binary      Self-reported health status
                            1 = good health or better
                            0 = fair or poor health

Missing Values: Coded as NA

================================================================
CITATION
================================================================

Finkelstein, A., Taubman, S., Wright, B., Bernstein, M.,
  Gruber, J., Newhouse, J.P., Allen, H., Baicker, K., and the
  Oregon Health Study Group. 2012. "The Oregon Health Insurance
  Experiment: Evidence from the First Year." The Quarterly
  Journal of Economics 127(3): 1057-1106.

================================================================

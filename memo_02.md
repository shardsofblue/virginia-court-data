# Memo: Preliminary Analysis

Please find the repository for this project [here](https://github.com/shardsofblue/virginia-court-data). _[Sean please note this is different from the CNS repository.]_

The majority of my work is in _[analysis.sql](https://github.com/shardsofblue/virginia-court-data/blob/master/analysis.sql)_. Some work is also in _[sentence-time-by-race.xlsx](https://github.com/shardsofblue/virginia-court-data/blob/master/sentence-time-by-race.xlsx)_.

## Gender Analysis

I started out looking for possible gender disparities in plea bargaining, but this proved uninteresting. 

### Findings of interest: Gender
* Men make up 76 percent of the total of people who are found guilty. 
* More women plead than men, at 85 percent of women and 81 percent of men.
* Men and women are found guilty at trial at basically the same rates: 82.87 for women and 82.26 for men.

## Racial Analysis

I have moved instead to a racial analysis. (_analysis.sql_ Line 307) Specifically, I am investigating whether there is a penalty in sentence length for going to trial as compared to taking a plea deal, and whether black people face a stronger penalty. My theory is that racially biased judges and juries may lead to harsher sentences.

### Findings of interest: Race
* Black people make up 41 percent of the convictions in VA, while only making up 20 percent of the population (according to [census 2010 data](https://www.census.gov/quickfacts/va)). By contrast, white people make up 70 percent of the population and 57 percent of the convictions.
* Within the races, more white than black people who were found guilty chose to plead rather than go to trial, at a rate of 84 percent to 78 percent.
* Within the races and looking at all cases (not just those that ended with a guilty verdict), more white people than black chose to plead rather than go to trial, at a rate of 77 percent to 69 percent.
* White people were found guilty at trial at a higher rate than black people, at 84 percent compared to 81 percent.
* A 5 year sentence was the most common; 1 year was the second-most common (unadjusted for suspensions).
* Both black and white people got longer sentences when they went to trial.
* Black people got longer sentences than white people.
* More black than white people got long sentences specifically as a result of going to trial.
 * 3 percent more black people than white got 5+ years as a result of going to trial.
 * 1 percent more black people than white got 10+ years as a result of going to trial.

## Other Notes

I used a variety of grouping schemes and filters to try to get a meaningful understanding of the data:
* I looked at data for the 10 years from 2007-2017
* I usually looked only at people found guilty, but I did remove this filter to determine the rates of conviction.
* I used percentages, not just raw numbers, in all my queries, and ensured the percents were meaningful by looking at percents within defined groups.
* I simplified the disposition codes by grouping them into "found" and "not found" guilty. _This probably needs more refinement._
* After noting the low rates of people of other races, I restricted my racial examination to black and white people for clarity.
* I adjusted sentence lengths for sentence suspensions and grouped them into blocks of time periods.




/* 
TODO NOTES
-Are more men/women, black/white people taking plea deals?
-look at the breakdowns of crimes for each sex/race
--clleeeeaaannninnnnnggg
--using sentence length as a proxy?
-how many of each sex/race who went to trial were found guilty?
-who gets a higher average sentence length: those who go to trial or those who take a plea deal? 
--How does this differ by sex/race?
*/

/* OVERVIEW: all info for FELONIES found GUILTY ConcludedBy a GUILTY PLEA or a TRIAL, for only year 2017  */
SELECT *, 
	EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") AS "YearFiled" /* year column */
FROM "CircuitCriminalCase" 
WHERE "CircuitCriminalCase"."DispositionCode" = 'Guilty' AND /* found guilty */
	"CircuitCriminalCase"."ChargeType" = 'Felony' AND /* felony */
	"CircuitCriminalCase"."SentenceTime" is not null AND /* was sentenced to jail time */
	("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" = 'Trial - Jury' /* ended with a JURY TRIAL */
		OR "CircuitCriminalCase"."ConcludedBy" = 'Trial - Judge With Witness') AND /* ended with a JUDGE TRIAL */
	EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017; /* for 10 years */

/*
BEGIN ANALYSIS OF DEFENDENTS BY SEX
BEGIN ANALYSIS OF DEFENDENTS BY SEX
BEGIN ANALYSIS OF DEFENDENTS BY SEX
BEGIN ANALYSIS OF DEFENDENTS BY SEX
BEGIN ANALYSIS OF DEFENDENTS BY SEX
BEGIN ANALYSIS OF DEFENDENTS BY SEX
*/

/* COUNT and PERCENT of which SEX went to trial or pled guilty and was found guilty, 
percent of TOTAL */
SELECT "CircuitCriminalCase"."Sex",
	"CircuitCriminalCase"."ConcludedBy",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
			AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
				OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
	AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Sex", "CircuitCriminalCase"."ConcludedBy");
	
/*
TOTAL: 549,783

WOMEN: 131,698, 23.95% of total
-plea: 111,696
-trial: 20,002
--judge: 19,399
--jury: 603

MEN: 418,085, 76.05% of total
-plea: 338,115
-trial: 
--judge: 72,340
--jury: 7,630
*/

/*
FINDING OF INTEREST: Men make up 76 percent of the total of people who are found guilty.
*/

/* COUNT and PERCENT of which SEX went to trial or pled guilty, 
percent of EACH */
SELECT "CircuitCriminalCase"."Sex",
	"CircuitCriminalCase"."ConcludedBy",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."Sex" = 'Female'
			AND "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
			AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
				OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."Sex" = 'Female'
	AND "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
	AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Sex", "CircuitCriminalCase"."ConcludedBy")

UNION ALL 

SELECT "CircuitCriminalCase"."Sex",
	"CircuitCriminalCase"."ConcludedBy",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."Sex" = 'Male'
			AND "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
			AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
				OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."Sex" = 'Male'
	AND "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
	AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Sex", "CircuitCriminalCase"."ConcludedBy")
;

/*
WOMEN: 131,698
-plea: 111,696, 84.81% of women
-trial: 20,002, 15.19% of women
--judge: 19,399, 14.73% of women
--jury: 603, .46% of women

MEN: 418,085
-plea: 338,115, 80.87% of men
-trial: 79,970, 19.13% of men
--judge: 72,340, 17.3% of men
--jury: 7,630, 1.82% of men
*/

/* FINDING OF INTEREST: More women plead than men, at 85 percent of women and 81 percent of men. */

/* COUNT and PERCENT of which SEX went to trial or pled guilty,  
percent of EACH */
SELECT "CircuitCriminalCase"."Sex",
	"CircuitCriminalCase"."ConcludedBy",
	"CircuitCriminalCase"."DispositionCode",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."Sex" = 'Female'
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
			AND "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."Sex" = 'Female'
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
	AND "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Sex", "CircuitCriminalCase"."ConcludedBy", "CircuitCriminalCase"."DispositionCode")

UNION ALL 

SELECT "CircuitCriminalCase"."Sex",
	"CircuitCriminalCase"."ConcludedBy",
	"CircuitCriminalCase"."DispositionCode",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."Sex" = 'Male'
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
			AND "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."Sex" = 'Male'
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
	AND "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Sex", "CircuitCriminalCase"."ConcludedBy", "CircuitCriminalCase"."DispositionCode")
;
/* I NEED TO ADD an IF statement to group disposition codes by layperson's understanding of guilty/not-guilty */
	
/* IF to group guilty vs not-guilty */
/* To make this meaningful, I NEED to figure out what all the disposition code types mean */

/* I just want to see the disposition codes */
SELECT "CircuitCriminalCase"."DispositionCode", 
	COUNT("CircuitCriminalCase"."DispositionCode")
FROM "CircuitCriminalCase" 
WHERE "CircuitCriminalCase"."ChargeType" = 'Felony' AND /* felony */
	("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" = 'Trial - Jury' /* ended with a JURY TRIAL */
		OR "CircuitCriminalCase"."ConcludedBy" = 'Trial - Judge With Witness') AND /* ended with a JUDGE TRIAL */
	EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY "CircuitCriminalCase"."DispositionCode";

/*
Appeal Withdrawn,1
Dismissed,11160 - dropped by judge
Guilty,584350
Mistrial,1682
No Indictment Presented,3
Nolle Prosequi,4214 - dropped by prosecutor
Not Guilty/Acquitted,12331
Not Guilty By Reason Of Insanity,448
Not True Bill,22 - ??
Remanded,28 - sent back for another decision
Resolved,6266 - ??
Sentence/Probation Revoked,57533 - crimes/violations committed during probation
*/

/** Figuring out IF statements **/
/* IF to group trial types together into trial/plea */
/* NORMAL SQL IF:
IF("CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%',
	'Trial',
	'Plea') AS "trial_or_plea",
*/

/* IF to group verdicts together into guilty/ng */
/* NORMAL SQL IF:
IF(("CircuitCriminalCase"."DispositionCode" LIKE 'Not Guilty%'
	OR "CircuitCriminalCase"."DispositionCode" = 'Nolle Prosequi'
	OR "CircuitCriminalCase"."DispositionCode" = 'Dismissed'),
	'Not Guilty',
	/* ELSE IF */
	IF(("CircuitCriminalCase"."DispositionCode" ='Nolo Contendere' OR "CircuitCriminalCase"."DispositionCode" LIKE 'Guilty%'), 
		'Guilty',
		'Other') 
	AS "guilty_or_not",
*/

/* better grouping schema, guilty/ng percentages WITHIN the trials for each gender */
SELECT "CircuitCriminalCase"."Sex",
	CASE WHEN "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' 
		THEN 'Trial'
		WHEN "CircuitCriminalCase"."ConcludedBy" IS NULL
		THEN NULL
		ELSE 'Plea'
	END AS "trial_or_plea",
	CASE WHEN ("CircuitCriminalCase"."DispositionCode" LIKE 'Not Guilty%'
		OR "CircuitCriminalCase"."DispositionCode" = 'Nolle Prosequi'
		OR "CircuitCriminalCase"."DispositionCode" = 'Dismissed') 
			THEN 'Not found guilty'
		WHEN ("CircuitCriminalCase"."DispositionCode" ='Nolo Contendere' 
		OR "CircuitCriminalCase"."DispositionCode" LIKE 'Guilty%'
		OR "CircuitCriminalCase"."DispositionCode" LIKE 'Sentence/Probation Revoked')
			THEN 'Guilty'
		ELSE 'Other'
	END AS "verdict",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."Sex" = 'Female'
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."Sex" = 'Female'
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Sex", "trial_or_plea", "verdict")

UNION ALL 

SELECT "CircuitCriminalCase"."Sex",
	CASE WHEN "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' 
		THEN 'Trial'
		WHEN "CircuitCriminalCase"."ConcludedBy" IS NULL
		THEN NULL
		ELSE 'Plea'
	END AS "trial_or_plea",
	CASE WHEN ("CircuitCriminalCase"."DispositionCode" LIKE 'Not Guilty%'
		OR "CircuitCriminalCase"."DispositionCode" = 'Nolle Prosequi'
		OR "CircuitCriminalCase"."DispositionCode" = 'Dismissed') 
			THEN 'Not found guilty'
		WHEN ("CircuitCriminalCase"."DispositionCode" ='Nolo Contendere' 
		OR "CircuitCriminalCase"."DispositionCode" LIKE 'Guilty%'
		OR "CircuitCriminalCase"."DispositionCode" LIKE 'Sentence/Probation Revoked')
			THEN 'Guilty'
		ELSE 'Other'
	END AS "verdict",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."Sex" = 'Male'
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."Sex" = 'Male'
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Sex", "trial_or_plea", "verdict")
;

/*  
FINDING OF INTEREST: Men and women are found guilty at trial at basically the same rates: 82.87 for women and 82.26 for men.
*/

/* The analysis by sex is not proving very enlightening. I am going to move on to race. */

/*
BEGIN ANALYSIS OF DEFENDENTS BY RACE
BEGIN ANALYSIS OF DEFENDENTS BY RACE
BEGIN ANALYSIS OF DEFENDENTS BY RACE
BEGIN ANALYSIS OF DEFENDENTS BY RACE
BEGIN ANALYSIS OF DEFENDENTS BY RACE
BEGIN ANALYSIS OF DEFENDENTS BY RACE
BEGIN ANALYSIS OF DEFENDENTS BY RACE
*/


/* COUNT and PERCENT of which RACE went to trial or pled guilty and was found guilty, 
percent of TOTAL */
SELECT "CircuitCriminalCase"."Race",
	"CircuitCriminalCase"."ConcludedBy",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
			AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
				OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
	AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Race", "CircuitCriminalCase"."ConcludedBy");
	
/*
TOTAL: 549,783

White Caucasian (Non-Hispanic): 312,639, 56.87% of total
-plea: 263,959, 48.01 percent of total
-trial: 
--judge: 45,522
--jury: 3,158

Black (Non-Hispanic): 227,764, 41.43% of total
-plea: 177,802, 32.34% of total
-trial: 
--judge: 45,078, 8.2
--jury: 4,884, 0.89

Hispanic: 3286, 0.6% of total
-plea: 2,806
-trial: 
--judge: 426
--jury: 54

American Indian: 284, 0.05% of total
-plea: 234
-trial: 50
--judge: 40
--jury: 10

Asian Or Pacific Islander: 1,797, 0.33% of total
-plea: 1,566
-trial: 
--judge: 217
--jury: 14

Other: 4,006, 0.73% of total
-plea: 3444
-trial: 
--judge: 449
--jury: 113

Census beaureu:
https://www.census.gov/quickfacts/va
https://www.census.gov/programs-surveys/decennial-census/data/tables.2010.html

Race and Hispanic Origin	
White alone, percent(a)	69.7%
Black or African American alone, percent(a) 19.8%
American Indian and Alaska Native alone, percent(a) 0.5%
Asian alone, percent(a)	6.8%
Native Hawaiian and Other Pacific Islander alone, percent(a) 0.1%
Two or More Races, percent	3.0%
Hispanic or Latino, percent(b)	9.4%
White alone, not Hispanic or Latino, percent 61.9%
*/

/*  
FINDING OF INTEREST: Black people make up 41 percent of the convictions in VA, while only making up 20 percent of the population. By contrast, white people make up 70 percent of the population and 57 percent of the convictions.
*/

/* COUNT and PERCENT of which RACE went to trial or pled guilty, within guilty verdicts, looking just at blacks and whites,
percent of EACH */
SELECT "CircuitCriminalCase"."Race",
	"CircuitCriminalCase"."ConcludedBy",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."Race" LIKE 'White%'
			AND "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
			AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
				OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."Race" LIKE 'White%'
	AND "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
	AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Race", "CircuitCriminalCase"."ConcludedBy")

UNION ALL 

SELECT "CircuitCriminalCase"."Race",
	"CircuitCriminalCase"."ConcludedBy",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."Race" LIKE 'Black%'
			AND "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
			AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
				OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."Race" LIKE 'Black%'
	AND "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
	AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Race", "CircuitCriminalCase"."ConcludedBy")
;

/*
White: 312,639
-plea: 263,959, 84.43% of white
-trial: 
--judge: 45,522, 14.56% of white
--jury: 3,158, 1.01% of white

Black: 227,764
-plea: 177,802, 78.06% of black
-trial: 
--judge: 45,078, 19.79% of black
--jury: 4,884, 2.14% of black
*/

/*  
FINDING OF INTEREST: Within the races, more white than black people who are found guilty chose to plead rather than go to trial, at a rate of 84 percent to 78 percent
*/

/* COUNT and PERCENT of which RACE went to trial or pled guilty, _expanded beyond guilty verdicts_, looking just at blacks and whites
percent of EACH */
SELECT "CircuitCriminalCase"."Race",
	"CircuitCriminalCase"."ConcludedBy",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."Race" LIKE 'White%'
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
				OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."Race" LIKE 'White%'
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Race", "CircuitCriminalCase"."ConcludedBy")

UNION ALL 

SELECT "CircuitCriminalCase"."Race",
	"CircuitCriminalCase"."ConcludedBy",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."Race" LIKE 'Black%'
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
				OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."Race" LIKE 'Black%'
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Race", "CircuitCriminalCase"."ConcludedBy")
;

/*
White: 380,235
-plea: 290,985, 76.53% of white
-trial: 
--judge: 82,601, 21.72% of white
--jury: 6,649, 1.75% of white

Black: 286,489
-plea: 197,872, 69.07% of black
-trial: 
--judge: 78,403, 27.37% of black
--jury: 10,214, 3.57% of black
*/

/*  
FINDING OF INTEREST: Within the races and looking at all cases (not just those that ended with a guilty verdict), more white people than black choose to plead rather than go to trial, at a rate of 77 percent to 69 percent.
*/

/* guilty/innocent percentages at trial WITHIN each race */
SELECT "CircuitCriminalCase"."Race",
	CASE WHEN "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' 
		THEN 'Trial'
		WHEN "CircuitCriminalCase"."ConcludedBy" IS NULL
		THEN NULL
		ELSE 'Plea'
	END AS "trial_or_plea",
	CASE WHEN ("CircuitCriminalCase"."DispositionCode" LIKE 'Not Guilty%'
		OR "CircuitCriminalCase"."DispositionCode" = 'Nolle Prosequi'
		OR "CircuitCriminalCase"."DispositionCode" = 'Dismissed') 
			THEN 'Not found guilty'
		WHEN ("CircuitCriminalCase"."DispositionCode" ='Nolo Contendere' 
		OR "CircuitCriminalCase"."DispositionCode" LIKE 'Guilty%'
		OR "CircuitCriminalCase"."DispositionCode" LIKE 'Sentence/Probation Revoked')
			THEN 'Guilty'
		ELSE 'Other'
	END AS "verdict",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."Race" LIKE 'White%'
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."Race" LIKE 'White%'
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Race", "trial_or_plea", "verdict")

UNION ALL 

SELECT "CircuitCriminalCase"."Race",
	CASE WHEN "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' 
		THEN 'Trial'
		WHEN "CircuitCriminalCase"."ConcludedBy" IS NULL
		THEN NULL
		ELSE 'Plea'
	END AS "trial_or_plea",
	CASE WHEN ("CircuitCriminalCase"."DispositionCode" LIKE 'Not Guilty%'
		OR "CircuitCriminalCase"."DispositionCode" = 'Nolle Prosequi'
		OR "CircuitCriminalCase"."DispositionCode" = 'Dismissed') 
			THEN 'Not found guilty'
		WHEN ("CircuitCriminalCase"."DispositionCode" ='Nolo Contendere' 
		OR "CircuitCriminalCase"."DispositionCode" LIKE 'Guilty%'
		OR "CircuitCriminalCase"."DispositionCode" LIKE 'Sentence/Probation Revoked')
			THEN 'Guilty'
		ELSE 'Other'
	END AS "verdict",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE "CircuitCriminalCase"."Race" LIKE 'Black%'
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) as percent
FROM "CircuitCriminalCase"
WHERE "CircuitCriminalCase"."Race" LIKE 'Black%'
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY ROLLUP("CircuitCriminalCase"."Race", "trial_or_plea", "verdict")
;

/*
FINDING OF INTEREST: White people are found guilty at trial at a higher rate than black people, at 84 percent compared to 81 percent.
*/

/* who gets a longer sentence length: those who go to trial or those who take a plea deal? */
/* remember to include life sentences */
/* remember to account for suspended sentences */
/* should I also look at who gets their charges amended? */

/* I just want to see the LifeDeath field */
SELECT "CircuitCriminalCase"."LifeDeath", 
	COUNT(*)
FROM "CircuitCriminalCase" 
WHERE "CircuitCriminalCase"."ChargeType" = 'Felony' AND /* felony */
	("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" = 'Trial - Jury' /* ended with a JURY TRIAL */
		OR "CircuitCriminalCase"."ConcludedBy" = 'Trial - Judge With Witness') AND /* ended with a JUDGE TRIAL */
	EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY "CircuitCriminalCase"."LifeDeath";

/*
Death Penalty, 7
Life Sentence, 968
All, 677,068
*/

/* I just want to see the SentenceTime field */
SELECT "CircuitCriminalCase"."SentenceTime", 
	COUNT(*) AS "how_many"
FROM "CircuitCriminalCase" 
WHERE "CircuitCriminalCase"."DispositionCode" = 'Guilty' AND /* found guilty */
	"CircuitCriminalCase"."ChargeType" = 'Felony' AND /* felony */
	"CircuitCriminalCase"."SentenceTime" is not null AND /* was sentenced to jail time */
	("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" = 'Trial - Jury' /* ended with a JURY TRIAL */
		OR "CircuitCriminalCase"."ConcludedBy" = 'Trial - Judge With Witness') AND /* ended with a JUDGE TRIAL */
	EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY "CircuitCriminalCase"."SentenceTime" 
ORDER BY "how_many" DESC;

/* 5 years is the most common, 1 year is the second-most common */

/* I want to see sentence time grouped more meaningfully */
SELECT CASE WHEN "CircuitCriminalCase"."LifeDeath" LIKE 'Life%'
		THEN 'life sentence'
		WHEN "CircuitCriminalCase"."LifeDeath" LIKE 'Death%'
		THEN 'death penalty'
		WHEN "CircuitCriminalCase"."SentenceTime" = 0
		THEN 'none'
		WHEN "CircuitCriminalCase"."SentenceTime" < 365
		THEN 'less than 1 year'
		WHEN "CircuitCriminalCase"."SentenceTime" < 1825
		THEN 'between 1 and 5 years'
		WHEN "CircuitCriminalCase"."SentenceTime" < 3650
		THEN 'between 5 and 10 years'
		WHEN "CircuitCriminalCase"."SentenceTime" < 14600
		THEN 'between 10 and 40 years'
		ELSE '40 years or more'
	END AS "sentence_time",
	COUNT(*) AS "how_many"
FROM "CircuitCriminalCase" 
WHERE "CircuitCriminalCase"."DispositionCode" = 'Guilty' AND /* found guilty */
	"CircuitCriminalCase"."ChargeType" = 'Felony' AND /* felony */
	"CircuitCriminalCase"."SentenceTime" is not null AND /* was sentenced to jail time */
	("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" = 'Trial - Jury' /* ended with a JURY TRIAL */
		OR "CircuitCriminalCase"."ConcludedBy" = 'Trial - Judge With Witness') AND /* ended with a JUDGE TRIAL */
	EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY "sentence_time" 
ORDER BY "how_many" DESC;

/* make a field adjusting for suspended sentences */
/* 
newfield = SentenceTime - SentenceSuspended
*/
SELECT CASE WHEN "CircuitCriminalCase"."SentenceSuspended" IS NOT NULL
	THEN ("CircuitCriminalCase"."SentenceTime" - "CircuitCriminalCase"."SentenceSuspended") 
	ELSE "CircuitCriminalCase"."SentenceTime"
	END AS "adjusted_sentence",
	COUNT(*) AS "how_many"
FROM "CircuitCriminalCase" 
WHERE "CircuitCriminalCase"."DispositionCode" = 'Guilty' AND /* found guilty */
	"CircuitCriminalCase"."ChargeType" = 'Felony' AND /* felony */
	"CircuitCriminalCase"."SentenceTime" is not null AND /* was sentenced to jail time */
	("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" = 'Trial - Jury' /* ended with a JURY TRIAL */
		OR "CircuitCriminalCase"."ConcludedBy" = 'Trial - Judge With Witness') AND /* ended with a JUDGE TRIAL */
	EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY "adjusted_sentence" 
ORDER BY "how_many" DESC;

/* next step: combine the meaningful sentence time grouping with the adjusted sentence calculation */

/* TEMP TABLE */
SELECT "CircuitCriminalCase"."Race",
	CASE WHEN "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%' 
		THEN 'Trial'
		WHEN "CircuitCriminalCase"."ConcludedBy" IS NULL
		THEN NULL
		ELSE 'Plea'
	END AS "trial_or_plea",
	COUNT(*),
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "CircuitCriminalCase"
		WHERE ("CircuitCriminalCase"."Race" LIKE 'Black%'
				OR "CircuitCriminalCase"."Race" LIKE 'White%')
			AND "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
			AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
			AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
			AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
				OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
			AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */),2) AS "percent",
	CASE WHEN "CircuitCriminalCase"."LifeDeath" LIKE 'Life%'
		THEN 9999999
		WHEN "CircuitCriminalCase"."LifeDeath" LIKE 'Death%'
		THEN 9990999
		WHEN "CircuitCriminalCase"."SentenceSuspended" IS NOT NULL
		THEN ("CircuitCriminalCase"."SentenceTime" - "CircuitCriminalCase"."SentenceSuspended") 
		ELSE "CircuitCriminalCase"."SentenceTime"
	END AS "adjusted_sentence"
INTO "AdjustedSentence"
FROM "CircuitCriminalCase"
WHERE ("CircuitCriminalCase"."Race" LIKE 'Black%'
		OR "CircuitCriminalCase"."Race" LIKE 'White%')
	AND "CircuitCriminalCase"."DispositionCode" = 'Guilty' /* found guilty */
	AND "CircuitCriminalCase"."ChargeType" = 'Felony' /* felony */
	AND "CircuitCriminalCase"."SentenceTime" is not null /* was sentenced to jail time */
	AND ("CircuitCriminalCase"."ConcludedBy" = 'Guilty Plea' /* ended with a GUILTY PLEA */
		OR "CircuitCriminalCase"."ConcludedBy" LIKE 'Trial%') /* ended with a TRIAL */
	AND EXTRACT(YEAR FROM "CircuitCriminalCase"."Filed") BETWEEN 2007 AND 2017 /* for 10 years */
GROUP BY "CircuitCriminalCase"."Race", "trial_or_plea", "adjusted_sentence"
;

SELECT * FROM "AdjustedSentence";

/* DROP TABLE "AdjustedSentence"; */

/* Comparing rates of sentence time chunks by race for trial and plea */
/* The following query REQUIRES THE PREVIOUS TEMP TABLE */
/* START MEGAQUERY */
/* START MEGAQUERY */
/* START MEGAQUERY */

SELECT "AdjustedSentence"."Race",
	"AdjustedSentence"."trial_or_plea",
	CASE WHEN "AdjustedSentence"."adjusted_sentence" = 9999999
		THEN 'life sentence'
		WHEN "AdjustedSentence"."adjusted_sentence" = 9990999
		THEN 'death penalty'
		WHEN "AdjustedSentence"."adjusted_sentence" = 0
		THEN 'none'
		WHEN "AdjustedSentence"."adjusted_sentence" < 365
		THEN 'less than 1 year'
		WHEN "AdjustedSentence"."adjusted_sentence" < 1825
		THEN 'between 1 and 5 years'
		WHEN "AdjustedSentence"."adjusted_sentence" < 3650
		THEN 'between 5 and 10 years'
		WHEN "AdjustedSentence"."adjusted_sentence" < 14600
		THEN 'between 10 and 40 years'
		ELSE '40 years or more'
	END AS "sentence_time",
	COUNT(*) AS "how_many",
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "AdjustedSentence"
		WHERE "AdjustedSentence"."Race" LIKE 'White%'
			AND "AdjustedSentence"."trial_or_plea" = 'Trial'),2) AS "percent"
FROM "AdjustedSentence" 
WHERE "AdjustedSentence"."Race" LIKE 'White%'
	AND "AdjustedSentence"."trial_or_plea" = 'Trial'
GROUP BY ROLLUP("Race", "trial_or_plea", "sentence_time") 

UNION ALL 

SELECT "AdjustedSentence"."Race",
	"AdjustedSentence"."trial_or_plea",
	CASE WHEN "AdjustedSentence"."adjusted_sentence" = 9999999
		THEN 'life sentence'
		WHEN "AdjustedSentence"."adjusted_sentence" = 9990999
		THEN 'death penalty'
		WHEN "AdjustedSentence"."adjusted_sentence" = 0
		THEN 'none'
		WHEN "AdjustedSentence"."adjusted_sentence" < 365
		THEN 'less than 1 year'
		WHEN "AdjustedSentence"."adjusted_sentence" < 1825
		THEN 'between 1 and 5 years'
		WHEN "AdjustedSentence"."adjusted_sentence" < 3650
		THEN 'between 5 and 10 years'
		WHEN "AdjustedSentence"."adjusted_sentence" < 14600
		THEN 'between 10 and 40 years'
		ELSE '40 years or more'
	END AS "sentence_time",
	COUNT(*) AS "how_many",
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "AdjustedSentence"
		WHERE "AdjustedSentence"."Race" LIKE 'White%'
			AND "AdjustedSentence"."trial_or_plea" = 'Plea'),2) AS "percent"
FROM "AdjustedSentence" 
WHERE "AdjustedSentence"."Race" LIKE 'White%'
	AND "AdjustedSentence"."trial_or_plea" = 'Plea'
GROUP BY ROLLUP("Race", "trial_or_plea", "sentence_time")

UNION ALL

SELECT "AdjustedSentence"."Race",
	"AdjustedSentence"."trial_or_plea",
	CASE WHEN "AdjustedSentence"."adjusted_sentence" = 9999999
		THEN 'life sentence'
		WHEN "AdjustedSentence"."adjusted_sentence" = 9990999
		THEN 'death penalty'
		WHEN "AdjustedSentence"."adjusted_sentence" = 0
		THEN 'none'
		WHEN "AdjustedSentence"."adjusted_sentence" < 365
		THEN 'less than 1 year'
		WHEN "AdjustedSentence"."adjusted_sentence" < 1825
		THEN 'between 1 and 5 years'
		WHEN "AdjustedSentence"."adjusted_sentence" < 3650
		THEN 'between 5 and 10 years'
		WHEN "AdjustedSentence"."adjusted_sentence" < 14600
		THEN 'between 10 and 40 years'
		ELSE '40 years or more'
	END AS "sentence_time",
	COUNT(*) AS "how_many",
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "AdjustedSentence"
		WHERE "AdjustedSentence"."Race" LIKE 'Black%'
			AND "AdjustedSentence"."trial_or_plea" = 'Trial'),2) AS "percent"
FROM "AdjustedSentence" 
WHERE "AdjustedSentence"."Race" LIKE 'Black%'
	AND "AdjustedSentence"."trial_or_plea" = 'Trial'
GROUP BY ROLLUP("Race", "trial_or_plea", "sentence_time") 

UNION ALL

SELECT "AdjustedSentence"."Race",
	"AdjustedSentence"."trial_or_plea",
	CASE WHEN "AdjustedSentence"."adjusted_sentence" = 9999999
		THEN 'life sentence'
		WHEN "AdjustedSentence"."adjusted_sentence" = 9990999
		THEN 'death penalty'
		WHEN "AdjustedSentence"."adjusted_sentence" = 0
		THEN 'none'
		WHEN "AdjustedSentence"."adjusted_sentence" < 365
		THEN 'less than 1 year'
		WHEN "AdjustedSentence"."adjusted_sentence" < 1825
		THEN 'between 1 and 5 years'
		WHEN "AdjustedSentence"."adjusted_sentence" < 3650
		THEN 'between 5 and 10 years'
		WHEN "AdjustedSentence"."adjusted_sentence" < 14600
		THEN 'between 10 and 40 years'
		ELSE '40 years or more'
	END AS "sentence_time",
	COUNT(*) AS "how_many",
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
		FROM "AdjustedSentence"
		WHERE "AdjustedSentence"."Race" LIKE 'Black%'
			AND "AdjustedSentence"."trial_or_plea" = 'Plea'),2) AS "percent"
FROM "AdjustedSentence" 
WHERE "AdjustedSentence"."Race" LIKE 'Black%'
	AND "AdjustedSentence"."trial_or_plea" = 'Plea'
GROUP BY ROLLUP("Race", "trial_or_plea", "sentence_time")
;

/* END MEGAQUERY */
/* END MEGAQUERY */
/* END MEGAQUERY */

/* I just realized that earlier queries that filtered by DispositionCode = Guilty ignored other guilty-ish pleas like the one with probation in it. Meaningful? */




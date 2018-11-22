# Scraps, Notes and Chicken Scratch

## Life Sentence Notes
Unlike the capital murder subset, the full data set is too large and complex to add life as a 99 year sentence across the board. While I can check sentence times to see if 99 years has been added, I cannot verify record-by-record whether a 30 or 50 year sentence accounted for the life sentence or was in addition to a life sentence. Therefore, I feel life sentence calculations should be noted in but handled separately from this aggregate table. 

```SQL
/* adds 99 years to sentence time if life sentence is checked (still NEEDS CHECK FOR if 99 years given but not marked LifeDeath AND count num of life sentences) */

CASE WHEN STRING_AGG("CircuitCriminalCase"."LifeDeath", ', ') LIKE '%Life%' /* if life sentence is coded */
	AND STRING_AGG(TO_CHAR("CircuitCriminalCase"."SentenceTime", '99999999'), ', ') NOT LIKE '%36135%' /* and if 99 years is not already accounted for in sentence time */
	THEN /* run checks and calculations to adjust for sentence suspensions and add 99 years */
		CASE WHEN SUM("CircuitCriminalCase"."SentenceSuspended") IS NOT NULL 
			THEN (SUM("CircuitCriminalCase"."SentenceTime") - SUM("CircuitCriminalCase"."SentenceSuspended") + 99*365) 
		ELSE SUM("CircuitCriminalCase"."SentenceTime") + 99*365
		END
	ELSE /* just run checks and calculations to output sentence times adjusted for suspensions */
		CASE WHEN SUM("CircuitCriminalCase"."SentenceSuspended") IS NOT NULL
			THEN (SUM("CircuitCriminalCase"."SentenceTime") - SUM("CircuitCriminalCase"."SentenceSuspended")) 
		ELSE SUM("CircuitCriminalCase"."SentenceTime")
		END
END AS "Adjusted_Life", 
```
```SQL
/* outputs sentence times aggregated together as a text string */
STRING_AGG(TO_CHAR("CircuitCriminalCase"."SentenceTime", '99999999'), ', ') AS "times",
```

# Process Notes for virginia-court-data

*Last updated: Dec. 5*

## To do
* [DONE]write function to pull fips codes from a .csv and insert them one by one into histograph-creating function
* [DONE]store all fips graphs in files of six charts per file for easy comparison
* [DONE]graph average sentence times for black and white people ~~for plea and trial~~
* [DONE]beautify chart axis labels
* [DONE]run same chart by percentage
* [DONE]identify problem counties

REAL DAYS | PERC
--- | ---
Southampton    |  Richmond City
Fauquier       |  Southampton
Bristol        |  Salem
Richmond City  |  Alleghany
Dinwiddie      |  Norfolk
Norfolk        |  Britol
Alleghany      |  Pulaski
Lynchburg      |  Fauquier
Newport News   |  Dinwiddie
Virginia Beach |  York/Poquoson

* [DONE]research other articles about racial divide in sentence times

* Out of project scope
  * re-aggregate from SQL with birthdates checked
  * clean crime types
  * look into specific cases
  * interview relevavant officials
  * look at plea/trial stats dimension
  * b/w found guilty/ng
  	* demographics compared to census b.
  * look into other factors of individual counties 
    * date trends
    * crime type
    * run a check on nat lang field (Charge\_Descriptions) or Code\_Sections as first pass on crime types?
  * instead of pre- and post-adjustment, look at plea vs. trial. Color code charts by color theme
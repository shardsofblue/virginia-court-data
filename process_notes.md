# Process Notes for virginia-court-data

*Last updated: Dec. 5*

## To do
* ~~re-aggregate from SQL with birthdates checked~~
* [DONE]write function to pull fips codes from a .csv and insert them one by one into histograph-creating function
* [DONE]store all fips graphs in files of six charts per file for easy comparison
* ~~instead of pre- and post-adjustment, look at plea vs. trial. Color code charts by color theme~~
* [DONE]graph average sentence times for black and white people ~~for plea and trial~~
* [DONE]beautify chart axis labels
* [DONE]run same chart by percentage
* [DONE]identify problem counties
  ||REAL DAYS         ||PERC
  #1.Southampton*     ##Richmond City*
  #2.Fauquier*        ##Southampton*
  #3.Bristol*         ##Salem
  #4.Richmond City*   ##Alleghany^
  #5.Dinwiddie*       ##Norfolk^
  #6.Norfolk^         ##Britol*
  #7.Alleghany^       ##Pulaski
  #8.Lynchburg        ##Fauquier*
  #9.Newport News     ##Dinwiddie*
  #10.Virginia Beach  ##York/Poquoson
* look into other factors of individual counties 
  * date trends
  * crime type
  * run a check on nat lang field (Charge\_Descriptions) or Code\_Sections as first pass on crime types?
* research other articles about racial divide in sentence times

* Out of project scope
  * clean crime types
  * look into specific cases
  * interview relevavant officials
  * look at plea/trial stats dimension
  * b/w found guilty/ng
  	* demographics compared to census b.
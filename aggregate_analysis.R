#Analysis file for Virginia court data for Plea Bargain Project. By Roxanne Ready, started on Aug. 27, 2018.
#install.packages("tidyverse")
#install.packages('stringr')
#install.packages('lubridate')
library(tidyverse)
library(stringr)
library(lubridate)
#brew install freetds --with-unixodbc
#brew install psqlodbc
#brew install mysql
#brew install sqliteodbc
#install.packages("odbc")

# Load in the aggregate data CSV
aggregate_data_table <- read.csv(file="/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/spreadsheets/aggregate_data_2007-2017.csv",head=TRUE,sep=";")

# Summarize aggregate_data_table
summary(aggregate_data_table)

# Filter the data set for only Guilty pleas
guilty_plea_cases <- aggregate_data_table %>%
  filter(Disposition_Code == "Guilty")
View(guilty_plea_cases)

# histogram for guilty plea cases' sentence times
ggplot(data=guilty_plea_cases, aes(guilty_plea_cases$Sentence_Time_Total)) + 
  geom_histogram(breaks=seq(0, 18250, by=365),
                 col="black", 
                 fill="black", 
                 alpha = 1.0) + 
  labs(title="Histogram for Sentence", x="Sentence", y="Count")

# histogram for guilty plea cases' adjusted sentence times
ggplot(data=guilty_plea_cases, aes(guilty_plea_cases$Adjusted_Sentence)) + 
  geom_histogram(breaks=seq(0, 18250, by=365),
                 col="black", 
                 fill="black", 
                 alpha = 1.0) + 
  labs(title="Histogram for Sentence", x="Sentence", y="Count")
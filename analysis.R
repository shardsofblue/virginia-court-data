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

aggregate_data_table <- read.csv(file="/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/spreadsheets/aggregate_data_2007-2017.csv",head=TRUE,sep=";")

qplot(aggregate_data_table$Adjusted_Sentence,
      geom="histogram",
      binwidth = 1,  
      main = "Histogram for Sentence", 
      xlab = "Length",  
      fill=I("blue"), 
      col=I("red"), 
      alpha=I(.2),
      xlim=c(20,50))
#Analysis file for Virginia court data for Plea Bargain Project. By Roxanne Ready, started on Aug. 27, 2018.
install.packages("tidyverse")
install.packages('stringr')
install.packages('lubridate')
install.packages('gridExtra')
install.packages('cowplot')
library(tidyverse)
library(stringr)
library(lubridate)
library(gridExtra)
library(cowplot)
theme_set(theme_cowplot(font_size=10)) # reduce default font size on charts

###############
## Data Prep ##
###############

# Load in the aggregate data CSV
aggregate_data_table <- read.csv(file="/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/data/aggregate_data_2007-2017.csv",head=TRUE,sep=";")

# Load in the fips code data CSV
fips_data_table <- read.csv(file="/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/data/circuit_courts_fips.csv",head=TRUE,sep=",")

# Filter the data set for only guilty
guilty_cases <- aggregate_data_table %>%
  filter(Disposition_Code == "Guilty")
#View(guilty_cases)

# Filter the data set for only guilty and black and white races
guilty_blackwhite_cases <- aggregate_data_table %>%
  filter(Disposition_Code == "Guilty") %>%
  filter(Race == "Black (Non-Hispanic)" | Race == "White Caucasian (Non-Hispanic)")
#View(guilty_blackwhite_cases)

# Add a column of logs of ag sentence times
guilty_bw_logs <- guilty_blackwhite_cases
guilty_bw_logs$log_adjusted_sentence <- log10(guilty_blackwhite_cases$Adjusted_Sentence)
#View(guilty_bw_logs)

###############
## FUNCTIONS ##
###############

# Create a histogram
histo_maker <- function(loc_name, table, measure, compare){
  output <- ggplot(table, aes(measure, fill=compare)) +
    background_grid(major = 'y', minor = "x") + 
    #geom_histogram(breaks=seq(0, 10, by=1), # 0 to 10 log value
    #geom_histogram(breaks=seq(1095, 10950, by=365), #3 to 30 years, chunks of 1 year
    geom_histogram(breaks=seq(1825, 10950, by=1825), #5 to 30 years, chunks of 5 years
                   aes(y = ..density..),
                   position = 'identity', 
                   alpha = .5) + 
    labs(title=paste(loc_name, "Sentences", sep=" "), x="Sentence", y="Density") 
  # + facet_wrap(~ Trial_or_Plea)
  return(output)
}
#test_histo1 <- histo_maker("Location", test_table, test_table$Sentence_Time_Total, test_table$Race)
#test_histo2 <- histo_maker("Location", test_table, test_table$Sentence_Time_Total, test_table$Race)
#plot_grid(test_histo1, test_histo2, labels = "AUTO")

# Filter by fips
fips_filter <- function(table, fips){
  output <- table %>%
    filter(Fips_Where_Filed == fips)
}
#test_table <- fips_filter(guilty_blackwhite_cases, 77)
#View(test_table)

# Create histogram for a single circuit court by fips
race_hist <- function(loc_fips, starting_df){
  loc_by_race <- fips_filter(starting_df, loc_fips)
  output <- histo_maker(loc_fips, loc_by_race, loc_by_race$Adjusted_Sentence, loc_by_race$Race)
  return(output)
}
#test <- race_hist(77,guilty_blackwhite_cases)
#test
#ggsave("test.png", plot=test, path="/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/bits_bobs/test_outputs")

# Create and save histograms for adjusted sentence times for each circuit court by fips
mass_hist_adjsent <- function(starting_df){
  fips_df <- fips_data_table
  for(i in 1:nrow(fips_df)) { #loop through fips codes
    loc_fips <- fips_df[i,1]
    loc_name <- fips_df[i,2]
    
    table_i <- starting_df %>% #create a dataframe for each fips
      filter(Fips_Where_Filed == loc_fips)
    
    histo_i <- histo_maker(loc_name, table_i, table_i$Adjusted_Sentence, table_i$Race) #make a histograph for each fips code
    
    save_name <- paste("histo_",loc_fips,".png",sep="") #specificy a save name, then save it
    ggsave(save_name, histo_i, path="/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/bits_bobs/histograms")
  }
}

##############
## Overview ##
##############

# Summarize aggregate_data_table
summary_df <- summary(aggregate_data_table)
View(summary_df)

# histogram for guilty plea cases' sentence times
ggplot(data=guilty_cases, aes(guilty_cases$Sentence_Time_Total)) + 
  geom_histogram(breaks=seq(0, 18250, by=365),
                 col="black", 
                 fill="black", 
                 alpha = 1.0) + 
  labs(title="Histogram for Sentence", x="Sentence", y="Count")

# histogram for guilty cases' adjusted sentence times
ggplot(data=guilty_cases, aes(guilty_cases$Adjusted_Sentence)) + 
  geom_histogram(breaks=seq(0, 18250, by=365),
                 col="black", 
                 fill="black", 
                 alpha = 1.0) + 
  labs(title="Histogram for Sentence", x="Sentence", y="Count")

#########################################
## Racial histogram analyses by county ##
#########################################

# Automated creation of histograms for sentence time
mass_hist_adjsent(guilty_blackwhite_cases)

# group by fips and race and get averages
#SELECT average(guilty_blackwhite_cases.Adjusted_Sentence)
#GROUP BY Race, fips WITH ROLLUP

by_fips <- guilty_blackwhite_cases %>% group_by(Race, Fips_Where_Filed)
mean_sent_by_racefips <- by_fips %>% summarise(
  mean_adjusted_sentence = mean(Adjusted_Sentence)
)
View(mean_sent_by_racefips)

# Averages by race within a single fips
fips77 <- fips_filter(mean_sent_by_racefips, 77)
View(fips77)

# Plot all fips on the same chart
# compare differences between black and white average sentences

# compute differences b/w b&w average sentences
# for each fips, substract avg_sent if(black) from avg_sent if(white), store
fips77_dif <- fips77

# I made a table storing the mean avgerage sentence time grouped by fips and race (only black and white). I want to look at each fips and subtract the average for each race, then store that difference as a value associated with each fips. 

#The table looks something like this:
# Race | fips | mean
# Black | 77 | 20
# White | 77 | 19
# Black | 105 | 55
# White | 105 | 21

# I want to get something like this:
# fips | dif
# 77 | 1
# 105 | 34



#ggplot (data = <DATA> ) + geom_point(), x, y, alpha, color, fill, shape, size, stroke
#black and white people different colors
point_graph <- ggplot (data = mean_sent_by_racefips, aes(mean_adjusted_sentence, fill=Race)) + 
  geom_histogram()
point_graph



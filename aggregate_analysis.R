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
#View(guilty_plea_cases)

# Filter the data set for only guilty and black and white races
guilty_blackwhite_cases <- aggregate_data_table %>%
  filter(Disposition_Code == "Guilty") %>%
  filter(Race == "Black (Non-Hispanic)" | Race == "White Caucasian (Non-Hispanic)")
#View(plea_blackwhite_cases)

# Add a column of logs of ag sentence times
guilty_bw_logs <- guilty_blackwhite_cases
guilty_bw_logs$log_adjusted_sentence <- log10(guilty_blackwhite_cases$Adjusted_Sentence)
#View(guilty_bw_logs)

###############
## FUNCTIONS ##
###############

# Create histograms
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

#Create histogram for a single circuit court by fips
race_hist <- function(loc_fips, starting_df){
  loc_by_race <- fips_filter(starting_df, loc_fips)
  output <- histo_maker(loc_fips, loc_by_race, loc_by_race$Adjusted_Sentence, loc_by_race$Race)
  return(output)
}
#test <- race_hist(77,guilty_blackwhite_cases)
#test
#ggsave("test.png", plot=test, path="/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/bits_bobs/test_outputs")

# Create and save histograms for adjusted sentence times for each circuit court by fips
mass_hist <- function(starting_df){
  fips_df <- fips_data_table
  for(i in 1:nrow(fips_df)) { #loop through fips codes
    loc_fips <- fips_df[i,1]
    loc_name <- fips_df[i,2]
    
    table_i <- starting_df %>% #create a dataframe for each fips
      filter(Fips_Where_Filed == loc_fips)
    
    histo_i <- histo_maker(loc_name, table_i, table_i$Adjusted_Sentence, table_i$Race) #make a histograph for each fips code
    
    save_name <- paste("histo_",loc_fips,".png",sep="") #specificy a save name, then save it
    ggsave(save_name, histo_i, path="/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/bits_bobs/test_outputs")
  }
}
mass_hist(guilty_blackwhite_cases)

##############
## Overview ##
##############

# Summarize aggregate_data_table
summary(aggregate_data_table)

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

## Grayson County (red)
hist_grayson_adjusted <- race_hist(77,guilty_blackwhite_cases)
#hist_grayson_adjusted

## Chesapeake county (blue)
hist_chesapeake_adjusted <- race_hist(550,guilty_blackwhite_cases)
#hist_chesapeake_adjusted

## Washington county (red)
hist_washington_adjusted <- race_hist(191,guilty_blackwhite_cases)
#hist_washington_adjusted

## Prince William county (blue)
hist_pwill_adjusted <- race_hist(153,guilty_blackwhite_cases)
#hist_pwill_adjusted

## Franklin county (red)
hist_franklin_adjusted <- race_hist(67,guilty_blackwhite_cases)
#hist_franklin_adjusted

## Montgomery (blue)
hist_montgomery_adjusted <- race_hist(121,guilty_blackwhite_cases)
#hist_montgomery_adjusted

# View all adjusted side by side
plot_grid(hist_grayson_adjusted, hist_chesapeake_adjusted, hist_washington_adjusted, hist_pwill_adjusted, hist_franklin_adjusted, hist_montgomery_adjusted, labels = "AUTO")

#####################################################
## Logarithmic racial histogram analyses by county ##
#####################################################

## Grayson County (red)
grayson_by_racelog <- fips_filter(guilty_bw_logs, 77)
#View(grayson_by_racelog)

# Grayson: Adjusted sentence times
dense_grayson_adjustedlog <- ggplot(grayson_by_racelog, aes(log_adjusted_sentence, fill = Race)) + 
  geom_density(alpha = 0.2)


## Chesapeake county (blue)
chesapeake_by_racelog <- fips_filter(guilty_bw_logs, 550)
#View(chesapeake_by_racelog)

# Chesapeake: Adjusted sentence times
dense_chesapeake_adjustedlog <- ggplot(chesapeake_by_racelog, aes(log_adjusted_sentence, fill = Race)) + 
  geom_density(alpha = 0.2)


## Washington county (red)
wash_by_racelog <- fips_filter(guilty_bw_logs, 191)

# Washington: Adjusted sentence times
dense_wash_adjustedlog <- ggplot(wash_by_racelog, aes(log_adjusted_sentence, fill = Race)) + 
  geom_density(alpha = 0.2)


## Prince William county (blue)
pw_by_racelog <- fips_filter(guilty_bw_logs, 191)

# Prince William: Adjusted sentence times
dense_pw_adjustedlog <- ggplot(pw_by_racelog, aes(log_adjusted_sentence, fill = Race)) + 
  geom_density(alpha = 0.2)


## Franklin county (red)
franklin_by_racelog <- fips_filter(guilty_bw_logs, 67)

# Franklin: Adjusted sentence times
dense_franklin_adjustedlog <- ggplot(franklin_by_racelog, aes(log_adjusted_sentence, fill = Race)) + 
  geom_density(alpha = 0.2)


## Montgomery (blue)
montgomery_by_racelog <- fips_filter(guilty_bw_logs, 121)

# Montgomery: Adjusted sentence times
dense_montgomery_adjustedlog <- ggplot(montgomery_by_racelog, aes(log_adjusted_sentence, fill = Race)) + 
  geom_density(alpha = 0.2)


plot_grid(dense_grayson_adjustedlog, dense_chesapeake_adjustedlog, dense_wash_adjustedlog, dense_pw_adjustedlog, dense_franklin_adjustedlog, dense_montgomery_adjustedlog, labels = "AUTO")


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
aggregate_data_table <- read.csv(file="/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/spreadsheets/aggregate_data_2007-2017.csv",head=TRUE,sep=";")

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

#######################
## Overview analysis ##
#######################

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

###############
## FUNCTIONS ##
###############

# Function to filter by fips
fips_filter <- function(table, fips){
  output <- table %>%
    filter(Fips_Where_Filed == fips)
}
#test_table <- fips_filter(guilty_blackwhite_cases, 77)
#View(test_table)

# Function to create histograms
histo_maker <- function(loc, table, measure, compare){
  output <- ggplot(table, aes(measure, fill=compare)) +
    background_grid(major = 'y', minor = "x") + 
    #geom_histogram(breaks=seq(0, 10, by=1),
    geom_histogram(breaks=seq(1095, 10950, by=365),
                   aes(y = ..density..),
                   position = 'identity', 
                   alpha = .5) + 
    labs(title=paste(loc, "Sentences", sep=" "), x="Sentence", y="Density")
  return(output)
}

#test_histo1 <- histo_maker("Location", test_table, test_table$Sentence_Time_Total, test_table$Race)
#test_histo2 <- histo_maker("Location", test_table, test_table$Sentence_Time_Total, test_table$Race)
#plot_grid(test_histo1, test_histo2, labels = "AUTO")

#########################################
## Racial histogram analyses by county ##
#########################################

## Grayson County (red)
grayson_by_race <- fips_filter(guilty_blackwhite_cases, 77)
#View(grayson_by_race)

# Grayson: Unadjusted sentence times, 3 to 30 years
hist_grayson_unadjusted <- histo_maker("Grayson", grayson_by_race, grayson_by_race$Sentence_Time_Total, grayson_by_race$Race)

# Grayson: Adjusted sentence times, 3 to 30 years
hist_grayson_adjusted <- histo_maker("Grayson", grayson_by_race, grayson_by_race$Adjusted_Sentence, grayson_by_race$Race)

# View them side by side
#plot_grid(hist_grayson_unadjusted, hist_grayson_adjusted, labels = "AUTO")


## Chesapeake county (blue)
chesapeake_by_race <- fips_filter(guilty_blackwhite_cases, 550)
#View(chesapeake_by_race)

# Chesapeake: Unadjusted sentence times, 3 to 30 years
hist_chesapeake_unadjusted <- histo_maker("Chesapeake", chesapeake_by_race, chesapeake_by_race$Sentence_Time_Total, chesapeake_by_race$Race)

# Chesapeake: Adjusted sentence times, 3 to 30 years
hist_chesapeake_adjusted <- histo_maker("Chesapeake", chesapeake_by_race, chesapeake_by_race$Adjusted_Sentence, chesapeake_by_race$Race)

# View them side by side
#plot_grid(hist_chesapeake_unadjusted, hist_chesapeake_adjusted, labels = "AUTO")


## Washington county (red)
washington_by_race <- fips_filter(guilty_blackwhite_cases, 191)
#View(washington_by_race)

# Washington: Unadjusted sentence times, 3 to 30 years
hist_washington_unadjusted <- histo_maker("Washington", washington_by_race, washington_by_race$Sentence_Time_Total, washington_by_race$Race)

# Washington: Adjusted sentence times, 3 to 30 years
hist_washington_adjusted <- histo_maker("Washington", washington_by_race, washington_by_race$Adjusted_Sentence, washington_by_race$Race)

# View them side by side
#plot_grid(hist_washington_unadjusted, hist_washington_adjusted, labels = "AUTO")


## Prince William county (blue)
pwill_by_race <- fips_filter(guilty_blackwhite_cases, 153)
#View(pwill_by_race)

# Prince William: Unadjusted sentence times, 3 to 30 years
hist_pwill_unadjusted <- histo_maker("Prince William", pwill_by_race, pwill_by_race$Sentence_Time_Total, pwill_by_race$Race)

# Prince William: Adjusted sentence times, 3 to 30 years
hist_pwill_adjusted <- histo_maker("Prince William", pwill_by_race, pwill_by_race$Adjusted_Sentence, pwill_by_race$Race)

# View them side by side
# plot_grid(hist_pwill_unadjusted, hist_pwill_adjusted, labels = "AUTO")


## Franklin county (red)
franklin_by_race <- fips_filter(guilty_blackwhite_cases, 67)

# Franklin: Unadjusted sentence times, 3 to 30 years
hist_franklin_unadjusted <- histo_maker("Franklin", franklin_by_race, franklin_by_race$Sentence_Time_Total, franklin_by_race$Race)

# Franklin: Adjusted sentence times, 3 to 30 years
hist_franklin_adjusted <- histo_maker("Franklin", franklin_by_race, franklin_by_race$Adjusted_Sentence, franklin_by_race$Race)

# View them side by side
# plot_grid(hist_franklin_unadjusted, hist_franklin_adjusted, labels = "AUTO")


## Montgomery (blue)
montgomery_by_race <- fips_filter(guilty_blackwhite_cases, 121)

# Montgomery: Unadjusted sentence times, 3 to 30 years
hist_montg_unadjusted <- histo_maker("Montgomery", montgomery_by_race, montgomery_by_race$Sentence_Time_Total, montgomery_by_race$Race)

# Montgomery: Adjusted sentence times, 3 to 30 years
hist_montg_adjusted <- histo_maker("Montgomery", montgomery_by_race, montgomery_by_race$Adjusted_Sentence, montgomery_by_race$Race)

# View them side by side
# plot_grid(hist_montg_unadjusted, hist_montg_adjusted, labels = "AUTO")


# View all adjusted side by side
plot_grid(hist_grayson_adjusted, hist_chesapeake_adjusted, hist_washington_adjusted, hist_pwill_adjusted, hist_franklin_adjusted, hist_montg_adjusted, labels = "AUTO")

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


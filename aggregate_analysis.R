#Analysis file for Virginia court data for Plea Bargain Project. By Roxanne Ready, started on Aug. 27, 2018.
install.packages("tidyverse")
install.packages('stringr')
install.packages('lubridate')
install.packages('gridExtra')
install.packages('cowplot')
install.packages('data.table')
library(tidyverse)
library(stringr)
library(lubridate)
library(gridExtra)
library(cowplot)
library(data.table)
theme_set(theme_cowplot(font_size=10)) # reduce default font size on charts

###############
## Data Prep ##
###############

# Load in the aggregate data CSV
aggregate_data_table <- read.csv(file="/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/data/aggregate_data_2007-2017.csv",head=TRUE,sep=";")

# Load in the fips code data CSV
fips_data_table <- read.csv(file="/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/data/circuit_courts_fips.csv",head=TRUE,sep=",")

# Load in demographic data CSV from 2017 census
demographic_data_table <- read.csv(file="/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/data/census_data/PEP_2017_PEPSR5H_with_ann.csv",head=TRUE,sep=",")

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

mean_sent_by_racefips <- guilty_blackwhite_cases %>%
  group_by(Race, Fips_Where_Filed) %>%
  summarise(mean_adjusted_sentence = mean(Adjusted_Sentence))
#View(mean_sent_by_racefips)

# Averages by race within a single fips
fips77 <- fips_filter(mean_sent_by_racefips, 77)
#View(fips77)

# compare differences between black and white average sentences
# county summary stats by race
county_summary <- mean_sent_by_racefips %>%
  spread(Race, mean_adjusted_sentence) %>%
  mutate(
    diff = `Black (Non-Hispanic)` - `White Caucasian (Non-Hispanic)`, # for each fips, substract avg_sent if(black) from avg_sent if(white)
    diff_perc = round(((diff/`Black (Non-Hispanic)`)*100),2) #value for black and white calculated as a percentage of black sent times
  ) %>%
  inner_join(fips_data_table,by=c("Fips_Where_Filed"="fips")) # add the name of the location by fips code
county_summary <- county_summary[,c(1,6,2,3:5)] # reorganize to put name next to fips
setnames(county_summary, old=c("Black (Non-Hispanic)","White Caucasian (Non-Hispanic)"), new=c("black_avg_sent_times", "white_avg_sent_times")) # give columns meaningful names
#View(county_summary)

#compute number of cases per race by fips
count_sent_by_racefips <- guilty_blackwhite_cases %>%
  group_by(Race, Fips_Where_Filed) %>%
  summarise(num_cases = n())

count_sent_by_racefips <- spread(count_sent_by_racefips, Race, num_cases)
setnames(count_sent_by_racefips, old=c("Black (Non-Hispanic)","White Caucasian (Non-Hispanic)"), new=c("black_num_cases", "white_num_cases")) # give columns meaningful names
#View(count_sent_by_racefips)

#add to summary table
county_summary <- inner_join(county_summary, count_sent_by_racefips, by=c("Fips_Where_Filed"))
#View(county_summary)

#add a column for total number of cases
county_summary <- mutate(county_summary, total_cases=black_num_cases + white_num_cases )
#View(county_summary)

#add a column for percentage of cases black
county_summary <- mutate(county_summary, perc_black = round(((black_num_cases/total_cases)*100),2) )
#View(county_summary)

#determine mean of the total sentence times before adjustment
mean_sent_by_racefips_t <- guilty_blackwhite_cases %>%
  group_by(Race, Fips_Where_Filed) %>%
  summarise(mean_total_sentence = mean(Sentence_Time_Total))
#View(mean_sent_by_racefips_t)

#add eval columns
mean_sent_by_racefips_t <- mean_sent_by_racefips_t %>%
  spread(Race, mean_total_sentence) %>%
  setnames(old=c("Black (Non-Hispanic)","White Caucasian (Non-Hispanic)"), new=c("black_avg_sent_times_t", "white_avg_sent_times_t")) # give columns meaningful names
mean_sent_by_racefips_t <- mean_sent_by_racefips_t %>%mutate(diff_total = black_avg_sent_times_t - white_avg_sent_times_t, # for each fips, substract avg_sent if(black) from avg_sent if(white)
         diff_total_perc = round(((diff_total/black_avg_sent_times_t)*100),2) #value for black and white calculated as a percentage of black sent times
  )
#View(mean_sent_by_racefips_t)


county_summary <- inner_join(county_summary, mean_sent_by_racefips_t, by=c("Fips_Where_Filed"))
View(county_summary)

#output the data frame as a csv file
write.csv(county_summary, file = "/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/data/county_summary.csv")

View(summary(county_summary))

# Look at only counties where at least 50 black people were charged, to reduce the swing caused by any individual case

# What did the people in the top disparate counties do?
View(fips_filter(aggregate_data_table, 105)) #Lee, one outlier skewed the data
View(fips_filter(aggregate_data_table, 760)) #Richmond, just more than a year
View(fips_filter(aggregate_data_table, 169)) #Scott
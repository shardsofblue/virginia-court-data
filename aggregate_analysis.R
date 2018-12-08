# Analysis file for Virginia court data for University of Maryland JOUR-472 Data Analysis Project. 
# Started Oct. 29, 2018
# By Roxanne Ready

# Github repository: https://github.com/shardsofblue/virginia-court-data

# Note that some actions are commented out to allow re-running the entire file without View windows popping open or duplicate files being created.

###########
## Setup ##
###########

# Install and load packages
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
library(scales)

# Set working directory
setwd("/Volumes/TOSHIBA_EXT/UMD/Data\ Journalism/Data_Analysis_Project/virginia-court-data/")

###############
## Data Prep ##
###############

# Load in the aggregate data CSV
aggregate_data_table <- read.csv(file="data/aggregate_data_2007-2017.csv",head=TRUE,sep=";")

# Load in the fips code data CSV
fips_data_table <- read.csv(file="data/circuit_courts_fips.csv",head=TRUE,sep=",")
#View(fips_data_table)

# Load in demographic data CSV from 2017 census
demographic_data_table <- read.csv(file="data/census_data/PEP_2017_PEPSR5H_with_ann.csv",head=TRUE,sep=",")

# Filter the data set for only guilty
guilty_cases <- aggregate_data_table %>%
  filter(Disposition_Code == "Guilty")
#View(guilty_cases)

# Filter the data set for only guilty and black and white races
guilty_blackwhite_cases <- aggregate_data_table %>%
  filter(Disposition_Code == "Guilty") %>%
  filter(Race == "Black (Non-Hispanic)" | Race == "White Caucasian (Non-Hispanic)")
#View(guilty_blackwhite_cases)

# Add a column of logs of ag sentence times UNUSED
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
#ggsave("test.png", plot=test, path="bits_bobs/test_outputs")

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
    ggsave(save_name, histo_i, path="bits_bobs/histograms")
  }
}

##############
## Overview ##
##############

# Summarize aggregate_data_table
summary_df <- summary(aggregate_data_table)
#View(summary_df)

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
#mass_hist_adjsent(guilty_blackwhite_cases)

###############################
## Racial analyses by county ##
###############################
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

###################################################################
## Compare differences between black and white average sentences ##
###################################################################

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

## PRE ADJUSTMENT NUMBERS ADDED (*_t)
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

# Add to county_summary data frame
county_summary <- inner_join(county_summary, mean_sent_by_racefips_t, by=c("Fips_Where_Filed"))
#View(county_summary)

#output the data frame as a csv file to view in other programs
write.csv(county_summary, file = "data/county_summary.csv")

View(summary(county_summary))

# Look at only counties where at least 50 black people were charged, to reduce the swing caused by any individual case
county_summary_filtered <- county_summary %>%
  filter(black_num_cases >= 250 & white_num_cases >= 250 & total_cases >= 1000) 
#View(county_summary_filtered)

View(summary(county_summary_filtered))

#for messing with charts without breaking things
csf_charted <- county_summary_filtered
csf_charted$Fips_Where_Filed <- factor(csf_charted$Fips_Where_Filed, as.character(csf_charted$Fips_Where_Filed))
csf_charted$name <- str_replace(csf_charted$name, " Circuit Court", "")
#View(csf_charted)

# Starting universe: Guilty, black/white, 1,000 or more cases total, 25% or more are black/white
# print(nrow(csf_charted)) #67 counties

onlygreater <- filter(csf_charted,diff >0)
#print(nrow(onlygreater)) #56

onlylesser <- filter(csf_charted,diff <=0)
#print(nrow(onlylesser)) #11

##########################
## Adjusted Days (Real) ##
##########################

# Create a chart showing the distribution of means as bars compared to a center point
chart1 <- ggplot(csf_charted, aes(x=reorder(name,-diff), diff)) +
  geom_bar(stat = "identity", 
           aes(fill = diff)
           ) +
  labs(x = "Counties", y = "Average Days Difference", title = "Days Difference Between Black and White Sentence Times") +
  theme_cowplot(font_size=6) +
  background_grid(
    major = c("xy"), minor = c("y"),
    size.major = 0.5, size.minor = 0.0, 
    colour.major = "gray60", colour.minor = "gray42") + 
  theme_gray() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1), legend.position="none")
chart1

ggsave("adjusted_real_diff.png", chart1, path="bits_bobs/bar_graphs")

######################
## Adjusted Percent ##
######################

# Create a chart showing the distribution of means as bars compared to a center point
chart2 <- ggplot(csf_charted, aes(x=reorder(name,-diff_perc), diff_perc)) +
  geom_bar(stat = "identity", 
           aes(fill = diff_perc)
  ) +
  labs(x = "Counties", y = "Average Percent Difference", title = "Percent Difference Between Black and White Sentence Times") +
  theme_cowplot(font_size=6) +
  background_grid(
    major = c("xy"), minor = c("y"),
    size.major = 0.5, size.minor = 0.0, 
    colour.major = "gray60", colour.minor = "gray42") + 
  theme_gray() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1), legend.position="none")
chart2

ggsave("adjusted_percent_diff.png", chart2, path="bits_bobs/bar_graphs")

#######################
## County Drill-down ##
#######################

# What did the people in the top disparate counties do?
#View(fips_filter(aggregate_data_table, 760)) #Richmond, just more than a year
#View(fips_filter(aggregate_data_table, 175)) #Scott

# Dataframe holding all info for the top 5 worst-offender counties
top_5_all <- guilty_blackwhite_cases %>%
  filter(Fips_Where_Filed == 175 | Fips_Where_Filed == 61 | Fips_Where_Filed == 520 | Fips_Where_Filed == 760 | Fips_Where_Filed == 53)
#View(top_5_all) #25,229 cases

# Dataframe holding grouped data for the top 5 worst-offender counties
top_5_grouped <- county_summary_filtered %>%
  filter(Fips_Where_Filed == 175 | Fips_Where_Filed == 61 | Fips_Where_Filed == 520 | Fips_Where_Filed == 760 | Fips_Where_Filed == 53)
#View(top_5_grouped)

#######################
## Finding Anecdotes ##
#######################

# UNSUCCESSFUL
norfolk_all <- fips_filter(guilty_blackwhite_cases, 710)
#View(norfolk_all)

norfolk_drill_down <- norfolk_all %>%
  filter(str_detect(norfolk_all$Code_Section, "18.2-58"), #robbery
         #str_detect(norfolk_all$Charge_Descriptions, "INT TO SELL"),
         Was_Amended == "True",
         Num_Charges == 1,
         Year_Filed == 2015,
         Trial_or_Plea == "Plea")
#View(norfolk_drill_down)

# UNSUCCESSFUL
southampton_all <- fips_filter(guilty_blackwhite_cases, 175)
#View(southampton_all)

southampton_drill_down <- southampton_all %>%
  filter(str_detect(southampton_all$Code_Section, "18.2-250"),
         str_detect(southampton_all$Charge_Descriptions, "FENTANYL") | str_detect(southampton_all$Charge_Descriptions, "OXYCODONE"),
         #Was_Amended == "True",
         #Num_Charges == 3,
         #Year_Filed == 2013 | Year_Filed == 2014 | Year_Filed == 2015 | Year_Filed == 2016 | Year_Filed == 2017,
         Trial_or_Plea == "Plea")
#View(southampton_drill_down)

# ANECDOTE FOUND
richmond_all <- fips_filter(guilty_blackwhite_cases, 760)
#View(richmond_all)

richmond_drill_down <- richmond_all %>%
  filter(str_detect(richmond_all$Code_Section, "18.2-250"), #drug posession
         str_detect(richmond_all$Charge_Descriptions, "HEROIN"),
         Num_Charges == 1,
         Year_Filed == 2017)
#View(richmond_drill_down)

## LIMITING THE DATASET
# Dataframe where total cases > 10,000
over_10k <- csf_charted %>%
  filter(total_cases > 10000)
View(over_10k)

# Create a chart showing the distribution of means as bars compared to a center point
chart3 <- ggplot(over_10k, aes(x=reorder(name,-diff_perc), diff_perc)) +
  geom_bar(stat = "identity", 
           aes(fill = diff_perc)
  ) +
  labs(x = "Counties", y = "Average Percent Difference", title = "Percent Difference Between Black and White Sentence Times") +
  theme_cowplot(font_size=6) +
  background_grid(
    major = c("xy"), minor = c("y"),
    size.major = 0.5, size.minor = 0.0, 
    colour.major = "gray60", colour.minor = "gray42") + 
  theme_gray() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1), legend.position="none")
chart3

ggsave("adjusted_percent_diff_10k.png", chart3, path="bits_bobs/bar_graphs")

###############################
## Number of Cases Over Time ##
###############################

# Count the number of cases in each county in each year
grouped_by_year <- top_5_all %>%
  group_by(Fips_Where_Filed, Year_Filed) %>%
  summarise(num_cases = n(),
            avg_init_time = mean(Sentence_Time_Total),
            avg_adj_time = mean(Adjusted_Sentence))
#View(grouped_by_year)

# Join county names info
grouped_by_year <- grouped_by_year %>%
  inner_join(fips_data_table,by=c("Fips_Where_Filed"="fips"))  # add the name of the location by fips
setnames(grouped_by_year,old=c("name"), new=c("County")) # give columns meaningful names
grouped_by_year$County <- str_replace(grouped_by_year$County, " Circuit Court", "") # trim off repetitive naming
grouped_by_year$County <- factor(grouped_by_year$County) # make counties distinct
grouped_by_year$Year_Filed <- factor(grouped_by_year$Year_Filed) # make years distinct

# Plot number of cases by fips/year
i1 <- grouped_by_year %>%
  ggplot(aes(x = Year_Filed, 
             y = num_cases,
             group = County,
             colour = County,
             label = County)) +
  geom_line(stat = "identity") +
  ggtitle("Number of Guilty Cases") +
  xlab("Year") +
  ylab("Number") +
  theme_gray() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
i1

# Plot sentence times by fips/year
i2 <- grouped_by_year %>%
  ggplot(aes(x = Year_Filed, 
             y = avg_adj_time,
             group = County,
             colour = County,
             label = County)) +
  geom_line(stat = "identity") +
  ggtitle("Average Sentence Times") +
  xlab("Year") +
  ylab("Days Sentenced") +
  theme_gray() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
i2

# Plot sentence times by race/fips/year (Line 232)

###############################################
## Repeat analysis with added year breakdown ##
###############################################

# would like to see how disparity has changed over time. This means repeating the spread on line 155 and the analysis below it to further break out the groups by race and adding difference to each year
#mean_sent_by_racefipsyear <- #stuff#
#View(mean_sent_by_racefipsyear)


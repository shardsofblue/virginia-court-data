# Code scraps

#brew install freetds --with-unixodbc
#brew install psqlodbc
#brew install mysql
#brew install sqliteodbc
#install.packages("odbc")

# How to write a function
function_name <- function(var1, var2="default value"){
  #do stuff, passing var1 and var2 as needed
}

## Connecting to the remote DB ##
# Connect to the remote DB
con <- DBI::dbConnect(odbc::odbc(),
                      Driver   = "/usr/local/lib/psqlodbcw.so",
                      Server   = "va-court-data.c7epjo1jekfc.us-east-1.rds.amazonaws.com",
                      Database = "vacourtscraper",
                      UID      = rstudioapi::askForPassword("readonly"),
                      PWD      = rstudioapi::askForPassword("HamptonRoadsTreeLeaves"),
                      Port     = 5432)

virginia_dc_2017_00 <- read_csv(col_types = cols(RestrictionEndDate=col_character()),'data/district_criminal_2017_anon_UG6NRN/district_criminal_2017_anon_00.csv')

## R Queries ##

# Create a filtered version of the data set only for Black (Non-Hispanic)
black_only_cases <- aggregate_data_table %>%
  filter(Race == "Black (Non-Hispanic)") %>%
  group_by(Race) %>%
  summarise(total = n())
View(black_only_cases)

# long version of above table for reference
black_only_cases <-  
  filter(aggregate_data_table, Race == "Black (Non-Hispanic)") %>%
  group_by(aggregate_data_table, Race) %>%
  summarise(aggregate_data_table, total = n())
View(black_only_cases)


# Histogram using qplot
qplot(aggregate_data_table$Adjusted_Sentence,
      geom="histogram",
      binwidth = 30,  
      main = "Histogram for Sentence", 
      xlab = "Sentence Length",  
      ylab = "Number Cases",
      xlim=c(0,500))
#fill=I("blue"), 
#col=I("red"), 
#alpha=I(1.0))

# Histogram using ggplot
ggplot(data=aggregate_data_table, aes(aggregate_data_table$Adjusted_Sentence)) + 
  # 10 years into one year buckets
  # geom_histogram(breaks=seq(0, 3650, by=365), 
  # 50 years in 1 year breaks
  geom_histogram(breaks=seq(0, 18250, by=365),
                 col="black", 
                 fill="black", 
                 alpha = 1.0) + 
  labs(title="Histogram for Sentence", x="Sentence", y="Count")
#+ scale_fill_gradient("Count", low="green", high="red")
#+ xlim(c(18,52)) 
#+ ylim(c(0,30))

# layered histograms
ggplot(guilty_plea_cases_grayson, aes(Adjusted_Sentence, fill=Race)) + 
  geom_histogram(breaks=seq(0, 10000, by=365),
                 aes(y = ..density..),
                 position = 'identity', 
                 alpha = .5) + 
  labs(title="Histogram for Sentence", x="Sentence", y="Count")

# density curves
ggplot(guilty_plea_cases_grayson, aes(Adjusted_Sentence, fill = Race)) + 
  geom_density(alpha = 0.2)

# Cycle through fips and print out the associated circuit court
fips_cycle <- function(table){
  #seq <- c(1:10)
  #for(i in seq) {
  for(i in 1:nrow(table)) {
    court_name <- table[i, 2]
    court_fips <- table[i,1]
    print(paste("The fips for", court_name, "is", court_fips, sep=" "))
  }
}
#fips_cycle(fips_data_table)

# Create histograms for each circuit court by fips, combine into single image, save
#unfinished, errors out
mass_hist_single <- function(starting_df){
  fips_df <- fips_data_table #define fips dataframe
  storage_list <- list() #initialize a list
  
  for(i in 1:nrow(fips_df)) { #loop through fips codes
    loc_fips <- fips_df[i,1]
    loc_name <- fips_df[i,2]
    
    table_i <- starting_df %>% #create a dataframe for the fips
      filter(Fips_Where_Filed == loc_fips)
    
    histo_i <- histo_maker(loc_name, table_i, table_i$Sentence_Time_Total, table_i$Race) #make a histograph for the fips code
    
    plot_grid(labels="AUTO")
    
    storage_list[[i]] <- histo_i #store the histograph in the list
  }
  #View(storage_list)
  storage_list[[1]]
}
mass_hist_single(guilty_blackwhite_cases)


# individual histos by fips
#########################################
## Racial histogram analyses by county ##
#########################################

# Automated creation of histograms for sentence time
mass_hist_adjsent(guilty_blackwhite_cases)


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
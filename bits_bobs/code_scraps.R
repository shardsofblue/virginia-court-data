# Code scraps

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
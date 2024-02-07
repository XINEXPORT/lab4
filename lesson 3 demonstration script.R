# retrieve your working directory - files are listed in the files pane at the bottom right of the RStudio display
getwd()
# to move the working directory up one level use the command below
setwd("..")
#then set it again
setwd("/Users/tel2320/Documents")
getwd()
# to specify a subfolder use the tilde character
setwd("~/ITSE_2309_Data_Files")
getwd()
# to use an installed package you must load it using the library function
library("tidyverse")
# if the package is not installed on your computer you can use the tools menu or use the command below to install it
install.packages("tidyverse")
# readxl is a package contained in the tidyverse package load this package to be able to read the spreadsheet data into an R tibble
library("readxl")
# the excel data will be stored in the tibble mortality_data
mortality_data <- read_excel("child_mortality_rates.xlsx", sheet = 1)
# to display the tibble
mortality_data
# to display the first 10 rows, this shows the headers, and the data types of each column
head(mortality_data)
# to display a different number of rows
head(mortality_data, 5)
# to display the last 6 rows
tail(mortality_data)
# to display the last 4 rows
tail(mortality_data, 4)
# the summary function displays statistics about the tibble
summary(mortality_data)
# to limit the summary to one column
summary(select(mortality_data, Year))
# another example with two columns, each containing spaces
summary(select(mortality_data, '01-04 Years', '10-14 Years'))
# To visually plot data, it might make sense to pivot the data so that it the year is repeated for times once for each age group. (3 columns by 467 rows). 
# This is a process known as “melting” the data. 
# create a new tibble by pivoting the wide data (5 columns) to long data (3 columns)
# The pivot_longer() function takes the wide data storing the age groups on a single row by year and “melts” the data so that each age group and its mortality rate for the year is stored in individual rows. 
mortality_long <- pivot_longer(mortality_data, cols = c("01-04 Years", "05-09 Years", "10-14 Years", "15-19 Years"), names_to = "AgeGroup", values_to = "DeathRate")
# display the new tibble
mortality_long
# add a new column to the tibble with the rate expressed as a whole number
mortality_long <-  mutate(mortality_long, DeathRateMultiplied = DeathRate * 100000)
# display the tibble
mortality_long
# overwrite an existing column
mortality_long <-  mutate(mortality_long, DeathRate = DeathRate * 100000)
# display the tibble
mortality_long
# add a column
# Add a column that assigns a decade to each row
# in this case we will name the column decade, divide the Year column values by 10 and then multiply by 10 to get the decade that the year falls into.
mortality_long <- mutate(mortality_long, Decade = (Year %/% 10) * 10)
# display the 60 rows of the  tibble to see the decades
print(mortality_long,n = 60)
# To save the mortality_long tibble into the current working directory
saveRDS(mortality_long, "mortality_long.rds")
# To read the saved RDS file back into a tibble from the current working directory
mortality_long_2 <- readRDS("mortality_long.rds")
# display the tibble named differently for clarity
mortality_long_2
# pipe a group by function, meaning take the output of the function and use it as the input of a related function
# in this example we will group by the Decade column and then use the pipe operator to calculate two columns
# the average number of deaths per year for each decade and the total number of deaths for the decade along with counting the number of rows in each decade. 
# All should be 40 except for the last one because the data is incomplete for the last decade. 
mortality_long %>% 
  group_by(Decade) %>%
  summarize(AvgDeaths = mean(DeathRate),
            DecadeTotal = sum(DeathRate),
            numRows = n())
# drawing a plot line visualization using the ggplot2 package that comes with tidyverse
# in this case we are the ggplot function, which in turn asks for the following arguments
# the name of the tibble to be plotted (mortality_long)
# an embedded aes function that defines the x axis (the horizontal column) and the y axis (the vertical column)
# the column that you wish to use for the color lines of the plot
# and a + operator to add a geometric line to the plot
ggplot(mortality_long, aes(x = Year, y = DeathRate, color = AgeGroup)) + geom_line()

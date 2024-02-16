#Christine Hoang
avocados <- read_csv("avocado.csv")

avocados

summary(avocados)

select(avocados, "Date", "AveragePrice", "TotalVolume", "TotalBags")

summary(select(avocados, "AveragePrice", "TotalVolume"))

tail(select(avocados, "Date", "AveragePrice", "TotalVolume"), 5)

EstimatedRevenue <- mutate(avocados, EstimatedRevenue = (TotalVolume*AveragePrice))
EstimatedRevenue

avocados_by_region<-avocados %>%
  group_by(region, type)%>%
  summarize(AveragePrice = mean(AveragePrice))
  
avocados_by_region

#1.	How many unique regions are there?
# There are 54 regions

#2.	What is the average price for each type of avocado (organic and conventional)? 
# conventional is 1.16
# organic is 1.65

avg_avocado_price<-avocados %>%
  group_by(type)%>%
  summarize(AveragePrice = mean(AveragePrice))

avg_avocado_price

#3.	Which region has the lowest average price for organic avocados? (Create a tibble that has the correct data. 
#Then, use RStudio to view the tibble and sort by the AveragePrice and type columns.)
#	CincinnatiDayton

lowest_price<-avocados %>%
  group_by(region, type) %>%
  summarize(AvgPrice = min(AveragePrice))

lowest_price








#demo code
setwd("C:/Users/Test/src/rstudio/lab4")

library("readxl")
library("tidyverse")

child<-read_xlsx("child_mortality_rates.xlsx")

child
#im going to use child<-read_csv("avocados")

summary(child)

#selecting specific columns
select(child, "Year", "01-04 Years", "05-09 Years")
summary (select(child, "01-04 Years", "05-09 Years"))

#get 3 of the columns and get the last 10 rows
tail(select(child, Year, "01-04 Years", "05-09 Years", "10-14 Years"), 10)

#pivot longer to display column data as rows
child_long<-pivot_longer(child, cols = c("01-04 Years", "05-09 Years", "10-14 Years", "15-19 Years"), names_to = "AgeGroup", values_to="DeathRate")

#multiple by 100 to get readable percentage
child_long<-mutate(child_long, Formatted_Percentage = DeathRate*100)
child_long

child_long_by_age<- child_long %>%
  group_by(AgeGroup) %>%
  summarize(DeathRateAvg = mean(DeathRate),
            numrows = n())

child_long_by_age




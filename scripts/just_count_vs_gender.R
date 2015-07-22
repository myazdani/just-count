### just_count_vs_gender.R
##
library(dplyr)
library(plotly)
setwd("~/Documents/misc_work/just_count/")

just.counts = read.csv("./processedData/enron-emails-just-counts.csv", header = TRUE, stringsAsFactors = FALSE)
genders.1 = read.csv("./processedData/names-gender_first_batch.csv", header = TRUE, stringsAsFactors = FALSE)
genders.2 = read.csv("./processedData/names-gender_second_batch.csv", header = TRUE, stringsAsFactors = FALSE)

genders = rbind(genders.1, genders.2)

just.genders = merge(just.counts, genders)

just.genders.known = subset(just.genders, gender != "None")

ggplot(subset(just.genders.known, num.emails < 1000001), aes(x = num.emails, y = median.just.count/median.char.count, colour = gender)) + geom_point() -> p

# over 80 percent of senders sent less than 50 emails
small.num.emails.females = subset(just.genders.known, num.emails < 50 & gender == "female") 
small.num.emails.males = subset(just.genders.known, num.emails < 50 & gender == "male") 

female.just.rates = small.num.emails.females$median.just.count/small.num.emails.females$median.word.count
male.just.rates = small.num.emails.males$median.just.count/small.num.emails.males$median.word.count

t.test(female.just.rates, male.just.rates)

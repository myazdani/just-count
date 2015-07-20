## just_count.R
##
library(dplyr)
library(plotly)
setwd("~/Documents/misc_work/just_count/")


## data processed and provided by Arne Hendrik Schulz
## http://www.ahschulz.de/enron-email-data/
load("./data/enron_mysqldump.RData")

## basic word count function
word.count <- function(x, word){
  res = unlist(strsplit(x, split = " "))
  num.word = length(which(res %in% word))
  return(num.word)
}

## key stats
message$just.count = sapply(message$body, FUN = function(txt) word.count(tolower(txt), "just") )
message$word.count = sapply(message$body, FUN = function(txt) length(unlist(strsplit(txt, split = " "))))
message$char.count = sapply(message$body, nchar)

# how does just count compare to a stop word count
message$the.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "the") )

# how does just count compare to a company-related word counts
message$lunch.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "lunch") )
message$dinner.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "dinner") )
message$coffee.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "coffee") )
message$beer.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "beer") )
message$enron.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "enron") )
message$chat.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "chat") )


## aggregate counts by sender
message %>%
  group_by(sender) %>%
  summarise(num.emails = n(),median.just.count = median(as.numeric(just.count)),
            median.word.count = median(as.numeric(word.count)),
            median.char.count = median(as.numeric(char.count)),
            median.the.count = median(as.numeric(the.count)),
            median.lunch.count = median(as.numeric(lunch.count)),
            median.dinner.count = median(as.numeric(dinner.count)),
            median.coffee.count = median(as.numeric(coffee.count)),
            median.beer.count = median(as.numeric(beer.count)),
            median.enron.count = median(as.numeric(enron.count))) %>% as.data.frame() -> res

res$email.type = "other"
res[grep("enron", res$sender),"email.type"] = "enron"

## select only senders that are "active" in data set
res.frequent = subset(res, num.emails > 4) # 5 or more emails gives us roughly 25% of all email addresses sent in data

py <- plotly()
p = ggplot(res.frequent, aes(x = median.char.count, y = median.just.count, label = sender)) + geom_text()
#response <- py$ggplotly(p, kwargs=list(filename="just-vs-char-counts", fileopt="overwrite"))


enron.emails = subset(res, email.type == "enron")
p = ggplot(enron.emails, aes(x = median.char.count, y = median.just.count, label = sender)) + geom_text()
res.merged = merge(res, employeelist, by.x = "sender", by.y = "Email_id")

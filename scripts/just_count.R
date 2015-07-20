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
#-----------------------------------------------------------------------------------
##
# how does just count compare to a stop word count
##
#-----------------------------------------------------------------------------------
message$the.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "the") )

#-----------------------------------------------------------------------------------
##
## how does just count compare to a company-related word counts
##
#-----------------------------------------------------------------------------------
message$lunch.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "lunch") )
message$dinner.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "dinner") )
message$coffee.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "coffee") )
message$beer.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "beer") )
message$enron.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "enron") )
message$chat.count = sapply(message$body, FUN = function(txt)  word.count(tolower(txt), "chat") )

#-----------------------------------------------------------------------------------
##
## aggregate counts by sender
##
#-----------------------------------------------------------------------------------
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

#-----------------------------------------------------------------------------------
##
##select only senders that are "active" in data set
##
#-----------------------------------------------------------------------------------
res.frequent = subset(res, num.emails > 4) # 5 or more emails gives us roughly 25% of all email addresses sent in data

py <- plotly()
p = ggplot(res.frequent, aes(x = median.char.count, y = median.just.count, label = sender)) + geom_text()
#response <- py$ggplotly(p, kwargs=list(filename="just-vs-char-counts", fileopt="overwrite"))



#-----------------------------------------------------------------------------------
##
## select enron email addresses
##
#-----------------------------------------------------------------------------------


enron.emails = subset(res, email.type == "enron")
p = ggplot(enron.emails, aes(x = median.char.count, y = median.just.count, label = sender)) + geom_text()
res.merged = merge(res, employeelist, by.x = "sender", by.y = "Email_id")

#-----------------------------------------------------------------------------------
##
## find first name from email address
##
#-----------------------------------------------------------------------------------
res$sender = as.character(res$sender)
get.first.name = function(x){
  strsplit(x, split = "@")[[1]][1] -> sender.name
  sender.name.split = strsplit(sender.name, split = "\\.")[[1]]
  if (length(sender.name.split) < 2) {
    return("UNKNOWN")
  }
  else{
    return(sender.name.split[1])
  }
}

res$first.name = sapply(res$sender, get.first.name)
res$name.num.chars = sapply(res$first.name, nchar)

#-----------------------------------------------------------------------------------
##
## select email addresses that have a first name and the first name is longer than 2
## characters and the sender has sent more than 4 eamil (active email participant)
##
#-----------------------------------------------------------------------------------
res.relevant = subset(res, first.name != "UNKNOWN" & num.emails > 4 & name.num.chars > 2)


## save unique names from data 
write.csv(unique(res.relevant[,"first.name"]), file = "./processedData/unique-first-names.csv", row.names = FALSE, quote = FALSE)

write.csv(res.relevant, file = "./processedData/enron-emails-just-counts.csv", row.names = FALSE, quote = FALSE)


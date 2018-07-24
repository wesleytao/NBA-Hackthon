library(httr)
library(lubridate)
library(rvest)
library(jsonlite)
library(readxl)
library(dplyr)

#Read in raw data (manipulated in excel to give URL identifiers to use on basketball-reference
#To pull down game times
#Note this same code logic was used to pull in data for the test set as well!

trainraw <- read_xlsx("training_with_br_reference.xlsx",sheet="training_with_br_reference")

#Create vector of games to search
gamevector <- as.vector(trainraw$ID_For_BR)
gamevector <- unique(gamevector)

#Create empty data frames for loop to read data into
gamedf <- data.frame()
masterdf <- data.frame()

#Loop query of basketball-reference over each game in the training data
for (i in gamevector){
    url <- paste("https://www.basketball-reference.com/boxscores/",i,".html",
                 sep="")
    
time_i<-read_html(url) %>% 
    html_nodes(".scorebox_meta") %>%
    html_text(trim=TRUE)

clean1 <- strsplit(time_i,",")

gametime <- clean1[[1]][1]

gamedf <- gametime %>% as.data.frame()

gamedf$gameid <- i

masterdf <- rbind(masterdf,gamedf)

}


names(masterdf)[1] <- "TipOff"

#Merge with train raw data
mergedtestset <- merge(masterdf,trainraw,by.x="gameid",by.y="ID_For_BR")

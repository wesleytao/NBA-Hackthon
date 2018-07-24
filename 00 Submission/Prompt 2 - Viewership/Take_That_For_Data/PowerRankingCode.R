###########BEGIN SCRIPT###########

#Clear global environment, install packages, and set working directory
rm(list=ls())

#install.packages("rvest")
#install.packages("rJava")
#install.packages("xlsxjars")
#install.packages("xlsx")

#install.packages("Rserver")
#library(Rserve)
#Rserve()

#SectorGadget vignette
#vignette("selectorgadget")

library(rvest)
library(xlsx)
library(xml2)

#Step 1: Set up first column for rankings
rank <- c("Rank",1:45)

#STEP 2.A: Store first date for URL in a vector 
first_article<-c("22993440")

#STEP 2.B: Scrape power rankings for October 10, 2016
for (i in first_article){
    
    #Store URL in Vector
    power_rankings_i <- paste("http://www.espn.com/nba/story/_/id/", i, sep="")
    
    #Scrape
    pr_i<-read_html(power_rankings_i) %>% 
        html_nodes("b") %>%
        html_text()
    pr_i
    #Clean scraped data to exclude extraneous character (club record, etc.)
    pr_i<-substring(pr_i,regexpr(pattern ='. ',pr_i)+2)
    
    #Create clean vector where header is the date
    pr_a<-c(first_article,pr_i)
    
    print(pr_a)
}

pr_a

#Step 3.A: Convert clean vector into a data frame with standard length of 40
pr <- c(pr_a, rep(NA, 46-length(pr_a)))
pr_frame <- data.frame(1:46)

#STEP 3.B: Store all articles for URL in a vector 
partapages<-c("20969020","21113212","21209410","21265048","21351221","21476052",
              "21576655","21654979","21731935","21768034","21839268","21904240",
              "21993425","22041441","22143421","22211929","22286300","22614518",
              "22724518","22775711","22910812","22993440")

#STEP 4: Scrape power rankings for all dates after October 12, 2017
for (i in partapages){
    
    #Store URL in Vector
    power_rankings_i <- paste("http://www.espn.com/nhl/story/_/id/", i, sep="")
    
    #Scrape
    pr_i<-read_html(power_rankings_i) %>% 
        html_nodes("b") %>%
        html_text()
    pr_i
    
    #Clean scraped data to exclude extraneous character (club record, etc.)
    pr_i<-substring(pr_i,regexpr(pattern ='. ',pr_i)+2)
    
    pr_i
    
    #Create clean vector where header is the date

    date<-read_html(power_rankings_i) %>% 
        html_nodes("span.timestamp") %>%
        html_text()
    date<- tail(date,1)
    pr_b<-c(date,pr_i)
    
    
    #Convert clean vector into a data frame with standard length of 40
    pr <- c(pr_b, rep(NA, 46-length(pr_b)))
    
    #Append each clean vector as a new column in the final data frame
    pr_frame <- cbind(pr,pr_frame)
    print(pr_frame)
    
}
View(pr_frame)


##Two weeks were randomly in a different format
vector2017partb <- c(19:20)

for (i in vector2017partb){
    
    #Store URL in Vector
    power_rankings_i <- paste("http://www.espn.com/nba/story/_/page/powerrankings-", i, sep="")
    
    #Scrape
    pr_i<-read_html(power_rankings_i) %>% 
        html_nodes("b") %>%
        html_text()
    pr_i
    
    #Clean scraped data to exclude extraneous character (club record, etc.)
    pr_i<-substring(pr_i,regexpr(pattern ='. ',pr_i)+2)
    
    pr_i
    
    #Create clean vector where header is the date
    date<-read_html(power_rankings_i) %>% 
        html_nodes("span.timestamp") %>%
        html_text()
    date<- tail(date,1)
    
    pr_b<-c(date,pr_i)
    
    #Convert clean vector into a data frame with standard length of 40
    pr <- c(pr_b, rep(NA, 46-length(pr_b)))
    
    #Append each clean vector as a new column in the final data frame
    pr_frame <- cbind(pr,pr_frame)
    print(pr_frame)
    
}


#STEP 5: Export to Excel
write.xlsx(pr_frame,file="PowerRankings2018.xlsx",sheetName="PowerRankings",col.names=FALSE,row.names=FALSE,append=TRUE)

###########END SCRIPT###########

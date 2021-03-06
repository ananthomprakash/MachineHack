library(Metrics)
library(readr)
library(xgboost)
library(sqldf)
library(openxlsx)

setwd("C:\\Kaggle\\BooksPrice\\CV Scrd Trn Datasets")
file_names <- list.files("C:\\Kaggle\\BooksPrice\\CV Scrd Trn Datasets")
file_names

Files_To_Remove <- c("20191003_Stacking01_DS.csv","20191004_Stack02_DS.csv")
file_names <- file_names[!(file_names %in% Files_To_Remove)]
file_names

training01 <- read.csv("20191004_Stack02_DS.csv", stringsAsFactors = FALSE, check.names = FALSE)
training01$Price_Log_Pred_LGB_ENS <- NULL
training01 <- training01[order(training01$id),]

for(i in 1:length(file_names)) {
  temp_trn <- read.csv(file_names[i], stringsAsFactors = FALSE, check.names = FALSE)
  temp_trn <- temp_trn[order(temp_trn$id),]
  training01[,paste("Price_Log_Pred",i,sep="")] <- temp_trn[,ncol(temp_trn)]
  remove(temp_trn)
}

setwd("C:\\Kaggle\\BooksPrice\\CV Scrd Tst Datasets")

testing01 <- read.csv("20191004_Stack02_DS.csv", stringsAsFactors = FALSE, check.names = FALSE)
testing01 <- testing01[,c("id",names(training01)[5:11])]
testing01 <- testing01[order(testing01$id),]

for(i in 1:length(file_names)) {
  temp_trn <- read.csv(file_names[i], stringsAsFactors = FALSE, check.names = FALSE)
  temp_trn <- temp_trn[order(temp_trn$id),]
  testing01[,paste("Price_Log_Pred",i,sep="")] <- temp_trn[,ncol(temp_trn)]
  remove(temp_trn)
}

fe_names <- names(testing01)[2:ncol(testing01)]
new_names <- seq.int(length(fe_names))
new_names <- paste("Price_Log_Pred_",new_names,sep="")
new_names

names(training01)[5:ncol(training01)] <- new_names
names(testing01)[2:ncol(testing01)] <- new_names

write.csv(training01,"C:\\Kaggle\\BooksPrice\\Participants_Data\\Data_Train03.csv",row.names = FALSE)
write.csv(testing01,"C:\\Kaggle\\BooksPrice\\Participants_Data\\Data_Test03.csv",row.names = FALSE)
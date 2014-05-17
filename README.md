# Description of run_analysis.R

## Libraries

library(plyr)
library(reshape)
library(reshape2)
library(Hmisc)

## Working directory  

This will be folder with subfolder containing data extracted from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

setwd("~/ownCloud/Coursera/Getting and Cleaning Data/project")


## Merge training and test data

act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = F) 
colnames(act_labels) <- c("id", "description") 
x_labels <- readLines("./UCI HAR Dataset/features.txt") 

## Load and transform training data

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=F)
colnames(x_train) <- x_labels
subject_train <- as.data.frame(readLines("./UCI HAR Dataset/train/subject_train.txt")) 
colnames(subject_train) <- "subject"
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = F)
colnames(activity_train) <- "id" 
train <- cbind(subject_train,activity_train,x_train) 
mrg_train <- arrange(join(act_labels,train),id)

## Load and transform test data

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=F)
colnames(x_test) <- x_labels
subject_test <- as.data.frame(readLines("./UCI HAR Dataset/test/subject_test.txt"))
colnames(subject_test) <- "subject"
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = F)
colnames(activity_test) <- "id" 
test <- cbind(subject_test,activity_test,x_test) 
mrg_test <- arrange(join(act_labels,test),id) 

## Combine training and test data and extract required variables

combine <- merge(mrg_train, mrg_test, all.x =T, all.y = T) 
combine$id <- NULL 
combine <- combine[,c(2,1,3:563)] 
extract <- combine[,grep("mean|std|subject|description", names(combine))] 
write.table(extract, "./tidy_data1.txt", sep = "\t", col.names = T) 

## Reshape data for analysis

melted <- melt(extract, id=c("subject","description")) 
data <- dcast(melted, subject+description ~ variable, mean) 
data <- data[order(as.numeric(as.character(data$subject))), ] 
names(data) <- gsub("[[:digit:]]", "", names(data)) 
write.table(data, file = "./tidy_data.txt", sep = "\t", col.names = T, row.names = F) 

##  Generate metadata for tidy_data.txt

sink(file = "./tidy_data_metadata.txt") 
print.contents.data.frame(data)
sink() 

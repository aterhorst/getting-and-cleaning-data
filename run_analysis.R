######################################## 
#                                      #
# Getting and Cleaning Data Assignment #
#                                      #
########################################


# Load relevant R libraries

library(plyr)
library(reshape)
library(reshape2)
library(gdata)
library(utils)
library(Hmisc)

# set working directory.  This will be folder of files extracted from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

setwd("C:/Users/ter053/ownCloud/Coursera/Getting and Cleaning Data/project") # Change path as needed
fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile ="UCI HAR Dataset.zip")
unzip("UCI HAR Dataset.zip", exdir = ".")
setwd("~/ownCloud/Coursera/Getting and Cleaning Data/project")
fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile ="UCI HAR Dataset.zip")
unzip("UCI HAR Dataset.zip", exdir = ".")



# Merge training and test data

act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = F) # read in activity numbers and corresponding descriptions
colnames(act_labels) <- c("id", "description") # add header information (id used for merging later)
x_labels <- readLines("./UCI HAR Dataset/features.txt") # read in measurement header information


## Load and transform training data

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=F)  # read in source measurements
colnames(x_train) <- x_labels # add header information
subject_train <- as.data.frame(readLines("./UCI HAR Dataset/train/subject_train.txt"))  # read in subjects
colnames(subject_train) <- "subject" # add header information
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = F)
colnames(activity_train) <- "id"   # add header information (use for merging later)
train <- cbind(subject_train,activity_train,x_train) # combine data frames horizontally
mrg_train <- arrange(join(act_labels,train),id) # replace activity numbers with descriptive strings

## Load and transform test data

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=F)  # read in source measurements
colnames(x_test) <- x_labels # add header information
subject_test <- as.data.frame(readLines("./UCI HAR Dataset/test/subject_test.txt"))  # read in subjects
colnames(subject_test) <- "subject" # add header information
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = F)
colnames(activity_test) <- "id"   # add header information (use for merging later)
test <- cbind(subject_test,activity_test,x_test) # combine data frames horizontally
mrg_test <- arrange(join(act_labels,test),id) # replace activity numbers with descriptive strings

## Combine training and test data

combine <- merge(mrg_train, mrg_test, all.x =T, all.y = T) # create merged data set
combine$id <- NULL # remove "id" as no longer needed
combine <- combine[,c(2,1,3:563)] # reorder columns
extract <- combine[,grep("mean|std|subject|description", names(combine))] # extract subject, activity description, mean and std deviations only

# Reshape data for analysis

melted <- melt(extract, id=c("subject","description")) # generate skinny data frame
data <- dcast(melted, subject+description ~ variable, mean) # summarise data
headata <- data[order(as.numeric(as.character(data$subject))), ]  # sort on subject
names(data) <- gsub("[[:digit:]]", "", names(data)) # remove numbers in measurement headers
names(data) <- gsub("[(\\)\\]", "", names(data)) # remove brackets
write.table(data, file = "./tidy_data.txt", sep = "\t", col.names = T, row.names = F) # generate tidy data set

#  Generate metadata for tidy_data.txt
# sink(file="tidy_data_metadata.txt") # pipe output to file
contents.data.frame(data)
# sink(file="tidy_data_format.txt") # pipe output to another file
file <- tempfile()
write.fwf(x=data, file=file, formatInfo=TRUE)
#sink() # revert to R console
# End of script


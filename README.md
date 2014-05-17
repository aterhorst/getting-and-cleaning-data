<<<<<<< HEAD
# Explanation of run_analysis.R

## Required R libraries

This script requires four R libraries:

```{r}
library(plyr)
library(reshape)
library(reshape2)
library(Hmisc)
```
## Set working directory

The working directory contains the downloaded compressed data file (downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) subfolders containing extracted data files.  The script needs to be run from the root folder.


```{r}
setwd("~/ownCloud/Coursera/Getting and Cleaning Data/project")
```

## Load data

###  Load general data

Read in activity description data as a data frame and assign column headings.

```{r}
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = F) 
colnames(act_labels) <- c("id", "description") 
```

Read in variable names for training data measurements.

```{r}
x_labels <- readLines("./UCI HAR Dataset/features.txt") 
```

### Load and merge training data

Load training measurement, activity and subject data into separate data frames and assign variable names.

```{r}
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=F)
colnames(x_train) <- x_labels 
subject_train <- as.data.frame(readLines("./UCI HAR Dataset/train/subject_train.txt")) 
colnames(subject_train) <- "subject" 
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = F)
colnames(activity_train) <- "id"
```

Combine subject, activity, and measurement training data into a single data frame.  Replace activity number with activity description.

```{r}
train <- cbind(subject_train,activity_train,x_train) # combine data frames horizontally
mrg_train <- arrange(join(act_labels,train),id)
```

### Load and merge test data

Load test measurement, activity and subject data into separate data frames and assign variable names.

```{r}
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=F)
colnames(x_test) <- x_labels 
subject_test <- as.data.frame(readLines("./UCI HAR Dataset/test/subject_test.txt")) 
colnames(subject_test) <- "subject" 
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = F)
colnames(activity_test) <- "id"
```

Combine subject, activity, and measurement training data into a single data frame.  Replace activity number with activity description.

```{r}
test <- cbind(subject_test,activity_test,x_test) # combine data frames horizontally
mrg_test <- arrange(join(act_labels,test),id)
```

### Merge training and test data

Cocatenate the training and test data.  Remove unnecessary columns. Subset mean and standard deviation variables. Reorder according to subject.

```{r}
combine <- merge(mrg_train, mrg_test, all.x =T, all.y = T) 
combine$id <- NULL 
combine <- combine[,c(2,1,3:563)] 
extract <- combine[,grep("mean|std|subject|description", names(combine))] 
```

Save result to text file.

```{r}
write.table(extract, "./tidy_data1.txt", sep = "\t", col.names = T) 
```

## Reshape data and create tidy data set

Use melt and dcast functions to reshape data - create data summaries sorted by subject and activity description.

```{r}
melted <- melt(extract, id=c("subject","description")) 
data <- dcast(melted, subject+description ~ variable, mean) 
data <- data[order(as.numeric(as.character(data$subject))), ] 
```

Remove numerical references from measurement variable names.  Save result as tidy data text file.

```{r}
names(data) <- gsub("[[:digit:]]", "", names(data)) 
write.table(data, file = "./tidy_data.txt", sep = "\t", col.names = T, row.names = F)
```

=======
# Explanation of code
>>>>>>> 99d0dce9ca054212fb2326fa362a77701680002f

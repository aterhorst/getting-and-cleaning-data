Explanation of run_analysis.R
========================================================

This script requires four R libraries.


```r
library(plyr)
library(reshape)
```

```
## 
## Attaching package: 'reshape'
## 
## The following objects are masked from 'package:plyr':
## 
##     rename, round_any
```

```r
library(reshape2)
```

```
## 
## Attaching package: 'reshape2'
## 
## The following objects are masked from 'package:reshape':
## 
##     colsplit, melt, recast
```

```r
library(Hmisc)
```

```
## Loading required package: grid
## Loading required package: lattice
## Loading required package: survival
## Loading required package: splines
## Loading required package: Formula
## 
## Attaching package: 'Hmisc'
## 
## The following objects are masked from 'package:plyr':
## 
##     is.discrete, summarize
## 
## The following objects are masked from 'package:base':
## 
##     format.pval, round.POSIXt, trunc.POSIXt, units
```


Fetch data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. Extract into working directory. Specify working directory in R. 


```r
setwd("~/ownCloud/Coursera/Getting and Cleaning Data/project")
```


Next, load data files into R. Begin by reading activity description data into a data frame and assigning column names.



```r
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = F)
colnames(act_labels) <- c("id", "description")
```


Read in variable names for training data measurements. Result is a list. 


```r
x_labels <- readLines("./UCI HAR Dataset/features.txt")
```


Load training measurement, activity and subject data into separate data frames and assign column names.


```r
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = F)
colnames(x_train) <- x_labels
subject_train <- as.data.frame(readLines("./UCI HAR Dataset/train/subject_train.txt"))
colnames(subject_train) <- "subject"
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = F)
colnames(activity_train) <- "id"
```


Combine subject, activity, and measurement training data into a single data frame.  Replace activity number with activity description.


```r
train <- cbind(subject_train, activity_train, x_train)  # combine data frames horizontally
mrg_train <- arrange(join(act_labels, train), id)
```

```
## Joining by: id
```


Load test measurement, activity and subject data into separate data frames and assign column names.


```r
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = F)
colnames(x_test) <- x_labels
subject_test <- as.data.frame(readLines("./UCI HAR Dataset/test/subject_test.txt"))
colnames(subject_test) <- "subject"
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = F)
colnames(activity_test) <- "id"
```


Combine subject, activity, and measurement test data into a single data frame.  Replace activity number with activity description.


```r
test <- cbind(subject_test, activity_test, x_test)  # combine data frames horizontally
mrg_test <- arrange(join(act_labels, test), id)
```

```
## Joining by: id
```


Cocatenate the training and test data.  Remove unnecessary columns. Subset mean and standard deviation variables. Reorder according to subject.


```r
combine <- merge(mrg_train, mrg_test, all.x = T, all.y = T)
combine$id <- NULL
combine <- combine[, c(2, 1, 3:563)]
extract <- combine[, grep("mean|std|subject|description", names(combine))]
```


Save interim result to text file.


```r
write.table(extract, "./tidy_data1.txt", sep = "\t", col.names = T)
```


Use melt and dcast functions to reshape data - create data summaries sorted by subject and activity description.


```r
melted <- melt(extract, id = c("subject", "description"))
data <- dcast(melted, subject + description ~ variable, mean)
data <- data[order(as.numeric(as.character(data$subject))), ]
```


Remove numerical references from measurement variable names.  Save result as tidy data text file.


```r
names(data) <- gsub("[[:digit:]]", "", names(data))
write.table(data, file = "./tidy_data.txt", sep = "\t", col.names = T, row.names = F)
```


Generate metadata and save as text file.


```r
sink(file = "./tidy_data_metadata.txt")
print.contents.data.frame(data)
```

```
## 
## Data frame:	 observations and  variables    Maximum # NAs:
## 
## NULL
```

```r
sink()
```


End.

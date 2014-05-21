Explanation of run_analysis.R
========================================================

Background
----------

This document explains the generation, structure and content of the tidy_data.txt dataset, derived from the "Human Activity Recognition Using Smartphones Dataset Version 1.0".

The original dataset contains records from experiments involving 30 volunteers aged between 19 and 48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity were capturat a constant rate of 50Hz. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Each record has the following data:

<ul>
<li>Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.</li>
<li>Triaxial Angular velocity from the gyroscope.</li>
<li>A 561-feature vector with time and frequency domain variables.</li>
<li>Its activity label.</li>
<li>An identifier of the subject who carried out the experiment.</li>
</ul>

Processing steps
----------------

The tidy_data.txt dataset was generated as follows:

<ol>
<li>Download archive file containing the "Human Activity Recognition Using Smartphones Dataset Version 1.0" into the working directory.</li>
<li>Extract the archived dataset.</li>
<li>Merge the training and the test sets to create one data set.</li>
<li>Extracts only the measurements on the mean and standard deviation for each measurement.</li>
<li>Uses descriptive activity names to name the activities in the data set.</li>
<li>Appropriately labels the data set with descriptive activity names.</li>
<li>Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
</ol>

R code
------

This script requires the following R libraries.


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
library(gdata)
```

```
## gdata: Unable to locate valid perl interpreter
## gdata: 
## gdata: read.xls() will be unable to read Excel XLS and XLSX files
## gdata: unless the 'perl=' argument is used to specify the location
## gdata: of a valid perl intrpreter.
## gdata: 
## gdata: (To avoid display of this message in the future, please
## gdata: ensure perl is installed and available on the executable
## gdata: search path.)
## gdata: Unable to load perl libaries needed by read.xls()
## gdata: to support 'XLX' (Excel 97-2004) files.
## 
## gdata: Unable to load perl libaries needed by read.xls()
## gdata: to support 'XLSX' (Excel 2007+) files.
## 
## gdata: Run the function 'installXLSXsupport()'
## gdata: to automatically download and install the perl
## gdata: libaries needed to support Excel XLS and XLSX formats.
## 
## Attaching package: 'gdata'
## 
## The following object is masked from 'package:stats':
## 
##     nobs
## 
## The following object is masked from 'package:utils':
## 
##     object.size
```

```r
library(utils)
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
## The following object is masked from 'package:gdata':
## 
##     combine
## 
## The following objects are masked from 'package:plyr':
## 
##     is.discrete, summarize
## 
## The following objects are masked from 'package:base':
## 
##     format.pval, round.POSIXt, trunc.POSIXt, units
```


Specify working directory in R. Fetch data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. Extract into working directory. 


```r
setwd("C:/Users/ter053/ownCloud/Coursera/Getting and Cleaning Data/project")  # Change path as needed
fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "UCI HAR Dataset.zip")
unzip("UCI HAR Dataset.zip", exdir = ".")
```


Next, load data files into R. Begin by reading activity description data into a data frame and assigning column names.



```r
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = F)  # read in activity numbers and corresponding descriptions
colnames(act_labels) <- c("id", "description")  # add header information (id used for merging later)
```


Read in variable names for training data measurements. Result is a list. 


```r
x_labels <- readLines("./UCI HAR Dataset/features.txt")  # read in measurement header information
```


Load training measurement, activity and subject data into separate data frames and assign column names.


```r
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = F)  # read in source measurements
colnames(x_train) <- x_labels  # add header information
subject_train <- as.data.frame(readLines("./UCI HAR Dataset/train/subject_train.txt"))  # read in subjects
colnames(subject_train) <- "subject"  # add header information
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = F)
colnames(activity_train) <- "id"  # add header information (use for merging later)
```


Combine subject, activity, and measurement training data into a single data frame.  Replace activity number with activity description.


```r
train <- cbind(subject_train, activity_train, x_train)  # combine data frames horizontally
mrg_train <- arrange(join(act_labels, train), id)  # replace activity numbers with descriptive strings
```

```
## Joining by: id
```


Load test measurement, activity and subject data into separate data frames and assign column names.


```r
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = F)  # read in source measurements
colnames(x_test) <- x_labels  # add header information
subject_test <- as.data.frame(readLines("./UCI HAR Dataset/test/subject_test.txt"))  # read in subjects
colnames(subject_test) <- "subject"  # add header information
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = F)
colnames(activity_test) <- "id"  # add header information (use for merging later)
```


Combine subject, activity, and measurement test data into a single data frame.  Replace activity number with activity description.


```r
test <- cbind(subject_test, activity_test, x_test)  # combine data frames horizontally
mrg_test <- arrange(join(act_labels, test), id)  # replace activity numbers with descriptive strings
```

```
## Joining by: id
```


Cocatenate the training and test data.  Remove unnecessary columns. Subset mean and standard deviation variables. Reorder according to subject.


```r
combine <- merge(mrg_train, mrg_test, all.x = T, all.y = T)  # create merged data set
combine$id <- NULL  # remove 'id' as no longer needed
combine <- combine[, c(2, 1, 3:563)]  # reorder columns
extract <- combine[, grep("mean|std|subject|description", names(combine))]  # extract subject, activity description, mean and std deviations only
```


Use melt and dcast functions to reshape data - create data summaries sorted by subject and activity description.


```r
melted <- melt(extract, id = c("subject", "description"))  # generate skinny data frame
data <- dcast(melted, subject + description ~ variable, mean)  # summarise data
data <- data[order(as.numeric(as.character(data$subject))), ]  # sort on subject
```


Remove numerical references from measurement variable names.  Save result as tidy data text file.


```r
names(data) <- gsub("[[:digit:]]", "", names(data))  # remove numbers in measurement headers
names(data) <- gsub("[(\\)\\]", "", names(data))  # remove brackets
write.table(data, file = "./tidy_data.txt", sep = "\t", col.names = T, row.names = F)  # generate tidy data set
```



Metadata
--------

**Variables**


```r
contents.data.frame(data)  # describe variables
```

```
## 
## Data frame:data	180 observations and 81 variables    Maximum # NAs:0
## 
##                                Levels Storage
## subject                            30 integer
## description                         6 integer
##  tBodyAcc-mean-X                       double
##  tBodyAcc-mean-Y                       double
##  tBodyAcc-mean-Z                       double
##  tBodyAcc-std-X                        double
##  tBodyAcc-std-Y                        double
##  tBodyAcc-std-Z                        double
##  tGravityAcc-mean-X                    double
##  tGravityAcc-mean-Y                    double
##  tGravityAcc-mean-Z                    double
##  tGravityAcc-std-X                     double
##  tGravityAcc-std-Y                     double
##  tGravityAcc-std-Z                     double
##  tBodyAccJerk-mean-X                   double
##  tBodyAccJerk-mean-Y                   double
##  tBodyAccJerk-mean-Z                   double
##  tBodyAccJerk-std-X                    double
##  tBodyAccJerk-std-Y                    double
##  tBodyAccJerk-std-Z                    double
##  tBodyGyro-mean-X                      double
##  tBodyGyro-mean-Y                      double
##  tBodyGyro-mean-Z                      double
##  tBodyGyro-std-X                       double
##  tBodyGyro-std-Y                       double
##  tBodyGyro-std-Z                       double
##  tBodyGyroJerk-mean-X                  double
##  tBodyGyroJerk-mean-Y                  double
##  tBodyGyroJerk-mean-Z                  double
##  tBodyGyroJerk-std-X                   double
##  tBodyGyroJerk-std-Y                   double
##  tBodyGyroJerk-std-Z                   double
##  tBodyAccMag-mean                      double
##  tBodyAccMag-std                       double
##  tGravityAccMag-mean                   double
##  tGravityAccMag-std                    double
##  tBodyAccJerkMag-mean                  double
##  tBodyAccJerkMag-std                   double
##  tBodyGyroMag-mean                     double
##  tBodyGyroMag-std                      double
##  tBodyGyroJerkMag-mean                 double
##  tBodyGyroJerkMag-std                  double
##  fBodyAcc-mean-X                       double
##  fBodyAcc-mean-Y                       double
##  fBodyAcc-mean-Z                       double
##  fBodyAcc-std-X                        double
##  fBodyAcc-std-Y                        double
##  fBodyAcc-std-Z                        double
##  fBodyAcc-meanFreq-X                   double
##  fBodyAcc-meanFreq-Y                   double
##  fBodyAcc-meanFreq-Z                   double
##  fBodyAccJerk-mean-X                   double
##  fBodyAccJerk-mean-Y                   double
##  fBodyAccJerk-mean-Z                   double
##  fBodyAccJerk-std-X                    double
##  fBodyAccJerk-std-Y                    double
##  fBodyAccJerk-std-Z                    double
##  fBodyAccJerk-meanFreq-X               double
##  fBodyAccJerk-meanFreq-Y               double
##  fBodyAccJerk-meanFreq-Z               double
##  fBodyGyro-mean-X                      double
##  fBodyGyro-mean-Y                      double
##  fBodyGyro-mean-Z                      double
##  fBodyGyro-std-X                       double
##  fBodyGyro-std-Y                       double
##  fBodyGyro-std-Z                       double
##  fBodyGyro-meanFreq-X                  double
##  fBodyGyro-meanFreq-Y                  double
##  fBodyGyro-meanFreq-Z                  double
##  fBodyAccMag-mean                      double
##  fBodyAccMag-std                       double
##  fBodyAccMag-meanFreq                  double
##  fBodyBodyAccJerkMag-mean              double
##  fBodyBodyAccJerkMag-std               double
##  fBodyBodyAccJerkMag-meanFreq          double
##  fBodyBodyGyroMag-mean                 double
##  fBodyBodyGyroMag-std                  double
##  fBodyBodyGyroMag-meanFreq             double
##  fBodyBodyGyroJerkMag-mean             double
##  fBodyBodyGyroJerkMag-std              double
##  fBodyBodyGyroJerkMag-meanFreq         double
## 
## +-----------+-----------------------------------------------------------+
## |Variable   |Levels                                                     |
## +-----------+-----------------------------------------------------------+
## |subject    |1,11,14,15,16,17,19,21,22,23,25,26,27,28,29,3,30,5,6,7,8,10|
## |           |12,13,18,2,20,24,4,9                                       |
## +-----------+-----------------------------------------------------------+
## |description|LAYING,SITTING,STANDING,WALKING,WALKING_DOWNSTAIRS         |
## |           |WALKING_UPSTAIRS                                           |
## +-----------+-----------------------------------------------------------+
```


**File structure**


```r
file <- tempfile()
write.fwf(x = data, file = file, formatInfo = TRUE)  # describe data format
```

```
##                           colname nlevels position width digits exp
## 1                         subject      30        1     2      0   0
## 2                     description       6        4    18      0   0
## 3                 tBodyAcc-mean-X       0       23     6      4   0
## 4                 tBodyAcc-mean-Y       0       30     9      6   0
## 5                 tBodyAcc-mean-Z       0       40     8      5   0
## 6                  tBodyAcc-std-X       0       49     9      6   0
## 7                  tBodyAcc-std-Y       0       59     9      6   0
## 8                  tBodyAcc-std-Z       0       69     9      6   0
## 9              tGravityAcc-mean-X       0       79     7      4   0
## 10             tGravityAcc-mean-Y       0       87     9      6   0
## 11             tGravityAcc-mean-Z       0       97     9      6   0
## 12              tGravityAcc-std-X       0      107     7      4   0
## 13              tGravityAcc-std-Y       0      115     7      4   0
## 14              tGravityAcc-std-Z       0      123     7      4   0
## 15            tBodyAccJerk-mean-X       0      131     7      5   0
## 16            tBodyAccJerk-mean-Y       0      139    10      3   2
## 17            tBodyAccJerk-mean-Z       0      150    10      3   2
## 18             tBodyAccJerk-std-X       0      161     9      6   0
## 19             tBodyAccJerk-std-Y       0      171     9      6   0
## 20             tBodyAccJerk-std-Z       0      181     8      5   0
## 21               tBodyGyro-mean-X       0      190    10      7   0
## 22               tBodyGyro-mean-Y       0      201     9      6   0
## 23               tBodyGyro-mean-Z       0      211    10      7   0
## 24                tBodyGyro-std-X       0      222     8      5   0
## 25                tBodyGyro-std-Y       0      231     9      6   0
## 26                tBodyGyro-std-Z       0      241     8      5   0
## 27           tBodyGyroJerk-mean-X       0      250     8      5   0
## 28           tBodyGyroJerk-mean-Y       0      259     8      5   0
## 29           tBodyGyroJerk-mean-Z       0      268     9      6   0
## 30            tBodyGyroJerk-std-X       0      278     8      5   0
## 31            tBodyGyroJerk-std-Y       0      287     8      5   0
## 32            tBodyGyroJerk-std-Z       0      296     9      6   0
## 33               tBodyAccMag-mean       0      306    10      7   0
## 34                tBodyAccMag-std       0      317     8      5   0
## 35            tGravityAccMag-mean       0      326    10      7   0
## 36             tGravityAccMag-std       0      337     8      5   0
## 37           tBodyAccJerkMag-mean       0      346     9      6   0
## 38            tBodyAccJerkMag-std       0      356     8      5   0
## 39              tBodyGyroMag-mean       0      365     9      6   0
## 40               tBodyGyroMag-std       0      375     8      5   0
## 41          tBodyGyroJerkMag-mean       0      384     8      5   0
## 42           tBodyGyroJerkMag-std       0      393     8      5   0
## 43                fBodyAcc-mean-X       0      402     8      5   0
## 44                fBodyAcc-mean-Y       0      411     9      6   0
## 45                fBodyAcc-mean-Z       0      421     8      5   0
## 46                 fBodyAcc-std-X       0      430     9      6   0
## 47                 fBodyAcc-std-Y       0      440     9      6   0
## 48                 fBodyAcc-std-Z       0      450     8      5   0
## 49            fBodyAcc-meanFreq-X       0      459    10      3   2
## 50            fBodyAcc-meanFreq-Y       0      470    10      7   0
## 51            fBodyAcc-meanFreq-Z       0      481    10      7   0
## 52            fBodyAccJerk-mean-X       0      492     9      6   0
## 53            fBodyAccJerk-mean-Y       0      502     9      6   0
## 54            fBodyAccJerk-mean-Z       0      512     8      5   0
## 55             fBodyAccJerk-std-X       0      521     9      6   0
## 56             fBodyAccJerk-std-Y       0      531     9      6   0
## 57             fBodyAccJerk-std-Z       0      541     9      6   0
## 58        fBodyAccJerk-meanFreq-X       0      551     9      6   0
## 59        fBodyAccJerk-meanFreq-Y       0      561    10      3   2
## 60        fBodyAccJerk-meanFreq-Z       0      572     9      6   0
## 61               fBodyGyro-mean-X       0      582     8      5   0
## 62               fBodyGyro-mean-Y       0      591     8      5   0
## 63               fBodyGyro-mean-Z       0      600     8      5   0
## 64                fBodyGyro-std-X       0      609     7      4   0
## 65                fBodyGyro-std-Y       0      617     8      5   0
## 66                fBodyGyro-std-Z       0      626     8      5   0
## 67           fBodyGyro-meanFreq-X       0      635     9      6   0
## 68           fBodyGyro-meanFreq-Y       0      645     9      6   0
## 69           fBodyGyro-meanFreq-Z       0      655    10      7   0
## 70               fBodyAccMag-mean       0      666     9      6   0
## 71                fBodyAccMag-std       0      676    10      7   0
## 72           fBodyAccMag-meanFreq       0      687    10      7   0
## 73       fBodyBodyAccJerkMag-mean       0      698    10      7   0
## 74        fBodyBodyAccJerkMag-std       0      709     8      5   0
## 75   fBodyBodyAccJerkMag-meanFreq       0      718    10      7   0
## 76          fBodyBodyGyroMag-mean       0      729    10      7   0
## 77           fBodyBodyGyroMag-std       0      740     8      5   0
## 78      fBodyBodyGyroMag-meanFreq       0      749    10      7   0
## 79      fBodyBodyGyroJerkMag-mean       0      760     8      5   0
## 80       fBodyBodyGyroJerkMag-std       0      769     8      5   0
## 81  fBodyBodyGyroJerkMag-meanFreq       0      778    10      7   0
```


End.

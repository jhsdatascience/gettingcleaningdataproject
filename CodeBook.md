---
title: "Code Book"
author: "jhsdatascience"
date: "06/20/2014"
output: html_document
---

## The data

The tidy data for this project consists of 180 observations of 68 variables. Each observation corresponds to an activity undertaken by a subject with various measurements of a wearable device. Two of the variables are identifiers: `subjectid` and `activity`. The remaining 66 are of the format:

```
measurement_type{mean|std}[[x|y|z]]
```

where `measurement_type` is the type of measurement recorded by the wearable device, `{mean|std}` denotes whether this variable records the mean or the standard deviation of this measurement for this activity and subject, and `[x|y|z]` is an optional signifier denoting the direction in which the measurement was taken.

A complete list of features follows:


```
##  [1] "subjectid"                "activity"                
##  [3] "tbodyaccmeanx"            "tbodyaccmeany"           
##  [5] "tbodyaccmeanz"            "tbodyaccstdx"            
##  [7] "tbodyaccstdy"             "tbodyaccstdz"            
##  [9] "tgravityaccmeanx"         "tgravityaccmeany"        
## [11] "tgravityaccmeanz"         "tgravityaccstdx"         
## [13] "tgravityaccstdy"          "tgravityaccstdz"         
## [15] "tbodyaccjerkmeanx"        "tbodyaccjerkmeany"       
## [17] "tbodyaccjerkmeanz"        "tbodyaccjerkstdx"        
## [19] "tbodyaccjerkstdy"         "tbodyaccjerkstdz"        
## [21] "tbodygyromeanx"           "tbodygyromeany"          
## [23] "tbodygyromeanz"           "tbodygyrostdx"           
## [25] "tbodygyrostdy"            "tbodygyrostdz"           
## [27] "tbodygyrojerkmeanx"       "tbodygyrojerkmeany"      
## [29] "tbodygyrojerkmeanz"       "tbodygyrojerkstdx"       
## [31] "tbodygyrojerkstdy"        "tbodygyrojerkstdz"       
## [33] "tbodyaccmagmean"          "tbodyaccmagstd"          
## [35] "tgravityaccmagmean"       "tgravityaccmagstd"       
## [37] "tbodyaccjerkmagmean"      "tbodyaccjerkmagstd"      
## [39] "tbodygyromagmean"         "tbodygyromagstd"         
## [41] "tbodygyrojerkmagmean"     "tbodygyrojerkmagstd"     
## [43] "fbodyaccmeanx"            "fbodyaccmeany"           
## [45] "fbodyaccmeanz"            "fbodyaccstdx"            
## [47] "fbodyaccstdy"             "fbodyaccstdz"            
## [49] "fbodyaccjerkmeanx"        "fbodyaccjerkmeany"       
## [51] "fbodyaccjerkmeanz"        "fbodyaccjerkstdx"        
## [53] "fbodyaccjerkstdy"         "fbodyaccjerkstdz"        
## [55] "fbodygyromeanx"           "fbodygyromeany"          
## [57] "fbodygyromeanz"           "fbodygyrostdx"           
## [59] "fbodygyrostdy"            "fbodygyrostdz"           
## [61] "fbodyaccmagmean"          "fbodyaccmagstd"          
## [63] "fbodybodyaccjerkmagmean"  "fbodybodyaccjerkmagstd"  
## [65] "fbodybodygyromagmean"     "fbodybodygyromagstd"     
## [67] "fbodybodygyrojerkmagmean" "fbodybodygyrojerkmagstd"
```

## Explanation of how the tidy data set was constructed

Cleaning the UCI HAR Dataset takes place in three steps: getting the data, cleaning it, and aggregating it.

### Getting the UCI data set

The function `getData` performs the following steps:

1. Load the feature labels from the file `data/features.txt`. Store these in a variable `feature_labels`
2. Load the features for the training set and testing set from the files `UCI HAR Dataset/train/X_train.txt` and `UCI HAR Dataset/test/X_test.txt`, respectively, using `feature_labels` as column names. Store these in dataf frames `features_train` and `features_test`, respectively.
3. Load the response variables for the training set and testing set from the files `UCI HAR Dataset/train/y_train.txt` and `UCI HAR Dataset/test/y_test.txt`, respectivel. Store these in vectors `activities_train` and `activities_test`.
4. Load the response variables for the training set and testing set from the files `UCI HAR Dataset/train/subject_train.txt` and `UCI HAR Dataset/test/subject_test.txt`, respectivel. Store these in vectors `subjects_train` and `subjects_test`.
5. Concatenate `features_train` and `features_test` into one data frame called `features`.
6. Concatenate `activities_train` and `activitiess_test` into one data frame called `activities`.
7. Concatenate `subjects_train` and `subjects_test` into one data frame called `subjects`.
8. Extract the desired features from the data frame `features`, namely, those that are observations of the mean and standard deviation for each measurement.
9. Merge `features`, `activities`, and `subjects` into one data frame.
10. Return the merged data frame.

### Cleaning the UCI Dataset

The function `cleanData` takes a data frame `df` such as the one returned by `getData` and performs the following steps:

1. Get the activity labels from the file `UCI HAR Dataset/activity_labels.txt`. Store as data frame `activity_labels`.
2. Convert the feature names of `df` to lower case for readability.
3. Replace the activity ids in `df` with the name of the activity using `activity_labels`.
4. Make `R` recognize `subjectid` as a factor.
5. Return the cleaned data frame.

### Aggregate features by activity

The function `getMeans` takes a data frame `df` such as the one returned by `cleanData` and performs the following steps:

1. Split `df` by `subjectid` and `activity`.
2. Get the column means for each of the splits.
3. Merge the column means per `subjectid` and `activity`.
4. Return the merged data frame.

#! /usr/bin/Rscript

library(plyr)

getUCIData <- function() {
    # Merges the UCI HAR data and extracts only the means and stdevs of the features therein
    
    # Download the raw data if it is not already present
    if (!file.exists("UCI HAR Dataset/")) {
        download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
                      'UCI HAR Dataset.zip',
                      method = 'curl')
        unzip('UCI HAR Dataset.zip')
    }
    
    # Labels:
    feature_labels <- read.table('UCI HAR Dataset/features.txt',
                                 col.names = c("featurenumber", "feature"))
    
    # Observations:
    features_train <- read.table('UCI HAR Dataset/train/X_train.txt',
                                 col.names = feature_labels$feature)
    features_test <- read.table('UCI HAR Dataset/test/X_test.txt',
                                col.names = feature_labels$feature)
    
    # Activities
    activities_train <- read.table('UCI HAR Dataset/train/y_train.txt',
                                   col.names = c("activity"))
    activities_test <- read.table('UCI HAR Dataset/test/y_test.txt',
                                  col.names = c("activity"))
    
    # Subjects
    subjects_train <- read.table('UCI HAR Dataset/train/subject_train.txt',
                                 col.names = c("subjectid"))
    subjects_test <- read.table('UCI HAR Dataset/test/subject_test.txt',
                                col.names = c("subjectid"))
    
    
    # Merge test and train
    activities <- rbind(activities_train, activities_test)
    features <- rbind(features_train, features_test)
    subjects <- rbind(subjects_train, subjects_test)
    
    # Exctract the relevant features
    features <- features[grep('mean\\(\\)|std\\(\\)', feature_labels$feature)]
    
    # Merge subjects, activities and features
    df <- cbind(subjects, activities, features)
    
    # Return . . .
    df
    
}

cleanUCIData <- function(df) {
    # Converts variable names and values to lowercase, strips obnoxious periods
    # and converts relevant variables to factors
    
    # get activity labels
    activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt',
                                  col.names = c("label", "activity"),
                                  stringsAsFactors=F)
    
    # Clean feature names
    names(df) <- tolower(gsub('\\.', '', names(df)))
    
    # Map activity ids to activity names, clean names, and reset as factor
    df$activity <- as.factor(tolower(mapvalues(df$activity, 1:6, activity_labels$activity)))
    
    # Make subject a factor
    df$subjectid <- as.factor(df$subjectid)
    
    # Return . . .
    df
}

aggregateUCIData <- function(df) {
    # Summarize the data set by the mean of each feature across subjects and activities
    mdf <- ddply(df, .(subjectid, activity), function(x) { colMeans(x[,3:ncol(x)]) })
    
    # Returns . . .
    mdf
}

df <- getUCIData()
df <- cleanUCIData(df)
df_means <- aggregateUCIData(df)
write.csv(df_means, "tidy_data.csv", row.names = F)

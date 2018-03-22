##  File - run_analysis.R

library(dplyr)

## Download and unzip the dataset:

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "./dataset.zip")


if (!file.exists("./UCI HAR Dataset")) {
        
        unzip("./dataset.zip")
        
}

## Read training data

trainSubjects <- read.table(file.path("./UCI HAR Dataset/train/subject_train.txt"))

trainValues <- read.table(file.path("./UCI HAR Dataset/train/X_train.txt"))

trainActivity <- read.table(file.path("./UCI HAR Dataset/train/y_train.txt"))


## Read test data

testSubjects <- read.table(("./UCI HAR Dataset/test/subject_test.txt"))

testValues <- read.table(("./UCI HAR Dataset/test/X_test.txt"))

testActivity <- read.table(("./UCI HAR Dataset/test/y_test.txt"))


## Read features

features <- read.table(file.path("./UCI HAR Dataset/features.txt"), as.is = TRUE)


## Read activity labels

activitieslabels <- read.table(file.path("./UCI HAR Dataset/activity_labels.txt"))


colnames(activitieslabels) <- c("activityId", "activityLabel")



## Merge the training and the test sets to create one data set

activity <- rbind(
        
       cbind(trainSubjects, trainValues, trainActivity),
        
       cbind(testSubjects, testValues, testActivity)
)



# Assign column names to "activity"

colnames(activity) <- c("subject", features[, 2], "activity")


## Extract only the measurements on the mean and standard deviation for each measurement


columns <- grepl("subject|activity|mean|std", colnames(activity))

activity <- activity[, columns]


## Replace activity values with named factor levels

activity$activity <- factor(activity$activity, 
                                 
                                 levels = activitieslabels[, 1], labels = activitieslabels[, 2])
                            


## remove special characters
Colactivity <- colnames(activity)

Colactivity <- gsub("[\\(\\)-]", "", Colactivity)

colnames(activity) <- Colactivity

## Group by subject and activity and summarise using mean

tidydata<- activity %>% 
        
        group_by(subject, activity) %>%
        
        summarise_each(funs(mean))



# Write table to file "tidy_data.txt"

write.table(tidydata, "tidy_data.txt", row.names = FALSE, 
            
            quote = FALSE)
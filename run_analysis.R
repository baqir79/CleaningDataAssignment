download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./data/exdata.zip")
unzip("./data/exdata.zip", exdir="./data")

## test Set
xtest<-read.table("./data/UCI HAR Dataset/test/X_test.txt",sep="")
ytest<-read.table("./data/UCI HAR Dataset/test/y_test.txt",sep="")
subtest<-read.table("./data/UCI HAR Dataset/test/subject_test.txt",sep="")
feature<-read.table("./data/UCI HAR Dataset/features.txt",sep="")
activitylable <-read.table("./data/UCI HAR Dataset/activity_labels.txt",sep="")

## Add column names to the xtest
names (xtest) <- feature[,2] 
names(subtest) <- c("Subject")  
testComplete <-cbind(subtest, xtest)
newytest<-merge(ytest,activitylable, by.x="V1", by.y="V1",all=TRUE)
names(newytest) <- c("activity_label","activity_name")
testComplete<-cbind(newytest,testComplete)
testComplete<-cbind(rep("test",nrow(testComplete)),testComplete)
names(testComplete)[1]<- "group"


##View (head(testComplete))

## train activity
xtrain<-read.table("./data/UCI HAR Dataset/train/X_train.txt",sep="")
ytrain<-read.table("./data/UCI HAR Dataset/train/y_train.txt",sep="")
subtrain<-read.table("./data/UCI HAR Dataset/train/subject_train.txt",sep="")

## Add column names to the xtrain
names (xtrain) <- feature[,2] 
names(subtrain) <- c("Subject")  
trainComplete <-cbind(subtrain, xtrain)
newytrain<-merge(ytrain,activitylable, by.x="V1", by.y="V1",all=TRUE)
names(newytrain) <- c("activity_label","activity_name")
trainComplete<-cbind(rep("train",nrow(trainComplete)),newytrain,trainComplete)
names(trainComplete)[1]<- "group"

##View (head(trainComplete))

## Combine test and train dataset into a single table
combinedSet <-rbind(testComplete, trainComplete)

## User grep to identify column names with mean() and std()
meanStd<-combinedSet[,c(c(1:4),grep("mean()",names(combinedSet)), grep("std()",names(combinedSet)))]

## Set factors
meanStd$activity_label <-as.factor(meanStd$activity_label)
meanStd$Subject <- as.factor(meanStd$Subject)
summary(meanStd)
str(meanStd)


# Write tidy dataset to output file
write.csv(head(combinedSet, 1000), file="./combinedSet.csv")


colMeans(meanStd)

library(data.table)
library(dplyr)
X_train <- read.table("./getdata/UCI HAR Dataset/train/X_train.txt", quote="\"", stringsAsFactors=FALSE)
X_test <- read.table("./getdata/UCI HAR Dataset/test/X_test.txt", quote="\"", stringsAsFactors=FALSE)
X<-rbind(X_train,X_test)
features <- read.table("./getdata/UCI HAR Dataset/features.txt", quote="\"", stringsAsFactors=FALSE)
names(X)<-features$V2
subject_train <- read.table("./getdata/UCI HAR Dataset/train/subject_train.txt", quote="\"", stringsAsFactors=FALSE)
subject_test<-read.table("./getdata/UCI HAR Dataset/test/subject_test.txt", quote="\"", stringsAsFactors=FALSE)
subject<-rbind(subject_train,subject_test)
activity_labels<-read.table("./getdata/UCI HAR Dataset/activity_labels.txt", quote="\"", stringsAsFactors=FALSE)
y_train <- read.table("./getdata/UCI HAR Dataset/train/y_train.txt", quote="\"", stringsAsFactors=FALSE)
y_test <- read.table("./getdata/UCI HAR Dataset/test/y_test.txt", quote="\"", stringsAsFactors=FALSE)
Y<-rbind(y_train,y_test)
y_labels<-merge(Y,activity_labels)
names(y_labels)<-c("activity_id","activity_label")
names(subject)<-c("subject_id")


##1. Merge Data sets into all_data
all_data<-cbind(X,y_labels,subject)
all_data<-all_data[,!duplicated(colnames(all_data))]

##2. Extract measures for mean and std dev
data_mean<-select(all_data,contains("mean"))
data_std<-select(all_data,contains("std"))
##3.Descriptive activity names in variable activity_label
##4. Giving descriptive names
names(all_data) <- gsub("Acc", "Accelerator", names(all_data))
names(all_data) <- gsub("Mag", "Magnitude", names(all_data))
names(all_data) <- gsub("Gyro", "Gyroscope", names(all_data))
names(all_data) <- gsub("^t", "time", names(all_data))
names(all_data) <- gsub("^f", "frequency", names(all_data))
##5.Generating tidy data set with means

all_data_dt<-data.table(all_data)
TidyData <- all_data_dt[, lapply(.SD, mean), by = 'activity_label,subject_id']

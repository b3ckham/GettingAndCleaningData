library(plyr);

path_rf <- file.path("./" , "UCI HAR Dataset")

dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)

dataXTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataXTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

dataYTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataYTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

## Marge features and load feature names
dataFeatures <- rbind(dataXTrain, dataXTest)
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

## Merge activities and load activity labels
dataActivity <- rbind(dataYTrain, dataYTest)
dataActivityNames <- read.table(file.path(path_rf, "activity_labels.txt"),head=FALSE)
dataActivity[, 1] <- dataActivityNames[dataActivity[, 1], 2]
names(dataActivity)<-c("activity")

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
names(dataSubject)<-c("subject")

## Merge columns
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

## take Names of Features with "mean()" or "std()"
subdataFeaturesNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity" )
Data <- subset(Data,select=selectedNames)

## Appropriately labels the data set with descriptive variable names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## Creates a second,independent tidy data set and ouput it
DataSet2<-aggregate(. ~subject + activity, Data, mean)
DataSet2<-DataSet2[order(DataSet2$subject,DataSet2$activity),]
write.table(DataSet2, file = "tidydata.txt",row.name=FALSE)

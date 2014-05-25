# Author: Shubham Agrawal
# Created on 25th May, 2014

require(data.table)

genTidyData <- function(datafile='tidyData.txt', sep=' ') {
    # Read Training Data
    train_X <- read.table('train/X_train.txt')
    train_y <- read.table('train/y_train.txt', col.names=c('ActivityID'))
    train_subjects <- read.table('train/subject_train.txt', col.names=c('VolunteerID'))
    
    # Read Test Data
    test_X <- read.table('test/X_test.txt')
    test_y <- read.table('test/y_test.txt', col.names=c('ActivityID'))
    test_subjects <- read.table('test/subject_test.txt', col.names=c('VolunteerID'))
    
    # Merge the Training and Test Data
    total_X <- rbind(train_X,test_X)
    total_y <- rbind(train_y,test_y)
    total_subjects <- rbind(train_subjects,test_subjects)
    
    # Extract only the measurements on the mean and standard deviation for each measurement
    features <- read.table('features.txt',col.names=c('FeatureID', 'Feature'))
    desiredColumnsIndices <- grepl("mean\\(\\)|std\\(\\)", features$Feature)
    reqTotal_X <- total_X[,desiredColumnsIndices]
    
    # Appropriately label the data set with activity and volunteer labels. Give descriptive column names
    desColNames <- lapply(as.list(features$Feature[desiredColumnsIndices]), function(x) gsub("\\(\\)", "", x))
    desColNames <- sapply(desColNames, function(y) gsub('-', "_", y))
    colnames(reqTotal_X) <- desColNames
    reqTotal_X <- cbind(total_subjects,total_y,reqTotal_X)
    
    # Apply 'aggregate' to compute average of each variable for each activity and each subject.
        # generate column names of each variable without quotes except VolunteerID(each subject) and ActivityID(each activity)
        colNamesListWidoutQuotes <- noquote(paste(noquote(desColNames), collapse=','))
        # create formula to be used for aggregation on above variables by VolunteerID(each subject) and ActivityID(each activity)
        aggrForm <- as.formula(paste("cbind(",colNamesListWidoutQuotes,")~VolunteerID+ActivityID"))
        # use FUN=mean to aggregate as per formula 'aggrForm' on our data set
        tidyData<- aggregate(formula=aggrForm, data=reqTotal_X, FUN=mean)
    
    # Label the tidy data set with appropriate descriptive activity names, column names and save it
    activities <- read.table('activity_labels.txt', col.names=c('ActivityID', 'ActivityType'))
    tidyData <- data.table(merge(tidyData, activities, by='ActivityID'))
    newColNames <- sapply(as.list(desColNames), function(x) paste0("avgOf_",x))
    setnames(tidyData,desColNames,newColNames)
    write.table(tidyData[,c("ActivityID","ActivityType","VolunteerID",newColNames),with=F],datafile, sep=sep, row.names=F)
}

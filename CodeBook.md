CodeBook to generate the Tidy Data
==================================



## Data Used
#### Data collected from the accelerometers of the Samsung Galaxy S smartphones and available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#### Data consists of two sets: Training and Test datasets
#### Each dataset has:
* Data of Internal Signals(captured from accelerometers) (Internal Signals)
* Data for vector of features computed from each recorded observation of internal signals (X_test.txt/X_train.txt)
* Information of type of activity corresponding to each observation recorded (y_test.txt/y_train.txt)
* Information of subject who was under observation for corresponding record (subject_test.txt/subject_train.txt)

#### Apart from test and training dataset, it has list of features(in features.txt) for features computed as in X_test.txt/X_train.txt. Also, activity_labels.txt having descriptive information for activity IDs used in y_test.txt/y_train.txt

## Steps Used
* First of all, training and test data sets were combined to form one data set (total_X, total_y, total_subjects).
* As we were interested in only the variables representing mean and standard deviation for each measurement, we parsed the features list from features.txt and learned the indices of variables needed for our case
* A data frame(reqTotal_X) of the required variables was chosen from the total dataset(total_X)
* Appropriate column names were assigned to selected set of variables and data frame was merged with total_y, total_subjects to label each record with their type of activity and subjects who carried out that activity
* Average of each variable for each subject and each activity was computed by calling the 'aggregate' function of R with appropriate formula, data frame(reqTotal_X) and 'mean' function
* Result of above step was assigned to data frame tidyData and its columns were renamed appropriately to incorporate the transformation on reqTotal_X
* Descriptive activity names were learned from activity_labels.txt and merged with tidyData by their respective ActivityID
* Saved the tidyData as generated from above cleaning steps for further analysis


## read in datasets 
features <- read.table('./UCI HAR Dataset/features.txt')
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt')

testData <- read.table('./UCI HAR Dataset/test/X_test.txt')
testLabels <- read.table('./UCI HAR Dataset/test/Y_test.txt')
testSubject <- read.table('./UCI HAR Dataset/test/subject_test.txt')

trainData <- read.table('./UCI HAR Dataset/train/X_train.txt')
trainLabels <- read.table('./UCI HAR Dataset/train/Y_train.txt')
trainSubject <- read.table('./UCI HAR Dataset/train/subject_train.txt')


## extract variable index number for mean and std (for use to extract only those features)
meanIndex <- grep('mean', features[,2], ignore.case=TRUE)
stdIndex <- grep('std', features[,2], ignore.case=TRUE)
combinedIndex <- sort(c(meanIndex, stdIndex))


## combine test and train sets, keeping only columns for mean & std for dataset
combinedData <- rbind(testData[, combinedIndex], trainData[, combinedIndex])
combinedLabels <- rbind(testLabels, trainLabels)
combinedSubject <- rbind(testSubject, trainSubject)

# add feature column names to dataset
colnames(combinedData) <- features[combinedIndex, 2]

# add columns: subject, activity (this completes the combined dataset)
library(plyr)
combinedDataComplete <- cbind(combinedSubject, 
                              activity=join(combinedLabels, activityLabels, by='V1')[,2],
                              combinedData)
colnames(combinedDataComplete)[1] <- 'subject'


## create tidy dataset of average of each feature for each activity and each subject
## from combinedDataComplete. The final tidy dataset is finalAverageData
molten <- melt(combinedDataComplete, id=c('subject','activity'))

finalAverageData <- data.frame()
library(dplyr)

for(subject in unique(molten$subject)){
      
      # for each subject calculate mean by activity & variable
      subjectData <- dcast(subset(molten, subject==subject), activity ~ variable, mean)
      subjectData <- cbind(data.frame(subject=subject), subjectData)
      
      # combine tidy data for each subject into finalAverageData
      if(empty(finalAverageData)){
            
            finalAverageData <- subjectData
            
      } else {
            
            finalAverageData <- rbind(finalAverageData, subjectData)
            
      }
}


## write 
## 1) complete dataset, and 2) Avg Std dataset 
## to ./data folder
if(!file.exists('./data')){ dir.create('./data') }
write.table(combinedDataComplete, file='./data/combinedAvgStdData', row.names=FALSE)
write.table(finalAverageData, file='./data/tidyAvgData', row.names=FALSE)

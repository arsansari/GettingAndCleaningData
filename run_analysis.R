library(plyr)

trainingX <- read.table("UCI HAR Dataset/train/X_train.txt")
trainingY <- read.table("UCI HAR Dataset/train/y_train.txt")
trainingSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")

testX <- read.table("UCI HAR Dataset/test/X_test.txt")
testY <- read.table("UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

# generate dataset for X
dataX <- rbind(trainingX, testX)

# generate dataset for Y
dataY <- rbind(trainingY, testY)

# generate dataset for Subject
subjectData <- rbind(trainingSubject, subjectTest)

features <- read.table("UCI HAR Dataset/features.txt")

# filter columns having mean() or std() in their names
featuresMeanSD <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns for mean & std
dataX <- dataX[, featuresMeanSD]

# correct the column names
names(dataX) <- features[featuresMeanSD, 2]

activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
dataY[, 1] <- activities[dataY[, 1], 2]

# correct column name
names(dataY) <- "activity"

# correct column name
names(subjectData) <- "subject"

# combine all the data in a single data set
dataAll <- cbind(dataX, dataY, subjectData)

# 66 <- 68 columns but last two (activity & subject)
dataAverage <- ddply(dataAll, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(dataAverage, "tidy.txt", row.name = FALSE)

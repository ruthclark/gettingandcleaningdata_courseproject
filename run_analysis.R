# Script for "Getting and Cleaning Data" course project

library(reshape2)

# Download project data
filename <- "data.zip"
if (!file.exists(filename)) {
  fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename)
}

# Extract downloaded data from zip folder
if (!file.exists("UCI HAR Dataset")) {
unzip(filename)
}

# Load file entitled "activity_labels" 
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE)
activity.labels[,2] <- as.character(activity.labels[,2])

# Load file entitled "features" and filter by measurements on mean and standard deviation
features <- read.table("UCI HAR Dataset/features.txt", header=FALSE)
features[,2] <- as.character(features[,2])
filtered.features <- subset(features, grepl(".*mean.*|.*std.*", V2))

# Assign clearer variable names
## column.names <- colNames(filtered.features)
for (i in 1:length(filtered.features[,1])) 
{
  filtered.features[i,2] = gsub("\\()","",filtered.features[i,2])
  filtered.features[i,2] = gsub("-std$","StdDev",filtered.features[i,2])
  filtered.features[i,2] = gsub("-mean","Mean",filtered.features[i,2])
  filtered.features[i,2] = gsub("^(t)","time",filtered.features[i,2])
  filtered.features[i,2] = gsub("^(f)","freq",filtered.features[i,2])
  filtered.features[i,2] = gsub("([Gg]ravity)","Gravity",filtered.features[i,2])
  filtered.features[i,2] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",filtered.features[i,2])
  filtered.features[i,2] = gsub("[Gg]yro","Gyro",filtered.features[i,2])
  filtered.features[i,2] = gsub("AccMag","AccMagnitude",filtered.features[i,2])
  filtered.features[i,2] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",filtered.features[i,2])
  filtered.features[i,2] = gsub("JerkMag","JerkMagnitude",filtered.features[i,2])
  filtered.features[i,2] = gsub("GyroMag","GyroMagnitude",filtered.features[i,2])
}

# Load files entitled "X_train", "y_train" and "subject_train" within the train folder
x.train <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)[filtered.features[,1]]
y.train <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE)
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)

# Load files entitled "X_test", "y_test" and "subject_test" within the test folder
x.test <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)[filtered.features[,1]]
y.test <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE)
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE)

# Combine all train data
train.all <- cbind(subject.train, y.train, x.train)

# Combine all test data
test.all <- cbind(subject.test, y.test, x.test)

# Merge train and test data together
merged.data <- rbind(train.all,test.all)

# Assign column names to merged.data
colnames(merged.data) <- c("subject", "activity",filtered.features[,2])

# Factorize activites and subjects
merged.data$activity <- factor(merged.data$activity, levels = activity.labels[,1], labels = activity.labels[,2])
merged.data$subject <- as.factor(merged.data$subject)

# Melt data tables
merged.data.melted <- melt(merged.data, id = c("subject", "activity"))
merged.data.mean <- dcast(merged.data.melted, subject + activity ~ variable, mean)

# Create tidy data set
write.table(merged.data.mean, "tidydata.txt", row.names = F, quote = F)


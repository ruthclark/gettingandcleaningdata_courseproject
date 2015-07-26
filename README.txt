Coursera - Getting and Cleaning Data - Course Project

The script "run_analysis.R" does the following:

1. Downloads the data for the project
2. Extracts the downloaded data from the zip folder
3. Loads the file entitled "activity_labels" 
4. Loads the file entitled "features" and selects only the rows containing measurements on mean and standard deviation
5. Assigns new, clearer variable names
6. Loads the files entitled "X_train", "y_train" and "subject_train" from the train folder
7. Loads the files entitled "X_test", "y_test" and "subject_test" from the test folder
8. Combines all the data in the train folder
9. Combines all the data in the test folder
10. Merges the data in the train and test folders together
11. Assigns column names to the merged data
12. Factorizes activities and subjects
13. Stacks the columns into a single column of data
14. Creates a tidy data set from the original data files


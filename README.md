## gc_project
This repository contains the following files:
=============================================
- README.md
- CodeBook.md
- run_analysis.R


README.md:
==========
It describes the variables, the data, and transformations performed to clean up the data and to create the combined dataset (train & test) and the tidy dataset.

CodeBook.md:
============
Describes the variables in the output data files.

run_analysis.R:
===============
R code that takes the "Human Activity Recognition Using Smartphones Data Set" and combines the train set (./train/X_train.txt) and test set (./test/X_test.txt) into a single dataset. It extracts only the columns that are measures on the mean and standard deviation of the measures. It then adds a subject column and an activity column to indicate the subject and the activity type conducted, respectively. It finally creates a tidy dataset from the previous dataset by averaging the measured values by subject, activity, and feature. The final tidy set contains these columns: subject, activity, feature1, feature2, etc., where the features columns are the averaged measures of the measure indicated by the column name for that particular subject and activity combination.


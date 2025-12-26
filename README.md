# Tidy UCI HAR Dataset — Final Project
This project contains an R script that downloads, cleans, and summarizes the Human Activity Recognition Using Smartphones (UCI HAR) dataset. 
The output is a tidy data file ("tidy_data.txt") with the average of each selected feature (means and standard deviations) for each subject and activity pair.

## CONTENTS

* run_analysis.R --> The analysis script
* tidy_data.txt --> Tidy output (tab-delimited; created by the script)
* CodeBook.md --> Codebook describing variables, units, and transformations
* README.md --> This file

## QUICK START

Prerequisites
Packages: readr, dplyr, stringr

Install packages in R with:

install.packages(c("readr", "dplyr", "stringr"))

### Run

From your R session in the project folder:

source("run_analysis.R")

This will:

* Download the official UCI HAR zip file to a temporary location
* Read all needed files directly from the zip
* Merge training and test sets, attach subject IDs and activity names
* Select only features that are means or standard deviations (excluding meanFreq() and angle() variables)
* Clean and standardize column names
* Compute the average of each selected feature for each subject and activity
* Write the tidy output as "tidy_data.txt" (tab-delimited, no row names, no quotes)

## SCRIPT STEPS (SUMMARY)

* Load libraries: readr, dplyr, stringr
* Download and inspect the UCI HAR zip file
* Read metadata: features.txt and activity_labels.txt
* Read data: X_train, y_train, subject_train, X_test, y_test, subject_test
* Clean column names for measurement data
* Bind activity labels and subject IDs to each partition, then merge train and test sets
* Select features containing "mean" or "std", excluding "meanFreq" and "angle"
* Rename columns to descriptive, machine-safe names (lowercase, underscores, expanded tokens)
* Aggregate: compute mean for each feature grouped by subject and activity
* Write the tidy data set to "tidy_data.txt"

## OUTPUT: tidy_data.txt

* Format: Tab-delimited text; header row; no row names or quotes
* Rows: One per subject × activity pair
* Columns: subject (integer), activity (string), 66 numeric columns = means of selected features after renaming (e.g., time_body_acc_mean_x, freq_body_gyro_std_z, etc.)


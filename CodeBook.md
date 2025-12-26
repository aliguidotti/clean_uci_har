# CodeBook — Tidy UCI HAR Dataset (averages by subject × activity)

## Purpose 
This code book describes the variables, units, and transformations performed by the provided R script to produce the tidy dataset 'tidy_data.txt' (mean of each selected feature for each activity and each subject).

## Source data and provenance

Human Activity Recognition Using Smartphones (UCI HAR). 

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 

### Each record provides:
* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope.
* A 561-feature vector with time and frequency domain variables.
* Its activity label.
* An identifier of the subject who carried out the experiment.

The original sensor signals are measured in standard gravity units (g) for acceleration and radians per second (rad/s) for angular velocity; however, features are normalized and bounded within [-1, 1].

##  Final Dataset: tidy_data.txt

The data set is tab-delimited.

It contains one row per subject × activity; numeric columns are means of the selected features.

### Transformations performed
1. Merge training and test sets, joining activity labels and subject IDs.
2. Select mean & standard deviation features: keep variables containing mean() or std(), excluding meanFreq() and angle().
3. Rename variables to descriptive, machine-safe names (remove parentheses; replace punctuation with underscores; lowercase; map prefixes t→time_, f→freq_; expand tokens; collapse double underscores).
4. Compute tidy averages grouped by subject and activity.


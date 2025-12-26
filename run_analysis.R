
# Loading libraries
library(readr)
library(dplyr)
library(stringr)

# Accessing data set through URL
zip_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_path <- tempfile(fileext = ".zip")
download.file(zip_url, destfile = zip_path, mode = "wb", quiet = TRUE)
contents <- utils::unzip(zip_path, list = TRUE)

head(contents)

features_con <- unz(zip_path, "UCI HAR Dataset/features.txt")
activity_con <- unz(zip_path, "UCI HAR Dataset/activity_labels.txt")
xtrain_con   <- unz(zip_path, "UCI HAR Dataset/train/X_train.txt")
ytrain_con   <- unz(zip_path, "UCI HAR Dataset/train/y_train.txt")
xtest_con   <- unz(zip_path, "UCI HAR Dataset/test/X_test.txt")
ytest_con   <- unz(zip_path, "UCI HAR Dataset/test/y_test.txt")
subject_tr_con <- unz(zip_path, "UCI HAR Dataset/train/subject_train.txt")
subject_te_con <- unz(zip_path, "UCI HAR Dataset/test/subject_test.txt")

# Reading files
features <- read_delim(
  features_con, delim = " ",
  col_names = c("index", "name"),
  col_types = cols(index = col_integer(), name = col_character())
)

activity_labels <- read_delim(
  activity_con, delim = " ",
  col_names = c("activity_id", "activity"),
  col_types = cols(activity_id = col_integer(), activity = col_character())
)

X_train <- read_table(
  xtrain_con, col_names = FALSE
)

y_train <- read_table(
  ytrain_con,
  col_names = "activity_id",
  col_types = cols(activity_id = col_integer())
)

X_test <- read_table(
  xtest_con, col_names = FALSE
)

y_test <- read_table(
  ytest_con,
  col_names = "activity_id",
  col_types = cols(activity_id = col_integer())
)

subject_train <- read_table(
  subject_tr_con, 
  col_names = "subject",
  col_types = cols(subject = col_integer())
)

subject_test <- read_table(
  subject_te_con, 
  col_names = "subject",
  col_types = cols(subject = col_integer())
)

# Cleaning column names
clean_names <- features$name %>%
  str_replace_all("[()]", "") %>%
  str_replace_all("[,-]", "_") %>%
  make.names(unique = TRUE)
colnames(X_train) <- clean_names
colnames(X_test) <- clean_names

# Joining datasets with activity and subject
# Note: rows are aligned by index in files X_*, y_*, subject_*
train_df <- y_train %>%
  left_join(activity_labels, by = "activity_id") %>%
  select(activity) %>%
  bind_cols(subject_train, ., X_train)
test_df <- y_test %>%
  left_join(activity_labels, by = "activity_id") %>%
  select(activity) %>%
  bind_cols(subject_test, ., X_test)

# Consistency checks
stopifnot(ncol(X_train) == length(clean_names), ncol(X_test) == length(clean_names))
stopifnot(setequal(names(train_df), names(test_df)))

# Merging test and train data sets
all_df <- bind_rows(train_df, test_df)

# Removing columns that are not mean and std
mean_std_df <- all_df %>%
  select(
    subject, activity,
    # match data with "mean" and "std"
    matches("mean|std"),
    # exluding meanFreq and angl
    -matches("meanFreq"),
    -matches("^angle")
  )

# Changing feature names
clean_feature_names <- function(nms) {
  nms %>%
    str_to_lower() %>%
    str_replace("^t", "time_") %>%
    str_replace("^f", "freq_") %>%
    str_replace_all("body", "body_") %>%
    str_replace_all("gravity", "gravity_") %>%
    str_replace_all("acc", "acc_") %>%
    str_replace_all("gyro", "gyro_") %>%
    str_replace_all("mag", "mag_") %>%
    str_replace_all("jerk", "jerk_") %>%
    str_replace_all("body_body", "body") %>%
    str_replace_all("_+", "_") %>%
    str_replace_all("_$", "")
}

names(mean_std_df) <- clean_feature_names(names(mean_std_df))

# Check
glimpse(mean_std_df)

# Creating the new data frame
tidy_avg_df <- mean_std_df %>%
  group_by(subject, activity) %>%
  summarise(
    across(where(is.numeric), ~ mean(.x, na.rm = TRUE)),
    .groups = "drop"
  ) %>%
  arrange(subject, activity)

# Quick check
glimpse(tidy_avg_df)


# Write the data set
write.table(
  tidy_avg_df,
  file = "tidy_data.txt",
  row.names = FALSE,
  quote = FALSE,
  sep = "\t" 
)

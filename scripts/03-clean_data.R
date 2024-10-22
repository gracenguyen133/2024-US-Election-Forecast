# 03-clean_data.R
# Script to clean and preprocess the polling data

# Load necessary libraries
library(dplyr)
library(lubridate)

# Load the raw data
file_path <- "data/01-raw_data/president_polls.csv"
polls_data <- read_csv(file_path)

# Data cleaning steps
cleaned_data <- polls_data %>%
  # Remove rows with missing critical information (pollster, candidate name, polling percentage)
  filter(!is.na(pollster), !is.na(candidate_name), !is.na(pct)) %>%
  # Convert date columns to Date format
  mutate(start_date = mdy(start_date), end_date = mdy(end_date), election_date = mdy(election_date)) %>%
  # Standardize candidate names (e.g., remove extra spaces or special characters)
  mutate(candidate_name = trimws(candidate_name)) %>%
  # Select relevant columns for analysis
  select(pollster, start_date, end_date, candidate_name, pct, sample_size, state, methodology, party, election_date)

# Handle missing values in 'state' column
# Replace missing state values with "National" for nationwide polls
cleaned_data <- cleaned_data %>%
  mutate(state = ifelse(is.na(state), "National", state))

# Save the cleaned data to the analysis_data folder
write_csv(cleaned_data, "data/02-analysis_data/cleaned_polls_data.csv")

# Display a summary of the cleaned data
summary(cleaned_data)

# View a sample of the cleaned data
head(cleaned_data)

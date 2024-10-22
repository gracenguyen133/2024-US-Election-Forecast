# 02-download_data.R
# Script to load and inspect the raw data

# Set the working directory to the main project folder
setwd("C:Downloads/starter_folder-main")

# Load necessary libraries
library(dplyr)
library(readr)

# Set the file path for the raw data
file_path <- "data/01-raw_data/president_polls.csv"

# Read the CSV file
polls_data <- read_csv(file_path)

# View the structure of the data
str(polls_data)


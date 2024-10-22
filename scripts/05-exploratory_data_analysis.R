# 05-exploratory_data_analysis.R
# Script for exploratory data analysis on the cleaned polling data

# Load necessary libraries
library(ggplot2)
library(dplyr)

# Load the cleaned data
file_path <- "data/02-analysis_data/cleaned_polls_data.csv"
cleaned_data <- read_csv(file_path)

# Define major candidates for filtering (example: Biden, Trump, Harris)
major_candidates <- c("Joe Biden", "Donald Trump", "Kamala Harris")

# Filter the data to include only major candidates
filtered_data <- cleaned_data %>% filter(candidate_name %in% major_candidates)

# Plot the polling percentage for major candidates over time
ggplot(filtered_data, aes(x = end_date, y = pct, color = candidate_name)) +
  geom_smooth(se = FALSE, size = 1.2) +
  labs(title = "Average Polling Percentage Over Time for Major Candidates",
       x = "End Date of Poll",
       y = "Polling Percentage",
       color = "Candidate") +
  scale_color_manual(values = c("Joe Biden" = "blue", 
                                "Donald Trump" = "red", 
                                "Kamala Harris" = "purple")) +
  theme_minimal() +
  theme(legend.position = "top")

# Save the improved plot
ggsave("data/02-analysis_data/average_polling_over_time_improved.png", width = 10, height = 6)

# Improved Plot for Polling Percentages by State

# Filter the data to include only major candidates and exclude national polls
state_data <- cleaned_data %>%
  filter(candidate_name %in% major_candidates & state != "National")

# Plot polling percentages by state for major candidates
ggplot(state_data, aes(x = reorder(state, pct, FUN = median), y = pct, fill = candidate_name)) +
  geom_boxplot(outlier.size = 0.5, alpha = 0.7) +
  labs(title = "Polling Percentages by State for Major Candidates",
       x = "State",
       y = "Polling Percentage",
       fill = "Candidate") +
  scale_fill_manual(values = c("Joe Biden" = "blue", 
                               "Donald Trump" = "red", 
                               "Kamala Harris" = "purple")) +
  theme_minimal(base_size = 14) + # Increase base font size for better readability
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10), # Rotate x-axis text for better fit
        legend.position = "top") +
  coord_cartesian(clip = "off") # Ensure plot elements aren't cut off

# Save the improved plot
ggsave("data/02-analysis_data/polling_by_state_improved_size.png", width = 16, height = 8)

# Filter to show only the top 20 pollsters with the most polls
top_pollsters <- pollster_counts %>% 
  top_n(20, num_polls)

# Plot the number of polls by the top 20 pollsters
ggplot(top_pollsters, aes(x = reorder(pollster, num_polls), y = num_polls)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Number of Polls Conducted by Top 20 Pollsters for Major Candidates",
       x = "Pollster",
       y = "Number of Polls") +
  theme_minimal(base_size = 14) + # Increase base font size for better readability
  theme(axis.text.y = element_text(size = 12), # Increase font size for y-axis text
        plot.title = element_text(hjust = 0.5)) # Center the plot title

# Save the improved plot
ggsave("data/02-analysis_data/polls_by_top_pollsters_improved.png", width = 12, height = 8)

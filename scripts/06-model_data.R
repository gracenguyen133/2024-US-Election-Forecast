# 06-model_data.R
# Script for training a Gradient Boosting model to predict election outcomes

# Load necessary libraries
library(dplyr)
library(xgboost)
library(caret)
library(Matrix)

# Load the cleaned data
file_path <- "data/02-analysis_data/cleaned_polls_data.csv"
cleaned_data <- read_csv(file_path)

# Filter data for major candidates
model_data <- cleaned_data %>%
  filter(candidate_name %in% c("Joe Biden", "Donald Trump", "Kamala Harris")) %>%
  mutate(candidate_win = ifelse(pct == max(pct), 1, 0)) %>%
  select(candidate_name, pct, sample_size, state, methodology, party, candidate_win) %>%
  na.omit()

# Convert categorical variables to factors
model_data <- model_data %>%
  mutate(state = as.factor(state),
         methodology = as.factor(methodology),
         party = as.factor(party))

# Encode categorical variables using one-hot encoding
dummies <- dummyVars(candidate_win ~ ., data = model_data)
model_data_encoded <- predict(dummies, newdata = model_data)
model_data_encoded <- as.data.frame(model_data_encoded)

# Add the target variable back to the encoded data
model_data_encoded$candidate_win <- model_data$candidate_win

# Split data into training and testing sets (70-30 split)
set.seed(123)
trainIndex <- createDataPartition(model_data_encoded$candidate_win, p = 0.7, list = FALSE)
training_set <- model_data_encoded[trainIndex, ]
testing_set <- model_data_encoded[-trainIndex, ]

# Convert datasets to matrix format for xgboost
dtrain <- xgb.DMatrix(data = as.matrix(training_set %>% select(-candidate_win)), label = training_set$candidate_win)
dtest <- xgb.DMatrix(data = as.matrix(testing_set %>% select(-candidate_win)), label = testing_set$candidate_win)

# Define hyperparameters for the Gradient Boosting model
params <- list(
  objective = "binary:logistic",
  eval_metric = "logloss",
  eta = 0.1, # Learning rate
  max_depth = 6, # Maximum depth of a tree
  subsample = 0.8, # Subsampling ratio of the training instances
  colsample_bytree = 0.8 # Subsampling ratio of columns
)

# Train the model
set.seed(123)
xgb_model <- xgb.train(params = params, 
                       data = dtrain, 
                       nrounds = 100, # Number of boosting rounds
                       watchlist = list(train = dtrain, test = dtest),
                       early_stopping_rounds = 10, # Stop if no improvement in 10 rounds
                       verbose = 1)

# Predict on the testing set
testing_set$predicted_prob <- predict(xgb_model, dtest)
testing_set$predicted_class <- ifelse(testing_set$predicted_prob > 0.5, 1, 0)

# Evaluate model performance
confusion_matrix <- confusionMatrix(as.factor(testing_set$predicted_class), 
                                    as.factor(testing_set$candidate_win))
print(confusion_matrix)

# Save the model
xgb.save(xgb_model, "data/02-analysis_data/xgb_model.model")

# Save the results
write_csv(testing_set, "data/02-analysis_data/testing_set_results.csv")

# Display feature importance
importance <- xgb.importance(model = xgb_model)
xgb.plot.importance(importance)

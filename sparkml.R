library(readr)  
library(dplyr)  
library(plumber)
library(SparkR)




url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"  
df <-  
read_delim(url, delim = ";") %>%  
dplyr::mutate(taste = as.factor(ifelse(quality < 6, "bad", ifelse(quality > 6, "good", "average")))) %>%  
dplyr::select(-quality)  
df <- dplyr::mutate(df, id = as.integer(rownames(df)))



sparkR.session(master="local[*]")

ddf <- createDataFrame(df)
seed <- 12345  
training_ddf <- sample(ddf, withReplacement=FALSE, fraction=0.7, seed=seed)  
test_ddf <- except(ddf, training_ddf)
model <- spark.randomForest(training_ddf, taste ~ ., type="classification", seed=seed)
summary(model)

predictions <- predict(model, test_ddf)  
prediction_df <- collect(select(predictions, "id", "prediction"))

actual_vs_predicted <-  
dplyr::inner_join(df, prediction_df, "id") %>%  
dplyr::select(id, actual = taste, predicted = prediction)

mean(actual_vs_predicted$actual == actual_vs_predicted$predicted)

tablePred = table(actual_vs_predicted$actual, actual_vs_predicted$predicted)


#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Echo back the input
#* @get /predicted
function(){
  predictions <- predict(model, test_ddf)  
}

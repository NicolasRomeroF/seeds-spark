library(readr)  
library(dplyr)  
library(plyr) 
library(plumber)
library(SparkR)

sparkR.session(appName = "seedsml")



  url <- "https://storage.googleapis.com/seeds-sparkr/seeds_dataset.txt"
  
df <-  
  read.delim(url, sep="")
df <- dplyr::mutate(df, id = as.integer(rownames(df)))
colnames(df) <- c("area", "perimeter", "compactness", "lengthk" ,"widthk", "asymmetry", "lengthkg", "class", "id")
# 
df <- dplyr::mutate(df, id = as.integer(rownames(df)))

# 

  
  ddf <- createDataFrame(df)
  seed <- 12345
  training_ddf <- sample(ddf, withReplacement=FALSE, fraction=0.7, seed=seed)
test_ddf <- except(ddf, training_ddf)
model <- spark.randomForest(training_ddf, class ~ ., type="classification", seed=seed)
summary(model)


predictions <- predict(model, test_ddf)  
prediction_df <- collect(select(predictions, "id", "prediction"))

actual_vs_predicted <-
  dplyr::inner_join(df, prediction_df, "id") %>%
  dplyr::select(id, actual = class, predicted = prediction)

actualvpred = mean(actual_vs_predicted$actual == actual_vs_predicted$predicted)

tablePred = table(actual_vs_predicted$actual, actual_vs_predicted$predicted)

# 
#* @get /info
function(){
  acc = actualvpred
  list(precision = acc)
}

#* Echo back the input
#* @get /predicted
function(){
  l <- list(a = list(area = 14.88, perimeter =	14.57, compactness =	0.8811, lengthk =	5.554, widthk =	3.333, asymmetry =	1.0180, lengthkg =	4.956))
  test <- ldply (l, data.frame)
  test <- dplyr::select(test,-.id)
  test <- dplyr::mutate(test, id = as.integer(rownames(test)))
  test <- createDataFrame(test)
  
  predictions <- predict(model, test)
  prediction_df <- collect(select(predictions, "id", "prediction"))
}
#* @param area
#* @param perimeter 
#* @param compactness 
#* @param lengthk 
#* @param widthk
#* @param asymmetry 
#* @param lengthkg
#' @post /predict
function(req, area, perimeter, compactness, lengthk, widthk, asymmetry, lengthkg){
  l = list( a = list(
    area = area, 
    perimeter = perimeter, 
    compactness = compactness, 
    lengthk = lengthk,
    widthk = widthk,
    asymmetry = asymmetry,
    lengthkg = lengthkg
  ))
  test <- ldply (l, data.frame)
  test <- dplyr::select(test,-.id)
  test <- dplyr::mutate(test, id = as.integer(rownames(test)))
  test <- createDataFrame(test)
  
  predictions <- predict(model, test)
  prediction_df <- collect(select(predictions, "id", "prediction"))
  pred = prediction_df[1,"prediction"]
  variety = "Kama"
  if(pred == 1){
    variety = "Kama"
  }
  if(pred==2){
    variety = "Rosa"
  }
  if(pred == 3){
    variety = "Canadian"
  }
  list(variety=variety)
}

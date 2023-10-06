# Import data about white and red wines: 
white <- read.csv("https://tinyurl.com/winedata1",sep = ";") 
red <- read.csv("https://tinyurl.com/winedata2",sep = ";") 

# Add a type variable: 
white$type <- "white" 
red$type <- "red" 

# Merge the datasets: 
wine <- rbind(white, red) 
wine$type <- factor(wine$type) 

#install packages (if needed)
#install.packages('caret', dependencies = TRUE) 
#install.packages('MLeval', dependencies = TRUE) 

#load packages
library(caret) 
library(MLeval) 
library(ggplot2)

#train model using 10-fold cross-validation, 
#using AUC to choose the best k.
tc <- trainControl(method = 'repeatedcv',
                   number = 10,
                   repeats = 100,
                   savePredictions = TRUE,
                   classProbs = TRUE)
m <- train(type ~ pH + alcohol + fixed.acidity 
           + residual.sugar,
           data = wine,
           trControl = tc,
           method = "glm",
           family = "binomial")

#print model summary
print(summary(m))

#evaluate the model
plots <- evalm(m)

#create a ROC plot
plots$roc

#construct confidence interval
plots$optres[[1]][13,]

# Calibration curve:
plots$cc
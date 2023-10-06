# kNN_classification_model_wine

### The Data ###
The data was retrieved from <a href="https://modernstatisticswithr.com/index.html">Modern Statistics with R by Måns Thulin</a>. 
This project was created for MDSD-531: Statistics for Data Science at the University of the Cumberlands.

### Setting up and Training the KNN Model ###
To fit the KNN model, I used the following code to import the data, create a working data set with new classifications, and import packages: 
```
white <- read.csv("https://tinyurl.com/winedata1",sep = ";") 
red <- read.csv("https://tinyurl.com/winedata2",sep = ";") 
white$type <- "white" 
red$type <- "red"
wine <- rbind(white, red) 
wine$type <- factor(wine$type) 
install.packages('caret', dependencies = TRUE) 
library(caret)  
install.packages('MLeval', dependencies = TRUE) 
library(MLeval)
```
This code was provided by Thulin in Modern statistics with R (Thulin, 2022).

Next, to train the model, I used the following code:
```
#train model using 10-fold cross-validation
tc <- trainControl(method = 'repeatedcv',
                   number = 10,
                   repeats = 100,
                   savePredictions = TRUE,
                   classProbs = TRUE)
#create model
m <- train(type ~ pH + alcohol + fixed.acidity 
           + residual.sugar,
           data = wine,
           trControl = tc,
           method = "glm",
           family = "binomial")
#print model summary
print(summary(m))
[1] Call:
NULL
Coefficients:
Estimate
(Intercept)     48.74549
pH             -11.74537
alcohol          0.29403
fixed.acidity   -1.84802
residual.sugar   0.35473
                   Std. Error     z value
(Intercept)       1.67047  29.181
pH                0.39285 -29.898
alcohol           0.04457   6.597
fixed.acidity     0.05973 -30.941
residual.sugar    0.01995  17.784
               Pr(>|z|)    
(Intercept)     < 2e-16 ***
pH              < 2e-16 ***
alcohol         4.2e-11 ***
fixed.acidity   < 2e-16 ***
residual.sugar  < 2e-16 ***
---
Signif. codes:  
  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’
  0.05 ‘.’ 0.1 ‘ ’ 1
(Dispersion parameter for binomial family taken to be 1)
Null deviance: 7251  on 6496  degrees of freedom
Residual deviance: 3175  on 6492  degrees of freedom
AIC: 3185
Number of Fisher Scoring iterations: 7
```

By looking at the summary of the model, I can see that the model looks like it is fitting the data well due to the low p-values. Next, I determine the accuracy and Kappa value using the code below to assess the model’s prediction accuracy: 
```
> m
Generalized Linear Model 
6497 samples
   4 predictor
   2 classes: 'red', 'white' 
No pre-processing
Resampling: Cross-Validated (10 fold, repeated 100 times) 
Summary of sample sizes: 5847, 5849, 5847, 5847, 5847, 5847, ... 
Resampling results:
  Accuracy   Kappa    
  0.8928447  0.7036358
The accuracy of the model is about 0.893, showing that the model is accurately predicting the classes of wine 89% of the time. The Cohen’s Kappa is about 0.704, which measures the model’s ability to predict the classes against the actual classification. In this case, the model successfully does this 70% of the time. With both the accuracy and Kappa value being greater than 60%, the model is doing well at predicting the classifications (KNIMETV, 2020).

### Evaluating the Model ###
To evaluate the model, I created a ROC plot. A ROC plot helps assess the overall classification ability of the model. I used the following code to create a ROC plot: 
> #evaluate the model
> plots <- evalm(m)
***MLeval: Machine Learning Model Evaluation***
Input: caret train function object
Averaging probs.
Group 1 type: repeatedcv
Observations: 6497
Number of groups: 1
Observations per group: 6497
Positive: white
Negative: red
Group: Group 1
Positive: 4898
Negative: 1599
***Performance Metrics***
Group 1 Optimal Informedness = 0.784736836594738
Group 1 AUC-ROC = 0.95
```
Figure 1: Precision Gain vs. Recall Gain
![precision vs recall (sensitivity)](https://github.com/samaguiar/kNN_classification_model_wine/assets/89755252/51bb1369-75d9-4304-9969-d8042287b0bf)

Figure 2: Precision vs. Recall (Sensitivity)
![precision vs recall](https://github.com/samaguiar/kNN_classification_model_wine/assets/89755252/059a8f19-b007-46aa-9590-950120c679a2)

Figure 3: ROC Plot
![ROC plot](https://github.com/samaguiar/kNN_classification_model_wine/assets/89755252/3ab47103-a8db-4974-840a-c23f55e56837)

According to Thulin, a ROC value greater than 0.5 indicates the model is performing better than a model that randomly guesses and a value of 1 represents the model can perfectly perfect the classifications. Figure 3 shows the AUC-ROC value. The model for wine has a ROC value of 0.95, which indicates that the model is very good at classifying the wines as ‘red’ or ‘white’, with only a few false positives. 
Next, I constructed a confidence interval to help determine how reliable the ROC value is for the model. I used the following code: 
```
> plots$optres[[1]][13,]
        Score        CI
AUC-ROC  0.95 0.95-0.95
```

The output shows that with 95% confidence the ROC values should always be 0.95. Since the confidence interval is 0.95-0.95, this suggests that there is no variability. While this could be accurate, this is normally not the case for confidence intervals and suggests that there may need to be changes to the model. To determine if this was a case of no variability, I increased and decreased the number of repeats of the training to see if this would change the confidence interval. I used the following models and the output was the same for both:
```
#increased number of repeats
>tc <- trainControl(method = 'repeatedcv',
                   number = 10,
                   repeats = 1000,
                   savePredictions = TRUE,
                   classProbs = TRUE)
>mI <- train(type ~ pH + alcohol + fixed.acidity 
           + residual.sugar,
           data = wine,
           trControl = tc,
           method = "glm",
           family = "binomial")
#decreased number of repeats
>tc <- trainControl(method = 'repeatedcv',
                   number = 10,
                   repeats = 50,
                   savePredictions = TRUE,
                   classProbs = TRUE)
>mD <- train(type ~ pH + alcohol + fixed.acidity 
           + residual.sugar,
           data = wine,
           trControl = tc,
           method = "glm",
           family = "binomial")
```

After running plots$optres[[1]][13,] for each new model, the confidence interval was the same, as seen in the output below:
```
Score        CI
AUC-ROC  0.95 0.95-0.95
```
Lastly, I created a calibration curve to show how well calibrated the model is. In this plot, I look for the predicted probabilities to follow the actual frequencies closely (Thulin, 2022). I used the following code:
```
> plots$cc
```
Figure 4: Calibration Curve
![calibration curve](https://github.com/samaguiar/kNN_classification_model_wine/assets/89755252/5725478a-5cb8-4eb7-a465-4fb41b581202)
In this model, the predicted probability follows the true probability fairly closely, indicating this is a well-calibrated model. 

### References ###
Thulin, M. (2022, June 9). Modern statistics with R. https://modernstatisticswithr.com/mlchapter.html 
KNIMETV. (2020, October 6). Cohen’s kappa. YouTube. https://www.youtube.com/watch?v=GNpAWoG5skM 


# Import data about white and red wines: 
white <- read.csv("https://tinyurl.com/winedata1",sep = ";") 
red <- read.csv("https://tinyurl.com/winedata2",sep = ";") 
# Add a type variable: 
white$type <- "white" 
red$type <- "red" 
# Merge the datasets: 
wine <- rbind(white, red) 
wine$type <- factor(wine$type) 
install.packages('caret', dependencies = TRUE) 
library(caret) 
# to visualize results you need the following 
install.packages('MLeval', dependencies = TRUE) 
library(MLeval) 
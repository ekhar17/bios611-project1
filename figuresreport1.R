library(tidyverse)
library(tidytext)
library(caret)
library(gbm)

#Load the data
wineswtraits = read_csv('derived_data/wineswtraits.csv')
winequality_red = read.csv("source_data/winequality-red.csv")
winequality_white = read.csv("source_data/winequality-white.csv")

## Make vector with all the common words
word = c("sweet", "price", "smooth", "dry", "light", "fruit", "cheap", "flavorful", "affordable")


## Calculate average and standard deviation of rating by word
averageratingbyword = c()
for (i in 34:42){
  averageratingbyword[i-33] = mean(wineswtraits$reviews.rating[unlist(wineswtraits[,i])], na.rm = TRUE)
}
sdratingbyword = c()
for (i in 34:42){
  sdratingbyword[i-33] = sd(wineswtraits$reviews.rating[unlist(wineswtraits[,i])], na.rm = TRUE)
}

## Make dataframe that include average rating and sd by word
wordsandrating = data.frame(word=word, mean = averageratingbyword, sd = sdratingbyword)
wordsandrating = wordsandrating %>% arrange(desc(mean))

## Make graph
figure1 = ggplot(wordsandrating, aes(x=word, y = mean)) + geom_bar(stat = "identity") +
  geom_errorbar(aes(x=word, ymin=mean- sd, ymax=mean + sd), width=0.3, alpha=0.9, size=.8) + 
  theme_classic()

## Generate Figure 1
png("report1figures/figure1.png", width = 800, height = 600)
print(figure1)
dev.off()

####################################################################


## Create training data set for red wine
trainIndex <- createDataPartition(winequality_red$quality, p = .8, 
                                  list = FALSE, 
                                  times = 1)


### Linear Model for red wine
form <- quality ~ pH +
  alcohol +
  residual.sugar +
  fixed.acidity +
  volatile.acidity +
  free.sulfur.dioxide;


#Make a generalized linear model
train_ctrl <- trainControl(method = "cv", number = 50);
gbmFit1 <- train(form, data = winequality_red %>% slice(trainIndex), 
                 method = "gbm", 
                 trControl = train_ctrl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = FALSE)
x=summary(gbmFit1)


## Create training set for white wine
trainIndex <- createDataPartition(winequality_white$quality, p = .8, 
                                  list = FALSE, 
                                  times = 1)
# White whine linear model
form <- quality ~ pH +
  alcohol +
  residual.sugar +
  fixed.acidity +
  volatile.acidity +
  free.sulfur.dioxide;

## Generate linear model for white wine
train_ctrl <- trainControl(method = "cv", number = 50);
gbmFit2 <- train(form, data = winequality_white %>% slice(trainIndex), 
                 method = "gbm", 
                 trControl = train_ctrl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = FALSE)
y=summary(gbmFit2)

## Combine models 
xy = inner_join(x,y, by = "var")

## Generate plot
figure2 = ggplot(data = xy %>% gather(rel.inf.x, rel.inf.y, -var), 
       aes(x = var, y = rel.inf.y, fill = rel.inf.x)) + 
  geom_bar(stat = 'identity', position = 'dodge') + theme_classic()
figure2

## Save plot
png("report1figures/figure2.png", width = 800, height = 600)
print(figure2)
dev.off()





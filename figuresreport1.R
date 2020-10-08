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


########################################################################

redwines = wineswtraits %>% filter(wine_type =="red")
whitewines = wineswtraits %>% filter(wine_type =="white")
rosewines = wineswtraits %>% filter(wine_type =="rose")
otherwines = wineswtraits %>% filter(wine_type =="other wine")

## Figure out for which rating do people recommend
averagerecommendbyred = c()
for (i in 1:5){
  x = filter(redwines, redwines$reviews.rating == i)
  averagerecommendbyred[i] = mean(x$reviews.doRecommend, na.rm = TRUE)
}
averagerecommendbywhite = c()
for (i in 1:5){
  x = filter(whitewines, whitewines$reviews.rating == i)
  averagerecommendbywhite[i] = mean(x$reviews.doRecommend, na.rm = TRUE)
}
averagerecommendbyrose = c()
for (i in 1:5){
  x = filter(rosewines, rosewines$reviews.rating == i)
  averagerecommendbyrose[i] = mean(x$reviews.doRecommend, na.rm = TRUE)
}
averagerecommendbyothers = c()
for (i in 1:5){
  x = filter(otherwines, otherwines$reviews.rating == i)
  averagerecommendbyothers[i] = mean(x$reviews.doRecommend, na.rm = TRUE)
}
averagerecommend = c()
for (i in 1:5){
  x = filter(wineswtraits, wineswtraits$reviews.rating == i)
  averagerecommend[i] = mean(x$reviews.doRecommend, na.rm = TRUE)
}


## Combine all in one data frame
df = data.frame(Rating = 1:5, red = averagerecommendbyred, white = averagerecommendbywhite, rose = averagerecommendbyrose, other = averagerecommendbyothers, all = averagerecommend)

## Generate figure3 
figure3 = df %>% tidyr::gather("id", "value", 2:6) %>% 
  ggplot(., aes(Rating, value))+
  geom_path(aes(color = id, linetype = id), position = position_dodge(0.4), size = 1) +
  theme_classic() + 
  scale_linetype_manual(values=c("dotted","dotted","dotted","dotted","dotted"))

## Save figure3
png("report1figures/figure3.png")
print(figure3)
dev.off()
  
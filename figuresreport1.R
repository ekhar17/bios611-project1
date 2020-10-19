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
figure1 = ggplot(wordsandrating, aes(x=word, y = mean)) + geom_bar(stat = "identity", aes(reorder(word,-mean),mean, fill = word)) +
  geom_errorbar(aes(x=word, ymin=mean- sd, ymax=mean + sd), width=0.3, alpha=0.9, size=.8) + 
  theme_classic() + labs(title ="Ratings of Wine Based on Word in Review", x = "Word in Review", y = "Average Rating") +
  theme(text=element_text(size=18)) + 
  theme(plot.title = element_text(size=25))

## Generate Figure 1
png("report1figures/figure1.png", width = 800, height = 600)
print(figure1)
dev.off()

####################################################################


## Create training data set for red wine
trainIndex <- createDataPartition(winequality_red$quality, p = .8, 
                                  list = FALSE, 
                                  times = 1)


### Model for red wine
form <- quality ~ pH +
  alcohol +
  residual.sugar +
  fixed.acidity +
  volatile.acidity +
  free.sulfur.dioxide;


#Make a gradient boosting model
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
# White whine model
form <- quality ~ pH +
  alcohol +
  residual.sugar +
  fixed.acidity +
  volatile.acidity +
  free.sulfur.dioxide;

## Generate gradient boosting model for white wine
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
xy$var = factor(xy$var, levels = c("alcohol", "volatile.acidity", "free.sulfur.dioxide",
                     "pH", "fixed.acidity", "residual.sugar"))
## Generate plot
figure2 = ggplot(data = xy %>% gather(rel.inf.x, rel.inf.y, -var), 
       aes(x = var, y = rel.inf.y, fill = rel.inf.x)) + 
  geom_bar(stat = 'identity', position = 'dodge') + theme_classic() + 
  labs(title ="Relative Influence of Components on Quality of Wine", x = "Components", y = "Relative Influence") +
  scale_fill_manual(values=c("dark red", "lightgoldenrod"), name = "Wine Type", labels = c("Red Wine", "White Wine")) + 
  theme(text=element_text(size=16)) + 
  theme(plot.title = element_text(size=25))+
  scale_x_discrete(labels=c("alcohol" = "Alcohol", "volatile.acidity" = "Volatile Acidity",
                            "free.sulfur.dioxide" = "Free Sulfur Dioxide", "pH" = "pH", "fixed.acidity" = "Fixed Acidity", "residual.sugar" = "Residual Sugar"))

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
df = data.frame(Rating = 1:5, "Red Wine" = averagerecommendbyred, "White Wine" = averagerecommendbywhite, "Rose Wine" = averagerecommendbyrose, "Other Wine" = averagerecommendbyothers, "All Wines" = averagerecommend)

## Generate figure3 
figure3 = ggplot(df, aes(Rating, averagerecommend))+
  geom_path(size = 2, colour = "purple") +
  theme_classic() +
  scale_color_manual(values=c("black", "dark grey", "dark red", "pink", "lightgoldenrod")) + 
  scale_linetype_manual(values=c("dotted","dotted","dotted","dotted","dotted")) +
  labs(title ="Proportion Recommended vs Rating", x = "Rating", y = "Proportion Recommend") +
  theme(text=element_text(size=18)) + 
  theme(plot.title = element_text(size=25))

## Save figure3
png("report1figures/figure3.png", width = 800, height = 600)
print(figure3)
dev.off()


###########################################################################################################################
## Generate data for red
averagealcred1 = c()
for (i in 8:14){
  xyz = filter(winequality_red, floor(winequality_red$alcohol) == i)
  averagealcred1[i-7] = mean(xyz$quality, na.rm = TRUE)
}
sdalcred1 = c()
for (i in 8:14){
  xyz = filter(winequality_red, floor(winequality_red$alcohol) == i)
  sdalcred1[i-7] = sd(xyz$quality, na.rm = TRUE)
}

## Generate data for white
averagealcwhite1 = c()
for (i in 8:14){
  xyz = filter(winequality_white, floor(winequality_white$alcohol) == i)
  averagealcwhite1[i-7] = mean(xyz$quality, na.rm = TRUE)
}
sdalcwhite1 = c()
for (i in 8:14){
  xyz = filter(winequality_red, floor(winequality_red$alcohol) == i)
  sdalcwhite1[i-7] = sd(xyz$quality, na.rm = TRUE)
}

## Combine results
alcvsquality1 = data.frame(alcohol = c(8:14,8:14), quality = c(averagealcred1, averagealcwhite1), sd = c(sdalcred1, sdalcwhite1), Wine_Type = c(rep("Red Wine",7), rep("White Wine", 7)))  

## Generate figure 4
figure4 = ggplot(alcvsquality1, aes(y=quality, x= alcohol, color =Wine_Type))+geom_path(size = 1.5)+
  theme_classic() + labs(title ="Effect of Alcohol Content on Quality of Wine", y = "Quality of Wine", x = "Alcohol Content (% ABV)") +
  theme(text=element_text(size=18)) +
  scale_color_manual(values=c("dark red", "lightgoldenrod"), name = "Wine Type") +  theme(plot.title = element_text(size=25))

## Save Figure 4
png("report1figures/figure4.png", width = 800, height = 600)
print(figure4)
dev.off()

#######################################################################################
pdp_data1 <- partial(gbmFit1, "alcohol", n.trees=100);
ggplot(pdp_data1, aes(alcohol,yhat)) + geom_line();

pdp_data2 <- partial(gbmFit2, "alcohol", n.trees=100);
ggplot(pdp_data2, aes(alcohol,yhat)) + geom_line();

## Combine red and white wine data
winequality = rbind(winequality_red, winequality_white)
winequality$Wine_Type = c(rep("Red Wine", 1599), rep("White Wine", 4898))

## Create breaks in data
winequality$alcohol1 = floor(winequality$alcohol)
winequality$volacid = cut(winequality$volatile.acidity, breaks = c(0, 0.4,0.8,1.2), labels = c(0.2, 0.6, 1.0))

## Generate Figure 5
figure5 = ggplot(na.omit(winequality), aes(x=alcohol1, y=volacid, fill= quality)) + 
  geom_tile()+facet_wrap(~Wine_Type)+theme_bw() + 
  labs(title ="Heat Map of Quality of Wine by Alcohol and Volatile Acidity Content", y = "Volatile Acidity (g/L)", x = "Alcohol Content (% ABV)") +
  theme(text=element_text(size=18), axis.line = element_line(colour = "black"),
        strip.background = element_rect(fill = "white", color = "black", size = 1),
        strip.text = element_text(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  scale_fill_gradient(low="light yellow", high="blue")

## Save Figure 5
png("report1figures/figure5.png", width = 800, height = 600)
print(figure5)
dev.off()

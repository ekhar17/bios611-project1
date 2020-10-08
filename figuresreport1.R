library(tidyverse)
library(tidytext)

#Load the data
wine_rev = read_csv('source_data/wine_reviews.csv')
wine_rev2 = read_csv('source_data/447_1.csv')
df = subset(wine_rev2, select = -c(quantities,primaryCategories) )
total_wine_rev = rbind(wine_rev, df)
twv = total_wine_rev[!total_wine_rev$brand == "Carmex",]
twv$name = tolower(twv$name)

## Add info about type of wine
redwine <- c("pinot noir", 'zinfandel', "syrah", "cabernet sauvignon", "merlot", "red blend", "red wine", "red", "bordeaux", "shiraz", "noir", "sangria")
patternwine <- c("wine")
rose <- c("rose", "pink")
whitewine <- c("riesling", "pinot gris", "pinot grigio", "sauvignon blanc", "chardonnay", "chardonnay", "muscat", "pinot blanc", "white wine", "white", "white blend", "moscato")
patternwhite = paste(whitewine, collapse="|")
patternrose = paste(rose, collapse="|")
patternred = paste(redwine, collapse="|")
twv$wine_type = "other alcohol"
twv[grepl(patternwine, twv$name),]$wine_type = "other wine"
twv[grepl(patternwhite, twv$name),]$wine_type = "white"
twv[grepl(patternred, twv$name),]$wine_type = "red"
twv[grepl(patternrose, twv$name),]$wine_type = "rose"
twv$wine_type<- factor(twv$wine_type,levels = c("red", "white", "rose", "other wine", "other alcohol"))

## Filter out other non-wines
onlywine = twv[twv$wine_type != "other alcohol", ]

## Make text lower case
onlywine$reviews.text = tolower(onlywine$reviews.text)

## Find most common words used
writing = onlywine$reviews.text
writing = onlywine$reviews.text
onlywine$reviews.text = tolower(onlywine$reviews.text)
data_frame(writing = writing) %>% 
  unnest_tokens(word, writing) %>%    # split words
  anti_join(stop_words) %>%    # take out "a", "an", "the", etc.
  count(word, sort = TRUE)    # count occurrences
## words common are sweet, price, smooth, dry, light, flavorful, fruit, 
## and affordable

## Make vector with all the common words
word = c("sweet", "price", "smooth", "dry", "light", "fruit", "cheap", "flavorful", "affordable")

## Add columns to test which reviews have the most common word
wineswtraits = onlywine %>% mutate(sweet = str_detect(reviews.text, "sweet"),
                                   price = str_detect(reviews.text, "price"),
                                   smooth = str_detect(reviews.text, "smooth"),
                                   dry = str_detect(reviews.text, "dry"),
                                   light = str_detect(reviews.text, "light"),
                                   fruit = str_detect(reviews.text, "fruit"),
                                   cheap = str_detect(reviews.text, "cheap"),
                                   flavorful = str_detect(reviews.text, "flavorful"),
                                   affordable = str_detect(reviews.text, "affordable"))

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

png("report1figures/figure1.png", width = 800, height = 600)
print(figure1)
dev.off()





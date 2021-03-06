library(tidyverse);
library(tidytext)

#Load the data
wine_rev = read.csv('source_data/wine_reviews.csv')
wine_rev2 = read.csv('source_data/447_1.csv')
winequality_red = read.csv("source_data/winequality-red.csv")
winequality_white = read.csv("source_data/winequality-white.csv")
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

write_csv(wineswtraits, "derived_data/wineswtraits.csv")

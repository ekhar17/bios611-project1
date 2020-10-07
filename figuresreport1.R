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



library(tidyverse)

wineswtraits = read.csv('derived_data/wineswtraits.csv')


## Function to get mode
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

## Function to generate best wine based on taste
bestwineforme <- function(x,y){
  x1 = NA
  x2 = NA
  word = c("sweet", "price", "smooth", "dry", "light", "fruit", "cheap", "flavorful", "affordable")
  for(i in 1:length(word)){
    if(word[i] %in% x){
      x1 = 33+i
    } else{x1 = x1}
  }
  for(i in 1:length(word)){
    if(word[i] %in% y){
      x2 = 33+i 
    } else{x2 = x2}
  }
  filter1 = wineswtraits[unlist(wineswtraits[,x1]),]
  filter2 = filter1[unlist(filter1[,x2]),]
  brand1 = filter2 %>% filter(reviews.rating == max(filter2$reviews.rating)) %>% select(c(brand, name)) %>% getmode()%>% slice(1)
  bestwine = filter2 %>% filter(brand %in% brand1)
  bestwine1 = bestwine %>% select(c(brand, name, wine_type))
  bestwine2 = distinct(bestwine1)
  if(nrow(bestwine2)== 0){
    bestwine2 = c("Sorry, there were no reviews that included both of these words")
  }
  return(bestwine2)
}


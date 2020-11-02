library(tidyverse)

wineswtraits = read.csv('derived_data/wineswtraits.csv')

wineswtraits$wine_type[wineswtraits$wine_type == "red"] = "Red Wine"
wineswtraits$wine_type[wineswtraits$wine_type == "white"] = "White Wine"
wineswtraits$wine_type[wineswtraits$wine_type == "rose"] = "Rose"
wineswtraits$wine_type[wineswtraits$wine_type == "other wine"] = "Other Wine Type"

myColors <- c("dark red", "lightgoldenrod", "pink", "dark gray")
names(myColors) <- c("Red Wine", "White Wine", "Rose", "Other Wine Type")
colScale <- scale_fill_manual(name = "Wine Type",values = myColors)


graphforword <- function(x,y){
  x1 = NA
  word = c("sweet", "price", "smooth", "dry", "light", "fruit", "cheap", "flavorful", "affordable")
  for(i in 1:length(word)){
    if(word[i] %in% x){
      x1 = 33+i
    } else{x1 = x1}
  }
  filter1 = wineswtraits[unlist(wineswtraits[,x1]),]
  means = filter1 %>% group_by(wine_type) %>% summarise(mean = mean(reviews.rating, na.rm = TRUE), sd = sd(reviews.rating, na.rm = TRUE), .groups = 'drop')
  if(y != "Display All Types"){
    means = means %>% filter(wine_type == y)
  }
  figure = ggplot(means, aes(x=wine_type, y = mean)) + geom_bar(stat = "identity",aes(reorder(wine_type,-mean),mean, fill = wine_type)) +
    geom_errorbar(aes(x=wine_type, ymin=mean- sd, ymax=mean + sd), width=0.3, alpha=0.9, size=.8) + 
    theme_classic() + labs(x = "Wine Type", y = "Average Rating")+
    colScale+
    theme(text=element_text(size=18)) + 
    theme(plot.title = element_text(size=25))
  return(figure)
}


################################################################################################################

getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

################################################################################################################

winerec <- function(x,y){
  x1 = NA
  word = c("sweet", "price", "smooth", "dry", "light", "fruit", "cheap", "flavorful", "affordable")
  for(i in 1:length(word)){
    if(word[i] %in% x){
      x1 = 33+i
    } else{x1 = x1}
  }
  filter1 = wineswtraits[unlist(wineswtraits[,x1]),]
  recrating = c()
  recbrands = c()
  recnames = c()
  recwine_type = c()
  maxrev = filter1 %>% group_by(wine_type) %>% summarise(max = max(reviews.rating, na.rm = TRUE), .groups = 'drop')
  for(i in 1:nrow(maxrev)){
      xz = filter1 %>% filter(wine_type == unlist(maxrev[i,1])) %>% filter(reviews.rating ==  unlist(maxrev[i,2]))
      type = xz %>% select(c(name)) %>% getmode()%>% slice(1)
      bestwine = xz %>% filter(name %in% type) %>% select(c(brand, name, wine_type, reviews.rating))
      bestwine1 = distinct(bestwine)
      recbrands[i] = bestwine1[1]
      recnames[i] =bestwine1[2]
      recwine_type[i] = bestwine1[3]
      recrating[i] = bestwine1[4]
    }
  bestwine2 = data.frame(Recommende_Wine_Brand = unlist(recbrands), Recommended_Wine_Name = unlist(recnames), Wine_Type = unlist(recwine_type), Rating = unlist(recrating))
  if(y != "Display All Types"){
    bestwine2 = bestwine2 %>% filter(Wine_Type == y)
  }
  if(nrow(bestwine2)==0){
    bestwine2 ="Sorry, there were no reviews of that wine type that included the word you selected."
  }
  return(bestwine2)
}

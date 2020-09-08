library(tidyverse)

wine_rev = read_csv('source_data/wine_reviews.csv')
wine_rev2 = read_csv('source_data/447_1.csv')
df = subset(wine_rev2, select = -c(quantities,primaryCategories) )
total_wine_rev = rbind(wine_rev, df)
twv = total_wine_rev[!total_wine_rev$brand == "Carmex",]
twv$name = tolower(twv$name)

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

meanreviewsbywine = twv %>% group_by(wine_type) %>% summarise(Mean_Review= mean(reviews.rating, na.rm = TRUE),SD_Review=sd(reviews.rating, na.rm = TRUE), .groups = 'drop')

wineratingbytype = ggplot(meanreviewsbywine, aes(x = wine_type, y = Mean_Review, fill = wine_type)) + 
  geom_bar(stat = "identity")+
  geom_errorbar(aes(x=wine_type, ymin=Mean_Review - SD_Review, ymax=Mean_Review + SD_Review), width=0.3, alpha=0.9, size=.8) + 
  theme_classic() + 
  labs(title ="Ratings of Different Wine Types", x = "Wine Type", y = "Average Rating") +
  scale_fill_manual(values=c("dark red", "lightgoldenrod", "pink", "dark gray", "goldenrod4"), name = "Wine Type", labels = c("Red Wine", "White Wine", "Rose", "Other Wine", "Other Alcohol")) + 
  scale_x_discrete(labels=c("red" = "Red Wine", "white" = "White Wine",
                          "rose" = "Rose", "other wine" = "Other Wine", "other alcohol" = "Other Alcohol")) +
  theme(text=element_text(size=18)) + 
  theme(plot.title = element_text(size=25))

png("figures/wineratingbytype.png", width = 800, height = 600)
print(wineratingbytype)
dev.off()


wineslist = twv[twv$wine_type != "other alcohol", ] %>% count(brand) %>% arrange(desc(n))
winesbrands = head(wineslist,20)
onlywine = twv[twv$wine_type != "other alcohol", ]
topbrandwines = onlywine[onlywine$brand %in% winesbrands$brand,]
brandandtypereviews= topbrandwines %>% group_by(brand, wine_type) %>% summarise(Mean_Review= mean(reviews.rating, na.rm = TRUE),SD_Review=sd(reviews.rating, na.rm = TRUE), .groups = 'drop')
brandandtypereviews = na.omit(brandandtypereviews)
brandandtypereviews = brandandtypereviews[brandandtypereviews$wine_type != "other wine",]
brandandtypereviews = brandandtypereviews[brandandtypereviews$wine_type != "rose",]

redwinebrands = brandandtypereviews %>% filter(wine_type == "red")
whitewinebrands = brandandtypereviews %>% filter(wine_type == "white")
whitewinebrands = whitewinebrands %>% filter(brand != "Jim Beam")

redwinebrands = redwinebrands %>% filter(brand %in% c("California Roots", "Gallo", "Wine Cube153"))
top3brandreviews= rbind(redwinebrands, whitewinebrands)
top3brandreviews

top3winebrandratingbytype = ggplot(aes(x = brand, y = Mean_Review), data = top3brandreviews) +  
  geom_bar(stat = "identity", aes(fill = wine_type), position = "dodge") +
  theme_classic() + 
  labs(title ="Comparison of Brands Ratings by Wine Type", x = "Wine Brand", y = "Average Rating") +
  scale_fill_manual(values=c("dark red", "lightgoldenrod"), name = "Wine Type", labels = c("Red Wine", "White Wine")) + 
  theme(text=element_text(size=18)) + 
  theme(plot.title = element_text(size=25))
png("figures/top3winebrandratingbytype.png", width = 800, height = 600)
print(top3winebrandratingbytype)
dev.off()

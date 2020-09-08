library(tidyverse);

reviews <- read_csv('source_data/447_1.csv');
quality <- read_csv('source_data/winequality-red.csv');

# Do something to clean stuff up.
write.csv(reviews, "derived_data/reviews.csv")
write.csv(quality, "derived_data/quality.csv")

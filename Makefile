.PHONY: clean

clean:
	rm derived_data/*
  
derived_data/reviews.csv derived_data/quality.csv:\
 source_data/447_1.csv\
 source_data/wine_reviews.csv\
 source_data/winequality-red.csv\
 source_data/winequality-white.csv\
 tidy_data.R
	Rscript tidy_data.R
 


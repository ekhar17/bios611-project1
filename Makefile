.PHONY: clean

clean:
	rm -f derived_data/*
	rm -f figures/*.png
  
derived_data/reviews.csv derived_data/quality.csv:\
 source_data/447_1.csv\
 source_data/wine_reviews.csv\
 source_data/winequality-red.csv\
 source_data/winequality-white.csv\
 tidy_data.R
	Rscript tidy_data.R
 
prelimfig/wineratingbytype.png prelimfig/top3winebrandratingbytype.png:\
 source_data/447_1.csv\
 source_data/wine_reviews.csv\
 prelimfig.R
	Rscript prelimfig.R



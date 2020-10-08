.PHONY: clean

clean:
	rm -f derived_data/*
	rm -f prelimfig/*.png

derived_data/wineswtraits.csv:\
 source_data/447_1.csv\
 source_data/wine_reviews.csv\
 tidy_data.R
	Rscript tidy_data.R
 
prelimfig/wineratingbytype.png prelimfig/top3winebrandratingbytype.png:\
 source_data/447_1.csv\
 source_data/wine_reviews.csv\
 prelimfig.R
	Rscript prelimfig.R



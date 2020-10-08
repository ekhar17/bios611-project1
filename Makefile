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

report1figures/figure1.png report1figures/figure2.png report1figures/figure3.png:\
 derived_data/wineswtraits.csv\
 source_data/winequality-red.csv\
 source_data/winequality-white.csv\
 figuresreport1.R
	Rscript figuresreport1.R



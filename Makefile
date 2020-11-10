.PHONY: clean

# This target makes the final Report
Report.pdf:\
 Report.Rmd\
 report1figures/figure1.png\
 report1figures/figure2.png\
 report1figures/figure3.png\
 report1figures/figure4.png\
 report1figures/figure5.png\
 pythonfigure/red_wine_partial_dependency.png\
 pythonfigure/white_wine_partial_dependency.png\
 functions.R
	Rscript -e "rmarkdown::render('Report.Rmd',output_format='pdf_document')"

clean:
	rm -f derived_data/*
	rm -f prelimfig/*.png
	rm -f report1figures/*.png
	rm -f pythonfigure/*.png
	rm -f Report.pdf

# This target makes the figures for report1
report1figures/figure1.png report1figures/figure2.png report1figures/figure3.png report1figures/figure4.png report1figures/figure5.png:\
 derived_data/wineswtraits.csv\
 source_data/winequality-red.csv\
 source_data/winequality-white.csv\
 figuresreport1.R
	Rscript figuresreport1.R

# This target makes the cleaned data
derived_data/wineswtraits.csv:\
 source_data/447_1.csv\
 source_data/wine_reviews.csv\
 tidy_data.R
	Rscript tidy_data.R
 
# This target makes the preliminary figures used in the README
prelimfig/wineratingbytype.png prelimfig/top3winebrandratingbytype.png:\
 source_data/447_1.csv\
 source_data/wine_reviews.csv\
 prelimfig.R
	Rscript prelimfig.R

.PHONY: wine_rec

# This target starts the shiny app
# Don't forget to invoke with the desired port number in an ENV variable
wine_rec: derived_data/wineswtraits.csv Project_2/functions_for_shiny.R
	Rscript Project_2/app.R ${PORT}



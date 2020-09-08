Bios 611 Project 1
==================

Dataset of Reviews and Qualities of Wine and Other Alcoholic Beverages
-----------------------------------------

Proposal
-------------------

### Introduction

Growing up in a household of oenophiles, I always assumed I would grow up with a vast knowledge of wines. After all, my parents have imported cases of wine from Georgia (the country, not the state) and our annual trip to see family friends in Sonoma consisted of visiting at least two wineries every day. There was one slight miscalculation to my plan, the majority of the wine tours occured when I was between the ages of ten and eighteen (below the legal drinking age). Since I was not allowed to attend any tastings, I missed a lot of the crucial information and am now significantly less knowledgeable about brands and types of wine than I would like to be. Unfortunately, the budget of a graduate student and a pandemic has made it difficult to tour wine country and discover novel wine types or buy many different brands and types of wine to discover my taste (two buck chuck has a fairly small selection of wine types), thus I have decided that the next best thing is to analyze data of reviews of wines found online to determine what the best brand and wine type is for my particular taste. 

This project will compute descriptive statistics of various wines by examining their ratings, reviews, and chemical composition. I will also attempt to use the key words in flavors of reviews (eg. sweet, fruity, bold) to develop a model that could predict the best wine (type and brand) based on one's current wine craving. I additionally I will perform regression on the chemical composition and ratings of the wine to determine what is most important in making a good wine, on a fundamental level. 

## Datasets

The datasets I undertake to analyze are publicly available on data.world and cover the chemical composition and reveiws of wine and other alcohols. They can be downloaded.

This repo will eventually contain an analysis of reviews and qualities of wine and other alcoholic beverages.

## Preliminary figures

![](figures/wineratingbytype.png)

The above figure shows a comparison of the average rating of wines by their type. Error bars represent the standard deviation in ratings. It is evident that rose wine has the best reviews out of all the wine types. 

![](figures/top3winebrandratingbytype.png)

When the top three most popular brands that have both red and white wine reviews are compared, it is evident that the type of wine has a large influence on the rating that brand receives.  

Usage
-------

You'll need Docker and the ability to run Docker as your current user.

You'll need to build the container:

     > docker build . -t project1-env

This Docker container is based on rocker/verse. To run rstudio server run:

    > docker run -v `pwd`:/home/rstudio -p 8787:8787\
        -e PASSWORD=happy -t project1-env
        
Then connect to the machine on port 8787

Makefile
-------

The Makefile is an excellent place to look to get a feel for the project.

To build figures relating to the ratings of wines, for example, enter with Rstudio and say:


     > make figures/wineratingbytype.png 


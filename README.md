Bios 611 Project 1

==================

Dataset of Reviews and Qualities of Wine and Other Alcoholic Beverages

-----------------------------------------
This repo will eventually contain an analysis of reviews and qualities of wine and other alcoholic beverages.

Usage
-------

You'll need Docker and the ability to run Docker as your current user.

This Docker container is based on rocker/verse. To run rstudio server run:

    > docker run -v `pwd`:/home/rstudio -p 8787:8787\
        -e PASSWORD=happy -t project1-env
        
Then connect to the machine on port 8787



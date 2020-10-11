FROM rocker/verse
MAINTAINER Elena Kharitonova "ekhar@ad.unc.edu"
RUN R -e "install.packages('tidytext')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('caret')"
RUN R -e "install.packages('MLmetrics')"
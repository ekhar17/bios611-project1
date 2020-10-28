FROM rocker/verse
MAINTAINER Elena Kharitonova "ekhar@ad.unc.edu"
RUN R -e "install.packages('tidytext')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('caret')"
RUN R -e "install.packages('MLmetrics')"
RUN R -e "install.packages('Rtsne')"
RUN R -e "install.packages('e1071')"
RUN apt update -y && apt install -y python3-pip
RUN pip3 install jupyter jupyterlab
RUN pip3 install numpy pandas sklearn plotnine matplotlib pandasql bokeh
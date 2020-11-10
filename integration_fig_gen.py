## Load libraries

import numpy as np
import pandas as pd
from sklearn.manifold import TSNE
from plotnine import *
from sklearn.cluster import SpectralClustering
from sklearn.metrics import pairwise_distances
from sklearn.preprocessing import MinMaxScaler
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.inspection import partial_dependence
from sklearn.inspection import plot_partial_dependence



## Load files

winequality_red = pd.read_csv("source_data/winequality-red.csv")
winequality_white = pd.read_csv("source_data/winequality-white.csv")



## Create data fram with only those columns used for gbm model 

winequality_red1 = winequality_red[['alcohol', 'residual sugar', 'pH', 'fixed acidity', 'free sulfur dioxide', 'volatile acidity']]
winequality_white1 = winequality_white[['alcohol', 'residual sugar', 'pH', 'fixed acidity', 'free sulfur dioxide', 'volatile acidity']]



## Create gbm for red wine

y = winequality_red["quality"]
my_model = GradientBoostingRegressor()
my_model.fit(winequality_red1, y)



## Create gbm for white wine

my_model1 = GradientBoostingRegressor()
y1 = winequality_white["quality"]
my_model1.fit(winequality_white1, y1)


## Save partial dependency plot for red wine

plt.figure()
plot_partial_dependence(my_model,       
                                   features=[0, 5], # column numbers of plots we want to show
                                   X=winequality_red1,            # raw predictors data.
                                   feature_names=['Red Wine Alcohol Content', 'residual sugar', 'pH', 'fixed acidity', 'free sulfur dioxide', 'Red Wine Volatile Acidity Content'], # labels on graphs
                                   grid_resolution=50)
plt.savefig('pythonfigure/red_wine_partial_dependency.png', format = 'png')                                   
                                   

## Save partial dependency plot for white wine

plt.figure()
plot_partial_dependence(my_model1,       
                                   features=[0, 5], # column numbers of plots we want to show
                                   X=winequality_white1,            # raw predictors data.
                                   feature_names=['White Wine Alcohol Content', 'residual sugar', 'pH', 'fixed acidity', 'free sulfur dioxide', 'White Wine Volatile Acidity Content'], # labels on graphs
                                   grid_resolution=50)
plt.savefig('pythonfigure/white_wine_partial_dependency.png', format = 'png')

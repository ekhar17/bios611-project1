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
winequality_red = pd.read_csv("source_data/winequality-red.csv")
winequality_white = pd.read_csv("source_data/winequality-white.csv")
y = winequality_red["quality"]
winequality_red1 = winequality_red[['alcohol', 'residual sugar', 'pH', 'fixed acidity', 'free sulfur dioxide', 'volatile acidity']]
winequality_white1 = winequality_white[['alcohol', 'residual sugar', 'pH', 'fixed acidity', 'free sulfur dioxide', 'volatile acidity']]
my_model = GradientBoostingRegressor()
my_model.fit(winequality_red1, y)
my_plots1 = plot_partial_dependence(my_model,       
                                   features=[0, 5], # column numbers of plots we want to show
                                   X=winequality_red1,            # raw predictors data.
                                   feature_names=['Red Wine Alcohol Content', 'residual sugar', 'pH', 'fixed acidity', 'free sulfur dioxide', 'Red Wine Volatile Acidity Content'], # labels on graphs
                                   grid_resolution=50)
my_model1 = GradientBoostingRegressor()
y1 = winequality_white["quality"]
my_model1.fit(winequality_white1, y1)
my_plots2 = (plot_partial_dependence(my_model1,       
                                   features=[0, 5], # column numbers of plots we want to show
                                   X=winequality_white1,            # raw predictors data.
                                   feature_names=['White Wine Alcohol Content', 'residual sugar', 'pH', 'fixed acidity', 'free sulfur dioxide', 'White Wine Volatile Acidity Content'], # labels on graphs
                                   grid_resolution=50))
plt.figure()
plot_partial_dependence(my_model,       
                                   features=[0, 5], # column numbers of plots we want to show
                                   X=winequality_red1,            # raw predictors data.
                                   feature_names=['Red Wine Alcohol Content', 'residual sugar', 'pH', 'fixed acidity', 'free sulfur dioxide', 'Red Wine Volatile Acidity Content'], # labels on graphs
                                   grid_resolution=50)
plt.savefig('pythonfigure/red_wine_partial_dependency.png', format = 'png')
plt.figure()
plot_partial_dependence(my_model1,       
                                   features=[0, 5], # column numbers of plots we want to show
                                   X=winequality_white1,            # raw predictors data.
                                   feature_names=['White Wine Alcohol Content', 'residual sugar', 'pH', 'fixed acidity', 'free sulfur dioxide', 'White Wine Volatile Acidity Content'], # labels on graphs
                                   grid_resolution=50)
plt.savefig('pythonfigure/white_wine_partial_dependency.png', format = 'png')
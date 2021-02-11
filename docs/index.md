---
title: "Data Visualization"
author: "Andrew Irwin"
date: "2021-02-10"
site: bookdown::bookdown_site
---

# Welcome {.unnumbered}

Data visualization is a critical skill for anyone interested in using data to think and persuade. 

This course focusses on three aspects of data visualization: 

* What makes a good data visualization?
* Designing, improving, and communicating with visualizations, and 
* the technical computer skills needed to create visualizations.

##  What is Data Visualization? {-}

Data visualization is the practice of turning data into graphics. Good graphics are more easily interpreted than the raw data. A well-designed visualization is faithful to the original data and does not mislead the intended audience. Almost every data visualization is a simplification and approximation of a raw dataset, and thus involves a perspective--the goals and biases of the person producing the visualization.

Data visualization approaches vary. For some purposes, highly customized graphic design and visual style are paramount. That's not our focus. We emphasize standardized graphical presentations -- which span a wide variety of visualizations -- that minimize the use of graphical elements not directly linked to the data.

## What is the purpose of data visualization? {-}

Data visualization is used to help tell [stories](https://clauswilke.com/dataviz/telling-a-story.html) with data. The usual goal is to communicate an interpretation of a dataset to a particular audience, to make an argument you have worked out from an analysis of the data. The visualization is a device to help you do that. Visualizations are best when accompanied by written explanations; even if a [picture is worth a thousand words](https://en.wikipedia.org/wiki/A_picture_is_worth_a_thousand_words), visualizations do not usually stand on their own. Once the message is understood and internalized, a good visualization can sometimes tell the story "by itself".
  
## Course Goals {#goals .unnumbered}

By the end of the course you will be familiar with several aspects of data visualzation.

*Visual impact and aesthetic aspects of graphics*

- Understand the relationship between the structure of your data and the perceptual features of your graphics.
- Describe aesthetic features of good plots. 
- Use length, shape, size, colour, annotations, and other features to effectively display data and enable comparitive visual interpretation.

*Visualization as communication*

- Visualization is a visual language for communication, which should be accompanied by written interpretations
- Communication effectiveness should be evaluated by peer-review and critical, constructive feedback
- Visualizations should be developed through an iterative process akin to editing text, including the process of refining plots to highlight key features of the data, labeling items of interest, annotating plots, and changing overall appearance
- Visualizations can be presented in different formats for different audiences and different communications goals

*Computing skills*

- Learn the basics of using R, Rstudio, several R add-on packages, and git
- Read data in several different formats into R
- Create graphs with ggplot2 for continuous and categorical variables with informative legends.
- Add error bars, linear models, smooths, labels, and other annotations to a graph
- Create small-multiple (facetted) plots.
- Use the principles of [tidy data](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html) tables to facilitate transformation and analysis of data. Reshape data to make it tidy.
- Summarize and transform data using dplyr
- Reshape data using pivots
- Create maps and some alternatives for presenting spatial data.
- Write reproducible documents with R markdown to document your analysis process and present your results
- Distribute data, code, and results using git and github
- Access and interpret help resources (built-in help, vignettes, web pages, online discussion forums, blogs).
- Develop skills for independently learning new data visualization methods and software

*Statistical models*

- Use a variety of modeling techniques such as LOESS, OLS, robust regression, polynomial regression, and quantile regression
- Learn how to extract model information to compare different statistical models
- Use principal component analysis (PCA) to reduce the dimensionality of complex datasets, increasing interpretability while minimizing information loss
- Use multidimensional scaling (MDS) to visualize and compare similarities and dissimilarities between variables
- Divide observations into homogeneous and distinct groups using K-means


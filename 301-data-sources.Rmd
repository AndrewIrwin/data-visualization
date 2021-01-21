# Data sources {#data-sources}

## Built-in and existing packages

Go-to datasets useful for lots of simple visualizations:

* mtcars and many other well-known data in datasets package
* penguins in palmerpenguins package
* gapminder in gapminder package  (but see website too [Gapminder](https://www.gapminder.org/data/))
* diamonds, mpg, economics, midwest, msleep in ggplot2 package
* nycflights13 in dbplyr package
* gss_sm, gss_cat, gss_sib, gss_lon and gss_lon in socviz package

## Tidy Tuesday

Tidy Tuesday is a project to encourage people to develop skills at data visualization and analysis using the tidyverse packages in R. Each week a new data set is posted and participants experiment to create new visualzations. Some people share their work on github and social media.

* Tidy Tuesday [website](https://github.com/rfordatascience/tidytuesday) describes the project and has a catalog of available datasets from previous weeks.
* The R package to access the data is called `tidytuesdayR`. Examples of using the package are [here](https://github.com/thebioengineer/tidytuesdayR)

## R packages for accessing data

* OECD for data from the OECD
* cansim for data from Statistics Canada
* cancensus for data from the Canadian census and National household survey

## Websites with data collections

* [Our World In Data](https://ourworldindata.org/) a curated set of over 3000 charts with documentation and open source data.
* [Awesome data](https://github.com/awesomedata/awesome-public-datasets) project
* One person's collection of [data](https://github.com/tacookson/data) of various sources


## Distribution of data

* [FAIR](https://en.wikipedia.org/wiki/FAIR_data)

## Canadian COVID data

* [Federal](https://health-infobase.canada.ca/covid-19/visual-data-gallery/), [BC](https://experience.arcgis.com/experience/a6f23959a8b14bfa989e3cda29297ded), [AB](https://www.alberta.ca/stats/covid-19-alberta-statistics.htm), [SK](https://dashboard.saskatchewan.ca/health-wellness/covid-19/cases), [MB](https://www.arcgis.com/apps/opsdashboard/index.html#/29e86894292e449aa75763b077281b5b?rha=Winnipeg), [ON](https://covid-19.ontario.ca/data), [QC](https://www.inspq.qc.ca/covid-19/donnees/par-region), [NB](https://experience.arcgis.com/experience/8eeb9a2052d641c996dba5de8f25a8aa), [PE](https://www.princeedwardisland.ca/en/information/health-and-wellness/pei-covid-19-case-data), [NS](https://novascotia.ca/coronavirus/data/), 



## Useful packages

datapasta

web app for getting data from graphs datathief (Mohammad has one he likes)

## Describing data

https://data.research.cornell.edu/content/readme

## Statistics Canada

### Canada population projection

Here are some data projecting the population of Canada for the next 50 years.
cansim::get_cansim("17100057")  # 2 million rows, 300 MB of data




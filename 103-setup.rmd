# Setting up your computer {#setup}

## Goals

In this lesson you will start using the computer tools introduced in the previous lesson.

Your [task](#task-2) for this lesson is to follow along with the instructions and provide some information on Brightspace at the link marked Task 2.

## Introduction

The statistical software R and RStudio and version control software git will be used in this course. No prior experience with
R, RStudio or git is assumed. We'll take class time to learn the software.

In this lesson you will 

* install the software on your computer, 
* learn to use the software "in the cloud",
* create a github account, and
* complete a task to let me know this is done or ask for help and tell me your github account name.

The steps below are demonstrated for a Windows and Macintosh computer in [videos](https://dal.brightspace.com/d2l/le/content/159870/Home?itemIdentifier=D2L.LE.Content.ContentObject.ModuleCO-2083726) on Brightspace. available on Brightspace. If you use a Chromebook, you can't install this software, so skip ahead to the rstudio.cloud section. If you use linux, follow the instructions below to install the software and contact me if you have trouble.

## R

* To download and install R go to [r-project.org](https://www.r-project.org/) and click on the link to [download R](http://cran.r-project.org/mirrors.html)

## Rstudio

* To download and install Rstudio, go to [Rstudio.com](https://www.rstudio.com/) and click on the link to [download Rstudio](https://rstudio.com/products/rstudio/download/)

## Git

* To download and install git: 
  * on Windows, go to [git-scm.org](https://git-scm.org) and click on the link to [download a version for Windows](https://git-scm.com/download/win)
  * on Macintosh, use the [Terminal app](https://www.dummies.com/computers/macs/mac-operating-systems/unix-terminal-application-on-your-macbook/) and type `xcode-select --install` to download and install git. There should be two minus signs in front of "install"; some web browsers may display this incorrectly as a dash (one symbol).

## rstudio.cloud

If you have a Chromebook you can use R, Rstudio and git through the cloud service [rstudio.cloud](https://rstudio.cloud/project/1998812). **Everyone** should learn to use the cloud service as a backup in case of problems with the software on their own computer.

## Dalhousie on-campus labs

R and Rstudio are available on Dalhousie computer labs, but the git version control software must be installed following the instructions for Windows computers above. Since all your user files are erased from lab computers when you log out, this process must be repeated on each login.

## Packages

You are not done downloading and installing software yet! Most of the tools we will use with R are distributed as add-on packages. These are bundles of software that add new functions to R. There are three steps to use a pacakge:

* Install the package (done only once)
* Tell R you will be using the package (done each time you start R)
* Learn how to use the package (a major goal of this course)

I install new packages all the time on my machine. Right now I have 203 installed. It's also common to update to new versions. Rstudio trys to help you identify packages you need to install -- we'll see how later on. An optional task for today is to install packages suggested by Healy in his [Preface](https://socviz.co/index.html#install). (We'll use lots more packages than this, but this is a good start.) Cut and paste the following R code into the window marked "Console" in Rstudio.

```
my_packages <- c("tidyverse", "broom", "coefplot", "cowplot",
                 "gapminder", "GGally", "ggrepel", "ggridges", "gridExtra",
                 "here", "interplot", "margins", "maps", "mapproj",
                 "mapdata", "MASS", "quantreg", "rlang", "scales",
                 "survey", "srvyr", "viridis", "viridisLite", 
                 "socviz", "devtools", "patchwork")

install.packages(my_packages)
```

## Github

Github is a web service for sharing and publishing github repositories and many related services. For today, all you need to do is [create an account](https://github.com/join?ref_cta=Sign+up) and tell me your github name on a Brightspace quiz. Once I have your github name I will send you an invitation to join course resources by email.




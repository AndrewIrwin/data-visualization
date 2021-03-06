# Evaluation {#evaluation .unnumbered}

All the work students will complete for evaluation and credit in the course is described below.

## Tasks {-}

Tasks for each lesson are described here. Each task is designed to demonstrate a particular skill or idea from the lesson or prepare for the next lesson.

Tasks will usually be evaluated on a 0-10 scale on the following rubric:

* 0-5: Work missing or mostly incomplete.
* 6-7: Mostly complete or complete with major deficiencies.
* 8: Complete and meets expectations.
* 9-10: Complete and excels in some respect: organization, clarity, creativity. 

### Task 1 (Lesson 1) {#task-1 .unnumbered}

Find two data visualizations that you find informative, compelling, or in need of improvement.

Create a document that shows each visualization (the figure, or a snapshot of a dynamic visualization), provides the source (e.g., url and publication details if applicable). In a few sentences describe 

1. the data behind the visualization, 
2. main message conveyed by the visualization,
3. one or two features of the visualization that make it effective or suggestions for improvement. 

The goal of this project isn't to be right or wrong, but rather to start the process of looking at data visualizations through the perspective of creator, designer, and critic. It's okay if you find visualizations from secondary sources and not the creator or original publisher. Include the reference to the source you used to find the visualiztions.

Submit your work as a single PDF on Brightspace.

Due Monday 11 January at 9:00 am Atlantic.

### Bonus task (Lesson 2)  {#task-b1 .unnumbered}

Read [Healy, Sections 2.1-2.4](https://socviz.co/gettingstarted.html#gettingstarted). There is nothing to submit for this task.

### Task 2 (Lesson 3) {#task-2 .unnumbered}

See the instructions in the [syllabus](#syllabus_software) or in [Lesson 3 notes](#setup)

1. Install R, Rstudio, and the packages identified in Healy's [Preface](https://socviz.co/index.html#install).
2. Install git.
3. Create a github account. 
2. Login to [rstudio.cloud](https://rstudio.cloud/project/1998812). This is a complete R, Rstudio, and git setup "in the cloud" that can be used if you have trouble using R on your own computer.
5. Ask for help with any of these tasks if you need it. 

Answer the quiz on Brightspace which will ask if you were successful with each task or if you need help. Provide your github name in one of the quiz questions. 

Due Monday 18 January at 9:00 am Atlantic.

### Task 3 (Lesson 4) {#task-3 .unnumbered}

1. Some people feel very strongly about the placement of 0 on the vertical scale of plots. Look again at the carbon dioxide plots in [Lesson 1](#ch-invitation). The vertical scale does not start at 0. Use the ideas in [Healy Chapter 1.6](https://socviz.co/lookatdata.html#problems-of-honesty-and-good-judgment) to describe how you would interpret vertical position on the carbon dioxide plots and how you could interpret this position if 0 was included on the vertical scale.

2. Hans Rosling's visualizations (as shown in [Lesson 1](#ch-invitation)) use many channels for conveying data: x and y position, color, size, an annotation for year in the plot background. The interactive versions use an animation for change over time, and mouse-over pop-ups to identify the country for each dot. These are very complex visualizations! 

a. For Rosling's plot showin in Lesson 1, what variables are shown for each of x and y position, color, and symbol size?
b. According to [Healy Chapter 1](https://socviz.co/lookatdata.html#channels-for-representing-data) which of these 4 features is most difficult to make quantitative comparisons with? Why? Do you agree? 
c. In your judgment, is this visualization effective or too complex? Watch the [TED talk](https://www.ted.com/talks/hans_rosling_the_best_stats_you_ve_ever_seen) or experiment with the [interactive version](https://bit.ly/3oAb0Uq) before answering the question. Does the live explanation provided in Rosling's oral presentation help you interpret the plot?

Write answers for these two questions in a word processor (we'll start using R markdown soon) and submit as a single PDF on Brightspace. Assesment: 10 points total, 5 points per question.

Due Monday 18 January at 9:00 am Atlantic.

### Bonus task (Lesson 5) {#task-b2 .unnumbered}

Repeat the examples from Lesson 5 and/or the accompanying video in Rstudio until you are comfortable with the basics of making a plot. We will learn much more about plotting starting the lesson after next. 

There is nothing to submit for this task.

### Task 4 (Lesson 6) {#task-4 .unnumbered}

Use Rstudio to create a new project from the github repository for Assignment 1. This is a new task, but it's going to be a recurring task throughout the course. Here are step-by-step instructions. If you have trouble with this task, ask for help. It's very important.

* Go to your [github](https://github.com) account and look for a repository called "assignment-1-" followed by your github user name. Get the link by clicking the green button labeled "Code". It should look like this: `https://github.com/Dalhousie-AndrewIrwin-Teaching/assignment-1-<your github name>.git` 
* Using Rstudio on your computer, select menu File > New Project > From repository... > Git. Insert the link to the repository and tell R where to put the repository on your computer.
* If you use rstudio.cloud, start at the [projects](https://rstudio.cloud/projects) page and choose New Project from git repository (pop-up menu) or open your existing project for our course. Clone the github repository in your project using the terminal window and type the command `git clone <link from github>`. Finally, open the new folder in the Files pane and click on the "assignment-1.Rproj" link to switch to the project. You may be asked by rstudio.cloud to link to your github account to access private repositories. 

There is a [video](https://dal.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=7cb26d66-a26e-4b24-89b1-acaf01321690) to help you with this task. You can also look at the [slides](slides/06-demo-assignment-github.html).

There is nothing to submit for this task, but please complete it by Monday 18 January or ask questions at office hours on Tuesday 19 January if you are having trouble. Everyone who *submits* Assignment 1 on time will get 10/10 for this task.

### Bonus task (Lesson 7) {#task-b3 .unnumbered}

Answer the questions at the end of the mini-lecture video. 

In addition, I suggest the following reading with nothing to submit:

* Browse the [R graph gallery](https://www.r-graph-gallery.com/) to explore the huge variety of visualiaations you can make with R. Practice thinking about how the language of aesthetic mappings, geometries, and scales can be used to describe these visualizations.
* Read through the ggplot [cheatsheet](https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf) to see how the concepts of the grammar of graphics will be connected to computer code. Don't worry about the details -- you will practice making visualizations using these tools over many future lessons.

### Bonus task (Lesson 8) {#task-b4 .unnumbered}

Practice using ggplot to make graphs by reproducing examples from mini-lecture or notes, and modifying them by changing variables used in aesthetic mappings. If you would like, use other data sources described in "Data Sources" chapter in course notes.

There is nothing to submit for this task.

### Task 5 (Lesson 9) {#task-5 .unnumbered}

Exercises to practice filter, group_by, summarize, and mutate.

I will add the repository for tasks 5 and 6 to your github account. Start by creating a new R project on your computer using the link to your repository you get from github. Edit the file task-5.rmd. When you are done, knit the file and commit the .rmd and .html files to your repository.

### Task 6 (Lesson 10) {#task-6 .unnumbered}

Exercises to practice making facetted plots. The questions are in the repository for tasks 5 and 6. Edit the file task-6.rmd. When you are done, knit the file and commit the .rmd and .html files to your repository. Push the changes to github to submit your work.

### Bonus task (Lesson 11) {#task-b5 .unnumbered}

I will get you to practice reading files later on in the course. For now, 

* pay attention to the code I use in future lessons for reading files, and
* download the [excel file](https://github.com/AndrewIrwin/data-visualization/blob/master/static/test-data.xlsx?raw=true) from the lesson, practice reading it into R, editing it in excel, and confirming that you can read the changes with R. 

You will want to practice this a bit over reading week or just after when you are looking for data to be used in your term project.


### Task 7 (Lesson 12) {#task-7 .unnumbered}

Reshaping data practice. The tasks are in the repository for task 7 and 8.

### Task 8 (Lesson 13) {#task-8 .unnumbered}

Displaying tables practice. The tasks are in the repository for task 7 and 8.

### Bonus task (Lesson 14) {#task-b6 .unnumbered}

The material in this lesson should be helpful if you run into challenges while working on Assignment 2, which asks you to develop new skills with unfamiliar functions.

### Bonus task (Lesson 15) {#task-b7 .unnumbered}

Practice adding linear models and smooths to visualizations. Reproduce some of the examples from the course notes, mini-lecture, or course textbook. Create new visualizations of your own design by changing the model, data, or underlying visualization. Esperiment with colors and facets. 

### Task 9 (Lesson 16) {#task-9 .unnumbered}

Exercises on linear models. See the file `task-9.rmd` in the repository for task 9 and 10.

### Task 10 (Lesson 17) {#task-10 .unnumbered}

Exercises on LOESS and GAM smooths. 
See the file `task-10.rmd` in the repository for task 9 and 10.

### Task 11 (Lesson 18) {#task-11 .unnumbered}

Clone the GitHub project "team-planning" to your computer (or rstudio.cloud workspace). Edit the file "team-planning.Rmd" to add your name and GitHub user ID to the teams table. If you want to work with someone as a team, add both team mates to the same line. If you want to be assigned a random team mate, add your name on a line by yourself.

### Bonus task (Lesson 19) {#task-b8 .unnumbered}

Look for some data on the internet. Download the data to your computer. Read the data into R. Make a summary table describing some part of the data. Make a visualization using some of the data. Can you find any formatting errors in the data? Did you have any trouble reading the data into R?

You can use any data you like for this task. If you want a specific suggestion, get some data from gapminder.org or another source in the lesson.

### Task 12 (Lesson 20) {#task-12 .unnumbered}

We've been using R markdown to make reproducible reports throughout the course. In this task, practice using `here` and chunk options.

This task is in the repository for task 12, 13, and 14.

### Task 13 (Lesson 21) {#task-13 .unnumbered}

Create a PCA and MDS plot as described in the task-13.rmd file. This task is in the repository for task 12, 13, and 14.

### Task 14 (Lesson 23) {#task-14 .unnumbered}

Create a K-means analysis and accompanying visualization as described in the task-14.rmd file. This task is in the repository for task 12, 13, and 14.

### Bonus task (Lesson 24) {#task-b9 .unnumbered}

Create and modify an "R presentation" slide presentation as described in the lesson. Ensure you know how to 

* show graphics output, but not the code that generated it,
* make the graphic the right size to fit on the slide,
* open the HTML version in your web browser.

### Bonus task (Lesson 27) {#task-b10 .unnumbered}

Practice making a map from the lesson

### Task 15 (Lesson 28) {#task-15 .unnumbered}

Make maps described in the task markdown file in the repository.

### Task 16 (Lesson 29) {#task-16 .unnumbered}

Show geographic data without maps as described in the repository.

### Task 17 (Lesson 30) {#task-17 .unnumbered}

Exercises with strings, factors, dates, and times.

### Bonus task (Lesson 31) {#task-b11 .unnumbered}

Make a custom color scale using a web interactive tool and then use those colours on a plot. Select a palette from a list given in the lesson and use it in a visualization.

### Task 18 (Lesson 32) {#task-18 .unnumbered}

Learn to use theme elements as described in the repository.

That is the last task for the course!

## Assignments {-}

Assignments are opportunities to apply and combine the skills from several lessons. They are both structured, in that you are asked to use specific skills to accomplish a task, and creative in that you have some flexibility in the product you produce. You will be assessed on your use of technical skills and your judgement in making well-designed and effective visualizations, following the principles explored in the course.

Assignments should be submitted to the relevant github repository, generally as an R markdown document.


### Assignment 1 {#assignment-1 .unnumbered}

Make a  markdown document with a figure and commit to a github repository. Ensures you know the foundation of  using git, github, R markdown, and ggplot to build new knowledge and skills on top.

Use the repository you created in Task 4.

Due Wednesday 27 January at 6:00 pm Atlantic time.

If, when you go to push your work back to github, you get an error about "Author identity unknown". you need to type the following two commands into the R terminal window:

```
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

### Assignment 2 {#assignment-2 .unnumbered}

There are so many packages and functions to make visualizations, that its really important to be able to read documentation and learn new functions. Fortunately, the design of ggplot means that many functions work very similarly and so once you have learned the basics, it's quite easy to learn more on your own.

The purpose of this assignment is for you to practice this sort of learning. I've picked out a few functions that work much like the examples we've looked at already. Your assignment is to pick out two of these and make a R markdown document describing how they work. This is the sort of practice I do all the time when I learn a new R skill.

Look in the repository `assignment-2` for a template for this assignment.

### Assignment 3 {#assignment-3 .unnumbered}

Practice using methods developed in the course so far (summarizing, ggplot visualizations, linear regression, smooths) to explore a data set and answer questions about the data.

### Assignment 4 {#assignment-4 .unnumbered}

[Tidy Tuesday](https://github.com/rfordatascience/tidytuesday) is a weekly activity to support people learning to use R for data analysis and visualization. Each week a new dataset is posted and interested participants post their visualizations. Some are complex pieces of work by people with lots of experience, but many are the work of beginners just learning to make good visualizations. I encourage you to explore the datasets and example visualizations others have made as a source of ideas and inspiration.

For the next two assignments, I'll select a few datasets and ask you to work with one of those for your assignment.

For this assignment you will make scatter plots with smooths (linear, loess, or gam) and dimensionality reduction (PCA or MDS). The goal is to gain some insight into the data and present some aspect of the data in a visually appealing way. You may be able to use the data as its presented, or you may need to transform it in some way first (for example using the dplyr tools). You should feel free to show a subset of the data if you think that makes a better visualization to highlight a particular feature of the data.

Present your work as a short R markdown report. You should describe the dataset, explain any analysis or transformations you did, present at least 2 visualizations, and describe the main messages conveyed by your visualization. Full instructions are in the repostory.

### Assignment 5 {#assignment-5 .unnumbered}

This is the second Tidy Tuesday assignment. Create maps as described in the repository.

Organize your work as a slide presentation. A template with instructions is in the repository.

### Assignment 6 {#assignment-6 .unnumbered}

This is a peer evaluation assignment. You should provide, in separate documents as described in the repository,

* confidential feedback on your team mates work for the term project
* a peer evaluation of two oral presentations from other teams, which will be shared with the presenters.

You should provide thoughtful and constructive feedback on the work of your classmates. Everyone's work has good aspects and areas where there could be improvement; you should aim to provide useful feedback in both areas.

Your assignment for the peer evaluation is in the project planning repository we all share. Pull an updated version from github to see your assigment. Remember to do this before the first day of presentations so you know which presentation to evaluate!

A rubric and guide for your evaluations is in the repository for this assignment.

## Term project {- #project-description}

Your final project is an analysis on a dataset of your own choosing. You can choose the data based on your interests, based on work in other courses, or independent research projects. You should demonstrate many of the techniques from the course, applying them as appropriate to develop and communicate insight into the data.

You should create compelling visualizations of your data. Pay attention to your presentation: neatness, coherency, and clarity will count. All analyses must be done in RStudio using R.

### Deliverables {-}

* Proposal - due Friday 12 March at 6:00 pm
* Presentation - due Thursday 1 April or Tuesday 6 April during synchronous meeting.
* Report - due Friday 9 April at 6:00 pm

Work in groups of 2 according to the assignments made in the team planning repository. You can produce team products, or one product per team member, whichever you prefer. You have two roles in the project. First you will contribute your original creative work for the project. Second, you will act as a collaborator, providing your teammate with feedback, suggestions, debugging help, proofreading and other assistance as requested.

Use a single GitHub repository for the proposal, presentation, and final report. Use the repository I created for your team. See the notes on [collaboration with GitHub](#collaboration) for guidance. Contact me if you have trouble.

### Team creation {-}

Teams will be created in late February. I will add everyone to a repository called `team-planning`. This repository will be used to create teams, schedule presentations, and organize peer-evaluation for Assignment 6.

If you would like to form a team with someone else in the class, edit the rmd document to add your request. If you would like to be assigned a randomly selected team mate, there will be a way to indicate that too. This process will also introduce you to some collaboration features of github. The deadline for selecting teammates will be Monday 1 March. I will review this list and finalize the assignments on Tuesday 2 March. I will create the presentation schedule and peer-evaluation assignments later that week.

### Proposal {-}

Your main task for the proposal is to find a dataset to analyze for your project and describe at least one question you can address with data visualizations.

It is important that you choose a readily accessible dataset that is large enough so multiple relationships can be explored, but no so complex that you get lost. I suggest your dataset should have at least 50 observations and about 10 variables. If you find a bigger dataset, you can make a subset to work with for your project. The dataset should include categorical and quantiative variables. If you plan to use a dataset that comes in a format that we haven’t encountered in class, make sure that you are able to load it into R as this can be tricky depending on the source. If you are having trouble ask for help before it is too late.

Do not reuse datasets from any part of the course.

Here is list of data repositories containing many interesting datasets. Feel free to use data from other sources if you prefer.

* [TidyTuesday](https://github.com/rfordatascience/tidytuesday)
* [Kaggle](https://www.kaggle.com/datasets) 
* [OpenIntro](https://www.openintro.org/book/statdata/index.php) 
* [Awesome public](https://github.com/awesomedata/awesome-public-datasets) datasets
* [Bikeshare](https://www.bikeshare.com/data/) data portal
* [Harvard Dataverse](https://dataverse.harvard.edu/)
* [Statistics Canada](https://www150.statcan.gc.ca/n1/en/type/data)
* Open government data: [Canada](https://open.canada.ca/en/open-data), [NS](https://data.novascotia.ca/), and many other sources
* Other sources listed in the [Data sources](#data-sources) section of these notes
* Data you find on your own may be suitable too.

Describe a dataset and question you can address with the data for your proposal. Outline a plan to use five visualizations (e.g., data overview plot, dplyr/table summary, small multiples, smoothing/regression, k-means/PCA, map).

The repository contains a template for your proposal called proposal.rmd. Write your proposal by revising this file and using this template.

* Questions: The introduction should introduce your research questions
* Data: Describe the data (where it came from, how it was collected, what are the cases, what are the variables, etc.).  Place your data in the /data folder. Show that you can read the data and include the output of `dplyr::glimpse()` or `skimr::skim()` on your data in the proposal.
* Visualization plan:
  * The outcome (response, Y) and predictor (explanatory, X) variables you will use to answer your question.
  * Ideas for at least two possible visualizations for exploratory data analysis, including some summary statistics and visualizations, along with some explanation on how they help you learn more about your data.
  * An idea of how at least one statistical method described in the course (smoothing, PCA, k-means) could be useful in analyzing your data
* Team planning: briefly decribe how members of your team will divide the tasks to be performed.

*Assessment*. See the file grade-proposal.rmd for the assessment guidelines and rubric.

### Oral presentation {-}

The oral presentation should be about 5 minutes long. The goal is to present the highlights of your project and allow for feedback which can be incorporated as you revise your written report.

You should have a small number of slides to accompany your presentation. I have provided a template for you to use as `presentation.rpres`. I suggest a format such as the following:

* A title with team members' names
* A description of the data you are analyzing
* At least one question you can investigate with your data visualization
* At least two data visualizations
* A conclusion

For suggestions on making slide presentations see the lesson on [slides](#slides) and recorded video.

Don't show your R code; the focus should be on your results and visualizations not your computing. Set `echo = FALSE` to hide R code (this is already done in the template).

Your presentation should not just be an account of everything you tried ("then we did this, then we did this, etc."), instead it should convey what choices you made, and why, and what you found.

Presentation schedule: Presentations will take place during the last two synchronous sessions of the course. You can choose to do your presentation live or pre-record it. You will watch presentations from other teams and provide feedback on one each day in the form of peer evaluations. The presentation schedule will be generated randomly.

*Assessment*. See the file grade-presentation.rmd for the assessment guidelines.

**Pratice your presentation, as a team, using the course collaborate room or other videoconferencing tool!**
 
### Written report {-}

Follow the template provided for your written report (report.rmd) to present your visualizations and insights about your data. Review the marking guidelines in grade-report.rmd and ask questions if any of the expectations are unclear.

Style and format does count for this assignment, so please take the time to make sure everything looks good and your tables and visualizations are properly formatted.

You and your teammate will be using the same repository, so merge conflicts will happen, issues will arise, and that’s fine! Pull work from github before you start, commit your changes, and push often. Ask questions when stuck. Look at the lesson on [collaboration](#collaboration) for help.

In your knitted report your R code should be hidden (`echo = FALSE`) so that your document is neat and easy to read. However your document should include all your code such that if I re-knit your R Markdown file I will obtain the results you presented. If you want to highlight something specific about a piece of code, you're welcome to show that portion.

General criteria for evaluation:

* Content - What is the quality of research question and relevancy of data to those questions?
* Correctness - Are visualization procedures carried out and explained correctly?
* Writing and Presentation - What is the quality of the visualizations, writing, and explanations?
* Creativity and Critical Thought - Is the project carefully thought out?  Does it appear that time and effort went into the planning and implementation of the project?


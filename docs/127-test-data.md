# Checking your work {#testing}



## An introduction to testing

You've made a data visualization. It looks great. All the calculations necessary are in a single Rmd file -- reading the data, organizing the data, and creating the figure. You can revise the data and reproduce the plot any time you want.

But then a thought occurs to you -- how do I know the visualization is correct? The computer saves us time by doing calculations for us, but the price is that you can't keep track of everything it does.

What if there is a problem with the data? Maybe the data you analyzed has a lot of observations -- too many to check by hand.  Or maybe the data are fine, but something went wrong when you read them into R. 
There are lots of ways for errors to creep in. Missing values when you thought there were none. Unexpected levels of factors (too many or too few). Detectable errors in the data such as impossible values. 

The best idea to counteract all these problems is testing. The secret is to get the computer to perform the tests for you. In this lesson we will discuss two kinds of testing: checking your data and checking your calculations. 

A lot of testing is done for you before you even start R: most (we hope all) the packages you use are carefully tested to be sure they work as intended. Still -- you might misunderstand what the packages are supposed to do. Or you might make a typo and use the wrong variable name somewhere. Or you might get the logic of your calculation wrong. So you should test your work in as many ways as you can.

The most important reason to test is that you will catch mistakes. Possibly the second most important reason for doing testing -- and being explicit about it -- is that it can help the people who use your analysis have more confidence in it. This includes you in the future!

## Checking analysis and visualizations

Once you have a preliminary analysis, develop a testing plan. Methods that can help:

* Check for errors in your data
* Perform your analysis on a small subset of your data that you can understand without computer help. This is the "sample calculation" method of testing
* Perform your analysis on simulated or fake "data" designed to test certain cases (independent variables, strong dependence, etc.) that will allow you to check your methods and interpretation
* Perform your calculations or visualizations two different ways, to check your understanding. This is especially useful if you have a fast and a slow way of doing a calculation. Use the slow way as a check on the fast method.

## Data errors

What kinds of errors can appear in data?

* Misspellings, upper/lower case inconsistency, extra spaces
* Duplicated observations
* Miss-coded missing data (-999, 0)
* Inconsistently formatted dates and times
* Impossible values arising from typographical errors
* Data in wrong columns
* All the data can look correct, but the methods may have changed, creating "silent" errors

Why do data sometimes have errors? 

* To answer this, you need to know about the process used to create the data. Were some data output by a particular machine or software package that has errors? Were the data typed in by a single person? Were many different people, who may have had different understandings of the data collection goals, involved? Were the data collected over a long period of time, when machines, people, and goals may have changed?

How can you find errors in data?

* Make summary tables and cross-check the summaries
* Look for missing data
* Check to be sure the correct number of variables (columns) and rows (observations) are present
* Plot histograms and densities
* Write tests to test data belong to a legitimate set of values

What do you do with errors?

* Keep original data, so you can revert the change in case of a misunderstanding
* Log changes and describe error
* Write tests to check for future errros
* Communicate with the people who collected the data and the people who will receive the analysis

### Sample data to test

The following data were collected by a class of students evaluating their ability to identify a jelly bean flavour by blindfolded testing. Much of our sense of taste comes from smell, so there were two treatments: a control with the participant was blindfolded and a treatment where the participant was blindfolded and blocked their nose to reduce the sense of smell. Groups of students entered their data into a single Google docs spreadsheet which was exported to the csv file below.

This dataset has a lot of problems, but they are very typical for data entered by a group of people who are not directly involved in the systematic analysis of the data with a software package like R. (They are not attuned to the problems of data errors.)  Take a look at the [file](static/jelly-bean-data.csv) and see how many problems you can find before continuing.


```r
jelly <- read_csv(here("static/jelly-bean-data.csv")) %>% clean_names()
```

```
## Warning: Missing column names filled in: 'X7' [7], 'X8' [8], 'X9' [9],
## 'X10' [10], 'X11' [11], 'X12' [12], 'X13' [13], 'X14' [14], 'X15' [15],
## 'X16' [16], 'X17' [17], 'X18' [18], 'X19' [19], 'X20' [20], 'X21' [21],
## 'X22' [22], 'X23' [23], 'X24' [24], 'X25' [25], 'X26' [26], 'X27' [27]
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   .default = col_logical(),
##   Initials = col_character(),
##   `Group (choose from drop down)` = col_character(),
##   `Trial #` = col_double(),
##   Flavour = col_character(),
##   `Reaction time (in sec)` = col_character(),
##   `Accuracy (0=incorrect, 1=correct)` = col_double()
## )
## ℹ Use `spec()` for the full column specifications.
```

```r
# jelly %>% kable() %>% scroll_box()
```

You should always look at data. For a first look, `View`, `skim` (in the `skimr` package), and `glimpse` functions are useful and will identify some problems.


```r
glimpse(jelly)
```

```
## Rows: 261
## Columns: 27
## $ initials                       <chr> "PKL", "PKL", "PKL", "LAG", "LAG", "LAG…
## $ group_choose_from_drop_down    <chr> "control", "control", "control", "exper…
## $ trial_number                   <dbl> 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, NA,…
## $ flavour                        <chr> "orange", "strawberry", "cherry", "oran…
## $ reaction_time_in_sec           <chr> "7.2", "7.6", "10.1", "10.15", "12.24",…
## $ accuracy_0_incorrect_1_correct <dbl> 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, NA,…
## $ x7                             <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x8                             <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x9                             <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x10                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x11                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x12                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x13                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x14                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x15                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x16                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x17                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x18                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x19                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x20                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x21                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x22                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x23                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x24                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x25                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x26                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ x27                            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
```

```r
# skimr::skim(jelly)
```

There are many columns that have no heading and are purely missing data. Before getting rid of those columns, let's be sure they are **all** missing using the `miss_var_summary` function from the `naniar` package.


```r
jelly %>% miss_var_summary() %>% kable() %>% kable_styling(full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> variable </th>
   <th style="text-align:right;"> n_miss </th>
   <th style="text-align:right;"> pct_miss </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x7 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x8 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x9 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x10 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x11 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x12 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x13 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x14 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x15 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x16 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x17 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x18 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x19 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x20 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x21 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x22 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x23 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x24 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x25 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x26 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x27 </td>
   <td style="text-align:right;"> 261 </td>
   <td style="text-align:right;"> 100.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> initials </td>
   <td style="text-align:right;"> 88 </td>
   <td style="text-align:right;"> 33.71648 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> group_choose_from_drop_down </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 13.02682 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> reaction_time_in_sec </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 13.02682 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> accuracy_0_incorrect_1_correct </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 13.02682 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> trial_number </td>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:right;"> 12.64368 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> flavour </td>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:right;"> 12.64368 </td>
  </tr>
</tbody>
</table>

Now we will get rid of those data.


```r
jelly <- jelly %>% select(-(x7:x27))
```

The `dlookr` package provides a similar table, plus it adds a count of the number of distinct values for each variable.


```r
diagnose(jelly) %>% kable() %>% kable_styling(full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> variables </th>
   <th style="text-align:left;"> types </th>
   <th style="text-align:right;"> missing_count </th>
   <th style="text-align:right;"> missing_percent </th>
   <th style="text-align:right;"> unique_count </th>
   <th style="text-align:right;"> unique_rate </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> initials </td>
   <td style="text-align:left;"> character </td>
   <td style="text-align:right;"> 88 </td>
   <td style="text-align:right;"> 33.71648 </td>
   <td style="text-align:right;"> 75 </td>
   <td style="text-align:right;"> 0.2873563 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> group_choose_from_drop_down </td>
   <td style="text-align:left;"> character </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 13.02682 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0.0153257 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> trial_number </td>
   <td style="text-align:left;"> numeric </td>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:right;"> 12.64368 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0.0153257 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> flavour </td>
   <td style="text-align:left;"> character </td>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:right;"> 12.64368 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 0.1685824 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> reaction_time_in_sec </td>
   <td style="text-align:left;"> character </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 13.02682 </td>
   <td style="text-align:right;"> 201 </td>
   <td style="text-align:right;"> 0.7701149 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> accuracy_0_incorrect_1_correct </td>
   <td style="text-align:left;"> numeric </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 13.02682 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0.0114943 </td>
  </tr>
</tbody>
</table>

There are at least 12% missing values in each variable, so there may be some rows that are completely missing. If you take another look at the data you will see that a lot of rows are all NA. Let's get rid of them.
First find the rows that are all NA. First we count the number of missing data in each row (mutate) then we remove the rows where every variable is missing (filter). Whenever I clean data, I like to preview what will happen before modifying the dataset.


```r
jelly %>% rowwise() %>%
  mutate(n_na = sum(is.na(across()))) %>% 
  filter(n_na == ncol(jelly)) %>%
  head() %>% kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> initials </th>
   <th style="text-align:left;"> group_choose_from_drop_down </th>
   <th style="text-align:right;"> trial_number </th>
   <th style="text-align:left;"> flavour </th>
   <th style="text-align:left;"> reaction_time_in_sec </th>
   <th style="text-align:right;"> accuracy_0_incorrect_1_correct </th>
   <th style="text-align:right;"> n_na </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
</tbody>
</table>

Now remove them:


```r
jelly <- jelly %>% rowwise() %>%
  mutate(n_na = sum(is.na(across()))) %>% 
  ungroup() %>%
  filter(n_na < ncol(jelly)) %>%
  select(-n_na)
```


We still don't know what most of thse variables mean, but already one thing should stand out. The variable `accuracy_0_incorrect_1_correct` presumably should only be 0 or 1, but has three different values. We may not care about the initials of the investigator, but we might be concerned about the fact that there are 88 missing values (about 50 more than the all blank rows we removed.) 

## Data quality assurance

You can get report on your data using the `pointblank` package. (See the documentation linked in further reading for examples.) Let's test a few things:

* are any values of the accuracy variable not 0 or 1?
* is reaction time and trial_number numeric? (We know the answer already, but I'll show how to test this condition.)
* are there any negative reaction times?
* are all the rows distinct? (It's unlikely, but not impossible to get the same result twice.)

First we will write the tests.


```r
my_test <- jelly %>% 
  create_agent(actions = action_levels(warn_at = 1)) %>%
  col_vals_in_set(accuracy_0_incorrect_1_correct, c(0,1)) %>%
  col_is_numeric(vars(trial_number, reaction_time_in_sec)) %>%
  col_vals_gt(reaction_time_in_sec, 0) %>%
  rows_distinct() 
```
Now you can use the tests to get a report. (The report is not shown. Experiment with these functions on your own.)


```r
my_test %>% interrogate() 
```

Reaction time (in seconds) is text not a number. Let's fix that. Probably there will be some non-numeric values in there, because otherwise the data would have been read as numeric. So let's look for those rows first. If you try to convert text to a number and the text doesn't look like a number, you'll get an NA instead. So filter out the NAs that get created when you convert from text to number. R will give us a message to alert us to the fact that there are some NAs created.


```r
jelly %>% filter(is.na(as.numeric(reaction_time_in_sec))) %>%
  kable() %>% kable_styling(full_width = FALSE)
```

```
## Warning in mask$eval_all_filter(dots, env_filter): NAs introduced by coercion
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> initials </th>
   <th style="text-align:left;"> group_choose_from_drop_down </th>
   <th style="text-align:right;"> trial_number </th>
   <th style="text-align:left;"> flavour </th>
   <th style="text-align:left;"> reaction_time_in_sec </th>
   <th style="text-align:right;"> accuracy_0_incorrect_1_correct </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> KS </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> Orange </td>
   <td style="text-align:left;"> Lemon </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BP </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> yellow and brown </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>

One of those is obviously an error. (Lemon is not a number!) In a careful analysis, you would contact the person who recorded the data (that's what the initials are for) and find out what went wrong. Same thing with the NA, where the time didn't get recorded. For now, we'll just throw away these numbers.


```r
jelly <- jelly %>% 
  mutate(reaction_time_in_sec = as.numeric(reaction_time_in_sec)) %>%
  filter(!is.na(reaction_time_in_sec))
```

The pointblank package also has a helpful function to produce a structured report on your whole dataset. (Again the results are not shown here.)


```r
jelly %>% scan_data()
```

## Data cleaning

Freshly collected and tabulated data are often "dirty": there are errors in the data such as typographical errors, impossible values, or simply more detail than is appropriate for your analysis. Preparing a dataset for analysis is called [data cleaning](https://en.wikipedia.org/wiki/Data_cleansing) and it can be a complex and lengthy task that is at least as complext as analyzing data. Although there are common tasks performed in data cleaning, every dataset presents its own set of challenges. That's the reason we usually use "clean" data in courses.

Data cleaning tasks are very individual and can take considerable creativity. Here we'll just try a few.

Let's look at the values of `flavour`. It seems like there are a lot of them.


```r
jelly %>% count(flavour) %>% arrange(-n) %>% 
  kable() %>% kable_styling(full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> flavour </th>
   <th style="text-align:right;"> n </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> orange </td>
   <td style="text-align:right;"> 32 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:right;"> 23 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cherry </td>
   <td style="text-align:right;"> 19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Orange </td>
   <td style="text-align:right;"> 19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> grape </td>
   <td style="text-align:right;"> 18 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> coconut </td>
   <td style="text-align:right;"> 14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cherry </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Banana </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Grape </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Lemon </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> banana </td>
   <td style="text-align:right;"> 7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Coconut </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lime </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> purple </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> apple </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> strawberry </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Yellow White </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> blueberry </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> bubblegum </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Purple </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> red </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> white </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow and white </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Yellow Brown </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Apple </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bubblegum </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cinnamon </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cocnut </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Coffee </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lemon/lime </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> licorice </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Lime </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> marshmallow </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Pinapple </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Plum </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> raspberry </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Red </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> watermelon </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Watermelon </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow + white </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow and brown </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>

We definitely have some duplication. I'll do one correction -- changing all letters to lower case so differences in capitalization don't duplicate flavours. (This simple change eliminates 13 different values of flavour.) 
If you look closely at the data, you will find spelling errors, different codings (and, +, or neither), and one missing flavour.


```r
jelly %>% mutate(flavour = tolower(flavour)) %>%
  count(flavour) %>% arrange(-n) %>% 
  kable() %>% kable_styling(full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> flavour </th>
   <th style="text-align:right;"> n </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> orange </td>
   <td style="text-align:right;"> 51 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:right;"> 32 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cherry </td>
   <td style="text-align:right;"> 29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> grape </td>
   <td style="text-align:right;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> coconut </td>
   <td style="text-align:right;"> 19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> banana </td>
   <td style="text-align:right;"> 16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> purple </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lime </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> apple </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> white </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> bubblegum </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> red </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> strawberry </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow white </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> blueberry </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> watermelon </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow and white </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow brown </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cinnamon </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cocnut </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> coffee </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lemon/lime </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> licorice </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> marshmallow </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> pinapple </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> plum </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> raspberry </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow + white </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow and brown </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>

Use what you learned to tidy the data. Here are some changes I'll make before continuing the analysis.


```r
jelly <- jelly %>% 
  mutate(flavour = tolower(flavour),
         flavour = case_when(flavour == "cocnut" ~ "coconut", 
                             TRUE ~ flavour), 
         flavour = str_replace(flavour, " and ", " "),
         flavour = str_replace(flavour, "[/+]", " "),
         flavour = str_squish(flavour))
```

## Analyze a subset of your data

Let's compute the average reaction time for correct and incorrect answers for each flavour and each treatment. We will count the number of observations for each grouping too.


```r
jelly %>% group_by(flavour, group_choose_from_drop_down, accuracy_0_incorrect_1_correct) %>%
  summarize(count = n(),
            mean_reaction_time = mean(reaction_time_in_sec),
            .groups = "drop") %>% 
  kable() %>% kable_styling(full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> flavour </th>
   <th style="text-align:left;"> group_choose_from_drop_down </th>
   <th style="text-align:right;"> accuracy_0_incorrect_1_correct </th>
   <th style="text-align:right;"> count </th>
   <th style="text-align:right;"> mean_reaction_time </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> apple </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 14.660000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> banana </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 12.616667 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> banana </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 24.222500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> banana </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 17.166667 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> blueberry </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5.980000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> blueberry </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 20.730000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> bubblegum </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 7.300000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> bubblegum </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 17.620000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cherry </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 17.487500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cherry </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 6.785000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cherry </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 15.835455 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cherry </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 12.320000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cherry </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 11.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cinnamon </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5.920000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> coconut </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 22.596667 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> coconut </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 6.821667 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> coconut </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 18.861111 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> coconut </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 15.040000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> coffee </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 7.650000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> grape </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 23.903333 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> grape </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 5.926000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> grape </td>
   <td style="text-align:left;"> Control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 13.250000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> grape </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 17.655833 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> grape </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 16.473333 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 10.756000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 7.138750 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 17.110000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 15.613333 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5.460000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lemon lime </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 10.800000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> licorice </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 8.460000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lime </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 10.640000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lime </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 12.760000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> marshmallow </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 12.050000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> orange </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 14.307778 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> orange </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 6.546250 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> orange </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 18.295000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> orange </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 10.086000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> pinapple </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 11.770000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> plum </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 15.200000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> purple </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 14.445000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> purple </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 14.756667 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> purple </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 36.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> raspberry </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 16.150000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> red </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 12.120000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> red </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 24.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> strawberry </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 23.716667 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> watermelon </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 23.800000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> white </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3.300000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> white </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 21.500000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> white </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 7.480000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 9.265000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow brown </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 15.800000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow brown </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 9.340000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow white </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 13.060000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow white </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 15.500000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow white </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 20.200000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yellow white </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 11.000000 </td>
  </tr>
</tbody>
</table>

This is a fairly simple calculation, but it serves to demonstrate the "manual check" method. Filter out just the incorrect, experimental results for apple flavours. Check that the number of rows and average match.


```r
jelly %>% filter(flavour == "apple",
                 accuracy_0_incorrect_1_correct == 0,
                 group_choose_from_drop_down == "experimental") %>% 
  kable() %>% kable_styling(full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> initials </th>
   <th style="text-align:left;"> group_choose_from_drop_down </th>
   <th style="text-align:right;"> trial_number </th>
   <th style="text-align:left;"> flavour </th>
   <th style="text-align:right;"> reaction_time_in_sec </th>
   <th style="text-align:right;"> accuracy_0_incorrect_1_correct </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> FACP </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> apple </td>
   <td style="text-align:right;"> 14.30 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VP </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> apple </td>
   <td style="text-align:right;"> 21.35 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> apple </td>
   <td style="text-align:right;"> 9.99 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tw </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> apple </td>
   <td style="text-align:right;"> 13.00 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
</tbody>
</table>

Looks good!

## Use fake data, where you already know the answer

This example will be a bit contrived, but its a good example of the idea. I'll create some simple data and then compute the averages using exactly the same code I wrote above. I'll put in a NA in one row just to see what happens.


```r
my_jelly <- tribble(
  ~group_choose_from_drop_down, ~ flavour, ~ reaction_time_in_sec, ~ accuracy_0_incorrect_1_correct,
  "experimental", "lime", 1, 1,
  "experimental", "lime", 2, 1,
  "experimental", "lemon", 3, 1,
  "control", "lemon", 4, 1,
)
my_jelly %>% kable() %>% kable_styling(full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> group_choose_from_drop_down </th>
   <th style="text-align:left;"> flavour </th>
   <th style="text-align:right;"> reaction_time_in_sec </th>
   <th style="text-align:right;"> accuracy_0_incorrect_1_correct </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:left;"> lime </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:left;"> lime </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> control </td>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>

I know exactly what I'm expecting. Stop and decide for yourself before reading on.


```r
my_jelly %>% group_by(flavour, group_choose_from_drop_down, accuracy_0_incorrect_1_correct) %>%
  summarize(count = n(),
            mean_reaction_time = mean(reaction_time_in_sec),
            .groups = "drop") %>% 
  kable() %>% kable_styling(full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> flavour </th>
   <th style="text-align:left;"> group_choose_from_drop_down </th>
   <th style="text-align:right;"> accuracy_0_incorrect_1_correct </th>
   <th style="text-align:right;"> count </th>
   <th style="text-align:right;"> mean_reaction_time </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 3.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lime </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1.5 </td>
  </tr>
</tbody>
</table>


## Do you calculations two different ways

Suppose we weren't really confident that we knew what `mean` does? Even simple functions like `sd` (for standard deviation) and `median` might not do what you think they should. How can we check it? Let's write our own function based on sum, length, and division.


```r
my_mean = function(x) sum(x) / length(x)
my_jelly %>% group_by(flavour, 
                      group_choose_from_drop_down, 
                      accuracy_0_incorrect_1_correct) %>%
  summarize(count = length(flavour),
            mean_reaction_time = my_mean(reaction_time_in_sec),
            .groups = "drop") %>%
  kable() %>% kable_styling(full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> flavour </th>
   <th style="text-align:left;"> group_choose_from_drop_down </th>
   <th style="text-align:right;"> accuracy_0_incorrect_1_correct </th>
   <th style="text-align:right;"> count </th>
   <th style="text-align:right;"> mean_reaction_time </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:left;"> control </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lemon </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 3.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lime </td>
   <td style="text-align:left;"> experimental </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1.5 </td>
  </tr>
</tbody>
</table>

Excellent! We got the same answers.

That's an introduction to testing calculations. These are good checks to make as you calculate and test your analysis. The next step is to write computer code that checks your answers as well, by giving sample data to your calculation code along with the known answers. There is a package (of course!) for helping with that: `testthat` and `tinytest` (links below). We won't be using these in the course, but you should take time to learn about them after the course.

## At the end of your analysis

* Provide a relatively simple dataset together with analysis results that can be used to verify your code is working the same way in the future, or that someone who develops a new way of analysing the data can use for comparison
* Document any testing processes you used for your data and for your computer code so that later users will know what problems you looked for
* Document any problems you found in the data and what steps you took to fix the problems
* Describe any weaknesses in your method which anticipate might cause problems for future users

## Lessons for this course

We are not integrating testing into our work in this course. This lesson is here to alert you to this problem, ensure you know many people think carefully about this, and to show you the first steps to developing a good quality assurance plan. Be aware that testing takes time -- possibly as much time as "the rest" of the work you do for data analysis.

## Further reading

* [Data cleaning](https://towardsdatascience.com/the-ultimate-guide-to-data-cleaning-3969843991d4) overview
* [pointblank](https://github.com/rich-iannone/pointblank) documentation and examples
* [dlookr](https://cran.r-project.org/web/packages/dlookr/vignettes/diagonosis.html) documentation and examples
* [dataMaid](https://github.com/ekstroem/dataMaid) documentation for data cleaning
* For testing R code, look at [tinytest](https://cran.r-project.org/web/packages/tinytest/vignettes/using_tinytest.pdf) and [testthat](https://testthat.r-lib.org/)


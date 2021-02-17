# More details about R {#r-details}



R is a big software package. It's developed over decades of use. It has millions of regular users across many disciplines in teaching,  academic research and professional applications.  It's a computer programming language, and a tool for accessing thousands of data analysis tools, and a great interactive environment for exploring, analyzing, and visualizing data. You won't learn it all.

The approach in this course is to teach you how to use R in a particular style, with an emphasis on the ggplot and tidyverse packages. The R markdown documents we write balance interactive use with a documentation of the sequence of steps used in any analysis. I have omitted a lot of details that might be called "fundamentals" and instead focussed on getting work done quickly. In this lesson I fill in some of the gaps. My reasoning is that most important to want to learn a tool before you spend too much time on details, so this course empahsizes what you can do with R. On the other hand, I hope you will use R for a long time on many projects, and once you reach the point you know you will do that, you should start developing a solid mental model of how R works so that you can build robust understandings of how to accomplish tasks with R and get beyond copy, paste,  search, and experiment. Without these fundamentals, its easy to make up incorrect ideas about why and how R works and then get really confused and frustrated. 

A simple introduction to the basics of R appears in [Healy Appendix](https://socviz.co/appendix.html#appendix). A different approach is taken in the R for Data Science book, which introduces the basics of many topics, such as  [tibbles](https://r4ds.had.co.nz/tibbles.html), 
[strings](https://r4ds.had.co.nz/strings.html), [factors](https://r4ds.had.co.nz/factors.html) and 
[dates](https://r4ds.had.co.nz/dates-and-times.html), [functions](https://r4ds.had.co.nz/functions.html) and [vectors](https://r4ds.had.co.nz/vectors.html) 
together with their applications one chapter at a time.

## What kinds of data structures does R use?

R has many basic types: logical, numeric (double), character, factor. Any combination of these types can be combined into lists. Elements of lists can be named so that they work like dictionaries. Vectors, matrices, and higher dimensional arrays are all composed of the same type of data, usually numeric, factor, or logical.

Lists are a very powerful type because they can be given attributes that identify them as special structures with particular intepretations. The most common special list is a data frame, data table or tibble. (The tibble is a refined kind of data frame.) You probably think of a tibble as a matrix where each column can be of a different type. How is this accomplished? It's a list of vectors. Each vector corresponds to a column or variable in the data frame with its own name and data type.

Here are some R commands you can use to decode the structure of any object you have in your workspace. I'll demonstrate on the `diamonds` tibble. As always, experiment with these commands by trying them on other objects such as `cars` (a data frame).


```r
typeof(diamonds)  # it's a list
```

```
## [1] "list"
```

```r
class(diamonds) # which works as a data.frame and also as a tbl (tibble)
```

```
## [1] "tbl_df"     "tbl"        "data.frame"
```

```r
str(diamonds)
```

```
## tibble [53,940 × 10] (S3: tbl_df/tbl/data.frame)
##  $ carat  : num [1:53940] 0.23 0.21 0.23 0.29 0.31 0.24 0.24 0.26 0.22 0.23 ...
##  $ cut    : Ord.factor w/ 5 levels "Fair"<"Good"<..: 5 4 2 4 2 3 3 3 1 3 ...
##  $ color  : Ord.factor w/ 7 levels "D"<"E"<"F"<"G"<..: 2 2 2 6 7 7 6 5 2 5 ...
##  $ clarity: Ord.factor w/ 8 levels "I1"<"SI2"<"SI1"<..: 2 3 5 4 2 6 7 3 4 5 ...
##  $ depth  : num [1:53940] 61.5 59.8 56.9 62.4 63.3 62.8 62.3 61.9 65.1 59.4 ...
##  $ table  : num [1:53940] 55 61 65 58 58 57 57 55 61 61 ...
##  $ price  : int [1:53940] 326 326 327 334 335 336 336 337 337 338 ...
##  $ x      : num [1:53940] 3.95 3.89 4.05 4.2 4.34 3.94 3.95 4.07 3.87 4 ...
##  $ y      : num [1:53940] 3.98 3.84 4.07 4.23 4.35 3.96 3.98 4.11 3.78 4.05 ...
##  $ z      : num [1:53940] 2.43 2.31 2.31 2.63 2.75 2.48 2.47 2.53 2.49 2.39 ...
```

```r
class(diamonds$carat)
```

```
## [1] "numeric"
```

```r
class(diamonds$cut)  # its a factor, and the factor is ordered (factors can be unordered)
```

```
## [1] "ordered" "factor"
```

```r
class(as.matrix(diamonds %>% select(depth, table, price)))  # if you pick columns of the same type, you can convert them to a matrix
```

```
## [1] "matrix" "array"
```

```r
class(as.matrix(diamonds %>% select(cut, color, clarity)))  
```

```
## [1] "matrix" "array"
```

## data frame, tibbles, and data tables

When R was young, there was one way to organize data into the tables we are using throughout this course: the data frame. This data structure is made from a list of vectors; each column is an entry in the list and all the data in each list (column) must be of the same time. Over time, people wanted to add new features to data tables, but existing code written and deployed made this difficult. So two new kinds of data frames were created.

A [tibble](https://r4ds.had.co.nz/tibbles.html) is a data frame, but it has some extra features. Most notably the way it is displayed in R has been improved. Only a few rows and colums are shown (unless you ask for more) with the rest of the information provided as a summary. Tibbles are widely used by the tidyverse pacakges.

A [data table](https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html) is a kind of data frame where all the code has been written with the goal of increasing calculation speed. Some of the methods for manipulating data tables are quite different from what we have learned in this course; some of the examples from R4DS chapter on data transformations are demonstrated [here](https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html).


## What is the difference between strings and factors?

A string is just a sequence of text, enclosed by single or double quotation marks. You can display strings, and search for text, and do other text-type things with them, but you can't (of course) do calculations with them.

You can convert a vector of strings into a vector of factors. This assigns an integer to each different element in the vector. Why would you do this?  The numbers can be assigned to give a particular order to the factors (strings) that is different from alphabetical. The factors can be used in statistical models as though they are numbers, as though they were the indexes you use on a variable in math class (e.g., $x_1, x_2, \dots$).

Here are some simple examples.


```r
v <- c("Apple", "Bananna", "Cat", "Apple", "Orange")
typeof(v)
```

```
## [1] "character"
```

```r
f <- factor(v)
typeof(f)
```

```
## [1] "integer"
```

```r
as.numeric(f)
```

```
## [1] 1 2 3 1 4
```

```r
f
```

```
## [1] Apple   Bananna Cat     Apple   Orange 
## Levels: Apple Bananna Cat Orange
```

The `forcats` package has lots of great functions for working with factors which can help you control how your plots are drawn. That's the main use we will have for them in this course.

## What’s the pipe? 

The pipe `%>%` is a way to write function composition. In our data analysis we build up calculations from lots of different functions such as `select`, `group_by`, `arrange`, `filter`, `summarize`, `distinct` and many more described in R for Data Science. Each function starts with a tibble, does something to it, and produces a revised tibble. It's very natural to develop a complex series of calculations like a recipe in a cookbook. (Sometimes these recipes are called pipelines!) Before pipes were invented there were basically two options; write the functions down in reverse order, or create lots of temporary variables to store the intermediate results and then discard them. Pipelines are easier to write and easier to read. Here's an example of the three styles, based on a simple analysis of the `diamonds` data.

Pipeline:


```r
diamonds %>% filter(cut=="Ideal") %>% group_by(color) %>% summarize(mean_price = mean(price))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```
## # A tibble: 7 x 2
##   color mean_price
##   <ord>      <dbl>
## 1 D          2629.
## 2 E          2598.
## 3 F          3375.
## 4 G          3721.
## 5 H          3889.
## 6 I          4452.
## 7 J          4918.
```

Temporary variables:


```r
d1 <- filter(diamonds, cut=="Ideal")
d2 <- group_by(d1, color) 
summarize(d2, mean_price = mean(price))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```
## # A tibble: 7 x 2
##   color mean_price
##   <ord>      <dbl>
## 1 D          2629.
## 2 E          2598.
## 3 F          3375.
## 4 G          3721.
## 5 H          3889.
## 6 I          4452.
## 7 J          4918.
```
Composition:


```r
summarize(
  group_by(
    filter(diamonds, cut == "Ideal"), color
  ), mean_price = mean(price)
)
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```
## # A tibble: 7 x 2
##   color mean_price
##   <ord>      <dbl>
## 1 D          2629.
## 2 E          2598.
## 3 F          3375.
## 4 G          3721.
## 5 H          3889.
## 6 I          4452.
## 7 J          4918.
```

Which do you think is easier to understand?  What if the pipline was longer? Or shorter?

Note: as of late 2020, a new kind of pipe is becoming part of R. It looks like this `|>` and works a bit like the existing pipe we use but has some differences. It's not in this course at all yet since the official release of R doesn't have it. This is another example of how R (and all computer systems) change over time. These sorts of big changes are very rare with R because so many people use it for so many purposes. 

## Why does ggplot use +?

When we make plots with ggplot we do something very similar -- we start with a tibble or data frame, but then we make a plot, and then modify it step by step, setting geometries, adding more data, creating facets, setting scales, altering the theme. This seems a lot like a pipeline. Why do we use `+` to connect different `ggplot2` commands?

Simple. The developer [didn't know about](https://www.reddit.com/r/dataisbeautiful/comments/3mp9r7/im_hadley_wickham_chief_scientist_at_rstudio_and/cvi19ly/) the pipe operator in R when ggplot was developed. Adding a feature to a plot seemed like a "plus" operation, so that was chosen. The developer says if he was starting over today, ggplot would use pipes, but its not practical to change at this point. Too many people use it with the `+`. Some [people think](https://community.rstudio.com/t/why-cant-ggplot2-use/4372/5) of functions as verbs and ggplot commands as nouns, and justify the difference that way. Software development is a complicated human activity that takes place over time and develops quirks and lore.


## What are packages? What’s the difference between installing one and using one? Why is r organized this way?

There are thousands of R packages. So many that it seems you are always needing to install a new one. Worse, sometimes you want a function, but you can't remember which package it's installed in -- so then you can't use it. (There is a solution to this: use the double ?? followed by the fuction name in the console to search for a function across all packages available on your computer.) Why this complication?

There are several reasons.

* New packages are developed frequently, by different people. And some packages get abandoned too. Packages create modularity that makes it easier to test and fix problems with packages across different groups of developers.
* The `library` command tells R you want to use a particular package in your current session. Not loading all packages can save time, computer resources, and avoid name collisions (see below).
* Most people only use a small fraction of all the packages available -- you simply don't need to install them all.
* Two packages can use the same name for a different function or different dataset. If there were no packages, everyone using R would have to coordinate the naming of everything across all the packages. An impossible task. Sometimes when you load a package with `library` you'll get a message that an existing function has been redefined (or masked) by this new package. You can always add the package name and two colons, `dplyr::filter` for example, to refer to a function in a particular package.

## Why are there so many kinds of "equals signs"?

There are many different concepts behind the humble equals sign used in mathematics. In R we use different symbols: `=`, `==`, `<-` and even some special functions like `all.equal` and `near`. Even with all these differences `=` can mean different things in different contexts, and there is a special version of `<-` written in the other way: `->`. The pipe adds its own twist, you can write `%<>%` as a combined assignment operator and pipe.

So what does each mean?

* `a <- b` means assign the name `a` to the object `b`. (You can use `=` for this, but I encourage you not to.)
* `a == b` is a comparison between `a` and `b` with the result `TRUE` if they are the same and otherwise `FALSE`. (The notion of "same" in computing is surprisingly complicated, but for basic types, in particular strings, this is fairly straightforward.)
* `a = b` is used when naming elements of a list or arguments to a function, for example `ggplot(mapping = aes(...))` or `list(a= "apple", b="bananna")`.
* `near(1.25, 1.253, tol = 0.01)` in the `dplyr` package is used to compare numbers to see if they are close together.

The `waldo` package has functions for testing equality of data frames and showing differences.


## Numbers

R is 

NA nan inf -inf
Testing for Na. Replacing. If then functions.

## What’s a function?

## What’s a formula?
Lm facet also t.test gam


## Programming styles

Grammar? Gg gt
Descriptive vs imperative
SQL as another example


## Comparing SQL to dplyr

## Using databases with R



## Computing notes

There are thousands of different programming languages. Why? Partly different ideas have arisen over time. Sometimes, languages have been created for particular problems. But most often, languages are created to enable a new kind of interaction between programmer and computer. Over time, as computing power increases and the kinds of problems solved by computer change, new opportunities and new needs arise and new languages are developed.

What are some of the constraints and trade-offs when using a computer? The three most important are
* the amount of storage required to solve a problem,
* the number of computations to solve a problem, and
* the amount of human time required to design and implement a solution.

Many programming languages prioritize the first two. The trade-off between the first two is a [classic idea](https://en.wikipedia.org/wiki/Space%E2%80%93time_tradeoff) in computer science. You can see how it arises from a simple example. Suppose you know you need the approximate result of some complex mathematical computation. You can either perform the calcuation when you need it (which takes time), or you can compute a table of possible computations in advance (which takes storage) and lookup the result when you need it. This is the idea behind statistical tables in the back of statistics textbooks -- the calculations are hard, but a good enough table fits on a page or two.

The designers of the R language and packages often prioritize minimizing the amount of time required for a human to design and code the solution to a problem. To do this well, the designers needed to give you flexible and powerful tools (functions). The flexibility of the functions means that they are not always optimized to use the least storage or time.

Powerful tools require significant study to learn how to use them effectively. The examples in this course are selected to convince you that that investment is worth your time. There are also many specialized packages of functions, each created to make a certain type of problem easier or faster to solve. This is now a feature of all programming domains, which have specialized tools for different operating systems, the web, or particular problem domains like databases, machine learningm or statistical data analysis. Each of these requires effort to learn, but a helpful insight comes from the early design of graphical user interfaces -- if tools made by different programmers have enough in common and adhere to conventions, then the burden on the programmer and user is greatly reduced.

There are many other optimizations and trade-offs in computing. For example, numerical computations sometimes are done in a different order compared to the way you would do them in math class as a result of numerical approximations made by computers.

Even within the R system there are many different styles of programming and problem solving. In this course I emphasize one particular style, now known popularly as the tidyverse. This approach organizes data and results in tables (called tibbles) as much as possible and encourages you to build larger solutions from composing powerful functions together (like th dplyr package). As a result in this course a hidden message throughout most lessons is how to organize your data and results and how to use a small set of powerful functions to solve a large set of general problems.

Many other computing systems would work well for this course. Among programmers, a very popular choice is
[python](https://www.python.org/), which shares a lot in common with R with many add-on packages providing similar functions. As a simplification, python use tends to be favoured by people developing software to solve a particular problem, while R tends to be favoured by people who want to interactively explore their data analysis options and need to develop custom analyses for each problem they encounter. Python and R have both existed since before the year 2000, but the styles of data analysis and problem solving possible with each has grown and converged together considerably in recent years.




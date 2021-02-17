# Working with factors and dates {#factors-dates}



And some other bonus topics.


## Working with strings

When making visualizations it is frequently useful to manipulate text ("strings") directly. Sometimes this is to simplify text that is being displayed on a graph. Or perhaps there is a typographical error or formatting problem with text. The [stringr](https://cran.r-project.org/web/packages/stringr/vignettes/stringr.html) package contains many useful functions for manipulating text strings. I will explain a few simple examples that I use frequently.

* A very common task is to remove leading, trailing, and duplicated spaces in a string. The `str_squish` function removes whitespace (including tabs, new lines, and spaces) in these positions.


```r
my_string <- "   A cat  is a small, living
                    and furry animal.  "
my_string2 <- str_squish(my_string)
my_string2
```

```
## [1] "A cat is a small, living and furry animal."
```

* If there are particular letters or symbols you want to remove, the `str_remove` function can accomplish this. This can be used on literal strings or on patterns. Patterns allow for the use of character classes, selecting specific sequences, and more complex symbolic descriptions of strings. I will give a couple of simple examples of patterns. `str_remove` matches only once; `str_remove_all` matches the pattern as many times as possible.


```r
str_remove(my_string2, "cat")
```

```
## [1] "A  is a small, living and furry animal."
```

```r
str_remove_all(my_string2, "[aeiou]")
```

```
## [1] "A ct s  smll, lvng nd frry nml."
```

```r
str_remove_all(my_string2, "[ ,\\.!]")
```

```
## [1] "Acatisasmalllivingandfurryanimal"
```

* If a pattern appears in a string, you might want to extract that information. `str_extract` allows you to write a pattern that matches part of the string and extract that from the source material.


```r
sets <- c("A1", "A2", "B1", "B4", "C5")
str_extract(sets, "[0-9]")
```

```
## [1] "1" "2" "1" "4" "5"
```

```r
str_extract(sets, "[A-Z]")
```

```
## [1] "A" "A" "B" "B" "C"
```

Thinking about patterns is a lot of work and prone to error, so the pair of functions `glue` and `unglue` were created to perform common tasks of combining text and data and then to separate them again.


```r
library(glue)
library(unglue)
a <- 1
b <- 6
c <- 15.63
my_string3 <- glue("The numbers a, b, and c are {a}, {b}, and {c}, respectively. Their sum is {a+b+c}.")
my_string3
```

```
## The numbers a, b, and c are 1, 6, and 15.63, respectively. Their sum is 22.63.
```

```r
unglue(my_string3, "The numbers a, b, and c are {a}, {b}, and {c}, respectively. Their sum is {d}.")
```

```
## $`1`
##   a b     c     d
## 1 1 6 15.63 22.63
```

```r
my_strings1 <- tibble(greeting = c("My name is Andrew.", "My name is Li.", "My name is Emily."))
unglue_unnest(my_strings1, greeting, "My name is {name}.", remove=FALSE)
```

```
## # A tibble: 3 x 2
##   greeting           name  
## * <chr>              <chr> 
## 1 My name is Andrew. Andrew
## 2 My name is Li.     Li    
## 3 My name is Emily.  Emily
```

## Working with factors

Factors are categorical variables in which a set of labels ("strings") are the possible values of a variable. These are sometimes interpreted as integers and sometimes interpreted as text. In data visualization, our primary concern is mapping factors on to sequence of colours, shapes, or locations on an axis. In R, if a factor is not given an explicit order by the analyst, but must have an order (on a scale), this is usually alphabetical. This ordering is rarely the best one for visualizations!

The [forcats](https://forcats.tidyverse.org/) package has a series of functions for reordering factors. These can be used to explicitly reorder a factor by value (level) or a quantitative value can be used to reorder a factor. 

Here are a few examples using the `mpg` data set. First a visualization without any explicit reordering of factors.


```r
mpg %>% ggplot(aes(x = cty,
                   y = trans)) +
  geom_boxplot()
```

<img src="130-bonus-topics_files/figure-html/unnamed-chunk-5-1.png" width="672" />

Here the transmission factor is reordered according to the minimum value of highway fuel economy.


```r
mpg %>% ggplot(aes(x = cty,
                   y = fct_reorder(trans, hwy, median))) +
  geom_boxplot()
```

<img src="130-bonus-topics_files/figure-html/unnamed-chunk-6-1.png" width="672" />

Here we extract the number of gears from the transmission and reorder transmission on this basis.


```r
mpg %>% unglue_unnest(trans, "{trans_desc}({trans_code})", remove=FALSE)  %>%
  mutate(gears = str_extract(trans_code, "[0-9]") %>% as.numeric()) %>%
  ggplot(aes(x = cty,
             y = fct_reorder(trans, gears))) +
  geom_boxplot() 
```

<img src="130-bonus-topics_files/figure-html/unnamed-chunk-7-1.png" width="672" />

When there are too many cateogories to display on a graph, it can be helpful to pick out the ones with the most observations and to group the remaining observations together in an "other" category. Here's how you can accomplish that.


```r
mpg %>% 
  ggplot(aes(x = cty,
             y = fct_lump(trans, 4))) +
  geom_boxplot() 
```

<img src="130-bonus-topics_files/figure-html/unnamed-chunk-8-1.png" width="672" />


## Working with dates and times

Dates and times are complex data to work with. Dates are represented in many formats. Times are reported in time zones. which change depending on the time of year and the location of the measurement. Dates are futher complicated by leap years and local rules operating in specific countries. Placing dates and times on plots, or comparing observations made at different times arithmetic with dates

The package `lubridate` contains many functions to help you work with dates and times. For data visualization purposes I mostly use functions to parse dates and times (converting text to a date-time object), some basic arithmetic, extract components of a date, and format axis labels.

### Reading dates

There are a family of functions `ymd`, `dmy`, `mdy`, and `ymd_hms` among others that are used to turn text (such as in a table you read from a file) into a date. I strongly endorse the use of ISO 8601 date formatting. Illegal dates are converted to NA_Date.


```r
dt1 <- tibble(text_date = c("1999-01-31", "2000-02-28", "2010-06-28", "2024-03-14", "2021-02-29"),
             date = ymd(text_date))
```

```
## Warning: 1 failed to parse.
```

```r
dt1
```

```
## # A tibble: 5 x 2
##   text_date  date      
##   <chr>      <date>    
## 1 1999-01-31 1999-01-31
## 2 2000-02-28 2000-02-28
## 3 2010-06-28 2010-06-28
## 4 2024-03-14 2024-03-14
## 5 2021-02-29 NA
```

Here is an example with times. You can specify a time zone if you want, but sometimes you can get away with ignoring the problem.


```r
dt2 <- tibble(text_date = c("1999-01-31 09:14", "2000-02-28 12:15", "2010-06-28 23:45", 
                            "2024-03-14 07:00 AM", "2021-03-01 6:16 PM"),
             date_time = ymd_hm(text_date, tz="America/Halifax"))  # UTC is assumed if not specified
dt2
```

```
## # A tibble: 5 x 2
##   text_date           date_time          
##   <chr>               <dttm>             
## 1 1999-01-31 09:14    1999-01-31 09:14:00
## 2 2000-02-28 12:15    2000-02-28 12:15:00
## 3 2010-06-28 23:45    2010-06-28 23:45:00
## 4 2024-03-14 07:00 AM 2024-03-14 07:00:00
## 5 2021-03-01 6:16 PM  2021-03-01 18:16:00
```

These functions are remarkably powerful, for example they work on formats like this:


```r
mdy(c("Jan 5, 1999", "Saturday May 16, 70", "8-8-88", "December 31/99", "Jan 1, 01"))
```

```
## [1] "1999-01-05" "1970-05-16" "1988-08-08" "1999-12-31" "2001-01-01"
```

As with people working in the [late 20th century](https://en.wikipedia.org/wiki/Year_2000_problem), 
you should be very careful with two digit years. Best not to use them.

If you want to know how much time has passed since the first observation, you can do arithmetic. Note the data types of each column (character, date, time, double = numeric).


```r
dt1 %>% arrange(date) %>%
  mutate(elapsed = date - min(date, na.rm=TRUE),
         t = as.numeric(elapsed))
```

```
## # A tibble: 5 x 4
##   text_date  date       elapsed       t
##   <chr>      <date>     <drtn>    <dbl>
## 1 1999-01-31 1999-01-31    0 days     0
## 2 2000-02-28 2000-02-28  393 days   393
## 3 2010-06-28 2010-06-28 4166 days  4166
## 4 2024-03-14 2024-03-14 9174 days  9174
## 5 2021-02-29 NA           NA days    NA
```

Let's add some random data to the second table and make a scatter graph.


```r
dt2 %>% mutate(r = rnorm(n(), 20, 3)) %>%
  ggplot(aes(x = date_time, y = r)) + 
  geom_point() +
  scale_x_datetime(date_labels = "%Y\n%b-%d")
```

<img src="130-bonus-topics_files/figure-html/unnamed-chunk-13-1.png" width="672" />

There are lots more options for formatting date and time axes. See the help pages for more (in particular the examples, as always).



## Working with missing data

Data are often missing. Missing data are encoded as `NA` in R, but occasionally you need to know a bit more than this. There are a few ways you can get tripped up with missing data.

### Reading from a file

If you read data from a csv or spreadsheet, an empty cell (and sometimes "NA") will be interpreted as missing data. If some other value is used to represent NA, then you can use the option `na = ` in `read_csv` or `read_excel`. (`read_excel` only makes missing values into NA unless you specify that NA is missing.)

### Computations with NA

Any arithmetic computation with an NA will result in an NA result.


```r
1 + NA
```

```
## [1] NA
```

```r
Inf + NA
```

```
## [1] NA
```

```r
NA/0
```

```
## [1] NA
```

```r
log(NA)
```

```
## [1] NA
```

When we use functions that turn a vector into a single number (mean, min, median, etc.), sometimes we want to ignore missing values. The option `na.rm=` is useful here.


```r
dt3 <- tibble(x = c(1, 5, 9, 14.5, NA, 21, NA))
dt3 %>% summarize(mean_with_NA = mean(x),
                  mean_no_NA = mean(x, na.rm = TRUE))
```

```
## # A tibble: 1 x 2
##   mean_with_NA mean_no_NA
##          <dbl>      <dbl>
## 1           NA       10.1
```

If you want to know the number of observations, non-missing or missing data, use `n` or the idiom `sum(!is.na(...))` and `sum(is.na(...))` The exclamation mark (!, sometimes called [bang](https://en.wikipedia.org/wiki/Exclamation_mark)) means logical not so `!is.na` means not missing.


```r
dt3 %>% summarize(n_with_NA = n(),
                  n_no_NA = sum(!is.na(x)),
                  n_is_NA = sum(is.na(x)))
```

```
## # A tibble: 1 x 3
##   n_with_NA n_no_NA n_is_NA
##       <int>   <int>   <int>
## 1         7       5       2
```

If you have missing data in one or more columns and want to remove all observations from a table that have missing data, you can use `na.omit`.


```r
na.omit(dt3)
```

```
## # A tibble: 5 x 1
##       x
##   <dbl>
## 1   1  
## 2   5  
## 3   9  
## 4  14.5
## 5  21
```


## Multi-panel figures 

patchwork 
cowplot
hiding and combining guides
Adding tags
Creating space for a legend

marginal plots (histograms, densities)


## Further reading

* A blog post about [missing values](https://www.njtierney.com/post/2020/09/17/missing-flavour/) and data types


## Move elsewhere


### Testing data and calculations

### What is reproducibility and why should I care?





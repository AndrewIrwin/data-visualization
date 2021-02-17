# Summarizing data {#summarizing-data}



The tidyverse packages provide powerful tools for transforming and summarizing data. In this lesson we will explore the methods I use most frequently, including

* `mutate` for defining new variables based on existing variables,
* `filter` for including or excluding observations (rows) according to the values of one or more variables,
* `group_by` for dividing a data table in to a set of groups according to one or more variables, before summarizing the data, and
* `summarise` for reducing a table to a single row or a single row for each value of a grouped variable.

These tools mirror the methods used by database software for querying and summarizing data, such as the widely used SQL data query language. The correspondence is close enough that the tools can be used directly on databases by translating the tidyverse code into SQL with the `dbplyr` package. In databases, there are often links between two or more tables and information be combined using "joins"; R has all the standard joins for [combining data from two or more tables](https://r4ds.had.co.nz/relational-data.html) into one.

There are many other data manipulation and reduction tools to be learned, but these four functions are the foundation for a huge number of calculations to help you understand, simplify, summarize and communicate information about a dataset.

We will work with the `diamonds` dataset; it's fairly large and has a combination of quantitative and categorical data which can be used to illustrate these methods. R4DS [chapter 5](https://r4ds.had.co.nz/transform.html) does many similar demostrations with a large database of flight data. You should practice all these calculations on a data set of your choice (some ideas are [here](#data-sources)).

## Creating new variables with mutate

The diamonds data has dimensions (x, y, and z) and a mass (carat) of each diamond. It might be interesting to compare a [cuboid](https://en.wikipedia.org/wiki/Cuboid) approximation of the diamond to its mass to get a quantitative measure of how different each diamond is from a box. To start, we'll create a new variable called `box` defined by the product of x, y, and z. Then we'll create the ratio `box_ratio` as the quotient of its mass (`carat`) and this volume.


```r
diamonds %>%
  mutate(box = x*y*z,
         box_ratio = carat / box) %>%
  head()
```

```
## # A tibble: 6 x 12
##   carat cut    color clarity depth table price     x     y     z   box box_ratio
##   <dbl> <ord>  <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl> <dbl>     <dbl>
## 1 0.23  Ideal  E     SI2      61.5    55   326  3.95  3.98  2.43  38.2   0.00602
## 2 0.21  Premi… E     SI1      59.8    61   326  3.89  3.84  2.31  34.5   0.00609
## 3 0.23  Good   E     VS1      56.9    65   327  4.05  4.07  2.31  38.1   0.00604
## 4 0.290 Premi… I     VS2      62.4    58   334  4.2   4.23  2.63  46.7   0.00621
## 5 0.31  Good   J     SI2      63.3    58   335  4.34  4.35  2.75  51.9   0.00597
## 6 0.24  Very … J     VVS2     62.8    57   336  3.94  3.96  2.48  38.7   0.00620
```

This function adds two new columns to the data table, computing values for every row in the table. It doesn't change any of the other columns. You can also modify an existing column, for example to change units from dollars to thousands of dollars or carats to grams, by using the name of an existing column on the left hand side of the equals sign.

A few things to note:

* We use the name of a column to create or modify on the left hand side of the equals sign/
* We use an `=` instead of `<-` when creating or modifying columns. The arrow is used to assign values to new R objects in your environment (see the Environment tab in R studio); here we are modifying the columns of a data frame so a different notation is appropriate.
* The transformation shown above does not modify the `diamonds` object -- it creates a new object, which you can then store in a new R variable in your environment. I often perform transformations simply for the purposes of making a table or a plot without ever storing the the result.

## Filtering rows

Tbe `diamonds` data has many rows (more than 50,000). You might be interested in just a subset of the rows. We use `filter` to select rows to keep from a table. (We can specify rows to remove and use the logical not operator `!` to reverse the logic and keep all the other rows.)

For example, there are only 5 diamonds of more than 4 carats:


```r
diamonds %>% 
  filter(carat > 4)
```

```
## # A tibble: 5 x 10
##   carat cut     color clarity depth table price     x     y     z
##   <dbl> <ord>   <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
## 1  4.01 Premium I     I1       61      61 15223  10.1 10.1   6.17
## 2  4.01 Premium J     I1       62.5    62 15223  10.0  9.94  6.24
## 3  4.13 Fair    H     I1       64.8    61 17329  10    9.85  6.43
## 4  5.01 Fair    J     I1       65.5    59 18018  10.7 10.5   6.98
## 5  4.5  Fair    J     I1       65.8    58 18531  10.2 10.2   6.72
```

You can combine filtering operations by chaining them together with commas, pipes, or using boolean logic (`&` for and; `|` for or). The following three expressions all do the same thing.


```r
diamonds %>% filter(color == "J") %>% filter(cut == "Premium") %>% filter(carat > 3.0)
```

```
## # A tibble: 4 x 10
##   carat cut     color clarity depth table price     x     y     z
##   <dbl> <ord>   <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
## 1  4.01 Premium J     I1       62.5    62 15223 10.0   9.94  6.24
## 2  3.51 Premium J     VS2      62.5    59 18701  9.66  9.63  6.03
## 3  3.01 Premium J     SI2      60.7    59 18710  9.35  9.22  5.64
## 4  3.01 Premium J     SI2      59.7    58 18710  9.41  9.32  5.59
```

```r
diamonds %>% filter(color == "J", cut == "Premium", carat > 3.0)
```

```
## # A tibble: 4 x 10
##   carat cut     color clarity depth table price     x     y     z
##   <dbl> <ord>   <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
## 1  4.01 Premium J     I1       62.5    62 15223 10.0   9.94  6.24
## 2  3.51 Premium J     VS2      62.5    59 18701  9.66  9.63  6.03
## 3  3.01 Premium J     SI2      60.7    59 18710  9.35  9.22  5.64
## 4  3.01 Premium J     SI2      59.7    58 18710  9.41  9.32  5.59
```

```r
diamonds %>% filter(color == "J" & cut == "Premium" & carat > 3.0)
```

```
## # A tibble: 4 x 10
##   carat cut     color clarity depth table price     x     y     z
##   <dbl> <ord>   <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
## 1  4.01 Premium J     I1       62.5    62 15223 10.0   9.94  6.24
## 2  3.51 Premium J     VS2      62.5    59 18701  9.66  9.63  6.03
## 3  3.01 Premium J     SI2      60.7    59 18710  9.35  9.22  5.64
## 4  3.01 Premium J     SI2      59.7    58 18710  9.41  9.32  5.59
```

The second example a convenient abbreviation of the first, but why would we want the third way? Because we can use a logical "or" instead of an and to make different kinds of selections. For example, we might want all the diamonds that meet *any* of three different tests.


```r
diamonds %>% filter((color == "J" | cut == "Premium") & carat > 4.0)
```

```
## # A tibble: 4 x 10
##   carat cut     color clarity depth table price     x     y     z
##   <dbl> <ord>   <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
## 1  4.01 Premium I     I1       61      61 15223  10.1 10.1   6.17
## 2  4.01 Premium J     I1       62.5    62 15223  10.0  9.94  6.24
## 3  5.01 Fair    J     I1       65.5    59 18018  10.7 10.5   6.98
## 4  4.5  Fair    J     I1       65.8    58 18531  10.2 10.2   6.72
```

These logical expressions can be challenging to interpret, so use care and test them carefully to be sure the calculation does what you think it should.

## Getting just some rows and columns

All of the tables above showed all 10 columns. Sometimes you only want some of the columns. Use `select` to extract and reorder columns:


```r
diamonds %>% select(price, cut, color, clarity, carat) %>% head()
```

```
## # A tibble: 6 x 5
##   price cut       color clarity carat
##   <int> <ord>     <ord> <ord>   <dbl>
## 1   326 Ideal     E     SI2     0.23 
## 2   326 Premium   E     SI1     0.21 
## 3   327 Good      E     VS1     0.23 
## 4   334 Premium   I     VS2     0.290
## 5   335 Good      J     SI2     0.31 
## 6   336 Very Good J     VVS2    0.24
```

You'll notice I've used `head` to get just the first 6 rows of the data table. You can also use `tail` to get the last few rows. And you can modify the number of rows (see the help page for head and tail.)

A more general method for extracting rows by number is `slice`.


```r
diamonds %>% slice(c(1, 100, 200, 1000, 5000, 1000))
```

```
## # A tibble: 6 x 10
##   carat cut       color clarity depth table price     x     y     z
##   <dbl> <ord>     <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
## 1  0.23 Ideal     E     SI2      61.5    55   326  3.95  3.98  2.43
## 2  0.8  Premium   H     SI1      61.5    58  2760  5.97  5.93  3.66
## 3  0.72 Premium   F     SI1      61.8    61  2777  5.82  5.71  3.56
## 4  1.12 Premium   J     SI2      60.6    59  2898  6.68  6.61  4.03
## 5  1.05 Very Good I     SI2      62.3    59  3742  6.42  6.46  4.01
## 6  1.12 Premium   J     SI2      60.6    59  2898  6.68  6.61  4.03
```

Sometimes with a large dataset I want to look at a random subset of all the rows. Use these variants on `slice_` for that task. (Try it yourself: you will get different rows each time.)


```r
diamonds %>% slice_sample(n = 5)
```

```
## # A tibble: 5 x 10
##   carat cut       color clarity depth table price     x     y     z
##   <dbl> <ord>     <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
## 1  0.35 Ideal     G     VVS1     61.7    56   887  4.54  4.57  2.81
## 2  0.7  Premium   D     SI2      61.9    58  2536  5.71  5.67  3.52
## 3  0.7  Very Good E     VS2      62.5    57  2593  5.64  5.68  3.54
## 4  1.62 Good      I     VS1      59.6    65  9526  7.69  7.59  4.55
## 5  0.52 Premium   H     SI1      62.6    55  1219  5.16  5.12  3.22
```

You can use `arrange` to sort the data by any number of columns before slicing or displaying the data.


```r
diamonds %>% arrange(cut, -color, -carat) %>% slice_head(n = 10) %>% select(carat, cut, color, price)
```

```
## Warning: Problem with `mutate()` input `^^--arrange_quosure_2`.
## ℹ '-' is not meaningful for ordered factors
## ℹ Input `^^--arrange_quosure_2` is `-color`.
```

```
## Warning in Ops.ordered(color): '-' is not meaningful for ordered factors
```

```
## # A tibble: 10 x 4
##    carat cut   color price
##    <dbl> <ord> <ord> <int>
##  1  5.01 Fair  J     18018
##  2  4.5  Fair  J     18531
##  3  4.13 Fair  H     17329
##  4  3.65 Fair  H     11668
##  5  3.4  Fair  D     15964
##  6  3.11 Fair  J      9823
##  7  3.02 Fair  I     10577
##  8  3.01 Fair  H     10761
##  9  3.01 Fair  I     18242
## 10  3.01 Fair  I     18242
```

You'll notice that there are only a few levels of each of the categorical variables (cut, color, clarity). Suppose you want to see all combinations that exist? Use select to pick out those rows, then `distinct` to show only the rows that are different from each other. (There are 276 combinations, so I'm showing only the top 5, after sorting.)


```r
diamonds %>% select(cut, clarity, color) %>% distinct() %>% arrange(color, clarity, cut) %>% head(5)
```

```
## # A tibble: 5 x 3
##   cut       clarity color
##   <ord>     <ord>   <ord>
## 1 Fair      I1      D    
## 2 Good      I1      D    
## 3 Very Good I1      D    
## 4 Premium   I1      D    
## 5 Ideal     I1      D
```

## Summarizing data tables

These filtering and transformation functions are powerful and encourage a really useful way of probing a complext dataset. The `summarize` (or `summarise`) provides a way to apply a function to one or more variables across all the rows or colletions of rows. To use this effectively you want to think of functions that operate on a set of numbers and return just a single one, such as `mean`, `median`, `max`, `min`, `sd`, or the simplest of all `n` which counts the number of rows.


```r
diamonds %>% summarise(n_rows = n(), 
                       mean_price = mean(price),
                       median_price = median(price),
                       min_carat = min(carat))
```

```
## # A tibble: 1 x 4
##   n_rows mean_price median_price min_carat
##    <int>      <dbl>        <dbl>     <dbl>
## 1  53940      3933.         2401       0.2
```
All the original data is gone, replaced by these four functions applied to all the data in the corresponding column. The name of the new column appears on the left side of the `=` and the calculation on the right. This is the same way we wrote the `mutate` function, but instead of creating a new variable and computing a value for each row, we get one value computed using all the rows.

Rows can be grouped to get summaries for each level of the grouped varible. Let's group on `cut` but otherwise repeat this calculation:


```r
diamonds %>% group_by(cut) %>%
  summarise(n_rows = n(), 
                       mean_price = mean(price),
                       median_price = median(price),
                       min_carat = min(carat))
```

```
## # A tibble: 5 x 5
##   cut       n_rows mean_price median_price min_carat
##   <ord>      <int>      <dbl>        <dbl>     <dbl>
## 1 Fair        1610      4359.        3282       0.22
## 2 Good        4906      3929.        3050.      0.23
## 3 Very Good  12082      3982.        2648       0.2 
## 4 Premium    13791      4584.        3185       0.2 
## 5 Ideal      21551      3458.        1810       0.2
```

Now we get 5 rows.

You can group on as many variables at once as you like; the result will have one row for each combination of levels from each grouped variable. (You can even group on quantitative varibles, but you usually don't want to!)


```r
diamonds %>% group_by(cut, clarity, color) %>%
  summarise(n_rows = n(), 
                       mean_price = mean(price),
                       median_price = median(price),
                       min_carat = min(carat)) %>%
  head(5)
```

```
## # A tibble: 5 x 7
## # Groups:   cut, clarity [1]
##   cut   clarity color n_rows mean_price median_price min_carat
##   <ord> <ord>   <ord>  <int>      <dbl>        <dbl>     <dbl>
## 1 Fair  I1      D          4      7383         5538.      0.91
## 2 Fair  I1      E          9      2095.        2036       0.7 
## 3 Fair  I1      F         35      2544.        1570       0.34
## 4 Fair  I1      G         53      3187.        1954       0.5 
## 5 Fair  I1      H         52      4213.        3340.      0.7
```

Grouping doen't do any calculations, it just makes a notation on a data frame that your grouping should be used for subsequent calculations that pay attention to grouping. After you summarise data, one grouping variable is removed (the last one) but the result is still grouped by the remaining variables. (See the notation: Groups: cut, clarity in the result above.)

`summarise` has an optional argument `.groups` to say what grouping you want to retain after the calculation is done. `drop_last` is the default, described above. Probably the next most frequently used choice is `drop` which ungroups all the rows. To see the diference, I'll add another step, `count()`, which is equivalent to `summarise(n=n())` and counts rows.

Using `drop_last` I get the number of rows for each level of cut and clarity (usually 7 for the levels of color: D, E, F, G, H, I, J) for all 40 combinations of cut and clarity (only a few shown here.)


```r
diamonds %>% group_by(cut, clarity, color) %>%
  summarise(n_rows = n(), 
                       mean_price = mean(price),
                       median_price = median(price),
                       min_carat = min(carat),
             .groups="drop_last") %>%
  count() %>%
  head()
```

```
## # A tibble: 6 x 3
## # Groups:   cut, clarity [6]
##   cut   clarity     n
##   <ord> <ord>   <int>
## 1 Fair  I1          7
## 2 Fair  SI2         7
## 3 Fair  SI1         7
## 4 Fair  VS2         7
## 5 Fair  VS1         7
## 6 Fair  VVS2        7
```

Change the options to `.groups = "drop"` and I get a very different result -- just the number of combinations of cut, clarity, and color (276 of the maximum 5 x 8 x 7 = 280 which are possible):


```r
diamonds %>% group_by(cut, clarity, color) %>%
  summarise(n_rows = n(), 
                       mean_price = mean(price),
                       median_price = median(price),
                       min_carat = min(carat),
            .groups="drop") %>%
  count()
```

```
## # A tibble: 1 x 1
##       n
##   <int>
## 1   276
```

You can also use `ungroup()` following a `summarise` to discard all grouping if you don't want to use the `.groups` argument.

## Example

These methods can be combined together to produce elaborate queries. For example, let's use mutate to compute a price per carat ratio, then find the median of this ratio over all diamonds grouped by cut, color, and clarity. Also report the sample size used for each median. Finally we will extract the top 2 ratios for each cut type (using a grouped slice) and arrange the resulting table from largest to smallest ratio.


```r
diamonds %>%
  mutate(price_per_carat = price / carat) %>%
  group_by(color, clarity, cut) %>%
  summarise(median_price_per_carat = median(price_per_carat), 
            n = n(),
            .groups = "drop") %>%
  arrange(-median_price_per_carat) %>%
  group_by(cut) %>%
  slice_head(n=2) %>%
  arrange(-median_price_per_carat)
```

```
## # A tibble: 10 x 5
## # Groups:   cut [5]
##    color clarity cut       median_price_per_carat     n
##    <ord> <ord>   <ord>                      <dbl> <int>
##  1 D     IF      Good                      14932.     9
##  2 D     IF      Premium                   11057.    10
##  3 D     IF      Very Good                 10202.    23
##  4 D     IF      Ideal                      7162.    28
##  5 J     VVS1    Premium                    5336.    24
##  6 J     VVS2    Very Good                  5227.    29
##  7 H     IF      Good                       5100.     4
##  8 E     VVS1    Fair                       4921.     3
##  9 G     VS2     Fair                       4838     45
## 10 H     SI1     Ideal                      4469.   763
```

When I did this calculation the first time, I forgot the first `arrange`. Why is it needed before the grouped `slice_head`? (Remove it and see how the result changes. Try removing the slice_head to see the full results.) Why is the second `arrange` needed?

The top 4 price per carat categories are all the best colour (D) and clarity (IF), but cut seems to be less important in determining this ratio. One of the top 10 categories has a lot of diamonds in it (763), while the other groups have very few diamonds relative to the size of the whole dataset (more than 50,000).

## What does this have to do with data visualization?

These tools are very useful for exploring data; helping you understand the structure of your data. This will help you make better visualizations. In particular, the humble `n` function which counts rows should be used frequently when you summarize with mean or median to let you know if you have very few observations or too many for a good plot.

Summarizing data, for example by computing means and standard errors can be done as part of the visualization process using `stat_summary`, but it can be easier to know exactly what you are calculating if you compute the summary yourself using the methods in this lesson and then plot the results.

Tables can be a useful way to visualize data and grouped summaries are often the easiest way to make a table to describe your data.



## Further reading

* R4DS. Chapter 5 on [Data transformations](https://r4ds.had.co.nz/transform.html)


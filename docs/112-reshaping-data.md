# Reshaping data {#pivot}



There are many ways to organize data in an array. The key principles we're following are

* each row is a different observation, and
* each column is a different variable.

This organization tends to make for very long tables. For example, the `gapminder` data has 1704 rows: 12 years of data for 142 countries. We might want to show median life expectancy for each continent (5 rows) in three different years. This would make a nice compact table, but it seems like the data is not in the right shape for this.

## Pivot wider

We'll start by selecting three years (1987, 1997, 2007) and computing the median life expectancy for each continent in each year. (The median for the continent may not be representative of all countries in the continent, but we'll worry about that some other time.)



```r
t1 <- gapminder %>% 
  filter(year %in% c(1987, 1997, 2007)) %>%
  group_by(continent, year) %>%
  summarise(median_life_expectancy = median(lifeExp), .groups = "drop")
t1
```

```
## # A tibble: 15 x 3
##    continent  year median_life_expectancy
##    <fct>     <int>                  <dbl>
##  1 Africa     1987                   51.6
##  2 Africa     1997                   52.8
##  3 Africa     2007                   52.9
##  4 Americas   1987                   69.5
##  5 Americas   1997                   72.1
##  6 Americas   2007                   72.9
##  7 Asia       1987                   66.3
##  8 Asia       1997                   70.3
##  9 Asia       2007                   72.4
## 10 Europe     1987                   74.8
## 11 Europe     1997                   76.1
## 12 Europe     2007                   78.6
## 13 Oceania    1987                   75.3
## 14 Oceania    1997                   78.2
## 15 Oceania    2007                   80.7
```

Now we can see the data and it's not too large, the reshaping problem is clearer. I'd like to create a table with one row for each continent, one column for each year and the numbers in the grid should be the median life expectancy. This reshaping is called a pivot, specifically a pivot to make a wider table, and we simply need to specify the current column to use as the new names (year) and the current column to use as the values for the new grid (median_life_expectancy).


```r
t1 %>% pivot_wider(names_from = year, values_from = median_life_expectancy)
```

```
## # A tibble: 5 x 4
##   continent `1987` `1997` `2007`
##   <fct>      <dbl>  <dbl>  <dbl>
## 1 Africa      51.6   52.8   52.9
## 2 Americas    69.5   72.1   72.9
## 3 Asia        66.3   70.3   72.4
## 4 Europe      74.8   76.1   78.6
## 5 Oceania     75.3   78.2   80.7
```

I'll give you an advanced peek at table formatting skills from the next lesson to make this look a bit better:


```r
t2 <- t1 %>% pivot_wider(names_from = year, values_from = median_life_expectancy)
t2 %>% rename(Continent = continent) %>%
  arrange(-`2007`) %>%
  kable(digits = 1) %>%
  column_spec(1, bold=TRUE) %>%
  kable_styling(full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Continent </th>
   <th style="text-align:right;"> 1987 </th>
   <th style="text-align:right;"> 1997 </th>
   <th style="text-align:right;"> 2007 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Oceania </td>
   <td style="text-align:right;"> 75.3 </td>
   <td style="text-align:right;"> 78.2 </td>
   <td style="text-align:right;"> 80.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Europe </td>
   <td style="text-align:right;"> 74.8 </td>
   <td style="text-align:right;"> 76.1 </td>
   <td style="text-align:right;"> 78.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Americas </td>
   <td style="text-align:right;"> 69.5 </td>
   <td style="text-align:right;"> 72.1 </td>
   <td style="text-align:right;"> 72.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Asia </td>
   <td style="text-align:right;"> 66.3 </td>
   <td style="text-align:right;"> 70.3 </td>
   <td style="text-align:right;"> 72.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Africa </td>
   <td style="text-align:right;"> 51.6 </td>
   <td style="text-align:right;"> 52.8 </td>
   <td style="text-align:right;"> 52.9 </td>
  </tr>
</tbody>
</table>


## Pivot longer

Sometimes data a provided in a "wide" format, like the summary table above. This is often very convient for data entry and visual inspection. Suppose you wanted to use the years in the table shown above as a aesthetic in a plot, or a grouping variable in a summarise operation. You can't! So you might want to pivot the table to make it longer.

`pivot_longer` undoes the `pivot_wider` operation. You need to give the set of variables to be stacked and a name for the new variable to be filled with those column headings. Here's how to perform the inverse of the `pivot_wider` shown above. You can describe a sequence of variables by giving the first one, a colon (`:`), and the last one. Since our variable names are just numbers (which are not standard column names in data tables), we need to put backticks around them. (The plain expression 1987:2007 would be interpreted quite differently by R. Try it in the console. )


```r
t3 <- t2 %>% pivot_longer(cols = `1987`:`2007`, names_to = "year", values_to = "median_life_expectancy")
t3
```

```
## # A tibble: 15 x 3
##    continent year  median_life_expectancy
##    <fct>     <chr>                  <dbl>
##  1 Africa    1987                    51.6
##  2 Africa    1997                    52.8
##  3 Africa    2007                    52.9
##  4 Americas  1987                    69.5
##  5 Americas  1997                    72.1
##  6 Americas  2007                    72.9
##  7 Asia      1987                    66.3
##  8 Asia      1997                    70.3
##  9 Asia      2007                    72.4
## 10 Europe    1987                    74.8
## 11 Europe    1997                    76.1
## 12 Europe    2007                    78.6
## 13 Oceania   1987                    75.3
## 14 Oceania   1997                    78.2
## 15 Oceania   2007                    80.7
```

There is an important difference between the original table `t1` and this recovered table `t3`: the year variable in t1 was an integer (numeric) but the year variable in `t3` is character (text). This will matter if you want to calculate with the new year variable or put it on a quantitative scale. The `hablar` package makes it really easy to convert variables from one type to another:


```r
t3 %>% convert(int(year))
```

```
## # A tibble: 15 x 3
##    continent  year median_life_expectancy
##    <fct>     <int>                  <dbl>
##  1 Africa     1987                   51.6
##  2 Africa     1997                   52.8
##  3 Africa     2007                   52.9
##  4 Americas   1987                   69.5
##  5 Americas   1997                   72.1
##  6 Americas   2007                   72.9
##  7 Asia       1987                   66.3
##  8 Asia       1997                   70.3
##  9 Asia       2007                   72.4
## 10 Europe     1987                   74.8
## 11 Europe     1997                   76.1
## 12 Europe     2007                   78.6
## 13 Oceania    1987                   75.3
## 14 Oceania    1997                   78.2
## 15 Oceania    2007                   80.7
```

The dataset `who` in the `tidyr` package is counts of tuberculosis cases by country and year. It is in wide format with many columns (new...) describing diagnosis method, sex, and age category. There are also a lot of missing data when the data are shown in this wide format. 

Let's pivot this data to make it long.


```r
who_long <- who %>% pivot_longer(new_sp_m014:newrel_f65, names_to = "category", values_to = "counts")
head(who_long)
```

```
## # A tibble: 6 x 6
##   country     iso2  iso3   year category     counts
##   <chr>       <chr> <chr> <int> <chr>         <int>
## 1 Afghanistan AF    AFG    1980 new_sp_m014      NA
## 2 Afghanistan AF    AFG    1980 new_sp_m1524     NA
## 3 Afghanistan AF    AFG    1980 new_sp_m2534     NA
## 4 Afghanistan AF    AFG    1980 new_sp_m3544     NA
## 5 Afghanistan AF    AFG    1980 new_sp_m4554     NA
## 6 Afghanistan AF    AFG    1980 new_sp_m5564     NA
```

the original data had 7240 observations and 60 columns (4 that we've kept and 56 that we have pivoted). As a result our new table `who_long` has 6 columns (4+2) and 56 x 7240 = 405,440 rows. Let's see how many of the count data are missing.


```r
who_long %>% summarize(count_NA = sum(is.na(counts)))
```

```
## # A tibble: 1 x 1
##   count_NA
##      <int>
## 1   329394
```

A lot of them! In fact 81% of the data in the original matrix are NA. So let's discard them using `na.omit` or `filter(!is.na(counts))`. You can also use `values_drop_na = TRUE` in the `pivot_longer` function call. That will make a much smaller table. If you look at the smaller table, you'll see there are some counts equal to 0. So NA did not simply mean 0. (You should never use NA to mean 0; it should mean missing. But some people do.) 


```r
who_long <- who_long %>% filter(!is.na(counts))
```

## Separate and Unite

The category variable combines three pieces of information together in one label. How can we decode the category into three columns: diagnosis, sex, and age group? The `separate` function is made for this. The easiest way to use separate is if the variable you are separating is consistently structured with the same character between each column, such as new_rel_f_2534. That's not the case here: some values start with `new_` and some are missing the underscore after the `new`. Also there is no underscore between sex and age group. So we will do a bit of pre-processing using the `stringr` package before we use separate.

First, I'll remove "new" or "new_" (described concisely by a "regular expression" using new_*). Then I'll change `_f` to `_f_` and `_m` to `_m_`. When you first start learning to do these kinds of manipulations, you should check through a lot of the cases to be sure all the transformations worked the way you expect. There are a lot os `str_` functions in the `stringr` package to help with these kinds of manipulations.


```r
who_long %>% mutate(category = str_remove(category, "new_*"),
                    category = str_replace(category, "_f", "_f_"),
                    category = str_replace(category, "_m", "_m_")
                    ) %>% 
  head()
```

```
## # A tibble: 6 x 6
##   country     iso2  iso3   year category  counts
##   <chr>       <chr> <chr> <int> <chr>      <int>
## 1 Afghanistan AF    AFG    1997 sp_m_014       0
## 2 Afghanistan AF    AFG    1997 sp_m_1524     10
## 3 Afghanistan AF    AFG    1997 sp_m_2534      6
## 4 Afghanistan AF    AFG    1997 sp_m_3544      3
## 5 Afghanistan AF    AFG    1997 sp_m_4554      5
## 6 Afghanistan AF    AFG    1997 sp_m_5564      2
```

Now, we will use `separate` to convert `category` into three columns using the underscore as a separator.


```r
who_new <- who_long %>% mutate(category = str_remove(category, "new_*"),
                    category = str_replace(category, "_f", "_f_"),
                    category = str_replace(category, "_m", "_m_")
                    ) %>% 
  separate(col = category, into = c("diagnosis", "sex", "age_group"), sep="_")
who_new %>% head()
```

```
## # A tibble: 6 x 8
##   country     iso2  iso3   year diagnosis sex   age_group counts
##   <chr>       <chr> <chr> <int> <chr>     <chr> <chr>      <int>
## 1 Afghanistan AF    AFG    1997 sp        m     014            0
## 2 Afghanistan AF    AFG    1997 sp        m     1524          10
## 3 Afghanistan AF    AFG    1997 sp        m     2534           6
## 4 Afghanistan AF    AFG    1997 sp        m     3544           3
## 5 Afghanistan AF    AFG    1997 sp        m     4554           5
## 6 Afghanistan AF    AFG    1997 sp        m     5564           2
```

Now we can use the `dplyr` methods group_by and summarize to count cases by sex, age group, diagnosis, country, and year. Or we can use these new variables in data visualizations for facets or colours.

Sometimes you will want to do the reverse operation: combining two or more columns together. For example, if I have some biological data with the variables genus and species, I might want to combine the two, since a species is usually described by both together (Homo is our genus, and sapiens is our species name). That's a job for `unite`.


## Suggested reading

* R4DS [Section 12.3 Pivoting](https://r4ds.had.co.nz/tidy-data.html#pivoting)
* R4DS [Sextion 12.4 Separate and Unite](https://r4ds.had.co.nz/tidy-data.html#separating-and-uniting)
* Vignette on [kableExtra](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html) for formatting tables. See the next lesson for a lot more on this topic.
* Vignette on [stringr](https://cran.r-project.org/web/packages/stringr/vignettes/stringr.html) for manipulating text variables.

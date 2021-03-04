# Format tables {#format-tables}



We're spending a lot of time in this course making graphic visualizations of data. In this one lesson we will take a detour and learn to make nice looking tables with text and numbers in them. There are a bunch of packages for doing this (see Assignment X). We'll use the `kable` table formatting function in this lesson (from the packages `knitr` and `kableExtra`). 

Let's use a simple table to demonstrate the main features. I want some text, some numbers, and not too many rows or columns. I'll summarize the data in the `palmerpenguins` table into a small table.


```
## # A tibble: 5 x 4
##   species   island    count body_mass_g
## * <fct>     <fct>     <int>       <dbl>
## 1 Adelie    Biscoe       44       3710.
## 2 Adelie    Dream        56       3688.
## 3 Adelie    Torgersen    51       3706.
## 4 Chinstrap Dream        68       3733.
## 5 Gentoo    Biscoe      123       5076.
```

The function `kable` turns this into a formatted table.


```r
kable(t1)
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> species </th>
   <th style="text-align:left;"> island </th>
   <th style="text-align:right;"> count </th>
   <th style="text-align:right;"> body_mass_g </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 3709.659 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 3688.393 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Torgersen </td>
   <td style="text-align:right;"> 51 </td>
   <td style="text-align:right;"> 3706.373 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chinstrap </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 68 </td>
   <td style="text-align:right;"> 3733.088 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gentoo </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 123 </td>
   <td style="text-align:right;"> 5076.016 </td>
  </tr>
</tbody>
</table>

## Header rows

Often you will want to rename or reformat the column headings. There are two ways to do this: using `rename` to change the actual column names before formatting the table, or using column formatting to just affect the table appearance. You can rename just one column using `rename`, but with the second version below (`col.names`) you need to provide all the column names in the correct order. 


```r
t1 %>% rename(`Body mass (g)` = body_mass_g) %>% kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> species </th>
   <th style="text-align:left;"> island </th>
   <th style="text-align:right;"> count </th>
   <th style="text-align:right;"> Body mass (g) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 3709.659 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 3688.393 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Torgersen </td>
   <td style="text-align:right;"> 51 </td>
   <td style="text-align:right;"> 3706.373 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chinstrap </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 68 </td>
   <td style="text-align:right;"> 3733.088 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gentoo </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 123 </td>
   <td style="text-align:right;"> 5076.016 </td>
  </tr>
</tbody>
</table>


```r
t1 %>% kable(col.names = c("Species", "Island", "Count",  "Body mass (g)"))
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Species </th>
   <th style="text-align:left;"> Island </th>
   <th style="text-align:right;"> Count </th>
   <th style="text-align:right;"> Body mass (g) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 3709.659 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 3688.393 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Torgersen </td>
   <td style="text-align:right;"> 51 </td>
   <td style="text-align:right;"> 3706.373 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chinstrap </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 68 </td>
   <td style="text-align:right;"> 3733.088 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gentoo </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 123 </td>
   <td style="text-align:right;"> 5076.016 </td>
  </tr>
</tbody>
</table>

## Column alignment

Commonly numbers are right justified and text is left justified. That's what's done automatically. You can specify each column as left, centre, or right justified using the letters l, c, or r for each column. Here we'll center the justify the numbers to demonstrate.


```r
t1 %>% kable(align = "llcc")
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> species </th>
   <th style="text-align:left;"> island </th>
   <th style="text-align:center;"> count </th>
   <th style="text-align:center;"> body_mass_g </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:center;"> 44 </td>
   <td style="text-align:center;"> 3709.659 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:center;"> 56 </td>
   <td style="text-align:center;"> 3688.393 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Torgersen </td>
   <td style="text-align:center;"> 51 </td>
   <td style="text-align:center;"> 3706.373 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chinstrap </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:center;"> 68 </td>
   <td style="text-align:center;"> 3733.088 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gentoo </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:center;"> 123 </td>
   <td style="text-align:center;"> 5076.016 </td>
  </tr>
</tbody>
</table>

## Formatting numbers

Any number that comes from a calculation (such as a mean) will have a lot of decimal places displayed unless you change this. You can control the number of decimal places to show using rounding. (Use a negative number of digits to round to the left of the decimal point, for example `digits=-1` to round to the tens place.) Give either one number to use for all columns, or provide a vector to control the number of digits separately for each column.

You can add a comma (or space for SI or . for European styles) to separate the thousands or millions using `format.args = list(big.mark = ",")`. See the help for `format` for more options.



```r
t1 %>% kable(digits = 1, format.args = list(big.mark = ","))
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> species </th>
   <th style="text-align:left;"> island </th>
   <th style="text-align:right;"> count </th>
   <th style="text-align:right;"> body_mass_g </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 3,709.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 3,688.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Torgersen </td>
   <td style="text-align:right;"> 51 </td>
   <td style="text-align:right;"> 3,706.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chinstrap </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 68 </td>
   <td style="text-align:right;"> 3,733.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gentoo </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 123 </td>
   <td style="text-align:right;"> 5,076.0 </td>
  </tr>
</tbody>
</table>

## Color, highlights, and other styles

There are a lot of options for changing the appearance of text in the `kableExtra` package. If you are interested, look at the [vignette](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html) linked in the further reading.

The two styles I use frequently are alternating shading to help you read across rows and making the columns only wide enough to display your data.


```r
t1 %>% kable() %>% kable_styling(full_width = FALSE, bootstrap_options = "striped")
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> species </th>
   <th style="text-align:left;"> island </th>
   <th style="text-align:right;"> count </th>
   <th style="text-align:right;"> body_mass_g </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 3709.659 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 3688.393 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Torgersen </td>
   <td style="text-align:right;"> 51 </td>
   <td style="text-align:right;"> 3706.373 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chinstrap </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 68 </td>
   <td style="text-align:right;"> 3733.088 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gentoo </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 123 </td>
   <td style="text-align:right;"> 5076.016 </td>
  </tr>
</tbody>
</table>


## Captions

You can add a caption to a table with the `caption` argument to `kable`. 


```r
t1 %>% kable(caption = "The number and average mass of penguins by species and island.")
```

<table>
<caption>(\#tab:unnamed-chunk-8)The number and average mass of penguins by species and island.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> species </th>
   <th style="text-align:left;"> island </th>
   <th style="text-align:right;"> count </th>
   <th style="text-align:right;"> body_mass_g </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 3709.659 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 3688.393 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Torgersen </td>
   <td style="text-align:right;"> 51 </td>
   <td style="text-align:right;"> 3706.373 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chinstrap </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 68 </td>
   <td style="text-align:right;"> 3733.088 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gentoo </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 123 </td>
   <td style="text-align:right;"> 5076.016 </td>
  </tr>
</tbody>
</table>


## Putting it all together

Usually you will want to combine these features to get the look you want. Your goal should always be to make a table that clearly displays your data.


```r
t1 %>% kable(digits = 1, format.args = list(big.mark = ","),
             col.names = c("Species", "Island", "n", "Body mass (g)"),
             caption="The number and average mass of penguins by species and island.") %>%
  kable_styling(full_width = FALSE, bootstrap_options = "striped")
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-9)The number and average mass of penguins by species and island.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Species </th>
   <th style="text-align:left;"> Island </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> Body mass (g) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 3,709.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 3,688.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Torgersen </td>
   <td style="text-align:right;"> 51 </td>
   <td style="text-align:right;"> 3,706.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chinstrap </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:right;"> 68 </td>
   <td style="text-align:right;"> 3,733.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gentoo </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:right;"> 123 </td>
   <td style="text-align:right;"> 5,076.0 </td>
  </tr>
</tbody>
</table>

## Adding row and column totals

We frequently make tables of counts of categorical variables. In these tables it can be helpful to add column or row totals. Sometimes we want to report those totals as percentages of a grand total. The `janitor` package makes it easy to add totals and percentages to rows and columns.

We'll start with a matrix of counts showing the number of countries with life expectancy more than 75 years in each year and continent.


```r
t1 <- gapminder %>% filter(lifeExp > 75) %>%
  group_by(year, continent) %>%
  dplyr::summarize(n = n()) %>%
  pivot_wider(names_from = "continent", values_from = "n", values_fill = 0)
```

```
## `summarise()` has grouped output by 'year'. You can override using the `.groups` argument.
```

```r
t1
```

```
## # A tibble: 7 x 6
## # Groups:   year [7]
##    year  Asia Europe Americas Oceania Africa
##   <int> <int>  <int>    <int>   <int>  <int>
## 1  1977     1      5        0       0      0
## 2  1982     2      7        1       0      0
## 3  1987     3     11        2       1      0
## 4  1992     5     17        3       2      0
## 5  1997     6     19        5       2      0
## 6  2002     7     20        7       2      1
## 7  2007     9     22       10       2      1
```

Now we will add row totals. No sum is computed for the first column since it is assumed to be a label. 


```r
t1 %>% adorn_totals()
```

```
##   year Asia Europe Americas Oceania Africa
##   1977    1      5        0       0      0
##   1982    2      7        1       0      0
##   1987    3     11        2       1      0
##   1992    5     17        3       2      0
##   1997    6     19        5       2      0
##   2002    7     20        7       2      1
##   2007    9     22       10       2      1
##  Total   33    101       28       9      2
```

 If you think about this, you'll realize this doesn't make much sense! So let's add column totals instead. Again the first column is ignored, assuming it is a label.


```r
t1 %>% adorn_totals(where = "col") 
```

```
##  year Asia Europe Americas Oceania Africa Total
##  1977    1      5        0       0      0     6
##  1982    2      7        1       0      0    10
##  1987    3     11        2       1      0    17
##  1992    5     17        3       2      0    27
##  1997    6     19        5       2      0    32
##  2002    7     20        7       2      1    37
##  2007    9     22       10       2      1    44
```

These tables are formatted differently compared to `data.frames` and `tibbles`, but they can still be reformatted as you would expect using `%>% kable() %>% kable_styling()`.

Incidentally, the `janitor` package has a powerful table generating function `tabyl` which does the counting we started this section with. We still need the `filter` to retain only rows with life expectancy more than 75 years. The columns are reported alphabetically instead of according to the order they appear in the original dataset.


```r
gapminder %>% filter(lifeExp > 75) %>%
  tabyl(year, continent) #  %>% adorn_totals(where="col")
```

```
##  year Africa Americas Asia Europe Oceania
##  1977      0        0    1      5       0
##  1982      0        1    2      7       0
##  1987      0        2    3     11       1
##  1992      0        3    5     17       2
##  1997      0        5    6     19       2
##  2002      1        7    7     20       2
##  2007      1       10    9     22       2
```

## Adding grouping for rows and columns

Sometimes it is desirable to add a grouping label over a series of columns. For example, the in the table showing totals above, we can add a header "Continent" over the appropriate columns. We do this to a `kable` formatted table using the function `add_header_row`. This function takes an argument which is a vector of pairs: labels for each column and the number of columns that label should span. There must be enough lables to span all the columns. We will add a blank label for the first and last column (spanning 1 column each), and a label "Continent" spanning the 5 continents.


```r
t1 %>% adorn_totals(where = "col") %>%
  kable() %>%
  add_header_above(c(" " = 1, 
                  "Continent" = 5,
                  " " = 1)) %>%
  kable_styling(full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
<tr>
<th style="empty-cells: hide;border-bottom:hidden;" colspan="1"></th>
<th style="border-bottom:hidden;padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="5"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">Continent</div></th>
<th style="empty-cells: hide;border-bottom:hidden;" colspan="1"></th>
</tr>
  <tr>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> Asia </th>
   <th style="text-align:right;"> Europe </th>
   <th style="text-align:right;"> Americas </th>
   <th style="text-align:right;"> Oceania </th>
   <th style="text-align:right;"> Africa </th>
   <th style="text-align:right;"> Total </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1982 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1987 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1992 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1997 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 32 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2002 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 37 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 44 </td>
  </tr>
</tbody>
</table>

It can also be helpful to add grouping to rows. For example, we could label the first 5 rows as being part of the 20th century and the last 2 rows as being part of the 21st century. We add row labels one at a time, giving a label for the row and the numbers of the rows the header should span. We will do this with the `kableExtra` function `group_rows`.


```r
t1 %>% adorn_totals(where = "col") %>%
  kable() %>%
  group_rows("20th century", 1, 5) %>%
  group_rows("21st century", 6, 7) %>%
  kable_styling(full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> Asia </th>
   <th style="text-align:right;"> Europe </th>
   <th style="text-align:right;"> Americas </th>
   <th style="text-align:right;"> Oceania </th>
   <th style="text-align:right;"> Africa </th>
   <th style="text-align:right;"> Total </th>
  </tr>
 </thead>
<tbody>
  <tr grouplength="5"><td colspan="7" style="border-bottom: 1px solid;"><strong>20th century</strong></td></tr>
<tr>
   <td style="text-align:right;padding-left: 2em;" indentlevel="1"> 1977 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:right;padding-left: 2em;" indentlevel="1"> 1982 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:right;padding-left: 2em;" indentlevel="1"> 1987 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:right;padding-left: 2em;" indentlevel="1"> 1992 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:right;padding-left: 2em;" indentlevel="1"> 1997 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 32 </td>
  </tr>
  <tr grouplength="2"><td colspan="7" style="border-bottom: 1px solid;"><strong>21st century</strong></td></tr>
<tr>
   <td style="text-align:right;padding-left: 2em;" indentlevel="1"> 2002 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 37 </td>
  </tr>
  <tr>
   <td style="text-align:right;padding-left: 2em;" indentlevel="1"> 2007 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 44 </td>
  </tr>
</tbody>
</table>

## Further reading

* Using [kable](https://bookdown.org/yihui/rmarkdown-cookbook/kable.html) to format tables
* Vignette on using [kable and kableExtra](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html)
* https://people.ok.ubc.ca/jpither/modules/Tables_markdown.html


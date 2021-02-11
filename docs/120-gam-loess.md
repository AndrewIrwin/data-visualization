# GAM and LOESS smoothing {#smoothing}




In this lesson I will show you how to create GAM and LOESS models and perform some basic tasks to interact with the R model objects that the functions create. In keeping with the goals of the course, we will primarily focus on using the models for visualization and not attempt a detailed statistical analysis of when and why you might use a particular model for inference. This means we will restrict our attention to some basic uses of these models using one predictor (x) and one response (y) variable.

## Generalized Additive Models

Generalized additive models are a kind of linear regression, but instead of finding coefficients of predictor variables (e.g., intercepts, slopes), the model finds a "smooth" response function for each predictor. Typically this means that a piecewise cubic function (spline) is used to approximate the relationship between two variables. We can compute predicted values, confindence and prediction intervals, and show the smooth response function that arose from the model. We don't provide a simple list of coefficients like we did with linear regression, because the spline curve is defined by many numbers which are not usually informative on their own.

Generalized additive models are most commonly used when there is no theoretical motivation for a functional relationship between the variables being studied. We'll look at the Mauna Loa atmospheric CO2 concentration. These data increase year over year and have well-established interannual oscillations, but there is no clear function for either of these patterns.

We will start by using the last decade of data from Lesson 1.



Here is a plot of atmospheric CO2 concentration over time.


```r
my_theme = theme_linedraw() + theme(text = element_text(size = 14))
p1 <- co2 %>% ggplot(aes(decimal_date, co2_avg)) + geom_point() + my_theme +
  labs(x = "Year (decimal)", y = "Atmospheric CO2 (ppm)")
p1
```

<img src="120-gam-loess_files/figure-html/unnamed-chunk-3-1.png" width="672" />

The next plot shows each observation, minus the annual mean, as a function of the time of year but not the actual year. Each year's observations are overlapped.


```r
p2 <- co2 %>% ggplot(aes(year_fraction, co2_anomaly)) + geom_point() + my_theme +
  labs(x = "Year fraction (decimal)", y = "Atmospheric CO2 anomaly (ppm)")
p2
```

<img src="120-gam-loess_files/figure-html/unnamed-chunk-4-1.png" width="672" />

Here are GAM fits to both of these pairs of data using the `gam` function from the `mgcv` package. 
There is a `plot` function in the `mgcv` package, but I'm using a ggplot function called `draw` in the `gratia` package.


```r
g1 <- gam(co2_anomaly ~ s(year_fraction, bs="cs"), data = co2)
draw(g1, residuals=TRUE, rug=FALSE)
```

<img src="120-gam-loess_files/figure-html/unnamed-chunk-5-1.png" width="672" />

```r
g2 <- gam(co2_avg ~ s(decimal_date, bs="cs"),  data = co2)
draw(g2, residuals=TRUE, rug=FALSE) 
```

<img src="120-gam-loess_files/figure-html/unnamed-chunk-5-2.png" width="672" />

Depending on your goal, you may find that the second plot is too smooth -- the interannual oscillations are smoothed out completely. We can increase the number of "knots" (by setting `k=25`) in the spline to capture the oscillation, but this is not the way the smoothing is normally used:


```r
g3 <- gam(co2_avg ~ s(decimal_date, bs="cs", k = 25),  data = co2)
draw(g3, residuals=TRUE, rug=FALSE) 
```

<img src="120-gam-loess_files/figure-html/unnamed-chunk-6-1.png" width="672" />

There is a `summary` function for GAM fits and the `broom` functions `glance` and `tidy` give access to these data, but the interpretation of this output is beyond the scope of the course:


```r
summary(g1)
```

```
## 
## Family: gaussian 
## Link function: identity 
## 
## Formula:
## co2_anomaly ~ s(year_fraction, bs = "cs")
## 
## Parametric coefficients:
##              Estimate Std. Error t value Pr(>|t|)
## (Intercept) 3.364e-15  2.673e-02       0        1
## 
## Approximate significance of smooth terms:
##                    edf Ref.df     F p-value    
## s(year_fraction) 8.296      9 530.7  <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =  0.976   Deviance explained = 97.8%
## GCV = 0.092244  Scale est. = 0.085038  n = 119
```

```r
glance(g1) %>% kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> df </th>
   <th style="text-align:right;"> logLik </th>
   <th style="text-align:right;"> AIC </th>
   <th style="text-align:right;"> BIC </th>
   <th style="text-align:right;"> deviance </th>
   <th style="text-align:right;"> df.residual </th>
   <th style="text-align:right;"> nobs </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 9.296072 </td>
   <td style="text-align:right;"> -17.3669 </td>
   <td style="text-align:right;"> 55.32595 </td>
   <td style="text-align:right;"> 83.94001 </td>
   <td style="text-align:right;"> 9.328994 </td>
   <td style="text-align:right;"> 109.7039 </td>
   <td style="text-align:right;"> 119 </td>
  </tr>
</tbody>
</table>

```r
tidy(g1) %>% kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> term </th>
   <th style="text-align:right;"> edf </th>
   <th style="text-align:right;"> ref.df </th>
   <th style="text-align:right;"> statistic </th>
   <th style="text-align:right;"> p.value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:right;"> 8.296072 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 530.7013 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
</tbody>
</table>

It is often useful to compute residuals and extract predicted values.


```r
co2 %>% add_residuals(g1) %>% add_fitted(g1) %>% kable() %>%  scroll_box(height = "200px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:200px; "><table>
 <thead>
  <tr>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> year </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> month </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> decimal_date </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> co2_avg </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> year_fraction </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> co2_anomaly </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> .residual </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> .value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2011.042 </td>
   <td style="text-align:right;"> 391.33 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -0.3216667 </td>
   <td style="text-align:right;"> 0.4287396 </td>
   <td style="text-align:right;"> -0.75040623 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2011.125 </td>
   <td style="text-align:right;"> 391.86 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.2083333 </td>
   <td style="text-align:right;"> 0.3028578 </td>
   <td style="text-align:right;"> -0.09452442 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2011.208 </td>
   <td style="text-align:right;"> 392.60 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 0.9483333 </td>
   <td style="text-align:right;"> 0.1440604 </td>
   <td style="text-align:right;"> 0.80427289 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2011.292 </td>
   <td style="text-align:right;"> 393.25 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 1.5983333 </td>
   <td style="text-align:right;"> -0.6010968 </td>
   <td style="text-align:right;"> 2.19943018 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2011.375 </td>
   <td style="text-align:right;"> 394.19 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.5383333 </td>
   <td style="text-align:right;"> -0.5071870 </td>
   <td style="text-align:right;"> 3.04552036 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2011.458 </td>
   <td style="text-align:right;"> 393.74 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.0883333 </td>
   <td style="text-align:right;"> -0.1757651 </td>
   <td style="text-align:right;"> 2.26409839 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2011.542 </td>
   <td style="text-align:right;"> 392.51 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.8583333 </td>
   <td style="text-align:right;"> 0.3875911 </td>
   <td style="text-align:right;"> 0.47074220 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 2011.625 </td>
   <td style="text-align:right;"> 390.13 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.5216667 </td>
   <td style="text-align:right;"> 0.0541267 </td>
   <td style="text-align:right;"> -1.57579337 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2011.708 </td>
   <td style="text-align:right;"> 389.08 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.5716667 </td>
   <td style="text-align:right;"> 0.3920488 </td>
   <td style="text-align:right;"> -2.96371550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2011.792 </td>
   <td style="text-align:right;"> 388.99 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.6616667 </td>
   <td style="text-align:right;"> 0.0151298 </td>
   <td style="text-align:right;"> -2.67679645 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 2011.875 </td>
   <td style="text-align:right;"> 390.28 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.3716667 </td>
   <td style="text-align:right;"> -0.2731017 </td>
   <td style="text-align:right;"> -1.09856499 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 2011.958 </td>
   <td style="text-align:right;"> 391.86 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.2083333 </td>
   <td style="text-align:right;"> -0.2091522 </td>
   <td style="text-align:right;"> 0.41748550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2012.042 </td>
   <td style="text-align:right;"> 393.12 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -0.7350000 </td>
   <td style="text-align:right;"> 0.0154062 </td>
   <td style="text-align:right;"> -0.75040623 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2012.125 </td>
   <td style="text-align:right;"> 393.86 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.0050000 </td>
   <td style="text-align:right;"> 0.0995244 </td>
   <td style="text-align:right;"> -0.09452442 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2012.208 </td>
   <td style="text-align:right;"> 394.40 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 0.5450000 </td>
   <td style="text-align:right;"> -0.2592729 </td>
   <td style="text-align:right;"> 0.80427289 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2012.292 </td>
   <td style="text-align:right;"> 396.18 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.3250000 </td>
   <td style="text-align:right;"> 0.1255698 </td>
   <td style="text-align:right;"> 2.19943018 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2012.375 </td>
   <td style="text-align:right;"> 396.74 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.8850000 </td>
   <td style="text-align:right;"> -0.1605204 </td>
   <td style="text-align:right;"> 3.04552036 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2012.458 </td>
   <td style="text-align:right;"> 395.71 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 1.8550000 </td>
   <td style="text-align:right;"> -0.4090984 </td>
   <td style="text-align:right;"> 2.26409839 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2012.542 </td>
   <td style="text-align:right;"> 394.36 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.5050000 </td>
   <td style="text-align:right;"> 0.0342578 </td>
   <td style="text-align:right;"> 0.47074220 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 2012.625 </td>
   <td style="text-align:right;"> 392.39 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.4650000 </td>
   <td style="text-align:right;"> 0.1107934 </td>
   <td style="text-align:right;"> -1.57579337 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2012.708 </td>
   <td style="text-align:right;"> 391.13 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.7250000 </td>
   <td style="text-align:right;"> 0.2387155 </td>
   <td style="text-align:right;"> -2.96371550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2012.792 </td>
   <td style="text-align:right;"> 391.05 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.8050000 </td>
   <td style="text-align:right;"> -0.1282035 </td>
   <td style="text-align:right;"> -2.67679645 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 2012.875 </td>
   <td style="text-align:right;"> 392.98 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -0.8750000 </td>
   <td style="text-align:right;"> 0.2235650 </td>
   <td style="text-align:right;"> -1.09856499 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 2012.958 </td>
   <td style="text-align:right;"> 394.34 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.4850000 </td>
   <td style="text-align:right;"> 0.0675145 </td>
   <td style="text-align:right;"> 0.41748550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2013.042 </td>
   <td style="text-align:right;"> 395.55 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -0.9700000 </td>
   <td style="text-align:right;"> -0.2195938 </td>
   <td style="text-align:right;"> -0.75040623 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2013.125 </td>
   <td style="text-align:right;"> 396.80 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.2800000 </td>
   <td style="text-align:right;"> 0.3745244 </td>
   <td style="text-align:right;"> -0.09452442 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2013.208 </td>
   <td style="text-align:right;"> 397.43 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 0.9100000 </td>
   <td style="text-align:right;"> 0.1057271 </td>
   <td style="text-align:right;"> 0.80427289 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2013.292 </td>
   <td style="text-align:right;"> 398.41 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 1.8900000 </td>
   <td style="text-align:right;"> -0.3094302 </td>
   <td style="text-align:right;"> 2.19943018 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2013.375 </td>
   <td style="text-align:right;"> 399.78 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 3.2600000 </td>
   <td style="text-align:right;"> 0.2144796 </td>
   <td style="text-align:right;"> 3.04552036 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2013.458 </td>
   <td style="text-align:right;"> 398.60 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.0800000 </td>
   <td style="text-align:right;"> -0.1840984 </td>
   <td style="text-align:right;"> 2.26409839 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2013.542 </td>
   <td style="text-align:right;"> 397.32 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.8000000 </td>
   <td style="text-align:right;"> 0.3292578 </td>
   <td style="text-align:right;"> 0.47074220 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 2013.625 </td>
   <td style="text-align:right;"> 395.20 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.3200000 </td>
   <td style="text-align:right;"> 0.2557934 </td>
   <td style="text-align:right;"> -1.57579337 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2013.708 </td>
   <td style="text-align:right;"> 393.45 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -3.0700000 </td>
   <td style="text-align:right;"> -0.1062845 </td>
   <td style="text-align:right;"> -2.96371550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2013.792 </td>
   <td style="text-align:right;"> 393.70 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.8200000 </td>
   <td style="text-align:right;"> -0.1432035 </td>
   <td style="text-align:right;"> -2.67679645 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 2013.875 </td>
   <td style="text-align:right;"> 395.16 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.3600000 </td>
   <td style="text-align:right;"> -0.2614350 </td>
   <td style="text-align:right;"> -1.09856499 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 2013.958 </td>
   <td style="text-align:right;"> 396.84 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.3200000 </td>
   <td style="text-align:right;"> -0.0974855 </td>
   <td style="text-align:right;"> 0.41748550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2014.042 </td>
   <td style="text-align:right;"> 397.85 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -0.7925000 </td>
   <td style="text-align:right;"> -0.0420938 </td>
   <td style="text-align:right;"> -0.75040623 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2014.125 </td>
   <td style="text-align:right;"> 398.01 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> -0.6325000 </td>
   <td style="text-align:right;"> -0.5379756 </td>
   <td style="text-align:right;"> -0.09452442 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2014.208 </td>
   <td style="text-align:right;"> 399.71 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 1.0675000 </td>
   <td style="text-align:right;"> 0.2632271 </td>
   <td style="text-align:right;"> 0.80427289 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2014.292 </td>
   <td style="text-align:right;"> 401.33 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.6875000 </td>
   <td style="text-align:right;"> 0.4880698 </td>
   <td style="text-align:right;"> 2.19943018 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2014.375 </td>
   <td style="text-align:right;"> 401.78 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 3.1375000 </td>
   <td style="text-align:right;"> 0.0919796 </td>
   <td style="text-align:right;"> 3.04552036 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2014.458 </td>
   <td style="text-align:right;"> 401.25 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.6075000 </td>
   <td style="text-align:right;"> 0.3434016 </td>
   <td style="text-align:right;"> 2.26409839 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2014.542 </td>
   <td style="text-align:right;"> 399.11 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.4675000 </td>
   <td style="text-align:right;"> -0.0032422 </td>
   <td style="text-align:right;"> 0.47074220 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 2014.625 </td>
   <td style="text-align:right;"> 397.03 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.6125000 </td>
   <td style="text-align:right;"> -0.0367066 </td>
   <td style="text-align:right;"> -1.57579337 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2014.708 </td>
   <td style="text-align:right;"> 395.38 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -3.2625000 </td>
   <td style="text-align:right;"> -0.2987845 </td>
   <td style="text-align:right;"> -2.96371550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2014.792 </td>
   <td style="text-align:right;"> 396.07 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.5725000 </td>
   <td style="text-align:right;"> 0.1042965 </td>
   <td style="text-align:right;"> -2.67679645 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 2014.875 </td>
   <td style="text-align:right;"> 397.28 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.3625000 </td>
   <td style="text-align:right;"> -0.2639350 </td>
   <td style="text-align:right;"> -1.09856499 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 2014.958 </td>
   <td style="text-align:right;"> 398.91 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.2675000 </td>
   <td style="text-align:right;"> -0.1499855 </td>
   <td style="text-align:right;"> 0.41748550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2015.042 </td>
   <td style="text-align:right;"> 399.98 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -0.8458333 </td>
   <td style="text-align:right;"> -0.0954271 </td>
   <td style="text-align:right;"> -0.75040623 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2015.125 </td>
   <td style="text-align:right;"> 400.35 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> -0.4758333 </td>
   <td style="text-align:right;"> -0.3813089 </td>
   <td style="text-align:right;"> -0.09452442 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2015.208 </td>
   <td style="text-align:right;"> 401.52 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 0.6941667 </td>
   <td style="text-align:right;"> -0.1101062 </td>
   <td style="text-align:right;"> 0.80427289 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2015.292 </td>
   <td style="text-align:right;"> 403.15 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.3241667 </td>
   <td style="text-align:right;"> 0.1247365 </td>
   <td style="text-align:right;"> 2.19943018 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2015.375 </td>
   <td style="text-align:right;"> 403.96 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 3.1341667 </td>
   <td style="text-align:right;"> 0.0886463 </td>
   <td style="text-align:right;"> 3.04552036 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2015.458 </td>
   <td style="text-align:right;"> 402.80 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 1.9741667 </td>
   <td style="text-align:right;"> -0.2899317 </td>
   <td style="text-align:right;"> 2.26409839 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2015.542 </td>
   <td style="text-align:right;"> 401.29 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.4641667 </td>
   <td style="text-align:right;"> -0.0065755 </td>
   <td style="text-align:right;"> 0.47074220 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 2015.625 </td>
   <td style="text-align:right;"> 398.93 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.8958333 </td>
   <td style="text-align:right;"> -0.3200400 </td>
   <td style="text-align:right;"> -1.57579337 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2015.708 </td>
   <td style="text-align:right;"> 397.63 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -3.1958333 </td>
   <td style="text-align:right;"> -0.2321178 </td>
   <td style="text-align:right;"> -2.96371550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2015.792 </td>
   <td style="text-align:right;"> 398.29 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.5358333 </td>
   <td style="text-align:right;"> 0.1409631 </td>
   <td style="text-align:right;"> -2.67679645 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 2015.875 </td>
   <td style="text-align:right;"> 400.16 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -0.6658333 </td>
   <td style="text-align:right;"> 0.4327317 </td>
   <td style="text-align:right;"> -1.09856499 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 2015.958 </td>
   <td style="text-align:right;"> 401.85 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 1.0241667 </td>
   <td style="text-align:right;"> 0.6066812 </td>
   <td style="text-align:right;"> 0.41748550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2016.042 </td>
   <td style="text-align:right;"> 402.50 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -1.7225000 </td>
   <td style="text-align:right;"> -0.9720938 </td>
   <td style="text-align:right;"> -0.75040623 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2016.125 </td>
   <td style="text-align:right;"> 404.07 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> -0.1525000 </td>
   <td style="text-align:right;"> -0.0579756 </td>
   <td style="text-align:right;"> -0.09452442 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2016.208 </td>
   <td style="text-align:right;"> 404.87 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 0.6475000 </td>
   <td style="text-align:right;"> -0.1567729 </td>
   <td style="text-align:right;"> 0.80427289 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2016.292 </td>
   <td style="text-align:right;"> 407.42 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 3.1975000 </td>
   <td style="text-align:right;"> 0.9980698 </td>
   <td style="text-align:right;"> 2.19943018 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2016.375 </td>
   <td style="text-align:right;"> 407.72 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 3.4975000 </td>
   <td style="text-align:right;"> 0.4519796 </td>
   <td style="text-align:right;"> 3.04552036 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2016.458 </td>
   <td style="text-align:right;"> 406.81 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.5875000 </td>
   <td style="text-align:right;"> 0.3234016 </td>
   <td style="text-align:right;"> 2.26409839 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2016.542 </td>
   <td style="text-align:right;"> 404.40 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.1775000 </td>
   <td style="text-align:right;"> -0.2932422 </td>
   <td style="text-align:right;"> 0.47074220 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 2016.625 </td>
   <td style="text-align:right;"> 402.26 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.9625000 </td>
   <td style="text-align:right;"> -0.3867066 </td>
   <td style="text-align:right;"> -1.57579337 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2016.708 </td>
   <td style="text-align:right;"> 401.05 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -3.1725000 </td>
   <td style="text-align:right;"> -0.2087845 </td>
   <td style="text-align:right;"> -2.96371550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2016.792 </td>
   <td style="text-align:right;"> 401.60 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.6225000 </td>
   <td style="text-align:right;"> 0.0542965 </td>
   <td style="text-align:right;"> -2.67679645 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 2016.875 </td>
   <td style="text-align:right;"> 403.53 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -0.6925000 </td>
   <td style="text-align:right;"> 0.4060650 </td>
   <td style="text-align:right;"> -1.09856499 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 2016.958 </td>
   <td style="text-align:right;"> 404.44 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.2175000 </td>
   <td style="text-align:right;"> -0.1999855 </td>
   <td style="text-align:right;"> 0.41748550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2017.042 </td>
   <td style="text-align:right;"> 406.17 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -0.3850000 </td>
   <td style="text-align:right;"> 0.3654062 </td>
   <td style="text-align:right;"> -0.75040623 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2017.125 </td>
   <td style="text-align:right;"> 406.47 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> -0.0850000 </td>
   <td style="text-align:right;"> 0.0095244 </td>
   <td style="text-align:right;"> -0.09452442 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2017.208 </td>
   <td style="text-align:right;"> 407.23 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 0.6750000 </td>
   <td style="text-align:right;"> -0.1292729 </td>
   <td style="text-align:right;"> 0.80427289 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2017.292 </td>
   <td style="text-align:right;"> 409.03 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.4750000 </td>
   <td style="text-align:right;"> 0.2755698 </td>
   <td style="text-align:right;"> 2.19943018 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2017.375 </td>
   <td style="text-align:right;"> 409.69 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 3.1350000 </td>
   <td style="text-align:right;"> 0.0894796 </td>
   <td style="text-align:right;"> 3.04552036 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2017.458 </td>
   <td style="text-align:right;"> 408.89 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.3350000 </td>
   <td style="text-align:right;"> 0.0709016 </td>
   <td style="text-align:right;"> 2.26409839 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2017.542 </td>
   <td style="text-align:right;"> 407.13 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.5750000 </td>
   <td style="text-align:right;"> 0.1042578 </td>
   <td style="text-align:right;"> 0.47074220 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 2017.625 </td>
   <td style="text-align:right;"> 405.12 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.4350000 </td>
   <td style="text-align:right;"> 0.1407934 </td>
   <td style="text-align:right;"> -1.57579337 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2017.708 </td>
   <td style="text-align:right;"> 403.37 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -3.1850000 </td>
   <td style="text-align:right;"> -0.2212845 </td>
   <td style="text-align:right;"> -2.96371550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2017.792 </td>
   <td style="text-align:right;"> 403.63 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.9250000 </td>
   <td style="text-align:right;"> -0.2482035 </td>
   <td style="text-align:right;"> -2.67679645 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 2017.875 </td>
   <td style="text-align:right;"> 405.12 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.4350000 </td>
   <td style="text-align:right;"> -0.3364350 </td>
   <td style="text-align:right;"> -1.09856499 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 2017.958 </td>
   <td style="text-align:right;"> 406.81 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.2550000 </td>
   <td style="text-align:right;"> -0.1624855 </td>
   <td style="text-align:right;"> 0.41748550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2018.042 </td>
   <td style="text-align:right;"> 407.96 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -0.5600000 </td>
   <td style="text-align:right;"> 0.1904062 </td>
   <td style="text-align:right;"> -0.75040623 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2018.125 </td>
   <td style="text-align:right;"> 408.32 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> -0.2000000 </td>
   <td style="text-align:right;"> -0.1054756 </td>
   <td style="text-align:right;"> -0.09452442 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2018.208 </td>
   <td style="text-align:right;"> 409.39 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 0.8700000 </td>
   <td style="text-align:right;"> 0.0657271 </td>
   <td style="text-align:right;"> 0.80427289 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2018.292 </td>
   <td style="text-align:right;"> 410.25 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 1.7300000 </td>
   <td style="text-align:right;"> -0.4694302 </td>
   <td style="text-align:right;"> 2.19943018 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2018.375 </td>
   <td style="text-align:right;"> 411.24 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.7200000 </td>
   <td style="text-align:right;"> -0.3255204 </td>
   <td style="text-align:right;"> 3.04552036 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2018.458 </td>
   <td style="text-align:right;"> 410.79 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.2700000 </td>
   <td style="text-align:right;"> 0.0059016 </td>
   <td style="text-align:right;"> 2.26409839 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2018.542 </td>
   <td style="text-align:right;"> 408.70 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.1800000 </td>
   <td style="text-align:right;"> -0.2907422 </td>
   <td style="text-align:right;"> 0.47074220 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 2018.625 </td>
   <td style="text-align:right;"> 406.97 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.5500000 </td>
   <td style="text-align:right;"> 0.0257934 </td>
   <td style="text-align:right;"> -1.57579337 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2018.708 </td>
   <td style="text-align:right;"> 405.52 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -3.0000000 </td>
   <td style="text-align:right;"> -0.0362845 </td>
   <td style="text-align:right;"> -2.96371550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2018.792 </td>
   <td style="text-align:right;"> 406.00 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.5200000 </td>
   <td style="text-align:right;"> 0.1567965 </td>
   <td style="text-align:right;"> -2.67679645 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 2018.875 </td>
   <td style="text-align:right;"> 408.02 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -0.5000000 </td>
   <td style="text-align:right;"> 0.5985650 </td>
   <td style="text-align:right;"> -1.09856499 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 2018.958 </td>
   <td style="text-align:right;"> 409.08 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.5600000 </td>
   <td style="text-align:right;"> 0.1425145 </td>
   <td style="text-align:right;"> 0.41748550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2019.042 </td>
   <td style="text-align:right;"> 410.83 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -0.6041667 </td>
   <td style="text-align:right;"> 0.1462396 </td>
   <td style="text-align:right;"> -0.75040623 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2019.125 </td>
   <td style="text-align:right;"> 411.75 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.3158333 </td>
   <td style="text-align:right;"> 0.4103578 </td>
   <td style="text-align:right;"> -0.09452442 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2019.208 </td>
   <td style="text-align:right;"> 411.97 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 0.5358333 </td>
   <td style="text-align:right;"> -0.2684396 </td>
   <td style="text-align:right;"> 0.80427289 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2019.292 </td>
   <td style="text-align:right;"> 413.33 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 1.8958333 </td>
   <td style="text-align:right;"> -0.3035968 </td>
   <td style="text-align:right;"> 2.19943018 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2019.375 </td>
   <td style="text-align:right;"> 414.64 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 3.2058333 </td>
   <td style="text-align:right;"> 0.1603130 </td>
   <td style="text-align:right;"> 3.04552036 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2019.458 </td>
   <td style="text-align:right;"> 413.93 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.4958333 </td>
   <td style="text-align:right;"> 0.2317349 </td>
   <td style="text-align:right;"> 2.26409839 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2019.542 </td>
   <td style="text-align:right;"> 411.74 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.3058333 </td>
   <td style="text-align:right;"> -0.1649089 </td>
   <td style="text-align:right;"> 0.47074220 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 2019.625 </td>
   <td style="text-align:right;"> 409.95 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.4841667 </td>
   <td style="text-align:right;"> 0.0916267 </td>
   <td style="text-align:right;"> -1.57579337 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2019.708 </td>
   <td style="text-align:right;"> 408.54 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.8941667 </td>
   <td style="text-align:right;"> 0.0695488 </td>
   <td style="text-align:right;"> -2.96371550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2019.792 </td>
   <td style="text-align:right;"> 408.52 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.9141667 </td>
   <td style="text-align:right;"> -0.2373702 </td>
   <td style="text-align:right;"> -2.67679645 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 2019.875 </td>
   <td style="text-align:right;"> 410.25 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.1841667 </td>
   <td style="text-align:right;"> -0.0856017 </td>
   <td style="text-align:right;"> -1.09856499 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 2019.958 </td>
   <td style="text-align:right;"> 411.76 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.3258333 </td>
   <td style="text-align:right;"> -0.0916522 </td>
   <td style="text-align:right;"> 0.41748550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2020.042 </td>
   <td style="text-align:right;"> 413.39 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -0.6154545 </td>
   <td style="text-align:right;"> 0.1349517 </td>
   <td style="text-align:right;"> -0.75040623 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2020.125 </td>
   <td style="text-align:right;"> 414.11 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.1045455 </td>
   <td style="text-align:right;"> 0.1990699 </td>
   <td style="text-align:right;"> -0.09452442 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2020.208 </td>
   <td style="text-align:right;"> 414.51 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 0.5045455 </td>
   <td style="text-align:right;"> -0.2997274 </td>
   <td style="text-align:right;"> 0.80427289 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2020.292 </td>
   <td style="text-align:right;"> 416.21 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.2045455 </td>
   <td style="text-align:right;"> 0.0051153 </td>
   <td style="text-align:right;"> 2.19943018 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2020.375 </td>
   <td style="text-align:right;"> 417.07 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 3.0645455 </td>
   <td style="text-align:right;"> 0.0190251 </td>
   <td style="text-align:right;"> 3.04552036 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2020.458 </td>
   <td style="text-align:right;"> 416.38 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.3745455 </td>
   <td style="text-align:right;"> 0.1104471 </td>
   <td style="text-align:right;"> 2.26409839 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2020.542 </td>
   <td style="text-align:right;"> 414.38 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.3745455 </td>
   <td style="text-align:right;"> -0.0961967 </td>
   <td style="text-align:right;"> 0.47074220 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 2020.625 </td>
   <td style="text-align:right;"> 412.55 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.4554545 </td>
   <td style="text-align:right;"> 0.1203388 </td>
   <td style="text-align:right;"> -1.57579337 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2020.708 </td>
   <td style="text-align:right;"> 411.29 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.7154545 </td>
   <td style="text-align:right;"> 0.2482610 </td>
   <td style="text-align:right;"> -2.96371550 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2020.792 </td>
   <td style="text-align:right;"> 411.28 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.7254545 </td>
   <td style="text-align:right;"> -0.0486581 </td>
   <td style="text-align:right;"> -2.67679645 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 2020.875 </td>
   <td style="text-align:right;"> 412.89 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.1154545 </td>
   <td style="text-align:right;"> -0.0168896 </td>
   <td style="text-align:right;"> -1.09856499 </td>
  </tr>
</tbody>
</table></div>

If we generate new data (dates), we can plot predictions too. Since the model is a piecewise cubic function, extrapolations are often dramatically unreliable. The downward facing cubic in the last "bump" is simply continued, with comically bad results. Extrapolation of models, and especially smooths, is somewhere between risky and foolish!


```r
new_data <- tibble(decimal_date = seq(2017, 2022, by = 0.05))
new_data %>% add_fitted(g3) %>%
  ggplot(aes(decimal_date, .value)) + 
  geom_line(color = "blue", size = 2) +
  geom_point(aes(y= co2_avg), data = co2) + my_theme + xlim(2017, 2022)
```

<img src="120-gam-loess_files/figure-html/unnamed-chunk-9-1.png" width="672" />

If you want confidence intervals on the fitted values, use the `confint` function together with the name of the smooth you are extracting.  Be aware that this function does not include the intercept (or grand mean) from the model, so the values are all centred on zero.


```r
confint(g1, "s(year_fraction)", level = 0.95) %>% kable() %>%  scroll_box(height = "200px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:200px; "><table>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> smooth </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> by_variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> year_fraction </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> est </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> se </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> crit </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> lower </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> upper </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0417000 </td>
   <td style="text-align:right;"> -0.7504062 </td>
   <td style="text-align:right;"> 0.0911643 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.9290849 </td>
   <td style="text-align:right;"> -0.5717275 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0463060 </td>
   <td style="text-align:right;"> -0.7162744 </td>
   <td style="text-align:right;"> 0.0858056 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.8844503 </td>
   <td style="text-align:right;"> -0.5480985 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0509121 </td>
   <td style="text-align:right;"> -0.6821033 </td>
   <td style="text-align:right;"> 0.0810032 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.8408666 </td>
   <td style="text-align:right;"> -0.5233401 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0555181 </td>
   <td style="text-align:right;"> -0.6478537 </td>
   <td style="text-align:right;"> 0.0768560 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.7984886 </td>
   <td style="text-align:right;"> -0.4972188 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0601241 </td>
   <td style="text-align:right;"> -0.6134862 </td>
   <td style="text-align:right;"> 0.0734532 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.7574518 </td>
   <td style="text-align:right;"> -0.4695205 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0647302 </td>
   <td style="text-align:right;"> -0.5789615 </td>
   <td style="text-align:right;"> 0.0708632 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.7178509 </td>
   <td style="text-align:right;"> -0.4400722 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0693362 </td>
   <td style="text-align:right;"> -0.5442405 </td>
   <td style="text-align:right;"> 0.0691214 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.6797160 </td>
   <td style="text-align:right;"> -0.4087649 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0739422 </td>
   <td style="text-align:right;"> -0.5092837 </td>
   <td style="text-align:right;"> 0.0682211 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.6429946 </td>
   <td style="text-align:right;"> -0.3755729 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0785482 </td>
   <td style="text-align:right;"> -0.4740520 </td>
   <td style="text-align:right;"> 0.0681097 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.6075445 </td>
   <td style="text-align:right;"> -0.3405594 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0831543 </td>
   <td style="text-align:right;"> -0.4385060 </td>
   <td style="text-align:right;"> 0.0686939 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.5731435 </td>
   <td style="text-align:right;"> -0.3038685 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0877603 </td>
   <td style="text-align:right;"> -0.4026064 </td>
   <td style="text-align:right;"> 0.0698502 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.5395102 </td>
   <td style="text-align:right;"> -0.2657026 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0923663 </td>
   <td style="text-align:right;"> -0.3663140 </td>
   <td style="text-align:right;"> 0.0714390 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.5063319 </td>
   <td style="text-align:right;"> -0.2262961 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.0969724 </td>
   <td style="text-align:right;"> -0.3295895 </td>
   <td style="text-align:right;"> 0.0733172 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.4732886 </td>
   <td style="text-align:right;"> -0.1858904 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1015784 </td>
   <td style="text-align:right;"> -0.2923936 </td>
   <td style="text-align:right;"> 0.0753476 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.4400721 </td>
   <td style="text-align:right;"> -0.1447150 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1061844 </td>
   <td style="text-align:right;"> -0.2546870 </td>
   <td style="text-align:right;"> 0.0774045 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.4063970 </td>
   <td style="text-align:right;"> -0.1029770 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1107905 </td>
   <td style="text-align:right;"> -0.2164304 </td>
   <td style="text-align:right;"> 0.0793762 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.3720049 </td>
   <td style="text-align:right;"> -0.0608559 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1153965 </td>
   <td style="text-align:right;"> -0.1775846 </td>
   <td style="text-align:right;"> 0.0811657 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.3366665 </td>
   <td style="text-align:right;"> -0.0185027 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1200025 </td>
   <td style="text-align:right;"> -0.1381102 </td>
   <td style="text-align:right;"> 0.0826900 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.3001797 </td>
   <td style="text-align:right;"> 0.0239592 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1246085 </td>
   <td style="text-align:right;"> -0.0979681 </td>
   <td style="text-align:right;"> 0.0838795 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.2623688 </td>
   <td style="text-align:right;"> 0.0664327 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1292146 </td>
   <td style="text-align:right;"> -0.0571188 </td>
   <td style="text-align:right;"> 0.0846774 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.2230834 </td>
   <td style="text-align:right;"> 0.1088458 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1338206 </td>
   <td style="text-align:right;"> -0.0155231 </td>
   <td style="text-align:right;"> 0.0850398 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.1821981 </td>
   <td style="text-align:right;"> 0.1511518 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1384266 </td>
   <td style="text-align:right;"> 0.0268582 </td>
   <td style="text-align:right;"> 0.0849363 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.1396139 </td>
   <td style="text-align:right;"> 0.1933303 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1430327 </td>
   <td style="text-align:right;"> 0.0700645 </td>
   <td style="text-align:right;"> 0.0843518 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.0952620 </td>
   <td style="text-align:right;"> 0.2353909 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1476387 </td>
   <td style="text-align:right;"> 0.1141377 </td>
   <td style="text-align:right;"> 0.0832991 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.0491256 </td>
   <td style="text-align:right;"> 0.2774010 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1522447 </td>
   <td style="text-align:right;"> 0.1591349 </td>
   <td style="text-align:right;"> 0.0818624 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.0013124 </td>
   <td style="text-align:right;"> 0.3195822 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1568508 </td>
   <td style="text-align:right;"> 0.2051180 </td>
   <td style="text-align:right;"> 0.0801551 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.0480169 </td>
   <td style="text-align:right;"> 0.3622191 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1614568 </td>
   <td style="text-align:right;"> 0.2521491 </td>
   <td style="text-align:right;"> 0.0782995 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.0986849 </td>
   <td style="text-align:right;"> 0.4056132 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1660628 </td>
   <td style="text-align:right;"> 0.3002902 </td>
   <td style="text-align:right;"> 0.0764232 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.1505034 </td>
   <td style="text-align:right;"> 0.4500769 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1706688 </td>
   <td style="text-align:right;"> 0.3496033 </td>
   <td style="text-align:right;"> 0.0746556 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.2032810 </td>
   <td style="text-align:right;"> 0.4959256 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1752749 </td>
   <td style="text-align:right;"> 0.4001506 </td>
   <td style="text-align:right;"> 0.0731215 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.2568350 </td>
   <td style="text-align:right;"> 0.5434661 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1798809 </td>
   <td style="text-align:right;"> 0.4519940 </td>
   <td style="text-align:right;"> 0.0719334 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.3110071 </td>
   <td style="text-align:right;"> 0.5929809 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1844869 </td>
   <td style="text-align:right;"> 0.5051955 </td>
   <td style="text-align:right;"> 0.0711820 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.3656813 </td>
   <td style="text-align:right;"> 0.6447098 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1890930 </td>
   <td style="text-align:right;"> 0.5598173 </td>
   <td style="text-align:right;"> 0.0709273 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.4208023 </td>
   <td style="text-align:right;"> 0.6988322 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1936990 </td>
   <td style="text-align:right;"> 0.6159213 </td>
   <td style="text-align:right;"> 0.0711913 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.4763889 </td>
   <td style="text-align:right;"> 0.7554537 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.1983050 </td>
   <td style="text-align:right;"> 0.6735696 </td>
   <td style="text-align:right;"> 0.0719558 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.5325388 </td>
   <td style="text-align:right;"> 0.8146003 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2029111 </td>
   <td style="text-align:right;"> 0.7328242 </td>
   <td style="text-align:right;"> 0.0731645 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.5894244 </td>
   <td style="text-align:right;"> 0.8762239 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2075171 </td>
   <td style="text-align:right;"> 0.7937471 </td>
   <td style="text-align:right;"> 0.0747300 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.6472790 </td>
   <td style="text-align:right;"> 0.9402152 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2121231 </td>
   <td style="text-align:right;"> 0.8564004 </td>
   <td style="text-align:right;"> 0.0765431 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.7063787 </td>
   <td style="text-align:right;"> 1.0064222 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2167291 </td>
   <td style="text-align:right;"> 0.9208462 </td>
   <td style="text-align:right;"> 0.0784822 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.7670239 </td>
   <td style="text-align:right;"> 1.0746685 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2213352 </td>
   <td style="text-align:right;"> 0.9871464 </td>
   <td style="text-align:right;"> 0.0804214 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.8295234 </td>
   <td style="text-align:right;"> 1.1447694 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2259412 </td>
   <td style="text-align:right;"> 1.0553631 </td>
   <td style="text-align:right;"> 0.0822369 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.8941819 </td>
   <td style="text-align:right;"> 1.2165444 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2305472 </td>
   <td style="text-align:right;"> 1.1255584 </td>
   <td style="text-align:right;"> 0.0838113 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.9612912 </td>
   <td style="text-align:right;"> 1.2898256 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2351533 </td>
   <td style="text-align:right;"> 1.1977942 </td>
   <td style="text-align:right;"> 0.0850372 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.0311244 </td>
   <td style="text-align:right;"> 1.3644640 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2397593 </td>
   <td style="text-align:right;"> 1.2721327 </td>
   <td style="text-align:right;"> 0.0858192 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.1039302 </td>
   <td style="text-align:right;"> 1.4403352 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2443653 </td>
   <td style="text-align:right;"> 1.3486358 </td>
   <td style="text-align:right;"> 0.0860772 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.1799275 </td>
   <td style="text-align:right;"> 1.5173440 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2489714 </td>
   <td style="text-align:right;"> 1.4273300 </td>
   <td style="text-align:right;"> 0.0857595 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.2592444 </td>
   <td style="text-align:right;"> 1.5954155 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2535774 </td>
   <td style="text-align:right;"> 1.5079637 </td>
   <td style="text-align:right;"> 0.0849111 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.3415409 </td>
   <td style="text-align:right;"> 1.6743864 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2581834 </td>
   <td style="text-align:right;"> 1.5901544 </td>
   <td style="text-align:right;"> 0.0836310 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.4262406 </td>
   <td style="text-align:right;"> 1.7540681 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2627894 </td>
   <td style="text-align:right;"> 1.6735188 </td>
   <td style="text-align:right;"> 0.0820324 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.5127382 </td>
   <td style="text-align:right;"> 1.8342994 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2673955 </td>
   <td style="text-align:right;"> 1.7576738 </td>
   <td style="text-align:right;"> 0.0802399 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.6004064 </td>
   <td style="text-align:right;"> 1.9149412 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2720015 </td>
   <td style="text-align:right;"> 1.8422362 </td>
   <td style="text-align:right;"> 0.0783857 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.6886031 </td>
   <td style="text-align:right;"> 1.9958692 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2766075 </td>
   <td style="text-align:right;"> 1.9268225 </td>
   <td style="text-align:right;"> 0.0766047 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.7766800 </td>
   <td style="text-align:right;"> 2.0769650 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2812136 </td>
   <td style="text-align:right;"> 2.0110497 </td>
   <td style="text-align:right;"> 0.0750289 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.8639958 </td>
   <td style="text-align:right;"> 2.1581037 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2858196 </td>
   <td style="text-align:right;"> 2.0945345 </td>
   <td style="text-align:right;"> 0.0737781 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.9499320 </td>
   <td style="text-align:right;"> 2.2391370 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2904256 </td>
   <td style="text-align:right;"> 2.1768937 </td>
   <td style="text-align:right;"> 0.0729507 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.0339128 </td>
   <td style="text-align:right;"> 2.3198745 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2950317 </td>
   <td style="text-align:right;"> 2.2577439 </td>
   <td style="text-align:right;"> 0.0726133 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.1154244 </td>
   <td style="text-align:right;"> 2.4000634 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.2996377 </td>
   <td style="text-align:right;"> 2.3367020 </td>
   <td style="text-align:right;"> 0.0727931 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.1940301 </td>
   <td style="text-align:right;"> 2.4793739 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3042437 </td>
   <td style="text-align:right;"> 2.4133848 </td>
   <td style="text-align:right;"> 0.0734745 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.2693774 </td>
   <td style="text-align:right;"> 2.5573922 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3088497 </td>
   <td style="text-align:right;"> 2.4874090 </td>
   <td style="text-align:right;"> 0.0746011 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.3411936 </td>
   <td style="text-align:right;"> 2.6336244 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3134558 </td>
   <td style="text-align:right;"> 2.5583913 </td>
   <td style="text-align:right;"> 0.0760825 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.4092725 </td>
   <td style="text-align:right;"> 2.7075102 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3180618 </td>
   <td style="text-align:right;"> 2.6259486 </td>
   <td style="text-align:right;"> 0.0778040 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.4734555 </td>
   <td style="text-align:right;"> 2.7784417 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3226678 </td>
   <td style="text-align:right;"> 2.6896975 </td>
   <td style="text-align:right;"> 0.0796371 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.5336118 </td>
   <td style="text-align:right;"> 2.8457833 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3272739 </td>
   <td style="text-align:right;"> 2.7492550 </td>
   <td style="text-align:right;"> 0.0814477 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.5896204 </td>
   <td style="text-align:right;"> 2.9088895 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3318799 </td>
   <td style="text-align:right;"> 2.8042376 </td>
   <td style="text-align:right;"> 0.0831041 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.6413566 </td>
   <td style="text-align:right;"> 2.9671186 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3364859 </td>
   <td style="text-align:right;"> 2.8542622 </td>
   <td style="text-align:right;"> 0.0844814 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.6886817 </td>
   <td style="text-align:right;"> 3.0198427 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3410920 </td>
   <td style="text-align:right;"> 2.8989455 </td>
   <td style="text-align:right;"> 0.0854659 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.7314354 </td>
   <td style="text-align:right;"> 3.0664557 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3456980 </td>
   <td style="text-align:right;"> 2.9379044 </td>
   <td style="text-align:right;"> 0.0859585 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.7694288 </td>
   <td style="text-align:right;"> 3.1063800 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3503040 </td>
   <td style="text-align:right;"> 2.9707810 </td>
   <td style="text-align:right;"> 0.0858845 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.8024505 </td>
   <td style="text-align:right;"> 3.1391114 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3549101 </td>
   <td style="text-align:right;"> 2.9975136 </td>
   <td style="text-align:right;"> 0.0852632 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.8304007 </td>
   <td style="text-align:right;"> 3.1646265 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3595161 </td>
   <td style="text-align:right;"> 3.0182316 </td>
   <td style="text-align:right;"> 0.0841816 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.8532388 </td>
   <td style="text-align:right;"> 3.1832245 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3641221 </td>
   <td style="text-align:right;"> 3.0330676 </td>
   <td style="text-align:right;"> 0.0827435 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.8708933 </td>
   <td style="text-align:right;"> 3.1952418 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3687281 </td>
   <td style="text-align:right;"> 3.0421539 </td>
   <td style="text-align:right;"> 0.0810659 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.8832676 </td>
   <td style="text-align:right;"> 3.2010401 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3733342 </td>
   <td style="text-align:right;"> 3.0456231 </td>
   <td style="text-align:right;"> 0.0792748 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.8902473 </td>
   <td style="text-align:right;"> 3.2009988 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3779402 </td>
   <td style="text-align:right;"> 3.0436077 </td>
   <td style="text-align:right;"> 0.0775011 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.8917084 </td>
   <td style="text-align:right;"> 3.1955071 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3825462 </td>
   <td style="text-align:right;"> 3.0362403 </td>
   <td style="text-align:right;"> 0.0758747 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.8875286 </td>
   <td style="text-align:right;"> 3.1849521 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3871523 </td>
   <td style="text-align:right;"> 3.0236534 </td>
   <td style="text-align:right;"> 0.0745173 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.8776022 </td>
   <td style="text-align:right;"> 3.1697045 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3917583 </td>
   <td style="text-align:right;"> 3.0059794 </td>
   <td style="text-align:right;"> 0.0735325 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.8618583 </td>
   <td style="text-align:right;"> 3.1501005 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.3963643 </td>
   <td style="text-align:right;"> 2.9833509 </td>
   <td style="text-align:right;"> 0.0729971 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.8402792 </td>
   <td style="text-align:right;"> 3.1264225 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4009704 </td>
   <td style="text-align:right;"> 2.9559004 </td>
   <td style="text-align:right;"> 0.0729517 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.8129177 </td>
   <td style="text-align:right;"> 3.0988830 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4055764 </td>
   <td style="text-align:right;"> 2.9237603 </td>
   <td style="text-align:right;"> 0.0733964 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.7799061 </td>
   <td style="text-align:right;"> 3.0676146 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4101824 </td>
   <td style="text-align:right;"> 2.8870633 </td>
   <td style="text-align:right;"> 0.0742905 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.7414567 </td>
   <td style="text-align:right;"> 3.0326700 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4147884 </td>
   <td style="text-align:right;"> 2.8459419 </td>
   <td style="text-align:right;"> 0.0755574 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.6978521 </td>
   <td style="text-align:right;"> 2.9940316 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4193945 </td>
   <td style="text-align:right;"> 2.8005284 </td>
   <td style="text-align:right;"> 0.0770931 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.6494288 </td>
   <td style="text-align:right;"> 2.9516281 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4240005 </td>
   <td style="text-align:right;"> 2.7509556 </td>
   <td style="text-align:right;"> 0.0787759 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.5965576 </td>
   <td style="text-align:right;"> 2.9053535 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4286065 </td>
   <td style="text-align:right;"> 2.6973558 </td>
   <td style="text-align:right;"> 0.0804760 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.5396258 </td>
   <td style="text-align:right;"> 2.8550857 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4332126 </td>
   <td style="text-align:right;"> 2.6398615 </td>
   <td style="text-align:right;"> 0.0820626 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.4790217 </td>
   <td style="text-align:right;"> 2.8007013 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4378186 </td>
   <td style="text-align:right;"> 2.5786054 </td>
   <td style="text-align:right;"> 0.0834106 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.4151236 </td>
   <td style="text-align:right;"> 2.7420872 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4424246 </td>
   <td style="text-align:right;"> 2.5137199 </td>
   <td style="text-align:right;"> 0.0844044 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.3482902 </td>
   <td style="text-align:right;"> 2.6791495 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4470307 </td>
   <td style="text-align:right;"> 2.4453374 </td>
   <td style="text-align:right;"> 0.0849424 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.2788533 </td>
   <td style="text-align:right;"> 2.6118216 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4516367 </td>
   <td style="text-align:right;"> 2.3735903 </td>
   <td style="text-align:right;"> 0.0849444 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.2071024 </td>
   <td style="text-align:right;"> 2.5400783 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4562427 </td>
   <td style="text-align:right;"> 2.2986049 </td>
   <td style="text-align:right;"> 0.0844157 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.1331531 </td>
   <td style="text-align:right;"> 2.4640567 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4608487 </td>
   <td style="text-align:right;"> 2.2205026 </td>
   <td style="text-align:right;"> 0.0834376 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 2.0569679 </td>
   <td style="text-align:right;"> 2.3840372 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4654548 </td>
   <td style="text-align:right;"> 2.1394047 </td>
   <td style="text-align:right;"> 0.0821100 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.9784720 </td>
   <td style="text-align:right;"> 2.3003374 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4700608 </td>
   <td style="text-align:right;"> 2.0554325 </td>
   <td style="text-align:right;"> 0.0805465 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.8975644 </td>
   <td style="text-align:right;"> 2.2133007 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4746668 </td>
   <td style="text-align:right;"> 1.9687074 </td>
   <td style="text-align:right;"> 0.0788695 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.8141261 </td>
   <td style="text-align:right;"> 2.1232887 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4792729 </td>
   <td style="text-align:right;"> 1.8793506 </td>
   <td style="text-align:right;"> 0.0772064 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.7280288 </td>
   <td style="text-align:right;"> 2.0306724 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4838789 </td>
   <td style="text-align:right;"> 1.7874834 </td>
   <td style="text-align:right;"> 0.0756838 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.6391458 </td>
   <td style="text-align:right;"> 1.9358210 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4884849 </td>
   <td style="text-align:right;"> 1.6932271 </td>
   <td style="text-align:right;"> 0.0744196 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.5473674 </td>
   <td style="text-align:right;"> 1.8390869 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4930910 </td>
   <td style="text-align:right;"> 1.5967031 </td>
   <td style="text-align:right;"> 0.0735144 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.4526175 </td>
   <td style="text-align:right;"> 1.7407886 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.4976970 </td>
   <td style="text-align:right;"> 1.4980325 </td>
   <td style="text-align:right;"> 0.0730422 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.3548725 </td>
   <td style="text-align:right;"> 1.6411925 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5023030 </td>
   <td style="text-align:right;"> 1.3973368 </td>
   <td style="text-align:right;"> 0.0730422 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.2541766 </td>
   <td style="text-align:right;"> 1.5404969 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5069090 </td>
   <td style="text-align:right;"> 1.2947372 </td>
   <td style="text-align:right;"> 0.0735146 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.1506512 </td>
   <td style="text-align:right;"> 1.4388231 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5115151 </td>
   <td style="text-align:right;"> 1.1903549 </td>
   <td style="text-align:right;"> 0.0744199 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 1.0444946 </td>
   <td style="text-align:right;"> 1.3362153 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5161211 </td>
   <td style="text-align:right;"> 1.0843114 </td>
   <td style="text-align:right;"> 0.0756842 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.9359731 </td>
   <td style="text-align:right;"> 1.2326497 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5207271 </td>
   <td style="text-align:right;"> 0.9767279 </td>
   <td style="text-align:right;"> 0.0772069 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.8254052 </td>
   <td style="text-align:right;"> 1.1280506 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5253332 </td>
   <td style="text-align:right;"> 0.8677257 </td>
   <td style="text-align:right;"> 0.0788699 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.7131435 </td>
   <td style="text-align:right;"> 1.0223079 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5299392 </td>
   <td style="text-align:right;"> 0.7574261 </td>
   <td style="text-align:right;"> 0.0805469 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.5995570 </td>
   <td style="text-align:right;"> 0.9152952 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5345452 </td>
   <td style="text-align:right;"> 0.6459504 </td>
   <td style="text-align:right;"> 0.0821105 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.4850167 </td>
   <td style="text-align:right;"> 0.8068840 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5391513 </td>
   <td style="text-align:right;"> 0.5334198 </td>
   <td style="text-align:right;"> 0.0834380 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.3698844 </td>
   <td style="text-align:right;"> 0.6969553 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5437573 </td>
   <td style="text-align:right;"> 0.4199558 </td>
   <td style="text-align:right;"> 0.0844161 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.2545033 </td>
   <td style="text-align:right;"> 0.5854083 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5483633 </td>
   <td style="text-align:right;"> 0.3056796 </td>
   <td style="text-align:right;"> 0.0849446 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.1391911 </td>
   <td style="text-align:right;"> 0.4721680 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5529693 </td>
   <td style="text-align:right;"> 0.1907130 </td>
   <td style="text-align:right;"> 0.0849426 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.0242286 </td>
   <td style="text-align:right;"> 0.3571974 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5575754 </td>
   <td style="text-align:right;"> 0.0751960 </td>
   <td style="text-align:right;"> 0.0844045 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.0902337 </td>
   <td style="text-align:right;"> 0.2406258 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5621814 </td>
   <td style="text-align:right;"> -0.0407101 </td>
   <td style="text-align:right;"> 0.0834106 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.2041918 </td>
   <td style="text-align:right;"> 0.1227716 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5667874 </td>
   <td style="text-align:right;"> -0.1568430 </td>
   <td style="text-align:right;"> 0.0820625 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.3176826 </td>
   <td style="text-align:right;"> 0.0039967 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5713935 </td>
   <td style="text-align:right;"> -0.2730401 </td>
   <td style="text-align:right;"> 0.0804759 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.4307699 </td>
   <td style="text-align:right;"> -0.1153103 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5759995 </td>
   <td style="text-align:right;"> -0.3891390 </td>
   <td style="text-align:right;"> 0.0787759 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.5435369 </td>
   <td style="text-align:right;"> -0.2347412 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5806055 </td>
   <td style="text-align:right;"> -0.5049773 </td>
   <td style="text-align:right;"> 0.0770931 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.6560770 </td>
   <td style="text-align:right;"> -0.3538776 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5852116 </td>
   <td style="text-align:right;"> -0.6203925 </td>
   <td style="text-align:right;"> 0.0755576 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.7684827 </td>
   <td style="text-align:right;"> -0.4723024 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5898176 </td>
   <td style="text-align:right;"> -0.7352222 </td>
   <td style="text-align:right;"> 0.0742909 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.8808297 </td>
   <td style="text-align:right;"> -0.5896147 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5944236 </td>
   <td style="text-align:right;"> -0.8493039 </td>
   <td style="text-align:right;"> 0.0733971 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.9931595 </td>
   <td style="text-align:right;"> -0.7054483 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.5990296 </td>
   <td style="text-align:right;"> -0.9624751 </td>
   <td style="text-align:right;"> 0.0729527 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.1054597 </td>
   <td style="text-align:right;"> -0.8194905 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6036357 </td>
   <td style="text-align:right;"> -1.0745735 </td>
   <td style="text-align:right;"> 0.0729984 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.2176477 </td>
   <td style="text-align:right;"> -0.9314992 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6082417 </td>
   <td style="text-align:right;"> -1.1854364 </td>
   <td style="text-align:right;"> 0.0735342 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.3295608 </td>
   <td style="text-align:right;"> -1.0413121 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6128477 </td>
   <td style="text-align:right;"> -1.2949016 </td>
   <td style="text-align:right;"> 0.0745192 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.4409565 </td>
   <td style="text-align:right;"> -1.1488467 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6174538 </td>
   <td style="text-align:right;"> -1.4028066 </td>
   <td style="text-align:right;"> 0.0758769 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.5515225 </td>
   <td style="text-align:right;"> -1.2540906 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6220598 </td>
   <td style="text-align:right;"> -1.5089888 </td>
   <td style="text-align:right;"> 0.0775034 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.6608926 </td>
   <td style="text-align:right;"> -1.3570850 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6266658 </td>
   <td style="text-align:right;"> -1.6132859 </td>
   <td style="text-align:right;"> 0.0792771 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.7686662 </td>
   <td style="text-align:right;"> -1.4579056 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6312719 </td>
   <td style="text-align:right;"> -1.7155353 </td>
   <td style="text-align:right;"> 0.0810682 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.8744261 </td>
   <td style="text-align:right;"> -1.5566446 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6358779 </td>
   <td style="text-align:right;"> -1.8155748 </td>
   <td style="text-align:right;"> 0.0827457 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.9777533 </td>
   <td style="text-align:right;"> -1.6533962 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6404839 </td>
   <td style="text-align:right;"> -1.9132417 </td>
   <td style="text-align:right;"> 0.0841835 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.0782384 </td>
   <td style="text-align:right;"> -1.7482449 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6450899 </td>
   <td style="text-align:right;"> -2.0083736 </td>
   <td style="text-align:right;"> 0.0852649 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.1754898 </td>
   <td style="text-align:right;"> -1.8412574 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6496960 </td>
   <td style="text-align:right;"> -2.1008081 </td>
   <td style="text-align:right;"> 0.0858858 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.2691412 </td>
   <td style="text-align:right;"> -1.9324750 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6543020 </td>
   <td style="text-align:right;"> -2.1903826 </td>
   <td style="text-align:right;"> 0.0859595 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.3588600 </td>
   <td style="text-align:right;"> -2.0219052 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6589080 </td>
   <td style="text-align:right;"> -2.2769242 </td>
   <td style="text-align:right;"> 0.0854665 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.4444355 </td>
   <td style="text-align:right;"> -2.1094129 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6635141 </td>
   <td style="text-align:right;"> -2.3602442 </td>
   <td style="text-align:right;"> 0.0844816 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.5258252 </td>
   <td style="text-align:right;"> -2.1946632 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6681201 </td>
   <td style="text-align:right;"> -2.4401525 </td>
   <td style="text-align:right;"> 0.0831041 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.6030336 </td>
   <td style="text-align:right;"> -2.2772714 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6727261 </td>
   <td style="text-align:right;"> -2.5164591 </td>
   <td style="text-align:right;"> 0.0814477 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.6760936 </td>
   <td style="text-align:right;"> -2.3568245 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6773322 </td>
   <td style="text-align:right;"> -2.5889738 </td>
   <td style="text-align:right;"> 0.0796372 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.7450599 </td>
   <td style="text-align:right;"> -2.4328877 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6819382 </td>
   <td style="text-align:right;"> -2.6575066 </td>
   <td style="text-align:right;"> 0.0778046 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.8100008 </td>
   <td style="text-align:right;"> -2.5050124 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6865442 </td>
   <td style="text-align:right;"> -2.7218674 </td>
   <td style="text-align:right;"> 0.0760837 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.8709887 </td>
   <td style="text-align:right;"> -2.5727460 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6911503 </td>
   <td style="text-align:right;"> -2.7818661 </td>
   <td style="text-align:right;"> 0.0746033 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.9280859 </td>
   <td style="text-align:right;"> -2.6356464 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.6957563 </td>
   <td style="text-align:right;"> -2.8373127 </td>
   <td style="text-align:right;"> 0.0734779 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.9813267 </td>
   <td style="text-align:right;"> -2.6932986 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7003623 </td>
   <td style="text-align:right;"> -2.8880170 </td>
   <td style="text-align:right;"> 0.0727979 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.0306982 </td>
   <td style="text-align:right;"> -2.7453359 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7049683 </td>
   <td style="text-align:right;"> -2.9337891 </td>
   <td style="text-align:right;"> 0.0726195 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.0761206 </td>
   <td style="text-align:right;"> -2.7914576 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7095744 </td>
   <td style="text-align:right;"> -2.9744387 </td>
   <td style="text-align:right;"> 0.0729582 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.1174342 </td>
   <td style="text-align:right;"> -2.8314433 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7141804 </td>
   <td style="text-align:right;"> -3.0097759 </td>
   <td style="text-align:right;"> 0.0737867 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.1543953 </td>
   <td style="text-align:right;"> -2.8651566 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7187864 </td>
   <td style="text-align:right;"> -3.0396106 </td>
   <td style="text-align:right;"> 0.0750383 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.1866830 </td>
   <td style="text-align:right;"> -2.8925382 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7233925 </td>
   <td style="text-align:right;"> -3.0637526 </td>
   <td style="text-align:right;"> 0.0766146 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.2139146 </td>
   <td style="text-align:right;"> -2.9135907 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7279985 </td>
   <td style="text-align:right;"> -3.0820120 </td>
   <td style="text-align:right;"> 0.0783956 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.2356646 </td>
   <td style="text-align:right;"> -2.9283594 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7326045 </td>
   <td style="text-align:right;"> -3.0941986 </td>
   <td style="text-align:right;"> 0.0802496 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.2514848 </td>
   <td style="text-align:right;"> -2.9369123 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7372106 </td>
   <td style="text-align:right;"> -3.1001223 </td>
   <td style="text-align:right;"> 0.0820412 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.2609202 </td>
   <td style="text-align:right;"> -2.9393244 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7418166 </td>
   <td style="text-align:right;"> -3.0995931 </td>
   <td style="text-align:right;"> 0.0836386 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.2635218 </td>
   <td style="text-align:right;"> -2.9356643 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7464226 </td>
   <td style="text-align:right;"> -3.0924208 </td>
   <td style="text-align:right;"> 0.0849173 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.2588557 </td>
   <td style="text-align:right;"> -2.9259860 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7510286 </td>
   <td style="text-align:right;"> -3.0784155 </td>
   <td style="text-align:right;"> 0.0857640 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.2465098 </td>
   <td style="text-align:right;"> -2.9103212 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7556347 </td>
   <td style="text-align:right;"> -3.0573880 </td>
   <td style="text-align:right;"> 0.0860800 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.2261017 </td>
   <td style="text-align:right;"> -2.8886744 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7602407 </td>
   <td style="text-align:right;"> -3.0293129 </td>
   <td style="text-align:right;"> 0.0858204 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.1975178 </td>
   <td style="text-align:right;"> -2.8611079 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7648467 </td>
   <td style="text-align:right;"> -2.9945125 </td>
   <td style="text-align:right;"> 0.0850374 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.1611827 </td>
   <td style="text-align:right;"> -2.8278422 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7694528 </td>
   <td style="text-align:right;"> -2.9533538 </td>
   <td style="text-align:right;"> 0.0838114 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.1176211 </td>
   <td style="text-align:right;"> -2.7890865 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7740588 </td>
   <td style="text-align:right;"> -2.9062038 </td>
   <td style="text-align:right;"> 0.0822379 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.0673870 </td>
   <td style="text-align:right;"> -2.7450205 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7786648 </td>
   <td style="text-align:right;"> -2.8534294 </td>
   <td style="text-align:right;"> 0.0804247 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -3.0110589 </td>
   <td style="text-align:right;"> -2.6957998 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7832709 </td>
   <td style="text-align:right;"> -2.7953975 </td>
   <td style="text-align:right;"> 0.0784894 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.9492338 </td>
   <td style="text-align:right;"> -2.6415611 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7878769 </td>
   <td style="text-align:right;"> -2.7324750 </td>
   <td style="text-align:right;"> 0.0765558 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.8825215 </td>
   <td style="text-align:right;"> -2.5824284 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7924829 </td>
   <td style="text-align:right;"> -2.6650289 </td>
   <td style="text-align:right;"> 0.0747497 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.8115356 </td>
   <td style="text-align:right;"> -2.5185223 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.7970889 </td>
   <td style="text-align:right;"> -2.5934262 </td>
   <td style="text-align:right;"> 0.0731924 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.7368807 </td>
   <td style="text-align:right;"> -2.4499717 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8016950 </td>
   <td style="text-align:right;"> -2.5180337 </td>
   <td style="text-align:right;"> 0.0719928 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.6591369 </td>
   <td style="text-align:right;"> -2.3769304 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8063010 </td>
   <td style="text-align:right;"> -2.4392184 </td>
   <td style="text-align:right;"> 0.0712375 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.5788412 </td>
   <td style="text-align:right;"> -2.2995955 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8109070 </td>
   <td style="text-align:right;"> -2.3573472 </td>
   <td style="text-align:right;"> 0.0709819 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.4964691 </td>
   <td style="text-align:right;"> -2.2182253 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8155131 </td>
   <td style="text-align:right;"> -2.2727871 </td>
   <td style="text-align:right;"> 0.0712435 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.4124217 </td>
   <td style="text-align:right;"> -2.1331524 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8201191 </td>
   <td style="text-align:right;"> -2.1859049 </td>
   <td style="text-align:right;"> 0.0719994 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.3270212 </td>
   <td style="text-align:right;"> -2.0447886 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8247251 </td>
   <td style="text-align:right;"> -2.0970677 </td>
   <td style="text-align:right;"> 0.0731893 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.2405162 </td>
   <td style="text-align:right;"> -1.9536192 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8293312 </td>
   <td style="text-align:right;"> -2.0066423 </td>
   <td style="text-align:right;"> 0.0747221 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.1530950 </td>
   <td style="text-align:right;"> -1.8601897 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8339372 </td>
   <td style="text-align:right;"> -1.9149958 </td>
   <td style="text-align:right;"> 0.0764853 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -2.0649042 </td>
   <td style="text-align:right;"> -1.7650873 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8385432 </td>
   <td style="text-align:right;"> -1.8224949 </td>
   <td style="text-align:right;"> 0.0783544 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.9760666 </td>
   <td style="text-align:right;"> -1.6689232 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8431492 </td>
   <td style="text-align:right;"> -1.7295067 </td>
   <td style="text-align:right;"> 0.0802005 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.8866967 </td>
   <td style="text-align:right;"> -1.5723167 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8477553 </td>
   <td style="text-align:right;"> -1.6363981 </td>
   <td style="text-align:right;"> 0.0818966 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.7969125 </td>
   <td style="text-align:right;"> -1.4758838 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8523613 </td>
   <td style="text-align:right;"> -1.5435361 </td>
   <td style="text-align:right;"> 0.0833217 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.7068435 </td>
   <td style="text-align:right;"> -1.3802286 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8569673 </td>
   <td style="text-align:right;"> -1.4512874 </td>
   <td style="text-align:right;"> 0.0843634 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.6166366 </td>
   <td style="text-align:right;"> -1.2859381 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8615734 </td>
   <td style="text-align:right;"> -1.3599274 </td>
   <td style="text-align:right;"> 0.0849396 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.5264060 </td>
   <td style="text-align:right;"> -1.1934488 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8661794 </td>
   <td style="text-align:right;"> -1.2694627 </td>
   <td style="text-align:right;"> 0.0850398 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.4361376 </td>
   <td style="text-align:right;"> -1.1027877 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8707854 </td>
   <td style="text-align:right;"> -1.1798505 </td>
   <td style="text-align:right;"> 0.0846819 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.3458239 </td>
   <td style="text-align:right;"> -1.0138771 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8753915 </td>
   <td style="text-align:right;"> -1.0910483 </td>
   <td style="text-align:right;"> 0.0838995 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.2554883 </td>
   <td style="text-align:right;"> -0.9266084 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8799975 </td>
   <td style="text-align:right;"> -1.0030134 </td>
   <td style="text-align:right;"> 0.0827403 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.1651815 </td>
   <td style="text-align:right;"> -0.8408454 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8846035 </td>
   <td style="text-align:right;"> -0.9157033 </td>
   <td style="text-align:right;"> 0.0812655 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -1.0749807 </td>
   <td style="text-align:right;"> -0.7564259 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8892095 </td>
   <td style="text-align:right;"> -0.8290752 </td>
   <td style="text-align:right;"> 0.0795495 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.9849894 </td>
   <td style="text-align:right;"> -0.6731610 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8938156 </td>
   <td style="text-align:right;"> -0.7430866 </td>
   <td style="text-align:right;"> 0.0776811 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.8953386 </td>
   <td style="text-align:right;"> -0.5908345 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.8984216 </td>
   <td style="text-align:right;"> -0.6576947 </td>
   <td style="text-align:right;"> 0.0757629 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.8061873 </td>
   <td style="text-align:right;"> -0.5092021 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9030276 </td>
   <td style="text-align:right;"> -0.5728571 </td>
   <td style="text-align:right;"> 0.0739126 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.7177231 </td>
   <td style="text-align:right;"> -0.4279911 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9076337 </td>
   <td style="text-align:right;"> -0.4885310 </td>
   <td style="text-align:right;"> 0.0722605 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.6301589 </td>
   <td style="text-align:right;"> -0.3469031 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9122397 </td>
   <td style="text-align:right;"> -0.4046738 </td>
   <td style="text-align:right;"> 0.0709465 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.5437264 </td>
   <td style="text-align:right;"> -0.2656213 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9168457 </td>
   <td style="text-align:right;"> -0.3212429 </td>
   <td style="text-align:right;"> 0.0701129 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.4586617 </td>
   <td style="text-align:right;"> -0.1838242 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9214518 </td>
   <td style="text-align:right;"> -0.2381957 </td>
   <td style="text-align:right;"> 0.0698940 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.3751854 </td>
   <td style="text-align:right;"> -0.1012061 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9260578 </td>
   <td style="text-align:right;"> -0.1554896 </td>
   <td style="text-align:right;"> 0.0704027 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.2934764 </td>
   <td style="text-align:right;"> -0.0175028 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9306638 </td>
   <td style="text-align:right;"> -0.0730818 </td>
   <td style="text-align:right;"> 0.0717185 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.2136475 </td>
   <td style="text-align:right;"> 0.0674839 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9352698 </td>
   <td style="text-align:right;"> 0.0090702 </td>
   <td style="text-align:right;"> 0.0738784 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.1357289 </td>
   <td style="text-align:right;"> 0.1538693 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9398759 </td>
   <td style="text-align:right;"> 0.0910090 </td>
   <td style="text-align:right;"> 0.0768756 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> -0.0596645 </td>
   <td style="text-align:right;"> 0.2416825 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9444819 </td>
   <td style="text-align:right;"> 0.1727773 </td>
   <td style="text-align:right;"> 0.0806649 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.0146771 </td>
   <td style="text-align:right;"> 0.3308776 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9490879 </td>
   <td style="text-align:right;"> 0.2544178 </td>
   <td style="text-align:right;"> 0.0851726 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.0874825 </td>
   <td style="text-align:right;"> 0.4213531 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9536940 </td>
   <td style="text-align:right;"> 0.3359730 </td>
   <td style="text-align:right;"> 0.0903084 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.1589717 </td>
   <td style="text-align:right;"> 0.5129742 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> s(year_fraction) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0.9583000 </td>
   <td style="text-align:right;"> 0.4174855 </td>
   <td style="text-align:right;"> 0.0959747 </td>
   <td style="text-align:right;"> 1.959964 </td>
   <td style="text-align:right;"> 0.2293786 </td>
   <td style="text-align:right;"> 0.6055924 </td>
  </tr>
</tbody>
</table></div>

```r
confint(g1, "s(year_fraction)", level = 0.95) %>% 
  ggplot(aes(year_fraction)) + 
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.25) + 
  geom_line(aes(y = est)) + my_theme
```

<img src="120-gam-loess_files/figure-html/unnamed-chunk-10-1.png" width="672" />

You can also use `lm` to fit splines; these are similar to GAMs but there are some important differences. The `mgcv` package has a lot of features not available with `lm`.


```r
s1 <- lm(co2_avg ~ splines::bs(decimal_date, df = 5), data = co2)
tidy(s1) %>% kable(digits = 2)
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> term </th>
   <th style="text-align:right;"> estimate </th>
   <th style="text-align:right;"> std.error </th>
   <th style="text-align:right;"> statistic </th>
   <th style="text-align:right;"> p.value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:right;"> 391.73 </td>
   <td style="text-align:right;"> 1.13 </td>
   <td style="text-align:right;"> 347.53 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> splines::bs(decimal_date, df = 5)1 </td>
   <td style="text-align:right;"> 0.64 </td>
   <td style="text-align:right;"> 2.16 </td>
   <td style="text-align:right;"> 0.30 </td>
   <td style="text-align:right;"> 0.77 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> splines::bs(decimal_date, df = 5)2 </td>
   <td style="text-align:right;"> 6.87 </td>
   <td style="text-align:right;"> 1.47 </td>
   <td style="text-align:right;"> 4.69 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> splines::bs(decimal_date, df = 5)3 </td>
   <td style="text-align:right;"> 14.49 </td>
   <td style="text-align:right;"> 1.98 </td>
   <td style="text-align:right;"> 7.31 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> splines::bs(decimal_date, df = 5)4 </td>
   <td style="text-align:right;"> 21.01 </td>
   <td style="text-align:right;"> 1.62 </td>
   <td style="text-align:right;"> 13.01 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> splines::bs(decimal_date, df = 5)5 </td>
   <td style="text-align:right;"> 22.14 </td>
   <td style="text-align:right;"> 1.64 </td>
   <td style="text-align:right;"> 13.50 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
</tbody>
</table>

```r
glance(s1) %>% kable(digits = 2)
```

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> r.squared </th>
   <th style="text-align:right;"> adj.r.squared </th>
   <th style="text-align:right;"> sigma </th>
   <th style="text-align:right;"> statistic </th>
   <th style="text-align:right;"> p.value </th>
   <th style="text-align:right;"> df </th>
   <th style="text-align:right;"> logLik </th>
   <th style="text-align:right;"> AIC </th>
   <th style="text-align:right;"> BIC </th>
   <th style="text-align:right;"> deviance </th>
   <th style="text-align:right;"> df.residual </th>
   <th style="text-align:right;"> nobs </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 0.91 </td>
   <td style="text-align:right;"> 0.9 </td>
   <td style="text-align:right;"> 2.31 </td>
   <td style="text-align:right;"> 219.14 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> -265.4 </td>
   <td style="text-align:right;"> 544.8 </td>
   <td style="text-align:right;"> 564.26 </td>
   <td style="text-align:right;"> 602.91 </td>
   <td style="text-align:right;"> 113 </td>
   <td style="text-align:right;"> 119 </td>
  </tr>
</tbody>
</table>
We can use `augment` to generate data to plot and combine it with the original data.


```r
a1 <- augment(s1, data = co2, se_fit = TRUE, interval="prediction") 
a1 %>%  ggplot(aes(decimal_date)) + 
  geom_ribbon(aes(ymin = .lower, ymax = .upper), alpha = 0.2) + 
  geom_line(aes(y= .fitted)) +
  geom_point(aes(y = co2_avg)) + 
  my_theme
```

<img src="120-gam-loess_files/figure-html/unnamed-chunk-12-1.png" width="672" />

For a spline that closely traces the data, increase `df` to 26 or more. This increases the numbers of knots or separate cubics used to approximate the data.

## Locally Estimated Scatterplot Smoothing (LOESS)

LOESS smooths are constructed by making a large number of quadratic (or possibly linear) regression lines as a window moves along the x-axis. The degree of the fits and the width of the window (and other details) can be adjusted. The predictions from these many local regressions are then computed and plotted as a "smooth" of the data. We usually just imagine the line is drawn through the data in a way that allows it to track fluctuations without specifying a model.


```r
l1 <- loess(co2_anomaly ~ year_fraction, data = co2)
```

As with the GAMs, the `summary` function is not particularly easy to interpret and we will not explore the details, but you can see that this is a quadratic model with a "span" of 0.75, meaning that 75% of the data are used for each regression. (The weighting of each point in the regression varies as a function of x, resulting a continuous change in the predictions.)


```r
summary(l1)
```

```
## Call:
## loess(formula = co2_anomaly ~ year_fraction, data = co2)
## 
## Number of Observations: 119 
## Equivalent Number of Parameters: 4.58 
## Residual Standard Error: 0.4647 
## Trace of smoother matrix: 5  (exact)
## 
## Control settings:
##   span     :  0.75 
##   degree   :  2 
##   family   :  gaussian
##   surface  :  interpolate	  cell = 0.2
##   normalize:  TRUE
##  parametric:  FALSE
## drop.square:  FALSE
```


We can use `predict`, `residuals` and `augment` on these model objects as we did for `lm` fits in the previous lesson.


```r
augment(l1, se_fit = TRUE) %>% kable() %>%  scroll_box(height = "200px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:200px; "><table>
 <thead>
  <tr>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> co2_anomaly </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> year_fraction </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> .fitted </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> .se.fit </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> .resid </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> -0.3216667 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -1.1874816 </td>
   <td style="text-align:right;"> 0.1278142 </td>
   <td style="text-align:right;"> 0.8658149 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.2083333 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.3297748 </td>
   <td style="text-align:right;"> 0.0783764 </td>
   <td style="text-align:right;"> -0.1214414 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.9483333 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 1.4858927 </td>
   <td style="text-align:right;"> 0.0756092 </td>
   <td style="text-align:right;"> -0.5375594 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1.5983333 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.2386031 </td>
   <td style="text-align:right;"> 0.0811237 </td>
   <td style="text-align:right;"> -0.6402698 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.5383333 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.7453971 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> -0.2070637 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.0883333 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.1417191 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> -0.0533857 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.8583333 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.4302506 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> 0.4280828 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.5216667 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.5283681 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.0067014 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.5716667 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.4561226 </td>
   <td style="text-align:right;"> 0.0811840 </td>
   <td style="text-align:right;"> -0.1155441 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.6616667 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.3873488 </td>
   <td style="text-align:right;"> 0.0757368 </td>
   <td style="text-align:right;"> -0.2743178 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.3716667 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.4172800 </td>
   <td style="text-align:right;"> 0.0803002 </td>
   <td style="text-align:right;"> 0.0456133 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.2083333 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.4905675 </td>
   <td style="text-align:right;"> 0.1329762 </td>
   <td style="text-align:right;"> -0.2822341 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.7350000 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -1.1874816 </td>
   <td style="text-align:right;"> 0.1278142 </td>
   <td style="text-align:right;"> 0.4524816 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.0050000 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.3297748 </td>
   <td style="text-align:right;"> 0.0783764 </td>
   <td style="text-align:right;"> -0.3247748 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.5450000 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 1.4858927 </td>
   <td style="text-align:right;"> 0.0756092 </td>
   <td style="text-align:right;"> -0.9408927 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.3250000 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.2386031 </td>
   <td style="text-align:right;"> 0.0811237 </td>
   <td style="text-align:right;"> 0.0863969 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.8850000 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.7453971 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.1396029 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1.8550000 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.1417191 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> -0.2867191 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.5050000 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.4302506 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> 0.0747494 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.4650000 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.5283681 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.0633681 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.7250000 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.4561226 </td>
   <td style="text-align:right;"> 0.0811840 </td>
   <td style="text-align:right;"> -0.2688774 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.8050000 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.3873488 </td>
   <td style="text-align:right;"> 0.0757368 </td>
   <td style="text-align:right;"> -0.4176512 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.8750000 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.4172800 </td>
   <td style="text-align:right;"> 0.0803002 </td>
   <td style="text-align:right;"> 0.5422800 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.4850000 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.4905675 </td>
   <td style="text-align:right;"> 0.1329762 </td>
   <td style="text-align:right;"> -0.0055675 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.9700000 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -1.1874816 </td>
   <td style="text-align:right;"> 0.1278142 </td>
   <td style="text-align:right;"> 0.2174816 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.2800000 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.3297748 </td>
   <td style="text-align:right;"> 0.0783764 </td>
   <td style="text-align:right;"> -0.0497748 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.9100000 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 1.4858927 </td>
   <td style="text-align:right;"> 0.0756092 </td>
   <td style="text-align:right;"> -0.5758927 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1.8900000 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.2386031 </td>
   <td style="text-align:right;"> 0.0811237 </td>
   <td style="text-align:right;"> -0.3486031 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.2600000 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.7453971 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.5146029 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.0800000 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.1417191 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> -0.0617191 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.8000000 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.4302506 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> 0.3697494 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.3200000 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.5283681 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.2083681 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -3.0700000 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.4561226 </td>
   <td style="text-align:right;"> 0.0811840 </td>
   <td style="text-align:right;"> -0.6138774 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.8200000 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.3873488 </td>
   <td style="text-align:right;"> 0.0757368 </td>
   <td style="text-align:right;"> -0.4326512 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.3600000 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.4172800 </td>
   <td style="text-align:right;"> 0.0803002 </td>
   <td style="text-align:right;"> 0.0572800 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.3200000 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.4905675 </td>
   <td style="text-align:right;"> 0.1329762 </td>
   <td style="text-align:right;"> -0.1705675 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.7925000 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -1.1874816 </td>
   <td style="text-align:right;"> 0.1278142 </td>
   <td style="text-align:right;"> 0.3949816 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.6325000 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.3297748 </td>
   <td style="text-align:right;"> 0.0783764 </td>
   <td style="text-align:right;"> -0.9622748 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1.0675000 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 1.4858927 </td>
   <td style="text-align:right;"> 0.0756092 </td>
   <td style="text-align:right;"> -0.4183927 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.6875000 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.2386031 </td>
   <td style="text-align:right;"> 0.0811237 </td>
   <td style="text-align:right;"> 0.4488969 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.1375000 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.7453971 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.3921029 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.6075000 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.1417191 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> 0.4657809 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.4675000 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.4302506 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> 0.0372494 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.6125000 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.5283681 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> -0.0841319 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -3.2625000 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.4561226 </td>
   <td style="text-align:right;"> 0.0811840 </td>
   <td style="text-align:right;"> -0.8063774 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.5725000 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.3873488 </td>
   <td style="text-align:right;"> 0.0757368 </td>
   <td style="text-align:right;"> -0.1851512 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.3625000 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.4172800 </td>
   <td style="text-align:right;"> 0.0803002 </td>
   <td style="text-align:right;"> 0.0547800 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.2675000 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.4905675 </td>
   <td style="text-align:right;"> 0.1329762 </td>
   <td style="text-align:right;"> -0.2230675 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.8458333 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -1.1874816 </td>
   <td style="text-align:right;"> 0.1278142 </td>
   <td style="text-align:right;"> 0.3416483 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.4758333 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.3297748 </td>
   <td style="text-align:right;"> 0.0783764 </td>
   <td style="text-align:right;"> -0.8056081 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.6941667 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 1.4858927 </td>
   <td style="text-align:right;"> 0.0756092 </td>
   <td style="text-align:right;"> -0.7917261 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.3241667 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.2386031 </td>
   <td style="text-align:right;"> 0.0811237 </td>
   <td style="text-align:right;"> 0.0855636 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.1341667 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.7453971 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.3887696 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1.9741667 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.1417191 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> -0.1675524 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.4641667 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.4302506 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> 0.0339161 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.8958333 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.5283681 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> -0.3674653 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -3.1958333 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.4561226 </td>
   <td style="text-align:right;"> 0.0811840 </td>
   <td style="text-align:right;"> -0.7397107 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.5358333 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.3873488 </td>
   <td style="text-align:right;"> 0.0757368 </td>
   <td style="text-align:right;"> -0.1484845 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.6658333 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.4172800 </td>
   <td style="text-align:right;"> 0.0803002 </td>
   <td style="text-align:right;"> 0.7514466 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1.0241667 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.4905675 </td>
   <td style="text-align:right;"> 0.1329762 </td>
   <td style="text-align:right;"> 0.5335992 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.7225000 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -1.1874816 </td>
   <td style="text-align:right;"> 0.1278142 </td>
   <td style="text-align:right;"> -0.5350184 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.1525000 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.3297748 </td>
   <td style="text-align:right;"> 0.0783764 </td>
   <td style="text-align:right;"> -0.4822748 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.6475000 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 1.4858927 </td>
   <td style="text-align:right;"> 0.0756092 </td>
   <td style="text-align:right;"> -0.8383927 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.1975000 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.2386031 </td>
   <td style="text-align:right;"> 0.0811237 </td>
   <td style="text-align:right;"> 0.9588969 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.4975000 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.7453971 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.7521029 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.5875000 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.1417191 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> 0.4457809 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.1775000 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.4302506 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> -0.2527506 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.9625000 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.5283681 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> -0.4341319 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -3.1725000 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.4561226 </td>
   <td style="text-align:right;"> 0.0811840 </td>
   <td style="text-align:right;"> -0.7163774 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.6225000 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.3873488 </td>
   <td style="text-align:right;"> 0.0757368 </td>
   <td style="text-align:right;"> -0.2351512 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.6925000 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.4172800 </td>
   <td style="text-align:right;"> 0.0803002 </td>
   <td style="text-align:right;"> 0.7247800 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.2175000 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.4905675 </td>
   <td style="text-align:right;"> 0.1329762 </td>
   <td style="text-align:right;"> -0.2730675 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.3850000 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -1.1874816 </td>
   <td style="text-align:right;"> 0.1278142 </td>
   <td style="text-align:right;"> 0.8024816 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.0850000 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.3297748 </td>
   <td style="text-align:right;"> 0.0783764 </td>
   <td style="text-align:right;"> -0.4147748 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.6750000 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 1.4858927 </td>
   <td style="text-align:right;"> 0.0756092 </td>
   <td style="text-align:right;"> -0.8108927 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.4750000 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.2386031 </td>
   <td style="text-align:right;"> 0.0811237 </td>
   <td style="text-align:right;"> 0.2363969 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.1350000 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.7453971 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.3896029 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.3350000 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.1417191 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> 0.1932809 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.5750000 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.4302506 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> 0.1447494 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.4350000 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.5283681 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.0933681 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -3.1850000 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.4561226 </td>
   <td style="text-align:right;"> 0.0811840 </td>
   <td style="text-align:right;"> -0.7288774 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.9250000 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.3873488 </td>
   <td style="text-align:right;"> 0.0757368 </td>
   <td style="text-align:right;"> -0.5376512 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.4350000 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.4172800 </td>
   <td style="text-align:right;"> 0.0803002 </td>
   <td style="text-align:right;"> -0.0177200 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.2550000 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.4905675 </td>
   <td style="text-align:right;"> 0.1329762 </td>
   <td style="text-align:right;"> -0.2355675 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.5600000 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -1.1874816 </td>
   <td style="text-align:right;"> 0.1278142 </td>
   <td style="text-align:right;"> 0.6274816 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.2000000 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.3297748 </td>
   <td style="text-align:right;"> 0.0783764 </td>
   <td style="text-align:right;"> -0.5297748 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.8700000 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 1.4858927 </td>
   <td style="text-align:right;"> 0.0756092 </td>
   <td style="text-align:right;"> -0.6158927 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1.7300000 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.2386031 </td>
   <td style="text-align:right;"> 0.0811237 </td>
   <td style="text-align:right;"> -0.5086031 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.7200000 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.7453971 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> -0.0253971 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.2700000 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.1417191 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> 0.1282809 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.1800000 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.4302506 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> -0.2502506 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.5500000 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.5283681 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> -0.0216319 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -3.0000000 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.4561226 </td>
   <td style="text-align:right;"> 0.0811840 </td>
   <td style="text-align:right;"> -0.5438774 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.5200000 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.3873488 </td>
   <td style="text-align:right;"> 0.0757368 </td>
   <td style="text-align:right;"> -0.1326512 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.5000000 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.4172800 </td>
   <td style="text-align:right;"> 0.0803002 </td>
   <td style="text-align:right;"> 0.9172800 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.5600000 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.4905675 </td>
   <td style="text-align:right;"> 0.1329762 </td>
   <td style="text-align:right;"> 0.0694325 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.6041667 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -1.1874816 </td>
   <td style="text-align:right;"> 0.1278142 </td>
   <td style="text-align:right;"> 0.5833149 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.3158333 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.3297748 </td>
   <td style="text-align:right;"> 0.0783764 </td>
   <td style="text-align:right;"> -0.0139414 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.5358333 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 1.4858927 </td>
   <td style="text-align:right;"> 0.0756092 </td>
   <td style="text-align:right;"> -0.9500594 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1.8958333 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.2386031 </td>
   <td style="text-align:right;"> 0.0811237 </td>
   <td style="text-align:right;"> -0.3427698 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.2058333 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.7453971 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.4604363 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.4958333 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.1417191 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> 0.3541143 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.3058333 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.4302506 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> -0.1244172 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.4841667 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.5283681 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.0442014 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.8941667 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.4561226 </td>
   <td style="text-align:right;"> 0.0811840 </td>
   <td style="text-align:right;"> -0.4380441 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.9141667 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.3873488 </td>
   <td style="text-align:right;"> 0.0757368 </td>
   <td style="text-align:right;"> -0.5268178 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.1841667 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.4172800 </td>
   <td style="text-align:right;"> 0.0803002 </td>
   <td style="text-align:right;"> 0.2331133 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.3258333 </td>
   <td style="text-align:right;"> 0.9583 </td>
   <td style="text-align:right;"> 0.4905675 </td>
   <td style="text-align:right;"> 0.1329762 </td>
   <td style="text-align:right;"> -0.1647341 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -0.6154545 </td>
   <td style="text-align:right;"> 0.0417 </td>
   <td style="text-align:right;"> -1.1874816 </td>
   <td style="text-align:right;"> 0.1278142 </td>
   <td style="text-align:right;"> 0.5720271 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.1045455 </td>
   <td style="text-align:right;"> 0.1250 </td>
   <td style="text-align:right;"> 0.3297748 </td>
   <td style="text-align:right;"> 0.0783764 </td>
   <td style="text-align:right;"> -0.2252293 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.5045455 </td>
   <td style="text-align:right;"> 0.2083 </td>
   <td style="text-align:right;"> 1.4858927 </td>
   <td style="text-align:right;"> 0.0756092 </td>
   <td style="text-align:right;"> -0.9813473 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.2045455 </td>
   <td style="text-align:right;"> 0.2917 </td>
   <td style="text-align:right;"> 2.2386031 </td>
   <td style="text-align:right;"> 0.0811237 </td>
   <td style="text-align:right;"> -0.0340576 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.0645455 </td>
   <td style="text-align:right;"> 0.3750 </td>
   <td style="text-align:right;"> 2.7453971 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.3191484 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.3745455 </td>
   <td style="text-align:right;"> 0.4583 </td>
   <td style="text-align:right;"> 2.1417191 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> 0.2328264 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.3745455 </td>
   <td style="text-align:right;"> 0.5417 </td>
   <td style="text-align:right;"> 0.4302506 </td>
   <td style="text-align:right;"> 0.0876044 </td>
   <td style="text-align:right;"> -0.0557051 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.4554545 </td>
   <td style="text-align:right;"> 0.6250 </td>
   <td style="text-align:right;"> -1.5283681 </td>
   <td style="text-align:right;"> 0.0876098 </td>
   <td style="text-align:right;"> 0.0729135 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.7154545 </td>
   <td style="text-align:right;"> 0.7083 </td>
   <td style="text-align:right;"> -2.4561226 </td>
   <td style="text-align:right;"> 0.0811840 </td>
   <td style="text-align:right;"> -0.2593319 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -2.7254545 </td>
   <td style="text-align:right;"> 0.7917 </td>
   <td style="text-align:right;"> -2.3873488 </td>
   <td style="text-align:right;"> 0.0757368 </td>
   <td style="text-align:right;"> -0.3381057 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.1154545 </td>
   <td style="text-align:right;"> 0.8750 </td>
   <td style="text-align:right;"> -1.4172800 </td>
   <td style="text-align:right;"> 0.0803002 </td>
   <td style="text-align:right;"> 0.3018254 </td>
  </tr>
</tbody>
</table></div>

```r
augment(l1, se_fit = TRUE) %>%
  ggplot(aes(x = year_fraction, y = .fitted)) + 
  geom_line() + 
  geom_ribbon(aes(ymin = .fitted - 2*.se.fit, ymax = .fitted + 2*.se.fit), alpha = 0.20) + 
  my_theme
```

<img src="120-gam-loess_files/figure-html/unnamed-chunk-15-1.png" width="672" />

This line is only drawn using 12 points, so we might want to generate a smoother prediction by creating a new set of dates. We also add the original data to the plot.


```r
new_data = tibble(year_fraction = seq(min(co2$year_fraction), 
                                      max(co2$year_fraction),
                                      length = 100))
augment(l1, newdata = new_data, se_fit = TRUE) %>%
  ggplot(aes(x = year_fraction, y = .fitted)) + 
  geom_line() + 
  geom_ribbon(aes(ymin = .fitted - 2*.se.fit,
                  ymax = .fitted + 2*.se.fit), 
              alpha = 0.20) + 
  geom_point(aes(y = co2_anomaly), data = co2) +
  my_theme
```

<img src="120-gam-loess_files/figure-html/unnamed-chunk-16-1.png" width="672" />

The LOESS function will not predict outside of the range of data provided, so I had to select the range of `new_data` above carefully to get the line to start and end near the first and last points.

Now we make two plots that contrast the results with different sized windows (`span`) and degree of the local regression models.


```r
l2 <- loess(co2_avg ~ decimal_date, data = co2, 
            degree = 1, span = 0.05)
l3 <- loess(co2_avg ~ decimal_date, data = co2, 
            degree = 1, span = 0.25)
new_data = tibble(decimal_date = seq(min(co2$decimal_date), 
                                      max(co2$decimal_date),
                                     length = 300))
a2 <- augment(l2, newdata = new_data, se_fit = TRUE) 
a3 <- augment(l3, newdata = new_data, se_fit = TRUE) 
ggplot(a2, aes(x = decimal_date, y = .fitted)) + 
  geom_line(col="green") + 
  geom_ribbon(aes(ymin = .fitted - 2*.se.fit, 
                  ymax = .fitted + 2*.se.fit), 
              alpha = 0.20, fill="green") + 
  geom_point(aes(y = co2_avg), data = co2) +
  geom_line(data = a3, 
            col="blue") + 
  geom_ribbon(data = a3, 
              aes(ymin = .fitted - 2*.se.fit, 
                  ymax = .fitted + 2*.se.fit), 
              alpha = 0.20, fill="blue") + 
  my_theme
```

<img src="120-gam-loess_files/figure-html/unnamed-chunk-17-1.png" width="672" />

LOESS fits are slow and take a lot of memory compared to other methods (both time and storage requirements increase like the square of the number of points), so they are usually only used for small data sets.

## Further reading

* [LOESS (Wikipedia)](https://en.wikipedia.org/wiki/Local_regression)
* [Generalized additive models (Wikipedia)](https://en.wikipedia.org/wiki/Generalized_additive_model)
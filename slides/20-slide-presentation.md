Making slide presentations
========================================================
author: Andrew Irwin
date: 2021-03-08
autosize: true



Goals
========================================================

- Why we make slides for data visualization
- How to make slides using "R presentation" format

Create a template
======================

Rstudio menu: 

* File
  * New File...
    * R presentation
    
    
Stopping distance increases with car speed
========================================================

<img src="20-slide-presentation-figure/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="40%" style="display: block; margin: auto;" />


Show computer code
========================================================


```r
cars %>% ggplot(aes(speed, dist)) + geom_point()
```

Formatting text and adding images
=======

All markdown formatting for *italics*, **bold**, [hyperlinks](https://www.r-project.org/) are available.

You can include images from the internet or your own computer.

![A kitten](https://placekitten.com/200/300)

Two column format
=========
left: 45%


```r
mpg %>% count(class)
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> class </th>
   <th style="text-align:right;"> n </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 2seater </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> compact </td>
   <td style="text-align:right;"> 47 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> midsize </td>
   <td style="text-align:right;"> 41 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> minivan </td>
   <td style="text-align:right;"> 11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> pickup </td>
   <td style="text-align:right;"> 33 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> subcompact </td>
   <td style="text-align:right;"> 35 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> suv </td>
   <td style="text-align:right;"> 62 </td>
  </tr>
</tbody>
</table>

***

![plot of chunk unnamed-chunk-6](20-slide-presentation-figure/unnamed-chunk-6-1.png)


Summary
=========

* I've shown a simple set of slides you can easily make using Rstudio and R markdown

* Remember, you generally want to make your slides quite simple and use large text and images

* You can use the formatting described in the lesson on reproducible reports to control how code and visualization are displayed

* A link to the full code for these slides is provided in the detailed outline


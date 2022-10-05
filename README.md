
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stopdetection

<!-- badges: start -->
<!-- badges: end -->

This package implements the stop detection algorithm as outlined in
Montoliu (2013). This package provides a set of tools to cluster
timestamped movement trajectories into sets of stops (or staypoints) and
tracks (or trajectories). Time-adjacent clusters are formed by first
identifying stops on the basis of provided dwell time and radius
parameters. A stop is created if all subsequent locations are within a
certain distance of an initiating location for at least as long as the
dwell time. For example, 200 meters and 5 minutes may be used in order
to find all clusters within the trajectory for which a person remained
within a circle with radius 200 meters for at least five minutes.

It is recommended to merge stops following the initial stop
identification, as documented in … FMS study …. Merging stops requires a
parameter for the maximum distance away from each other that two stops
may be while being considered the same stop. Single points between two
stops adjacent in time are removed during this step. In data where
locations are measured without error, this step is optional. Where
locations are generated with error, this step provides an error
correcting mechanism for erroneous and low-accuracy locations.

## Installation

You can install the development version of stopdetection from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("daniellemccool/stopdetection")
```

## Example

The following demonstrates the stopFinder algorithm with a distance
radius parameter of 200 meters, and a minimum time parameter of 200
seconds.

``` r
library(data.table)
library(stopdetection)

df <- data.frame(entity_id = rep(1, 27),
   timestamp = c(1, 2, 4, 10, 14, 18, 20, 21, 24, 25, 28, 29, 45, 80, 100,
                 120, 200, 270, 300, 340, 380, 450, 455, 460, 470, 475,
                 490),
   longitude = c(5.1299311, 5.129979, 5.129597, 5.130028, 5.130555, 5.131083,
           5.132101, 5.132704, 5.133326, 5.133904, 5.134746, 5.135613,
           5.135613, 5.135613, 5.135613, 5.135613, 5.135613, 5.135613,
           5.135613, 5.135613, 5.135613, 5.135613, 5.134746, 5.133904,
           5.133326, 5.132704, 5.132101),
   latitude = c(52.092839, 52.092827, 52.092571, 52.092292, 52.092076, 52.091821,
           52.091420, 52.091219, 52.091343, 52.091651, 52.092138, 52.092698,
           52.092698, 52.092698, 52.092698, 52.092698, 52.092698, 52.092698,
           52.092698, 52.092698, 52.092698, 52.092138, 52.091651, 52.091343,
           52.091219, 52.091420, 52.091821))
setDT(df)
stopFinder(df, thetaD = 200, thetaT = 200)
#> function (x, df1, df2, ncp, log = FALSE) 
#> {
#>     if (missing(ncp)) 
#>         .Call(C_df, x, df1, df2, log)
#>     else .Call(C_dnf, x, df1, df2, ncp, log)
#> }
#> <bytecode: 0x000001d0058e96e0>
#> <environment: namespace:stats>
df
#>     entity_id timestamp longitude latitude stop_id
#>  1:         1         1  5.129931 52.09284      NA
#>  2:         1         2  5.129979 52.09283      NA
#>  3:         1         4  5.129597 52.09257      NA
#>  4:         1        10  5.130028 52.09229      NA
#>  5:         1        14  5.130555 52.09208      NA
#>  6:         1        18  5.131083 52.09182      NA
#>  7:         1        20  5.132101 52.09142      NA
#>  8:         1        21  5.132704 52.09122      NA
#>  9:         1        24  5.133326 52.09134      NA
#> 10:         1        25  5.133904 52.09165      NA
#> 11:         1        28  5.134746 52.09214      NA
#> 12:         1        29  5.135613 52.09270      12
#> 13:         1        45  5.135613 52.09270      12
#> 14:         1        80  5.135613 52.09270      12
#> 15:         1       100  5.135613 52.09270      12
#> 16:         1       120  5.135613 52.09270      12
#> 17:         1       200  5.135613 52.09270      12
#> 18:         1       270  5.135613 52.09270      12
#> 19:         1       300  5.135613 52.09270      12
#> 20:         1       340  5.135613 52.09270      12
#> 21:         1       380  5.135613 52.09270      12
#> 22:         1       450  5.135613 52.09214      12
#> 23:         1       455  5.134746 52.09165      12
#> 24:         1       460  5.133904 52.09134      12
#> 25:         1       470  5.133326 52.09122      12
#> 26:         1       475  5.132704 52.09142      NA
#> 27:         1       490  5.132101 52.09182      NA
#>     entity_id timestamp longitude latitude stop_id
```

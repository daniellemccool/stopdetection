
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stopdetection

<!-- badges: start -->
<!-- badges: end -->

This package implements the stop detection algorithm as outlined in Ye
et al. (2009). This package provides a set of tools to cluster
timestamped movement trajectories into sets of stops (or staypoints) and
tracks (or trajectories). Time-adjacent clusters are formed by first
identifying stops on the basis of provided dwell time and radius
parameters. A stop is created if all subsequent locations are within a
certain distance of an initiating location for at least as long as the
dwell time. For example, 200 meters and 5 minutes may be used in order
to find all clusters within the trajectory for which a person remained
within a circle with radius 200 meters for at least five minutes.

It is recommended to merge stops following the initial stop
identification, as documented in Montoliu, Blom, and Gatica-Perez
(2013). Merging stops requires a parameter for the maximum distance away
from each other that two stops may be while being considered the same
stop. Single points between two stops adjacent in time are removed
during this step. In data where locations are measured without error,
this step is optional. Where locations are generated with error, this
step provides an error correcting mechanism for erroneous and
low-accuracy locations.

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
data("loc_data_2019")
setDT(loc_data_2019)
stopFinder(loc_data_2019, thetaD = 200, thetaT = 200)
```

## Extract states

Use to quickly extract a data.table containing information about the
stops and tracks

``` r
returnStateEvents(loc_data_2019)
#>      state_id   state  meanlat  meanlon          begin_time            end_time
#>   1:        1 stopped 52.07212 5.123760 2019-11-01 00:02:46 2019-11-01 08:05:55
#>   2:        2  moving       NA       NA 2019-11-01 08:06:27 2019-11-01 08:06:27
#>   3:        3 stopped 52.07793 5.122575 2019-11-01 08:06:42 2019-11-01 08:12:00
#>   4:        4  moving       NA       NA 2019-11-01 08:12:15 2019-11-01 08:15:24
#>   5:        5 stopped 52.08895 5.109750 2019-11-01 08:15:40 2019-11-01 08:24:29
#>  ---                                                                           
#> 303:      303  moving       NA       NA 2019-11-14 19:02:59 2019-11-14 19:11:46
#> 304:      304 stopped 52.08177 5.138043 2019-11-14 19:12:02 2019-11-14 19:57:11
#> 305:      305 stopped 52.08248 5.134109 2019-11-14 19:57:40 2019-11-14 20:01:20
#> 306:      306  moving       NA       NA 2019-11-14 20:01:37 2019-11-14 20:08:32
#> 307:      307 stopped 52.07213 5.123719 2019-11-14 20:08:47 2019-11-14 23:59:23
#>      raw_travel_dist stop_id move_id n_locations
#>   1:              NA       1      NA         472
#>   2:              NA      NA       1           1
#>   3:              NA       2      NA          22
#>   4:        1253.036      NA       2          12
#>   5:              NA       3      NA          37
#>  ---                                            
#> 303:        2122.411      NA      90          32
#> 304:              NA     214      NA          65
#> 305:              NA     215      NA          13
#> 306:        1532.397      NA      91          25
#> 307:              NA     216      NA         205
```

## Merge stops/handle short tracks

Subsequent nearby stops can be merged based on the distance of their
centroids. This is often useful if they represent the same stop
subjectively. Short tracks can be either merged into the previous stop
or excluded. Often short ‘tracks’ represent erroneously measured GNSS
locations of one or two points, so excluding them is helpful. The
combination of excluding short tracks and merging stops can be used to
handle noisy location data.

``` r
mergingCycle(loc_data_2019, thetaD = 200, small_track_action = "exclude")
returnStateEvents(loc_data_2019)
#>      state_id    state  meanlat  meanlon          begin_time
#>   1:        1  stopped 52.07212 5.123760 2019-11-01 00:02:46
#>   2:       NA excluded       NA       NA 2019-11-01 08:06:27
#>   3:        2  stopped 52.07791 5.122623 2019-11-01 08:06:42
#>   4:        3   moving       NA       NA 2019-11-01 08:12:15
#>   5:        4  stopped 52.08895 5.109750 2019-11-01 08:15:40
#>  ---                                                        
#> 265:      264   moving       NA       NA 2019-11-14 19:02:59
#> 266:      265  stopped 52.08177 5.138043 2019-11-14 19:12:02
#> 267:      266  stopped 52.08248 5.134109 2019-11-14 19:57:40
#> 268:      267   moving       NA       NA 2019-11-14 20:01:37
#> 269:      268  stopped 52.07213 5.123719 2019-11-14 20:08:47
#>                 end_time raw_travel_dist stop_id move_id n_locations
#>   1: 2019-11-01 08:05:55              NA       1      NA         472
#>   2: 2019-11-14 16:25:07              NA      NA      NA           8
#>   3: 2019-11-01 08:12:00              NA       2      NA          22
#>   4: 2019-11-01 08:15:24        1253.036      NA       1          12
#>   5: 2019-11-01 08:24:29              NA       3      NA          37
#>  ---                                                                
#> 265: 2019-11-14 19:11:46        2122.411      NA      82          32
#> 266: 2019-11-14 19:57:11              NA     183      NA          65
#> 267: 2019-11-14 20:01:20              NA     184      NA          13
#> 268: 2019-11-14 20:08:32        1532.397      NA      83          25
#> 269: 2019-11-14 23:59:23              NA     185      NA         205
```

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-Montoliu2013-tb" class="csl-entry">

Montoliu, Raul, Jan Blom, and Daniel Gatica-Perez. 2013. “Discovering
Places of Interest in Everyday Life from Smartphone Data.” *Multimedia
Tools and Applications* 62 (1): 179–207.
<https://doi.org/10.1007/s11042-011-0982-z>.

</div>

<div id="ref-Ye2009-dv" class="csl-entry">

Ye, Yang, Yu Zheng, Yukun Chen, Jianhua Feng, and Xing Xie. 2009.
“Mining Individual Life Pattern Based on Location History.” In
*Proceedings of the 2009 Tenth International Conference on Mobile Data
Management: Systems, Services and Middleware*, 1–10. MDM ’09. USA: IEEE
Computer Society. <https://doi.org/10.1109/MDM.2009.11>.

</div>

</div>

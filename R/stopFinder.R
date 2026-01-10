#' Detect Stop Points in GPS Trajectories
#'
#' Identifies stop points in timestamped GPS data using spatiotemporal
#' clustering. A stop is detected when a sequence of points remains within
#' a specified distance radius for at least a minimum time duration.
#'
#' @param traj A [data.table] ordered by `timestamp`, containing columns:
#'   * `timestamp` - Time of observation (numeric or POSIXct)
#'   * `longitude` - Longitude in decimal degrees
#'   * `latitude` - Latitude in decimal degrees
#' @param thetaD Distance threshold in meters. Points within this radius
#'   of the initiating location are considered part of the same potential stop.
#' @param thetaT Time threshold in same units as `timestamp`. Minimum duration
#'   required to qualify as a stop.
#'
#' @return Modifies `traj` by reference, adding columns:
#'   * `stop_initiation_idx` - Row index of stop start (`NA` if moving)
#'   * `state_id` - Integer ID for each contiguous state segment
#'   * `state` - Factor: `"stopped"` or `"moving"`
#'   * `timedif` - Time elapsed since previous point
#'
#' @details
#' This is the reference R implementation. For better performance in
#' simulation studies or large datasets, use [stopFinderFast()] which
#' provides ~500x speedup via C++.
#'
#' Optimized for repeated calls; input validation should be performed
#' beforehand.
#'
#' @section Warning:
#' Input must be pre-sorted by `timestamp` with correctly named columns.
#' No error checking is performed for efficiency.
#'
#' @seealso [stopFinderFast()] for C++ implementation
#' @family stop-detection
#'
#' @references
#' Li, Q., et al. (2008). Mining user similarity based on location history.
#' *ACM SIGSPATIAL*.
#'
#' @export
#' @examples
#' library(data.table)
#' dt <- data.table(
#'   entity_id = 1L,
#'   timestamp = c(
#'     1, 2, 4, 10, 14, 18, 20, 21, 24, 25, 28, 29, 45, 80, 100,
#'     120, 200, 270, 300, 340, 380, 450, 455, 460, 470, 475, 490
#'   ),
#'   longitude = c(
#'     5.1299311, 5.129979, 5.129597, 5.130028, 5.130555, 5.131083,
#'     5.132101, 5.132704, 5.133326, 5.133904, 5.134746, 5.135613,
#'     5.135613, 5.135613, 5.135613, 5.135613, 5.135613, 5.135613,
#'     5.135613, 5.135613, 5.135613, 5.135613, 5.134746, 5.133904,
#'     5.133326, 5.132704, 5.132101
#'   ),
#'   latitude = c(
#'     52.092839, 52.092827, 52.092571, 52.092292, 52.092076,
#'     52.091821, 52.091420, 52.091219, 52.091343, 52.091651,
#'     52.092138, 52.092698, 52.092698, 52.092698, 52.092698,
#'     52.092698, 52.092698, 52.092698, 52.092698, 52.092698,
#'     52.092698, 52.092138, 52.091651, 52.091343, 52.091219,
#'     52.091420, 52.091821
#'   )
#' )
#'
#' stopFinder(dt, thetaD = 50, thetaT = 400)
#'
#' # Visualize results
#' plot(dt$longitude, dt$latitude,
#'   type = "b", pch = 20,
#'   main = "Stop Detection", xlab = "Longitude", ylab = "Latitude"
#' )
#' points(dt[state == "stopped", .(longitude, latitude)],
#'   col = "red", pch = 20
#' )
stopFinder <- function(traj, thetaD, thetaT) {
  data.table::set(traj, j = "stop_initiation_idx", value = NA_integer_)

  # Extract once, avoid repeated subsetting
  lon <- traj[["longitude"]]
  lat <- traj[["latitude"]]
  time <- as.numeric(traj[["timestamp"]])
  pointNum <- length(lon)

  if (pointNum == 0) {
    return(NA_integer_)
  }

  # Pre-allocate result vector instead of repeated set() calls
  stop_idx <- rep(NA_integer_, pointNum)

  i <- 1L
  while (i < pointNum) {
    j <- i + 1L
    while (j <= pointNum) {
      # Scalar haversine - avoid data.table subsetting entirely
      dist <- haversine_cpp(lat[i], lon[i], lat[j], lon[j])

      if (dist >= thetaD) {
        if ((time[j] - time[i]) >= thetaT) {
          stop_idx[i:(j - 1L)] <- i
        }
        i <- j
        break
      }
      j <- j + 1L
    }
    if (j > pointNum) break
  }

  # Final stop check
  if ((time[pointNum] - time[i]) >= thetaT) {
    stop_idx[i:pointNum] <- i
  }

  data.table::set(traj, j = "stop_initiation_idx", value = stop_idx)

  data.table::set(traj,
    j = c(
      "timedif",
      "state_id",
      "state"
    ),
    value = list(
      splitDiffTime(traj[["timestamp"]]),
      rleid(traj[["stop_initiation_idx"]]),
      fifelse(is.na(traj[["stop_initiation_idx"]]), "moving", "stopped")
    )
  )
}

# Previous implementation
# stopFinder <- function(traj, thetaD, thetaT) {
#   data.table::set(traj,
#                   j = "stop_initiation_idx",
#                   value = NA_integer_
#   )
#   # traj[, stop_id := NA_integer_]
#   mat <- as.matrix(traj[, .(longitude, latitude, as.numeric(timestamp))])
#   i <- 1
#   j <- i + 1
#   pointNum <- nrow(mat) # number of GPS points in traj
#
#   if (pointNum == 0) {
#     return(NA_integer_)
#   }
#
#   while (i < pointNum & j < pointNum) {
#     # flag <- TRUE
#     while ((j < pointNum)) {
#       distance <-
#         # haversinem(mat[c(i, j), c(1, 2)]) # most efficient, but others work
#         traj[c(i, j), haversine_seq(latitude, longitude)] # most efficient, but others work
#       # traj[c(i, j), geodist_vec(longitude, latitude, sequential = TRUE)]
#       # traj[c(i, j), haversine(longitude, latitude)]
#       # geodist(mat[c(i, j),], sequential = TRUE)
#       if (distance >= thetaD) {
#         time <- mat[j, 3] - mat[i, 3]
#         # time <- diff(mat[c(i, j), 3])
#         if ((time >= thetaT)) {
#           data.table::set(traj, i = i:(j - 1), j = "stop_initiation_idx", value = i)
#           # traj[i:j, stop_id := i]
#         }
#         i <- j
#         break
#       } else {
#         j <- j + 1
#       }
#     }
#   }
#
#   # Capture the last stop if it's longer than time window
#   if (mat[j, 3] - mat[i, 3] >= thetaT) {
#     data.table::set(traj, i = i:j, j = "stop_initiation_idx", value = i)
#   }
#   # traj[i:j, stop_id := i]
#
#   data.table::set(traj,
#                   j = c(
#                     "timedif",
#                     "state_id",
#                     "state"
#                   ),
#                   value = list(
#                     splitDiffTime(traj[["timestamp"]]),
#                     rleid(traj[["stop_initiation_idx"]]),
#                     fifelse(is.na(traj[["stop_initiation_idx"]]), "moving", "stopped")
#                   )
#   )
# }

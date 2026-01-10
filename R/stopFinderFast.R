#' Detect Stop Points in GPS Trajectories
#'
#' @description
#' `r lifecycle::badge("experimental")`
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
#' This is a C++ implementation of [stopFinder()], offering ~500x speedup.
#' Optimized for repeated calls in simulation studies; input validation
#' should be performed beforehand.
#'
#' @section Warning:
#' Input must be pre-sorted by `timestamp` with correctly named columns.
#' No error checking is performed for efficiency.
#'
#' @seealso [stopFinder()] for the reference R implementation
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
#' stopFinderFast(dt, thetaD = 50, thetaT = 400)
#'
#' # Visualize results
#' plot(dt$longitude, dt$latitude,
#'   type = "b", pch = 20,
#'   main = "Stop Detection", xlab = "Longitude", ylab = "Latitude"
#' )
#' points(dt[state == "stopped", .(longitude, latitude)],
#'   col = "red", pch = 20
#' )
stopFinderFast <- function(traj, thetaD, thetaT) {
  if (nrow(traj) == 0) {
    return(
      data.table(
        stop_initiation_idx = NA_integer_,
        timedif = NA_real_,
        state_id = NA_integer_,
        state = NA_character_
      )
    )
  }
  stop_idx <- stopFinder_cpp(
    traj$latitude,
    traj$longitude,
    as.numeric(traj$timestamp),
    thetaD,
    thetaT
  )
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

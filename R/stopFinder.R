#' Find an initial set of stops given timestamped locations
#'
#' Clusters trajectories spatiotemporally based on a user-provided distance
#' radius parameter and time parameter. Points are evaluated sequentially to
#' determine whether they meet the criteria for being a stop (at least
#' \code{thetaT} time spent within \code{thetaD} distance of the initiating
#' location). Points must therefore have a timestamp, longitude and latitude
#' column.
#'
#' This function has been optimized for simulation studies where it will be
#' called repeatedly. Because of this, all error-handling is done prior to this
#' step. If calling this function directly, the user must ensure that the data
#' are ordered based on the timestamp, and that the columns names are correct.
#'
#'
#' @param traj An ordered data.table with columns named timestamp, longitude and latitude
#' @param thetaD The distance parameter, represents a radius in meters for establishing how much area a stop can encompass.
#' @param thetaT The time parameter, representing the length of time that must be spent within the stop area before being considered a stop.
#'
#' @return traj is modified by reference to include a column stop_id, which is NA for locations not belonging to a stop, and equal to the row number initiating the stop it belongs to otherwise.
#' @export
#'
#' @examples
#' # Set up data
#'
stopFinder <- function(traj, thetaD, thetaT) {
  set(traj,
      j = "stop_id",
      value = NA_integer_)
  # traj[, stop_id := NA_integer_]
  mat <- as.matrix(traj[, .(longitude, latitude, as.numeric(timestamp))])
  i <- 1
  j <- i + 1
  pointNum <- nrow(mat) # number of GPS points in traj

  while (i < pointNum & j < pointNum) {
    # flag <- TRUE
    while ((j < pointNum)) {
      distance <-
        haversinem(mat[c(i, j), c(1, 2)]) # most efficient, but others work
      # traj[c(i, j), geodist_vec(longitude, latitude, sequential = TRUE)]
      # traj[c(i, j), haversine(longitude, latitude)]
      # geodist(mat[c(i, j),], sequential = TRUE)
      if (distance >= thetaD) {
        time <- mat[j, 3] - mat[i, 3]
        # time <- diff(mat[c(i, j), 3])
        if ((time >= thetaT)) {
          set(traj, i = i:j, j = "stop_id", value = i)
          # traj[i:j, stop_id := i]
        }
        i <- j
        break
      } else  {
        j <- j + 1
      }
    }
  }

  # Capture the last stop if it's longer than time window
  if (mat[j, 3] - mat[i, 3] >= thetaT)
    set(traj, i = i:j, j = "stop_id", value = i)
  # traj[i:j, stop_id := i]

  # traj
}

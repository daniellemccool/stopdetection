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
        haversinem(mat[c(i, j), c(1, 2)])
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

  traj
}

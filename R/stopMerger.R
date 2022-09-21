stopMerger <- function(events, thetaD) {
  i <- 1
  j <- i + 1
  # events[, newmeanlon := meanlon]
  # events[, newmeanlat := meanlat]
  # events[, new_stop_id := state_id]
  mat <- as.matrix(events[, .(meanlon = meanlon,
                              meanlat = meanlat,
                              newmeanlon = meanlon,
                              newmeanlat = meanlat,
                              new_stop_id = state_id,
                              ts = time_length(end_time - begin_time, "seconds"))])
  pointNum <- nrow(mat) # number of GPS points in traj


  while ((i < pointNum) & (j < pointNum)) {
    # flag <- TRUE
    while ((j < pointNum)) {
      distance <-
        haversinem(mat[c(i, j), c(3, 4)])
      # events[c(i, j), haversine(newmeanlon, newmeanlat)]

      if (is.na(distance) | distance > thetaD) {
        i <- j
        j <- j + 1
        break
      } else {
        mat[i:j, 5] <- i
        # events[i:j, new_stop_id := i]
        mat[i:j, 3] <- weighted.mean(mat[i:j, 1], mat[i:j, 6])
        mat[i:j, 4] <- weighted.mean(mat[i:j, 2], mat[i:j, 6])
        # events[i:j, newmeanlon := weighted.mean(meanlon, time_length(end_time - begin_time, "seconds"))]
        # events[i:j, newmeanlat := weighted.mean(meanlat, time_length(end_time - begin_time, "seconds"))]

        j <- j + 1
      }
    }
  }


  set(events,
      j = c("new_stop_id", "newmeanlon", "newmeanlat"),
      value = list(
        mat[, 5],
        mat[, 3],
        mat[, 4]
      ))
  # events[, `:=`(new_stop_id = mat[, 5],
  #               newmeanlon = mat[, 3],
  #               newmeanlat = mat[, 4])][]
  #
}

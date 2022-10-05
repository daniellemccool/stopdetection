returnStateEvents <- function(dt) {
  res <- copy(dt)
  set(res,
      j = c("timedif",
            "state_id",
            "move_id"),
      value = list(
        splitDiffTime(res[["timestamp"]]),
        rleid(res[["stop_initiation_idx"]]),
        NA_integer_
      ))


  is_stop <- !is.na(res[["stop_initiation_idx"]])
  move_idx <- which(!is_stop)
  stop_idx <- which(is_stop)

  set(res,
      i = move_idx,
      j = c("move_id", "state"),
      value = list(rleid(res[["state_id"]][move_idx]), "moving"))

  set(res,
      i = stop_idx,
      j = c("stop_id", "state"),
      value = list(rleid(res[["state_id"]][stop_idx]), "stopped"))


  set(res,
      j = c("prev_lon",
            "prev_lat"),
      value = list(shift(res[["longitude"]]),
                   shift(res[["latitude"]])))

  res[(move_idx), raw_travel_dist := sum(
    geodist::geodist_vec(
      prev_lon,
      prev_lat,
      longitude,
      latitude,
      paired = TRUE,
      measure = "haversine"
    ),
    na.rm = TRUE
  ), move_id]



  res[(stop_idx), `:=`(meanlon = stats::weighted.mean(longitude, timedif),
                       meanlat = stats::weighted.mean(latitude, timedif),
                       sdlon = sd(longitude),
                       sdlat = sd(latitude)), state_id]


  unique(res[, .(
    state,
    meanlat,
    meanlon,
    begin_time = timestamp[1L],
    end_time = timestamp[.N],
    raw_travel_dist,
    sdlon,
    sdlat,
    stop_id,
    move_id,
    stop_initiation_idx,
    n_locations = .N
  ), state_id])
}

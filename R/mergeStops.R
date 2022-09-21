mergeStops <- function(res, events, thetaD = 200){
  stopMerger(events, 200)
  moveMerger(events)
  # events[is.na(new_stop_id), new_stop_id := state_id]
  res[events, `:=`(state_id = i.new_stop_id,
                   within_stop = i.new_within_stop), on = .(state_id)]
  # set(res,
  #     j = "within_stop",
  #     value = !is.na(res[["stop_id"]]))
  # # res[, within_stop := !is.na(stop_id)]
  # Reset the results with new stop_ids
  set(res, j = c("stop_id", "move_id", "traveldist", "sdlon", "sdlat"),
      value = NA)
  # res[, `:=`(stop_id = NA,
  # move_id = NA,
  # traveldist = NA,
  # sdlon = NA,
  # sdlat = NA)]

  stop <- res[["within_stop"]]
  scondition <- which(stop)
  mcondition <- which(!stop)
  set(res,
      i = scondition,
      j = "stop_id",
      value = rleid(res[["state_id"]][scondition]))
  # res[(within_stop), stop_id := rleid(state_id)]
  set(res,
      i = mcondition,
      j = "move_id",
      value = rleid(res[["state_id"]][mcondition]))

  # res[!(within_stop), move_id := rleid(state_id)]

  # res[within_stop == FALSE, move_id := rleid(state_id)])

  set(res,
      j = c("state_id", "prev_lon", "prev_lat"),
      value = list(
        rleid(res[["stop_id"]]),
        shift(res[["longitude"]]),
        shift(res[["latitude"]])
      ))

  # res[, state_id := rleid(stop_id)]
  # res[, `:=`(prev_lon = shift(longitude),
  # prev_lat = shift(latitude))]

  # Recalculate travel distance
  res[!(within_stop), traveldist := sum(
    geodist_vec(
      prev_lon,
      prev_lat,
      longitude,
      latitude,
      paired = TRUE,
      measure = "haversine"
    ),
    na.rm = TRUE
  ), move_id]

  set(res,
      j = "timedif",
      value = splitDiffTime(res[["timestamp"]]))
  # res[, timedif := splitDiffTime(timestamp)]

  res[(within_stop), `:=`(meanlon = weighted.mean(longitude, timedif),
                          meanlat = weighted.mean(latitude, timedif),
                          sdlon = sd(longitude),
                          sdlat = sd(latitude)), state_id]

  events <- res[, .(
    meanlat,
    meanlon,
    begin_time = timestamp[1L],
    end_time = timestamp[.N],
    traveldist,
    sdlon,
    sdlat,
    stop_id,
    move_id,
    .N
  ), state_id]
  events <<- unique(events)

}

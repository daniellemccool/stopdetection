#' Return State Events
#'
#' Given a data.table updated with stop and move events from
#' \code{\link{stopFinder}}, returns data aggregated to the event level.
#'
#' @param dt data.table updated with stop and move events from
#'   \code{\link{stopFinder}}
#'
#' @return data.table with one line per stop/move event, annotated with columns
#'   state_id, state, begin_time, end_time and n_locations. Move events contain
#'   information on the raw_travel_dist and a move_id. Stop events have values
#'   for columns meanlat and meanlon, which are respectively the mean latitude
#'   and longitude of locations occurring during the stop.
#' @export
#'
#' @examples
#' library(data.table)
#' data(loc_data_2019)
#' setDT(loc_data_2019)
#' stopFinder(loc_data_2019, thetaD = 200, thetaT = 300)
#' returnStateEvents(loc_data_2019)
returnStateEvents <- function(dt) {
  res <- copy(dt)

  is_stop <- res[["state"]] == "stopped"
  is_move <- res[["state"]] == "moving"
  move_idx <- which(is_move)
  stop_idx <- which(is_stop)

  data.table::set(res,
    j = c("move_id", "stop_id", "raw_travel_dist", "meanlat", "meanlon"),
    value = list(NA_integer_, NA_integer_, NA_real_, NA_real_, NA_real_)
  )

  data.table::set(res,
    i = move_idx,
    j = c("move_id", "state"),
    value = list(rleid(res[["state_id"]][move_idx]), "moving")
  )

  data.table::set(res,
    i = stop_idx,
    j = c("stop_id", "state"),
    value = list(rleid(res[["state_id"]][stop_idx]), "stopped")
  )

  if (length(move_idx) > 0) {
    res[move_idx, raw_travel_dist := {
      if (.N < 2) 0.0 else sum(haversine_seq(as.numeric(latitude), as.numeric(longitude)))
    }, by = move_id]
  }


  res[
    state != "excluded",
    `:=`(timedif = splitDiffTime(timestamp))
  ]

  res[
    (stop_idx),
    `:=`(
      meanlon = weighted.mean(longitude, timedif),
      meanlat = weighted.mean(latitude, timedif)
    ), state_id
  ]

  unique(res[, .(
    state,
    meanlat,
    meanlon,
    begin_time = timestamp[1L],
    end_time = timestamp[.N],
    raw_travel_dist,
    stop_id,
    move_id,
    # stop_initiation_idx,
    n_locations = .N
  ), state_id])[]
}

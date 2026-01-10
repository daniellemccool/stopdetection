#' @keywords internal
"_PACKAGE"

## usethis namespace: start

#' @importFrom data.table .BY
#' @importFrom data.table .EACHI
#' @importFrom data.table .GRP
#' @importFrom data.table .I
#' @importFrom data.table .N
#' @importFrom data.table .NGRP
#' @importFrom data.table .SD
#' @importFrom data.table :=
#' @importFrom data.table copy
#' @importFrom data.table data.table
#' @importFrom data.table rleid
#' @importFrom data.table set
#' @importFrom data.table setDT
#' @importFrom data.table shift
#' @importFrom lifecycle deprecated
#' @importFrom Rcpp sourceCpp
#' @useDynLib stopdetection, .registration = TRUE
## usethis namespace: end
NULL

globalVariables(c(
  "state", "state_id", "new_state_id", "timestamp", "longitude",
  "latitude", "move_id", "stop_id", "meanlat", "meanlon",
  "mergeable", "n_locations", "end_time", "begin_time",
  "raw_travel_dist", "timedif", "dist_prev_stop",
  "i.new_state_id", "i.new_state", ".", "data_set_days", "device_id",
  "dist_gap_from_prev", "id", "minutes_gap", "next_lat", "next_lon", "next_ts",
  "prev_lat", "prev_lon", "prev_ts", "time_gap_from_prev"
))

moveMerger <- function(events){
  condition <- events[N == 1, which = TRUE]
  set(events,
      j = c("new_stop_id",
            "new_within_stop"),
      value = list(events[["new_stop_id"]],
                   !is.na(events[["stop_id"]]))
  )
  set(events,
      i = condition,
      j = c("new_stop_id",
            "new_within_stop"),
      value = list(
        events[["state_id"]][condition] - 1,
        TRUE)
  )
}

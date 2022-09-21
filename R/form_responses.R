# form_id = "AguBBFpm"
type_responses <- function(form_id, attempt_table = TRUE, auth = config::get()$typeform) {
  response <- type_request(glue::glue("forms/{form_id}/responses"), auth)
  response <- response$content |> rawToChar() |> jsonlite::fromJSON()
  if (attempt_table) {
    response <- lapply(seq_along(response$items$submitted_at), \(i) {
      x = data.table::as.data.table(response$items$answers[i])
      x[,submitted_at := response$items$submitted_at[i]]
      x[,response_id := response$items$response_id[i]]
    }) |>
      data.table::rbindlist() |>
      {\(x) data.table::setcolorder(x, c("submitted_at", "response_id", names(x)[which(!names(x) %in% c("submitted_at", "response_id"))]) )}()
  }
  response
}

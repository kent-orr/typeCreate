

#' function factory that generates an extractor function for a given type
#'
#' @param type the type, given in the answers object.
#'
val_extractor <- function(type) {
  if (type %in% c("text", "email", "url", "file_url", "boolean", "number", "date", "payment")) {
    function(answer_obj, i) {answer_obj[type][[1]][[i]]}
  } else if (type == "choice") {
    function(answer_obj, i) {list(answer_obj["choice"][[1]]["ref"][[1]][i])}
  } else if (type == "choices") {
    function(answer_obj, i) {answer_obj["choices"][[1]]["refs"][[1]][i]}
  }
}

#' Retrieve Responses from a Typeform
#'
#' @param form_id the form id, can be found in the URL of a form
#' @param ... query paramters. See details
#' @param attempt_table coerce the results to a table?
#' @param wide_table only if attempt_table = TRUE, simplify table results to a wide format
#' @param auth typeform API token
#'
#' @details
#'
#' @export
#'
type_responses <- function(form_id, ..., attempt_table = TRUE, wide_table = TRUE, auth = config::get()$typeform) {

  query <- list(...)
  query <- if (length(query) != 0) {
    nm = names(query)
    va = query
    paste0("?", paste(nm, va, sep = "=", collapse = "&"))
  } else {
    ""
  }

  response <- type_request(glue::glue("forms/{form_id}/responses{query}"), auth)
  response.l <- response <- response$content |> rawToChar() |> jsonlite::fromJSON()

  if (attempt_table) {

    # create a data.table of each submission object suing timestamp and id
    response <- lapply(seq_along(response$items$submitted_at), \(i) {
      x = data.table::as.data.table(response$items$answers[i])
      x[,submitted_at := response$items$submitted_at[i]]
      x[,response_id := response$items$response_id[i]]
    }) |>
      data.table::rbindlist(fill = TRUE) |>
      {\(x) data.table::setcolorder(x, c("submitted_at",
                                         "response_id",
                                         names(x)[which(!names(x) %in% c("submitted_at", "response_id"))]
                                         )
                                    )}()

    # convert the various fields that contain the responses to a single column "value"
    values <- sapply(response.l["items"][[1]][["answers"]], \(i) {
      sapply(seq_along(i[["type"]]), \(j) {
        f_extract <- val_extractor(i[["type"]][j])
        f_extract(i, j)
      })
    }) |> as.vector()

    # concatenate the different ref objects, which usually are a human readable identifier
    refs <- sapply(response.l["items"][[1]][["answers"]], \(i) {
      i[[1]][["ref"]]
    }) |> as.vector()

    response[,value := values]
    response[,ref := refs]

    # if there are hidden fields label according to id and timestamp and append to dataframe
    if (!is.null(response.l[["items"]][["hidden"]])) {
      x = data.table::as.data.table(response.l[["items"]][["hidden"]])
      x[,submitted_at := response.l$items$submitted_at]
      x[,response_id := response.l$items$response_id]
      x <- data.table::melt(x, id.vars = c("submitted_at", "response_id"),
                value.name = "value", variable.name = "ref")
      response <- rbind(x, response, fill = TRUE)[order(submitted_at, response_id)]
    }

    # if a wide table is requested, drop to only necessary fields in wide format
    if (wide_table)
      response <- response[,data.table::dcast(.SD, submitted_at + response_id ~ ref)]
  }
  response
}

#' Title
#'
#' @param ... query parameters. defaults to page_size = 200. See details
#' @param auth
#'
#' @details
#' query parameters are
#' search: a string to search for
#' page
#' pagesize
#' workspace_id
#' sort_by
#' order_by
#'
#' @export
#'
#' @examples
get_forms <- function(..., auth = config::get()$typeform) {

   query <- list(...)
    query <- if (length(query) != 0) {
    nm = names(query)
    va = query
    paste0("?", paste(nm, va, sep = "=", collapse = "&"))
  } else {
    "?page_size=200"
  }

  response <- type_request(glue::glue("forms{query}"), auth)
  response$content |> rawToChar() |>
    jsonlite::fromJSON() |>
    data.table::as.data.table()
}

#' Delete a Form
#'
#' @param form_vector a character vector of form id's. Canbe single
#' @param auth personal access token
#'
#' @export
#'
delete_forms <- function(form_vector, auth = config::get()$typeform) {
  for (form in form_vector) {
    handle = curl::new_handle()
    curl::handle_setheaders(handle, .list = list(Authorization = glue::glue("Bearer {auth}")))
    curl::handle_setopt(handle, customrequest = "DELETE")
    r = curl::curl_fetch_memory(glue::glue("https://api.typeform.com/forms/{form}"), handle)
    cat("\n", r$status_code, " for ", form)
  }
}

#' Update a Form
#'
#' @param form_id the id o fhte form to update
#' @param form_object a typeform object
#' @param auth personal access token
#'
#' Overwrites the previously stored form with the given form_id. Any new fields in your request will be added to the form. Likewise, any fields you don't include in your request will be deleted from the form.
#'
#' @export
#'
update_form <- function(form_id, form_object, auth = config::get()$typeform) {
  type_put(paste0("forms/", form_id), form_object, auth = auth)
}

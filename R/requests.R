#' Send a request to the typeform API
#'
#' @param endpoint API endpoint
#' @param auth auth token. Defaults to a config.yml with a default => typeform entry
#'
#' @export
#'
type_request <- function(endpoint, auth = config::get()$typeform) {
  handle = curl::new_handle()
  curl::handle_setheaders(handle, .list = list(Authorization = glue::glue("Bearer {auth}")))
  curl::curl_fetch_memory(glue::glue("https://api.typeform.com/{endpoint}"), handle)
}

#' Send a post to the typeform API
#'
#' @inheritParams type_request
#' @param payload json containing a payload
#'
#' @return returns the response content
#' @export
#'
type_post <- function(endpoint, payload, auth = config::get()$typeform) {
  if (!"json" %in% class(payload))
    payload <- jsonlite::toJSON(payload, auto_unbox = TRUE)
  handle = curl::new_handle()
  curl::handle_setheaders(handle, .list = list(Authorization = glue::glue("Bearer {auth}")))
  curl::handle_setopt(handle, customrequest = "POST")
  curl::handle_setopt(handle, postfields = payload)
  response = curl::curl_fetch_memory(glue::glue("https://api.typeform.com/{endpoint}"), handle)
  response
}

#' Send a put to the typeform API
#'
#' @inheritParams type_post
#'
#' @return returns the response content
#' @export
#'
type_put <- function(endpoint, payload, auth = config::get()$typeform) {
  if (!"json" %in% class(payload))
    payload <- jsonlite::toJSON(payload, auto_unbox = TRUE)
  handle = curl::new_handle()
  curl::handle_setheaders(handle, .list = list(Authorization = glue::glue("Bearer {auth}")))
  curl::handle_setopt(handle, customrequest = "PUT")
  curl::handle_setopt(handle, postfields = payload)
  response = curl::curl_fetch_memory(glue::glue("https://api.typeform.com/{endpoint}"), handle)
  response
}

#' Create a Form Object
#'
#' Creates a list that can be appended with form fields, attachments, etc.
#'
#' reference: https://developer.typeform.com/create/reference/create-form/
#'
#' @param title Title of the form
#'
#' @export
#'
form_object <- function(title = paste("New Form", Sys.Date())) {
  x = list(title = title)
  class(x) <- c("list", "typeform")
  x
}

#' @param x object of class typeform
#'
#' @export
#'
print.typeform <- function(x) {
  print(jsonlite::toJSON(x, auto_unbox = T, pretty = TRUE))
}

#' Create settings for a form
#'
#'
#'
#' @param form_object the form object
#' @param settings a named list of settings.
#'
#'
#' @export
#'
form_settings <- function(form_object, settings = list(hide_navigation = FALSE)) {
  settings <- list(settings)
  form_object$settings <- c(form_object$settings, settings)
  form_object
}

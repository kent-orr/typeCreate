#' Create a form field, often a question in the form.
#'
#' reference: https://developer.typeform.com/create/reference/create-form/
#'
#' @param form_object a form created by type_create_form_object.
#' @param title the field title.
#' @param type type of field, See details for more.
#' @param ref the machine readable name for the referenced field.
#' @param properties field properties. Can be created with field_prop_multi or other appropraite functions.
#' @param validations array of validation statements
#' @param attachment images and other attachments
#' @param layout layout schema
#' @param verbose should a pretty printed json be shown after each call?
#'
#' @details # Type: Valid Values
#' - calendly
#' - datedropdown
#' - email
#' - file_upload
#' - group
#' - legal
#' - long_text
#' - matrix
#' - multiple_choice
#' - nps
#' - number
#' - opinion_scale
#' - payment
#' - phone_number
#' - picture_choice
#' - ranking
#' - rating
#' - short_text
#' - statement
#' - website
#' - yes_no
#'
#' @return returns the entire form object with the new field appended.
#' @export
#'
form_field <- function(form_object,
                       title,
                       type,
                       ref = snakecase::to_snake_case(title),
                       properties = NULL,
                       validations = NULL,
                       attachment = NULL,
                       layout = NULL,
                       verbose = FALSE) {
  field <- list(title = title,
                ref = ref,
                type = type,
                properties = properties,
                validations = validations,
                attachment = attachment,
                layout = layout)
  field <- field[!sapply(field, is.null)]
  form_object$fields <- append(form_object$fields, list(field))
  if (verbose)
    print(jsonlite::toJSON(form_object, auto_unbox = T, pretty = TRUE))
  invisible(form_object)
}

#' Create properties for a multiple choice field.
#'
#' Supplied to the `properties` argument in `type_create_form_field`.
#'
#' @param description The instructions for the question
#' @param labels human readable option labels
#' @param refs machine readable option labels
#' @param allow_multiple_selection boolean
#' @param randomize boolean
#' @param allow_other_choice boolean
#' @param vertical_alignment true to list answer choices vertically. false to list answer choices horizontally.
#'
#' @return returns a properties object to be used in creating a field
#' @export
#'
field_prop_multi <- function(
    description,
    labels,
    refs = snakecase::to_snake_case(labels),
    allow_multiple_selection = FALSE,
    randomize = FALSE,
    allow_other_choice = FALSE,
    vertical_alignment = TRUE) {

  choices = lapply(seq_along(labels), \(l) {
    list(label = labels[l],
         ref = refs[l])
  })


  properties <- list(
    description = description,
    choices = choices,
    allow_multiple_selection = allow_multiple_selection,
    randomize = randomize,
    allow_other_choice = allow_other_choice,
    vertical_alignment = vertical_alignment
  )

  properties
}

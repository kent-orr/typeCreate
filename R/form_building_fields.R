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

#' Create hidden fields
#'
#' @param form_object a form created by type_create_form_object.
#' @param fields a character vector of field names
#' @param verbose should a pretty printed json be shown after each call?
#'
#' @return
#' @export
#'
form_field_hidden <- function(form_object, fields, verbose = TRUE) {
  hidden <- fields
  form_object$hidden <- append(form_object$hidden, hidden[!hidden %in% form_object$hidden])
  if (length(form_object$hidden) == 1)
    form_object$hidden <- list(form_object$hidden)


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


#' Thank You Screens for Ending
#'
#' @inheritParams form_field
#' @param type Valid values: "thankyou_screen", "url_redirect". The type of thank you screen.
#' @param show_button T/F display button
#' @param button_text button text
#' @param button_mode Valid values: "reload", "default_redirect", "redirect"
#'
#' @return
#' @export
#'
#' @examples
thank_you_screens <- function(form_object,
                              title = "Response Recorded",
                              ref = snakecase::to_snake_case(title),
                              type = "thankyou_screen",
                              show_button = TRUE,
                              button_text = "Record Again",
                              button_mode = "reload",
                              share_icons = FALSE,
                              verbose = TRUE) {

  thankyou_screens <- list(ref = ref,
                           title = title,
                           type = type,
                           properties = list(
                             show_button = show_button,
                             button_text = button_text,
                             button_mode = button_mode,
                             share_icons = share_icons
                           ))

  # browser()

  if (length(form_object$thankyou_screens) == 0) {
    form_object$thankyou_screens <- list(thankyou_screens)
  } else {
    form_object$thankyou_screens <- append(form_object$thankyou_screens, thankyou_screens[!thankyou_screens %in% form_object$thankyou_screens])
  }

  if (verbose)
    print(jsonlite::toJSON(form_object, auto_unbox = T, pretty = TRUE))
  invisible(form_object)
}

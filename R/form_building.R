#' Create a Form Object
#'
#' Creates a list that can be appended with form fields, attachments, etc.
#'
#' @param title Title of the form
#'
#' @export
#'
type_create_form_object <- function(title = paste("New Form", Sys.Date())) {
  x = list(title = title)
  class(x) <- c("list", "typeform")
  x
}

#' Create a form field, often a question in the form.
#'
#' @param form_object a form created by type_create_form_object.
#' @param title the field title.
#' @param type type of field, See details for more.
#' @param ref the machine readable name for the referenced field.
#' @param properties field properties. Can be created with field_multiple_choice_properties or other appropraite functions.
#' @param validations array of validation statements
#' @param attachment images and other attachments
#' @param layout layout schema
#' @param verbose should a pretty printed json be shown after each call?
#'
#' @details
#' @details # Type: Valid Values
#'  "calendly" "datedropdown" "email" "file_upload" "group" "legal" "long_text matrix"
#'  "multiple_choice" "nps" "number" "opinion_scale" "payment" "phone_number"
#'  "picture_choice" "ranking" "rating" "short_text" "statement" "website" "yes_no"
#'
#' @return returns the entire form object with the new field appended.
#' @export
#'
type_create_form_field <- function(form_object,
                                   title,
                                   type,
                                   ref = snakecase::to_snake_case(title),
                                   properties = NULL,
                                   validations = NULL,
                                   attachment = NULL,
                                   layout = NULL,
                                   verbose = TRUE) {
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
field_multiple_choice_properties <- function(
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

type_create_logic_jump <- function(
    form_object,
    ref, # ref from
    to, # ref to
    operation = "equal", # operation being applied

    type = "field" # what type of valu is being monitored
) {

  logic_field <- list(
    ref = ref,
    type = type,
    actions = list(
      type = "jump",
      jump = list(
        to = list(
          type = "field", value = to
        )
      ),
      condition = list(
        op = operation
      )
    )
  )

  jsonlite::toJSON(logic_field, pretty = TRUE, auto_unbox = T)
  # form_object$logic <- append(form_object$logic, list(logic_field))
  # form_object
}

# type_create_logic_jump(new_form2, "q_2", "q_1")
#
# print.typeform <- function(x) {
#   print(jsonlite::toJSON(x, auto_unbox = T, pretty = TRUE))
# }
#
# new_form2 <- type_create_form_object() |>
#   type_create_form_field("Q1", "multiple_choice",
#                          properties = field_multiple_choice_properties(
#                            "What of these is the answer?",
#                            c("A", "B", "C")
#                          )) |>
#   type_create_form_field("Q2", "short_text") |>
#
#   response = type_post("forms", new_form2)
# new_form2
# response$content |> rawToChar() |> jsonlite::fromJSON()
#
# new_form <- type_create_form_object() |>
#   type_create_form_field("Point of Sale", "multiple_choice",
#                          properties = field_multiple_choice_properties(
#                            "What Point of Sale are you Counting For?",
#                            paste(pos$pos_name, pos$pos_location),
#                            pos$pos_id
#                          )) |>
#   type_create_form_field("Category", "multiple_choice",
#                          properties = field_multiple_choice_properties(
#                            "What Product Category is being counted?",
#                            sort(unique(products$inv_category))
#                          ))
# for (i in sort(unique(products$inv_category))) {
#   cat_products = subset(products, inv_category == i)
#   choice_items = paste(cat_products$inv_item, cat_products$inv_unit)
#   ref_items = cat_products$inv_id
#   new_form <- type_create_form_field(new_form,
#                                      paste(i, "Items"), "multiple_choice",
#                                      ref = snakecase::to_snake_case(i),
#                                      properties = field_multiple_choice_properties(
#                                        paste("What", i, "is being counted"),
#                                        c(choice_items),
#                                        c(ref_items)
#                                      ))
# }
#
# response = type_post("forms", new_form)
# new_form
# response$content |> rawToChar() |> jsonlite::fromJSON()
#
# payload = list(
#   title = "New API Form2",
#   fields = list(
#     list(
#       type = "short_text",
#       title = "Airspeed?"
#     )
#   )
# )

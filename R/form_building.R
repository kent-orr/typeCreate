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
#' @details
#' @details # Type: Valid Values
#'  "calendly" "datedropdown" "email" "file_upload" "group" "legal" "long_text matrix"
#'  "multiple_choice" "nps" "number" "opinion_scale" "payment" "phone_number"
#'  "picture_choice" "ranking" "rating" "short_text" "statement" "website" "yes_no"
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

#' Create a logic field
#'
#' @param form_object a form object
#' @param ref the field for which a logical condition is checked
#' @param ref_type either "field" or "hidden"
#' @param actions an array of actions and conditions. Caan be created with functions like `jump_actions()`.
#'
#' @export
#'
form_logic <- function(
    form_object,
    ref,
    ref_type,
    actions) {
  logic_field <-
    list(ref = ref, type = ref_type,
         actions = actions
         )

  form_object$logic <- append(form_object$logic, list(logic_field))
  form_object
  }

#' Create vector of actions for a logic jump ref
#'
#' @param ref the reference being checked in the condition. Often the same ref as the logic field
#' @param to the ref to jump to
#' @param operation the operation to be applied
#' @param op_value the value being tested in the operation
#' @param monitored_type the type of field, "hidden" or "field" being checked in the operation
#'
#' @return returns a field that can be nested in the actions array of a logic jump.
#' @export
#'
actions_jump_multi <- function(ref, to, operation, op_value, monitored_type) {
  lapply(seq_along(to), \(i) {
  list(
    action = "jump",
    details = list(
      to = list(
        type = "field",
        value = to[i]
      )
    ), # end details
    condition = list(
      op = operation,
      vars = list(
        list(type = monitored_type,
             value = ref),
        list(type = "choice",
             value = op_value[i])
      )
    )
  )
  })
}

#' Create a "jump always" action for a logic field
#'
#' @param to the ref to jump to
#'
#' @export
#'
actions_jump_always <- function(to) {
  lapply(seq_along(to), \(i) {
    list(
      action = "jump",
      details = list(
        to = list(
          type = "field",
          value = to[i]
        )
      ), # end details
      condition = list(
        op = "always",
        vars = list()
      )
    )
  })
}


# type_create_logic_jump(new_form2, "q_2", "q_1")
#

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

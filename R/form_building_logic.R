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

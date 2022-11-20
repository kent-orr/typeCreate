conn <- DBI::dbConnect(RSQLite::SQLite(), "/home/kent/Documents/beverage2/data/appdata.sqlite")
products <- DBI::dbReadTable(conn, "products")
pos <- DBI::dbReadTable(conn, "points_of_sale")
DBI::dbDisconnect(conn)

new_form <- function(x) {
  assign("form_", x, envir = .GlobalEnv)
}

products <- function(x) {
  DBI::dbReadTable(conn, "products")
}

pos <- function(x) {
  DBI::dbReadTable(conn, "points_of_sale")
}

event_id = "123"

generate_form <- function(event_id, pos, products, new_form) {
  form <- form_object(event_id) |>
    form_field("Point of Sale", "multiple_choice", "pos",
               properties = field_prop_multi(
                 "What Point of Sale are you counting?",
                 labels = paste(pos()$pos_name, pos()$pos_location),
                 refs = pos()$pos_id
               )) |>
    form_field("Product Category", "multiple_choice", "inv_category",
               properties = field_prop_multi(
                 "What Category Item are you counting?",
                 labels = unique(products()$inv_category),
                 refs = snakecase::to_snake_case(unique(products()$inv_category))
               )) |>
    form_logic("inv_category", "field",
               actions = actions_jump_multi(
                 ref = "inv_category",
                 to = snakecase::to_snake_case(unique(products()$inv_category)),
                 operation = "is",
                 op_value = snakecase::to_snake_case(products()$inv_category) |> unique(),
                 monitored_type = "field"
               )) |>
    form_field_hidden(c("audit_id", "volunteer"))
  new_form(form)

  for (i in sort(unique(products()$inv_category))) {
    cat_products = subset(products(), inv_category == i)
    choice_items = paste(cat_products$inv_item, cat_products$inv_unit)
    ref_items = cat_products$inv_id
    form <- form_
    form <- form_field(form,
                       title = paste(i, "Items"),
                       type = "multiple_choice",
                       ref = snakecase::to_snake_case(i),
                       properties =  field_prop_multi(
                         description = paste("What", i, "is being counted?"),
                         labels = choice_items,
                         refs = ref_items
                       ))
    form <- form_logic(form,
                       ref = snakecase::to_snake_case(i),
                       ref_type = "field",
                       actions = actions_jump_always("batches"))
    new_form(form)
  }

  form <- form_
  form <- form |>
    form_field("Batch / Case / Whole Bottles",
               "number",
               "batches"
    ) |>
    form_field("Units",
               "number",
               "units"
    ) |>
    thank_you_screens()

  new_form(form)
}

generate_form("123", pos, products, new_form)

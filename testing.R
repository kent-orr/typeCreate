conn <- DBI::dbConnect(RSQLite::SQLite(), "/home/kent/Documents/beverage2/data/appdata.sqlite")
products <- DBI::dbReadTable(conn, "products")
pos <- DBI::dbReadTable(conn, "points_of_sale")
DBI::dbDisconnect(conn)



new_form <- form_object(Sys.time()) |>
  form_field("Point of Sale", "multiple_choice", "pos",
             properties = field_prop_multi(
               "What Point of Sale are you counting?",
               labels = paste(pos$pos_name, pos$pos_location),
               refs = pos$pos_id
             )) |>
  form_field("Product Category", "multiple_choice", "inv_category",
             properties = field_prop_multi(
               "What Category Item are you counting?",
               labels = unique(products$inv_category),
               refs = snakecase::to_snake_case(unique(products$inv_category))
             )) |>
  form_logic("inv_category", "field",
              actions = actions_multi_jump(
                ref = "inv_category",
                to = snakecase::to_snake_case(products$inv_category) |> unique(),
                operation = "is",
                op_value = snakecase::to_snake_case(products$inv_category) |> unique(),
                monitored_type = "field"
              ))

for (i in sort(unique(products$inv_category))) {
  cat_products = subset(products, inv_category == i)
  choice_items = paste(cat_products$inv_item, cat_products$inv_unit)
  ref_items = cat_products$inv_id
  new_form <- form_field(new_form,
                         paste(i, "Items"), "multiple_choice",
                         ref = snakecase::to_snake_case(i),
                         properties =  field_prop_multi(
                                       paste("What", i, "is being counted"),
                                       c(choice_items),
                                       c(ref_items)
                                     )) |>
    form_logic(snakecase::to_snake_case(i), "field",
                actions = actions_jump_always("batches"))
}

new_form <- new_form |>
  form_field("Batch / Case / Whole Bottles",
             "number",
             "batches"
             ) |>
  form_field("Units",
             "number",
             "units"
  )

response = type_post("forms", new_form)
response$content |> rawToChar() |> jsonlite::fromJSON()
new_form

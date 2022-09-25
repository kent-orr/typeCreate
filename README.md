# typeCreate

Generate and retrieve typeorms via the typeform API.

## Authentication

Authentication is done vi Typeform's API [personal access token](https://developer.typeform.com/get-started/personal-access-token/).
The package itself assumes a .yml in your home directory compatible with the `config` package. 

```
default:
  typeform: personal_access_token_here
```

## Creating a Form 

Forms are built with a functional approach. Form objects are passed to various builder functions which in turn augment form attributes such as fields (questions asked) and logic (question jumping, etc.)

```{r}
new_form <- form_object(title = "New Form") |>
  form_field(
   title = "Select a Color",
   type = "multiple_choice",
   ref = "color_select",
   properties = field_prop_multi(
      description = "Select a color form the given choices",
      labels = c("Red", "Blue", "Green")
     )
  ) |>
  form_field(
   title = "What is Your Name?",
   type = "short_text"
     )
     
link <- create_form(new_form)
browseURL(link)
```

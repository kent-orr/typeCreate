# typeCreate

R package for Typeform
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
## Retrieving a Form

```
resp = type_responses(form_id = "AguBBFpm", attempt_table = TRUE, wide_table = TRUE)

#            submitted_at                      response_id   pos_id      pos inv_category
# 1: 2022-09-21T00:01:06Z obx46fal3eblr416tjobx42qlp7msdlg          d37b200d         wine
# 2: 2022-09-21T01:26:50Z m6fdni5fb8ri5hin8m6fdniq31gctwbe          213ea65a    cocktails
# 3: 2022-09-25T01:41:51Z u8ggs06blzeyub7u9u8ggslrxcnf6j51 d37b200d d37b200d         wine

resp = type_responses(form_id = "AguBBFpm", attempt_table = TRUE, wide_table = FALSE)

#            submitted_at                      response_id          ref    value     field.id ...
# 1: 2022-09-21T00:01:06Z obx46fal3eblr416tjobx42qlp7msdlg       pos_id                  <NA> ...
# 2: 2022-09-21T00:01:06Z obx46fal3eblr416tjobx42qlp7msdlg          pos d37b200d vfQnvGa49XbD ...
# 3: 2022-09-21T00:01:06Z obx46fal3eblr416tjobx42qlp7msdlg inv_category     wine 6J6TRkaRRVZM ...
# 4: 2022-09-21T00:01:06Z obx46fal3eblr416tjobx42qlp7msdlg         wine bbd938a0 oiCSoMYa9tWd ...
# 5: 2022-09-21T00:01:06Z obx46fal3eblr416tjobx42qlp7msdlg      batches       12 7OFLA5btRdso ...
# 6: 2022-09-21T00:01:06Z obx46fal3eblr416tjobx42qlp7msdlg        units        1 qMLSqQQEnnMA ...

resp = type_responses(form_id = "AguBBFpm", attempt_table = FALSE, wide_table = FALSE)

# List of 3
# $ total_items: int 3
# $ page_count : int 1
# $ items      :'data.frame':	3 obs. of  9 variables:
#   ..$ landing_id  : chr [1:3] "u8ggs06blzeyub7u9u8ggslrxcnf6j51" "m6fdni5fb8ri5hin8m6fdniq31gctwbe" "obx46fal3eblr416tjobx42qlp7msdlg"
# ..$ token       : chr [1:3] "u8ggs06blzeyub7u9u8ggslrxcnf6j51" "m6fdni5fb8ri5hin8m6fdniq31gctwbe" "obx46fal3eblr416tjobx42qlp7msdlg"
# ..$ response_id : chr [1:3] "u8ggs06blzeyub7u9u8ggslrxcnf6j51" "m6fdni5fb8ri5hin8m6fdniq31gctwbe" "obx46fal3eblr416tjobx42qlp7msdlg"
# ..$ landed_at   : chr [1:3] "2022-09-25T01:41:40Z" "2022-09-21T01:26:39Z" "2022-09-21T00:00:51Z"
# ..$ submitted_at: chr [1:3] "2022-09-25T01:41:51Z" "2022-09-21T01:26:50Z" "2022-09-21T00:01:06Z"
# ..$ metadata    :'data.frame':	3 obs. of  5 variables:
#   ..$ hidden      :'data.frame':	3 obs. of  1 variable:
#   ..$ calculated  :'data.frame':	3 obs. of  1 variable:
#   ..$ answers     :List of 3
```

# typeCreate

R package for Typeform
Generate and retrieve typeorms via the typeform API.

## Authentication

Authentication is done vi Typeform's API [personal access token](https://developer.typeform.com/get-started/personal-access-token/).
The package itself assumes a `config.yml` file in your home directory compatible with the `config` package. 

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

A full form as a listin R will have the following structure:

```
List of 12
 $ cui_settings    :List of 1
  ..$ avatar: chr "https://images.typeform.com/images/4BKUhw8A9cSM"
 $ fields          :'data.frame':	19 obs. of  7 variables:
  ..$ attachment :'data.frame':	19 obs. of  4 variables:
  ..$ properties :'data.frame':	19 obs. of  21 variables:
  ..$ ref        : chr [1:19] "nice_readable_date_reference" "nice_readable_dropdown_reference" "nice_readable_email_reference" "nice_readable_file_upload_reference" ...
  ..$ title      : chr [1:19] "Date Title" "Dropdown Title" "Email Title" "File Upload Title" ...
  ..$ type       : chr [1:19] "date" "dropdown" "email" "file_upload" ...
  ..$ validations:'data.frame':	19 obs. of  4 variables:
  ..$ layout     :'data.frame':	19 obs. of  3 variables:
 $ hidden          : chr [1:3] "var1" "var2" "var3"
 $ logic           :'data.frame':	1 obs. of  3 variables:
  ..$ actions:List of 1
  ..$ ref    : chr "nice_readable_yes_no_reference"
  ..$ type   : chr "field"
 $ settings        :List of 16
  ..$ facebook_pixel            : chr "4347295725729872"
  ..$ google_analytics          : chr "UA-1111-22"
  ..$ google_tag_manager        : chr "GTM-43959999"
  ..$ hide_navigation           : logi FALSE
  ..$ is_public                 : logi FALSE
  ..$ language                  : chr "en"
  ..$ meta                      :List of 5
  ..$ notifications             :List of 2
  ..$ progress_bar              : chr "percentage"
  ..$ redirect_after_submit_url : chr "https://www.redirecttohere.com"
  ..$ show_cookie_consent       : logi FALSE
  ..$ show_number_of_submissions: logi FALSE
  ..$ show_progress_bar         : logi TRUE
  ..$ show_question_number      : logi TRUE
  ..$ show_time_to_complete     : logi TRUE
  ..$ show_typeform_branding    : logi FALSE
 $ thankyou_screens:'data.frame':	1 obs. of  4 variables:
  ..$ attachment:'data.frame':	1 obs. of  2 variables:
  ..$ properties:'data.frame':	1 obs. of  5 variables:
  ..$ ref       : chr "nice-readable-thank-you-ref"
  ..$ title     : chr "Thank you Title"
 $ theme           :List of 1
  ..$ href: chr "https://api.typeform.com/themes/qHWOQ7"
 $ title           : chr "This is an example form"
 $ type            : chr "form"
 $ variables       :List of 4
  ..$ age  : int 28
  ..$ name : chr "typeform"
  ..$ price: num 10.6
  ..$ score: int 0
 $ welcome_screens :'data.frame':	1 obs. of  4 variables:
  ..$ layout    :'data.frame':	1 obs. of  3 variables:
  ..$ properties:'data.frame':	1 obs. of  3 variables:
  ..$ ref       : chr "nice-readable-welcome-ref"
  ..$ title     : chr "Welcome Title"
 $ workspace       :List of 1
  ..$ href: chr "https://api.typeform.com/workspaces/Aw33bz"s
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

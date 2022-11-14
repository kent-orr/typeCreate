form_id = "AguBBFpm"

#' Get a list of webhooks
#'
#' @param form_id form id, can be foundin URL
#' @param auth auth
#'
#' @export
#'
get_webhooks <- function(form_id, auth = config::get()$typeform) {
  response = type_request(glue::glue("forms/{form_id}/webhooks"), auth = auth)
  stopifnot("Did not return status 2xx" = floor(as.integer(response$status_code)) == 200L)
  response$content |>
    rawToChar() |>
    jsonlite::fromJSON() |>
    {\(x) x[["items"]]}()
}

#' Create or Update a Webhook
#'
#' @param form_id the form id, can be found in url
#' @param tag a tag for the webhook. Required.
#' @param url url to point the webhook to.
#' @param ... see details
#' @param auth auth
#'
#' @details
#' enabled: boolean
#' True if you want to send responses to the webhook immediately. Otherwise, false.
#' secret: string
#' If specified, will be used to sign the webhook payload with HMAC SHA256, so that you can verify that it came from Typeform.
#' url: string
#' Webhook URL.
#' verify_ssl: boolean
#' True if you want Typeform to verify SSL certificates when delivering payloads.
#'
#' @export
#'
create_webhook <- function(form_id, tag, url, ..., auth = config::get()$typeform) {
  payload <- list(enabled = TRUE,
                  secret = "typeCreate",
                  url = url,
                  verify_ssl = TRUE)
  x = list(...)
  if (length(x) > 0) {
    nm = names(x)
    vals = unlist(x)
    for (i in seq_along(nm)) {
      payload[nm[i]] <- vals[i]
    }
  }
  type_put(glue::glue("forms/{form_id}/webhooks/{tag}"), payload, auth = auth)
}

#' Create or Update a Webhook
#'
#' @inheritParams create_webhook
#'
#' @export
update_webhook <- function(form_id, tag, url, ..., auth = config::get()$typeform) {
  create_webhook(form_id, tag, url, ..., auth = config::get()$typeform)
}

delete_webhook <- function(form_id, tag, auth = config::get()$typeform) {
  type_delete(glue::glue("forms/{form_id}/webhooks/{tag}"), payload = NULL, auth = auth)
}

sample_payload <- '{
    "event_id": "01GE3H6AS5FGFB3BZ2J1Z8WJGV",
    "event_type": "form_response",
    "form_response": {
        "form_id": "AguBBFpm",
        "token": "k1cbijgll9mmh5k1xyi6yuzuuetaxend",
        "landed_at": "2022-09-29T02:28:30Z",
        "submitted_at": "2022-09-29T02:28:43Z",
        "hidden": {
            "pos_id": "xxxxx"
        },
        "definition": {
            "id": "AguBBFpm",
            "title": "2022-09-20 19:58:39",
            "fields": [
                {
                    "id": "vfQnvGa49XbD",
                    "ref": "pos",
                    "type": "multiple_choice",
                    "title": "Point of Sale",
                    "properties": {},
                    "choices": [
                        {
                            "id": "wsLJhwTkoEBh",
                            "label": "Beverage Tent #1 North Brentwood"
                        },
                        {
                            "id": "EHFdTCcq9Bfk",
                            "label": "Beverage Tent #2 Brentwood & Forsyth"
                        },
                        {
                            "id": "JkBZyBHHvccw",
                            "label": "Beverage Tent #3 North Meramec"
                        },
                        {
                            "id": "iJ3AebkqNysx",
                            "label": "Beverage Tent #4 Forsyth at Meramec"
                        },
                        {
                            "id": "H4D3f6KeOuFh",
                            "label": "Beverage Tent #5 Forsyth and Central"
                        },
                        {
                            "id": "38PaijFR8kbs",
                            "label": "Beverage Tent #6 South Central"
                        }
                    ]
                },
                {
                    "id": "6J6TRkaRRVZM",
                    "ref": "inv_category",
                    "type": "multiple_choice",
                    "title": "Product Category",
                    "properties": {},
                    "choices": [
                        {
                            "id": "BGjslVcf0wyM",
                            "label": "Craft Beer"
                        },
                        {
                            "id": "kHM9Bf6v6UvJ",
                            "label": "Seltzer"
                        },
                        {
                            "id": "deJy4aZ4RUJa",
                            "label": "Soda"
                        },
                        {
                            "id": "3RAmbuQIximS",
                            "label": "Wine"
                        },
                        {
                            "id": "UZBp6dJj3Lvd",
                            "label": "Cocktails"
                        },
                        {
                            "id": "qfmwW1S8OGXw",
                            "label": "Cups"
                        },
                        {
                            "id": "TxnOQAlt9jXb",
                            "label": "Draft Beer"
                        }
                    ]
                },
                {
                    "id": "gRX6IeJF00AA",
                    "ref": "cocktails",
                    "type": "multiple_choice",
                    "title": "Cocktails Items",
                    "properties": {},
                    "choices": [
                        {
                            "id": "v07lsCu8mxBW",
                            "label": "Vodka Mule Can"
                        },
                        {
                            "id": "cuZVjOVsv8Ts",
                            "label": "Margarita 750 ml"
                        }
                    ]
                },
                {
                    "id": "7OFLA5btRdso",
                    "ref": "batches",
                    "type": "number",
                    "title": "Batch / Case / Whole Bottles",
                    "properties": {}
                },
                {
                    "id": "qMLSqQQEnnMA",
                    "ref": "units",
                    "type": "number",
                    "title": "Units",
                    "properties": {}
                }
            ]
        },
        "answers": [
            {
                "type": "choice",
                "choice": {
                    "label": "Beverage Tent #2 Brentwood & Forsyth"
                },
                "field": {
                    "id": "vfQnvGa49XbD",
                    "type": "multiple_choice",
                    "ref": "pos"
                }
            },
            {
                "type": "choice",
                "choice": {
                    "label": "Cocktails"
                },
                "field": {
                    "id": "6J6TRkaRRVZM",
                    "type": "multiple_choice",
                    "ref": "inv_category"
                }
            },
            {
                "type": "choice",
                "choice": {
                    "label": "Vodka Mule Can"
                },
                "field": {
                    "id": "gRX6IeJF00AA",
                    "type": "multiple_choice",
                    "ref": "cocktails"
                }
            },
            {
                "type": "number",
                "number": 0,
                "field": {
                    "id": "7OFLA5btRdso",
                    "type": "number",
                    "ref": "batches"
                }
            },
            {
                "type": "number",
                "number": 9,
                "field": {
                    "id": "qMLSqQQEnnMA",
                    "type": "number",
                    "ref": "units"
                }
            }
        ]
    }
}'

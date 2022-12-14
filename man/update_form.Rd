% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/account_mgmt.R
\name{update_form}
\alias{update_form}
\title{Update a Form}
\usage{
update_form(form_id, form_object, auth = config::get()$typeform)
}
\arguments{
\item{form_id}{the id of the form to update}

\item{form_object}{a typeform object}

\item{auth}{personal access token

Overwrites the previously stored form with the given form_id. Any new fields in your request will be added to the form. Likewise, any fields you don't include in your request will be deleted from the form.}
}
\description{
Update a Form
}

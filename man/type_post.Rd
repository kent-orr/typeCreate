% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/requests.R
\name{type_post}
\alias{type_post}
\title{Send a post to the typeform API}
\usage{
type_post(endpoint, payload, auth = config::get()$typeform)
}
\arguments{
\item{endpoint}{API endpoint}

\item{payload}{json containing a payload}

\item{auth}{auth token. Defaults to a config.yml with a default => typeform entry}
}
\value{
returns the response content
}
\description{
Send a post to the typeform API
}

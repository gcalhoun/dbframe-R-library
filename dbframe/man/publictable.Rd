\name{dftable}
\alias{dftable}
\title{Construct a nice table from a data frame}
\description{Constructs an attractive LaTeX table (that uses booktabs)
  from an arbitrary data frame.}
\usage{
dftable(dframe, align, digits, tabular.environment = "tabularx",
        sanitize.text.function = function(x) x, drop = NULL,
        include.rownames = FALSE,...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dframe}{The data frame}
  \item{align}{Alignment}
  \item{digits}{Number of digits for each column.}
  \item{tabular.environment}{Defaults to using tabularx in LaTeX.}
  \item{sanitize.text.function}{Disables escaping out backslashes, etc.}
  \item{\dots}{Additional arguments to pass to \code{xtable}.}
}
\details{This function uses \code{xtable} to generate the LaTeX, then
  modifies the table.}
\value{LaTeX code for a table.}

\author{Gray Calhoun \email{gcalhoun@iastate.edu}}
\seealso{\code{\link{xtable}}}
\examples{###
}
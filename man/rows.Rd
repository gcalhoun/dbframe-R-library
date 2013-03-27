% -*- mode: noweb; noweb-default-code-mode: R-mode -*-
% Copyright (C) 2011  Gray Calhoun

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with this program.  If not, see
% <http://www.gnu.org/licenses/>.

\name{rows}
\alias{rows}
\title{Extract rows from a data frame and present as a list}
\description{This is a convenience function that takes a dataframe \dQuote{x}
  and returns a list where each element is a row of x.  I use this for
  loops.}
\usage{
rows(x)
}

\arguments{
  \item{x}{A data frame or an object that can be coerced to a data frame.}
}

\value{A list; each element is a row of \code{x}.}
\author{Gray Calhoun \email{gcalhoun@iastate.edu}}

\section{Implementation}{
\preformatted{<<*>>=
    rows <- function(x) \{
      x <- as.data.frame(x)
      if (nrow(x) > 0) \{
        lapply(seq.int(nrow(x)), function(i) x[i,])
      \} else \{
        list()
      \}
    \}
} 
}

\examples{
data(chickwts)
for (r in rows(head(chickwts))) print(r)
}
\keyword{utilities}


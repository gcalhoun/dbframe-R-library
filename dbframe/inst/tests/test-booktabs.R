context("Tests for 'booktabs'")
filename <- tempfile(fileext = ".db")
library(xtable)

data(morley)
test_that("booktabs executes at all", {
  expect_that(booktabs(morley), is_a("character"))
})


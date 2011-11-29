context("Not sure, just getting started")

data(chickwts)
## Unfortunately, dbframe doesn't handle factors right now.
chickwts$feed <- as.character(chickwts$feed)
## the first test is really basic; if we put in some data, do we get
## it out?
test_that("insert and select work", {
   example.dbframe <- dbframe("table1", "/tmp/example.db")
   clear(example.dbframe)
   insert(example.dbframe) <- chickwts
   expect_that(chickwts, is_equivalent_to(select(example.dbframe)))
})



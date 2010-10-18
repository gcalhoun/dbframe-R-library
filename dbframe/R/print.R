print.dbview <- function(x,...) {
  print("dbview object; first 5 rows:")
  print(query(x, "select * from %s limit 5"))
}
print.dbframe <- function(x,...) {
  print("dbframe object; first 5 rows:")
  print(query(x, "select * from %s limit 5"))
}

test_that("DBI monitor works as expected", {
  skip_if_not_installed("RSQLite")

  t <- trajectory() %>%
    timeout(1) %>%
    set_attribute("time", 1) %>%
    timeout(1) %>%
    seize("resource") %>%
    timeout(1) %>%
    release("resource")

  env_mem <- simmer() %>%
    add_resource("resource") %>%
    add_generator("dummy", t, at(0), mon=2) %>%
    run()

  con <- DBI::dbConnect(RSQLite::SQLite())
  expect_equal(DBI::dbListTables(con), character())

  mon <- monitor_dbi(con, auto_disconnect=TRUE)
  env_dbi <- simmer(mon=mon) %>%
    add_resource("resource") %>%
    add_generator("dummy", t, at(0), mon=2) %>%
    run()

  tables <- sort(unlist(mon$handlers, use.names=FALSE))
  expect_equal(sort(DBI::dbListTables(con)), tables)

  expect_equal(nrow(DBI::dbReadTable(con, tables[1])), 1)
  expect_equal(nrow(DBI::dbReadTable(con, tables[2])), 1)
  expect_equal(nrow(DBI::dbReadTable(con, tables[3])), 1)
  expect_equal(nrow(DBI::dbReadTable(con, tables[4])), 2)

  df <- within(get_mon_arrivals(env_dbi, FALSE), finished <- as.logical(finished))
  expect_equal(get_mon_arrivals(env_mem, FALSE), df)
  expect_equal(get_mon_arrivals(env_mem, TRUE), get_mon_arrivals(env_dbi, TRUE))
  expect_equal(get_mon_attributes(env_mem), get_mon_attributes(env_dbi))
  expect_equal(get_mon_resources(env_mem), get_mon_resources(env_dbi))
})

test_that("DBI monitor honors 'auto_disconnect' and 'keep'", {
  skip_if_not_installed("RSQLite")

  con <- DBI::dbConnect(RSQLite::SQLite())
  expect_equal(DBI::dbListTables(con), character())

  mon_ff <- monitor_dbi(con, auto_disconnect = FALSE, keep = FALSE)
  mon_ft <- monitor_dbi(con, auto_disconnect = FALSE, keep = TRUE)
  mon_t <- monitor_dbi(con, auto_disconnect = TRUE)

  tables_ff <- sort(unlist(mon_ff$handlers, use.names=FALSE))
  tables_ft <- sort(unlist(mon_ft$handlers, use.names=FALSE))
  tables_t <- sort(unlist(mon_t$handlers, use.names=FALSE))
  expect_equal(sort(DBI::dbListTables(con)), sort(c(tables_ff, tables_ft, tables_t)))

  rm(mon_ff, mon_ft); invisible(gc())
  expect_true(DBI::dbIsValid(con))
  expect_equal(sort(DBI::dbListTables(con)), sort(c(tables_ft, tables_t)))

  rm(mon_t); invisible(gc())
  expect_false(DBI::dbIsValid(con))
})

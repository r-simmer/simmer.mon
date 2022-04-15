#' Create a DBI Monitor
#'
#' Methods for creating database-backed (\pkg{DBI}-based) \code{monitor} objects.
#' 
#' @inheritParams DBI::dbCreateTable
#' @param auto_disconnect whether the connection should be automatically closed
#' when the monitor is deleted. Set to \code{TRUE} if you initialised the
#' connection inside the call to \code{memory_dbi}.
#' @param keep whether to keep the tables created on exit. By default, tables
#' are removed.
#'
#' @return A \code{monitor} object.
#'
#' @export
monitor_dbi <- function(conn, auto_disconnect=FALSE, keep=FALSE) {
  pattern <- basename(tempfile(pattern=""))
  tables <- list(
    arrivals = paste0("arrivals_", pattern),
    releases = paste0("releases_", pattern),
    attributes = paste0("attributes_", pattern),
    resources = paste0("resources_", pattern)
  )
  fields <- get_fields()
  dbClear <- function() {
    for (table in names(tables)) {
      if (DBI::dbExistsTable(conn, tables[[table]]))
        DBI::dbClearResult(
          DBI::dbSendStatement(conn, paste("drop table", tables[[table]])))
      DBI::dbCreateTable(conn, tables[[table]], fields[[table]])
    }
  }
  dbClear()
  
  monitor(
    "to database (DBI interface)",
    DBIMonitor__new(
      tables[[1]], tables[[2]], tables[[3]], tables[[4]],
      dbClear, function(...) DBI::dbAppendTable(conn, ...)
    ),
    function(xptr, per_resource)
      do.call(DBI::dbReadTable, c(conn, ifelse(!per_resource, tables[[1]], tables[[2]]))),
    function(xptr) do.call(DBI::dbReadTable, c(conn, tables[[3]])),
    function(xptr) do.call(DBI::dbReadTable, c(conn, tables[[4]])),
    tables,
    function(...) {
      if(!keep) for (table in tables) DBI::dbRemoveTable(conn, table)
      if (auto_disconnect) DBI::dbDisconnect(conn)
    }
  )
}

get_fields <- function() {
  mon <- monitor_mem()
  list(
    arrivals = mon$get_arrivals(FALSE),
    releases = mon$get_arrivals(TRUE),
    attributes = mon$get_attributes(),
    resources = mon$get_resources()
  )
}

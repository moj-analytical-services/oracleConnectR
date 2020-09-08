#' Considerately run a SQL query, closing the database connection on completion.
#'
#' @param db_name A list containing database credentials
#' @param qry A character string containing a SQL query
#' @param qry_path A character string containing a path to a .sql file
#' @param config_path Optional character string with the location to the config
#' file with database connection details
#' @param driver Optional character string specifying the database driver to use (currently
#' supports 'odbc' (default) or 'ROracle'.
#' @param ... Optional arguments to be passed to write.csv
#'
#' @return A data frame containing records fetched by a SQL query
#' @export
#'
considerate_qry <- function(db_name, qry = NULL, qry_path = NULL, config_path = NULL, driver = NULL, ...){

  if(!xor(is.null(qry), is.null(qry_path)))
    stop("Exactly one of qry or qry_path must be supplied")

  if(!is.null(qry_path))
    qry <- paste(readLines(qry_path), collapse = "\n")

  con <- create_connection(db_name, config_path, driver)

  dat <- DBI::dbGetQuery(con, qry)

  DBI::dbDisconnect(con)

  if(!missing(...)) utils::write.csv(dat, ...)

  return(dat)
}


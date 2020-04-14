
#' Create an Oracle database connection
#'
#' @param db_name A character string specifying the name of the database
#' @param config_path A character string specifying the file path for the .yml
#' file containing database credentials (optional)
#'
#' @return A ROracle dbconnect object.
#' @export
#'
create_connection <- function(db_name, config_path = NULL){

  db_cred <- read_db_creds(db_name, config_path, check_type = "stop")
  db_cred <- db_cred[[1]]

  db_name <- sprintf(
    "(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=%s)(PORT=%s))(CONNECT_DATA=(SID=%s)))",
    db_cred$host, db_cred$port, db_cred$sid
  )

  drv <- DBI::dbDriver("Oracle")

  con <- ROracle::dbConnect(drv, db_cred$username, db_cred$password, db_name)

  return(con)
}



#' List Oracle database connections available
#'
#' @param config_path A character string specifying the file path for the .yml
#' file containing database credentials (optional)
#'
#' @return A character vector of database names
#' @export
#'
list_connections <- function(config_path = NULL){

  db_creds <- read_db_creds(config_path = config_path, check_type = "warning")

  return(names(db_creds))
}


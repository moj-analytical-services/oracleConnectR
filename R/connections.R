
#' Create an Oracle database connection
#'
#' @param db_name A character string specifying the name of the database
#' @param config_path A character string specifying the file path for the .yml
#' file containing database credentials (optional)
#' @param driver Optional character string specifying the database driver to use (currently
#' supports 'odbc' (default) or 'ROracle'.
#'
#' @return A dbconnect object.
#' @export
#'
create_connection <- function(db_name, config_path = NULL, driver = NULL){

  if(is.null(driver)){
    # first try with ROracle
    if((requireNamespace("ROracle", quietly = TRUE) == TRUE)){
      con <- create_ROracle_connection(db_name, config_path)
    }
    else{
      message("No driver argument provided to create_connection:
              ROracle not installed, trying odbc instead")

      con <- create_odbc_connection(db_name, config_path)
    }
  }
  else if(driver == "odbc"){
      con <- create_odbc_connection(db_name, config_path)
  }
  else if(driver == "ROracle"){
      con <- create_ROracle_connection(db_name, config_path)
  }

  else {
    stop("driver must be one of NULL, 'Roracle' or 'odbc'.")
  }

  return(con)
}

#' Create an Oracle database connection using ROracle
#'
#' @param db_name A character string specifying the name of the database
#' @param config_path A character string specifying the file path for the .yml
#' file containing database credentials (optional)
#'
#' @return A dbconnect object.
#'
create_ROracle_connection <- function(db_name, config_path = NULL){

  # Load ROracle library
  loadNamespace("ROracle")

  # get database credentials from config store
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

#' Create an Oracle database connection using odbc
#'
#' @param db_name A character string specifying the name of the database
#' @param config_path A character string specifying the file path for the .yml
#' file containing database credentials (optional)
#'
#' @return A dbconnect object.
#'
create_odbc_connection <- function(db_name, config_path = NULL){

  # get database credentials from config store
  db_cred <- read_db_creds(db_name, config_path, check_type = "stop")
  db_cred <- db_cred[[1]]

  con <- DBI::dbConnect(
      odbc::odbc(),
      db_cred$username,
      pwd  = db_cred$password,
      host = db_cred$host,
      port = db_cred$port
    )

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


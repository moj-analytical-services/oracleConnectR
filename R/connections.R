
#' Create an Oracle database connection
#'
#' @param db_name A character string specifying the name of the database
#' @param config_path A character string specifying the file path for the .yml
#' file containing database credentials (optional)
#' @param driver A character string specifying the driver package. Currently supports
#' options "ROracle" or "odbc". If left NULL it will first prioritise odbc over ROracle
#'
#' @return A dbconnect object.
#' @export
#'
create_connection <- function(db_name, config_path = NULL, driver = NULL){

  # get database credentials from config store
  db_cred <- read_db_creds(db_name, config_path, check_type = "stop")
  db_cred <- db_cred[[1]]

  # test that driver specifies an appropriate value
  if(!is.null(driver) && !(driver %in% c("ROracle", "odbc"))){
    stop("driver must be one of NULL, 'Roracle' or 'odbc'.")
  }

  # if driver is left as NULL identify the driver to use
  if(is.null(driver)){
    # prioritise odbc
    if("odbc" %in% installed.packages()){driver <- "odbc"}

    # else use ROracle
    else if("ROracle" %in% installed.packages()){driver <- "ROracle"}

    # otherwise return an error
    else{ stop("No supported database driver found: one of ROracle or odbc must be installed")}
  }

  # create the connection with the appropriate driver API
  if(driver == "ROracle"){
    db_name <- sprintf(
      "(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=%s)(PORT=%s))(CONNECT_DATA=(SID=%s)))",
      db_cred$host, db_cred$port, db_cred$sid
    )

    drv <- DBI::dbDriver("Oracle")

    con <- ROracle::dbConnect(drv, db_cred$username, db_cred$password, db_name)
  }
  else if(driver == "odbc"){

    con <- DBI::dbConnect(
      odbc::odbc(),
      db_cred$username,
      pwd  = db_cred$password,
      host = db_cred$host,
      port = db_cred$port
    )
  }

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


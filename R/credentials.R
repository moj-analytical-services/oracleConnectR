
#' Read .yml configuration file
#'
#' @param config_path A character string specifying the file path for the .yml
#' file containing database credentials (optional)
#'
#' @return A list containing the .yml file contents
#'
read_db_creds <- function(db_name = NULL, config_path = NULL, check_type = "warning"){

  if(is.null(config_path)){config_path <- get_config_path()}

  db_creds <- config::get(file = config_path)

  if(!is.null(db_name)) db_creds <- db_creds[names(db_creds) == db_name]

  check_db_creds(db_creds, check_type)

  return(db_creds)
}



#' Read config-path from system environment, and return a descriptive error if not found.
#'
#' @return A character string
#'
get_config_path <- function(){

  config_path <- Sys.getenv("config-path")

  if(config_path == "")
    stop("No config_path variable set; either define using config_path argument,
           or declare an environment variable `config-path`.")

  return(config_path)
}



#' Check that the contents of the provided .yml credentials file contains valid
#' database credentials.
#'
#' @param db_creds A list containing database credentials
#' @param check_type A character indicating whether errors found on checking should
#' induce a warning or a stop.
#'
#' @return A list containing the .yml file contents
#'
check_db_creds <- function(db_creds, check_type = "warning"){

  if(!(check_type %in% c("warning", "stop"))){
    stop("`check_type` should be either warning or stop.")
  }

  # identify if any credentials are missing
  db_missing <- lapply(db_creds, FUN = function(cred){
    setdiff(c("username", "password", "host", "port", "sid"), names(cred))
  })

  db_missing <- db_missing[lapply(db_missing, length) > 0]

  # error handling
  if(length(db_missing) == 0) return(invisible(TRUE))

  missing_str <- lapply(1:length(db_missing), function(i){
    sprintf("Some database connections are missing required credentials.\n %s - %s \n",
      names(db_missing)[i],
      paste(db_missing[[i]], collapse = ", ")
    )
  })

  if(check_type == "warning"){
    warning(missing_str)
  } else{
    stop(missing_str)
  }
}


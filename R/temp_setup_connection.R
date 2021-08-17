library(tidyverse)
library(yaml)


setup_connection <- function(db_name, username, password, host, port, sid){

  # 1. Check if config file alraedy exists

  config_path <- Sys.getenv("config-path")

  if(config_path == ""){
    config_exists <- FALSE
  } else {
    config_exists <- TRUE
  }

  # 1.1 Config file exists: Check if connection already exist

  if(config_exists == TRUE){

    # Search for connection in config file
    cons <- list_connections() %>%
      as.tibble() %>%
      filter(value == db_name) %>%
      pull()

    if(cons == ""){
      con_exists <- FALSE
    } else {
      con_exists <- TRUE
    }

  }

    # 1.1.1 Connection exisits

    if(con_exists == TRUE){
      # Ask user if they want to overwite connection
      ovewrite <- readline(prompt= paste0("The connection ", db_name, " already exists, do you want to overwrite? (y/N)"))
    }
        # 1.1.1.a Yes: Overwite connection

        if(tolower(ovewrite) == "y"){
          ### code to overwrite connection ###
        }


        # 1.1.1.b No: Do not overwrite, end function

        if(tolower(ovewrite) == "y"){
          stop("Connection has not been overwritten")
        }

    # 1.1.2 Connection dose not exist: go to 2





  # 1.2 Config filse dose not exist: create new config file

  if(config_exists == FALSE){

    # Create config file
    config_path <- paste0("C:/Users/", Sys.info()[["user"]], "/Documents/test.yml")
    file.create(config_path)

    # Add config file path to renviron
    r_environ_path <- usethis::edit_r_environ() # is there a better way to do this, as it opens the file also  #paste0("C:/Users/", Sys.info()[["user"]], "/Documents/.Renviron")
    renviron <- read.delim2(r_environ_path, sep = "\r", col.names = "vars", stringsAsFactors = FALSE)

    # variable to be added to .Renviron
    renviron_var <- base::paste0('config-path = "', config_path, '"')

    # Write new .renviron file
    readr::write_lines(renviron_var, r_environ_path, append = TRUE)

  }

  # 2. Add conection to config file






}


# Testing - function arguments

db_name <- "PAINT_LIVE"
username <- "PAINT_LIVE"
password <- "pwd123"
host <- "bbp-dca-lopt02"
port <- "1521"
sid <- "OPTLIVEW"











setup_connection <- function(db_name, username, password, host, port, sid){

  # 1. Check if config file alraedy exists


  # 1.1 Config file exists: Dose connection already exist


    # 1.1.1 Connection exisits

      # Ask user if they want to overwite connection

        # 1.1.1.a Yes: Overwite connection


        # 1.1.1.b No: Do not overwrite, end


    # 1.1.2 Connection dose not exist: go to 2



  # 1.2 Configle filse dose not exist: create new config file



  # 2. Add conection to config file



}

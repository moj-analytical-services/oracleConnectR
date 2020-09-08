# oracleConnectR

A minimal package to simplify connecting to Oracle databases from R
```r
library(oracleConnectR)

# connect to your database, query and disconnect all in one go
dat <- considerate_qry(con = "my-database", qry = "my-query")

# or create a database connection for running many queries against
con <- create_connection("my-database")
```

## Installation

The package has a number of critical dependencies which you will want to ensure are correctly installed first.
```r
install.packages("DBI")
install.packages("config")
```

In addition a database driver package is required: currently [`odbc`](https://db.rstudio.com/odbc/) and [`ROracle`](https://www.oracle.com/database/technologies/roracle-downloads.html) are supported.

The easiest way to install is by using the `devtools` package:

``` r
install.packages("devtools")
library(devtools)

devtools::install_github("moj-analytical-services/oracleConnectR", INSTALL_opts=c("--no-multiarch"))
```

Instructions of how to install without devtools are detailed at the end.

## Setup

Before you can connect to a database using the package, you will need to create a lookup of the database credentials you have access to.

The package expects credentials to be provided in a `.yml` configuration file, which is a best practice method [recommended](https://db.rstudio.com/best-practices/managing-credentials/) by Rstudio.

The template below sets out the expected format that database credentials are expected. Text in `<angle-brackets>` should be replaced with the specific details for your database connection. These details will have been provided to you by the datbase administrator (all but the password are also visible in SQL Developer).

```yml
default:
  <database_name_1>:
    username: '<username_1>'
    password: '<password_1>'
    host: '<host_1>'
    port: '<port_1>'
    sid: '<sid_1>'
    
  <database_name_2>:
    username: '<username_2>'
    password: '<password_2>'
    host: '<host_2>'
    port: '<port_2>'
    sid: '<sid_2>'
```

Having filled in your database details you should save this file somewhere memorable; the name does not matter but should end with the file type `.yml`.


### Implicit Referencing (Optional - but recommended)
Adding the location that you have saved the `.yml` file as a variable in `.Renviron` will enable the package to connect to databases without you needing to explicitly reference the location that you have saved your credential file.

To set this up: from within the R terminal calling `usethis::edit_r_environ()` will open your global `.Renviron` file. Add the line:

```
config-path="<path-to-config-yml>"
```

## Example

### Viewing Connections
To view a list of all of the database names available (eg. those you have defined in the .yml file) you can call:

```r
list_connections("<path-to-config-yml>")
```

If you set-up implicit referencing then there is no need to provide the argument, and running `list_connections()` will return the same output.

### Running a Query
You can now connect to a database, query from it and close the connection in one function call - this is considerate as it ensures you do not leave the database connection open, potentially impacting other users ability to run queries.

```r
library(oracleConnectR)

dat <- considerate_qry("<database_name>", "<query>", "<path-to-config-yml>")
```

Again, using implicit querying you can run:
```r
library(oracleConnectR)

dat <- considerate_qry("<database_name>", "<query>")
```

### Wider Database Interaction
If you want more flexibility than running a single query (eg. you want to view all of the tables in the database, or want to write back to the server) you can create the connection and then use functions from the DBI package, etc.

```r
library(oracleConnectR)

con <- create_connection("<database_name>") # assumes implicit referencing

DBI::dbListTables(con)
```


## Driver Options
`oracleConnectR` requires one of `odbc` or `ROracle` to be installed. The default behaviour when calling `create_connection` or `considerate_qry` is for the package to try and connect using ROracle, and failing that to attempt using odbc.

To over-ride this default the driver can be specified when calling these functions, eg.

```r
con <- create_connection("<database_name>", driver = "odbc")
```


## Install without `devtools`
Alternatively to installing with `devtools`, you can make a local copy of this repository and build the package locally.

On Dom1 laptops, downloading directly from GitHub is not possible - so you will need to clone the repository. Instructions on cloning from GitHub are provided [here](https://github.com/moj-analytical-services/git2r-demo); you will need to follow up to step 5.

In a new Rstudio session, navigate to the location where you have saved the repository, and open the Rstudio project.

You can now locally build the package by pressing `CTRL + SHIFT + B`.

# oracleConnectR

A minimal package to simplify connecting to Oracle databases from R
```r
library(oracleConnectR)
con <- create_connection("my-database")
```

## Installation

To be able to install the package you will need to be a member of the Github organization moj-analytical-services (if you are reading this, chances are you are a member - or you are looking over the shoulder of a member). 

The package has a number of critical dependencies which you will want to ensure are correctly installed first.
```r
install.packages("DBI")
install.packages("ROracle")
install.packages("config")
```

*Installation via `devtools` currently has teathing problems! Ideally in the future the following will work*

``` r
install.packages("devtools")
library(devtools)

devtools::install_github("moj-analytical-services/oracleConnectR")
```

Without devtools, to install the package you will need to first acquire a local copy of this repo and thenbuild the package from within Rstudio.

Downloading the package directly from GitHub is currently not an option as the `.zip` file will not pass the virus scanner. Instead, you will need to clone the repository.

Instructions on cloning from GitHub are provided [here](https://github.com/moj-analytical-services/git2r-demo), which you will need to follow up to step 5.

In a new Rstudio session, navigate to the location where you have saved the repository, and open the Rstudio project.

You can now locally build the package by pressing `CTRL + SHIFT + B`.

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

## Example

Creating a database connection can now be completed in one line, as set out at the top, after which you can use any commands you may already be familiar with to query a database, for instance retrieving a list of all of the available tables.

```r
library(oracleConnectR)

con <- create_connection("<database_name>", "<path-to-config-yml")

ROracle::dbListTables(con)
```

To view a list of all of the database names available you can call

```r
list_connections("<path-to-config-yml>")
```

Both examples above explicitly stated the path where the `.yml` file is saved; alternatively this can be specified in an environment variable, eg. by adding the line

```r
config-path=<path-to-config-yml>
```
to a `.Renviron` file within your project directory. You can now list connections, and create connections without publically specifying your file path

```r
list_connections()
con <- create_connection("<database_name>")
```

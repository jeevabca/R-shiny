# Package to connect MySQL
library(RMySQL)
library(DBI)

# create a database connection

con <- dbConnect(MySQL(),
                 user = "root",
                 password = "Zyjeev@09",
                 host = "localhost",
                 port = 3306,
                 dbname = "uandp")



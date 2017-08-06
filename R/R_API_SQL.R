#================================================================================= 
# [table of contents]
# 	- library(DBI)
#=================================================================================

#=================================================================================
# library(DBI) 
#=================================================================================

# connect to MySQL database
con <- dbConnect(RMySQL::MySQL(), user = 'root', password = 'pwd', dbname = 'dbname')
dbDisconnect(con)  # Disconnect from the database

dbListTables(con)  # list table
dbListFields(con, 'table')  # list fields

#---------------------------------------------------------------------------------
# fetch results

output <- dbSendQuery(con, 'SELECT * FROM table WHERE field = 4')
dbFetch(output, n = 10)  # fetch top 10 of the results
dbClearResult(output)  # clear the result

# a chunk at a time
ouptput <- dbSendQuery(con, "SELECT * FROM table WHERE field1 = 4")
while(!dbHasCompleted(res)){
  chunk <- dbFetch(res, n = 5)
  print(nrow(chunk))
}
dbClearResult(res)  # clear the result

#---------------------------------------------------------------------------------
# import / export from databse

dbReadTable(con, 'table_name')
dbWriteTable(con, 'table_name', dataset)

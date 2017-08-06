#================================================================================= 
# [table of contents]
#   - setup 
# 	- setup in R
#   - API: SparkR
#=================================================================================
# http://spark.apache.org/docs/latest/index.html
# SparkR intro: https://youtu.be/5o-9ozwQgMw
# Spark's main abstraction is RDD (resilient distributed dataset), a collection of
# elements partitioned across a cluster's nodes that can be operated in parrallel
# Spark = developed to IO to disk iff needed, so that iterative algorithms and 
# interactive data analysis (performs cyclic operations on the same dataset) 
# can be done faster; caching the in-memory processing are optimized 
#=================================================================================
# setup
#=================================================================================
# build from source code
# - install homebrew: http://brew.sh/
# - install hadoop: brew install hadoop
# - install maven: brew install maven
# - install spark: http://spark.apache.org/docs/latest/building-spark.html
# - re-install R (if OS X El Capitan, which places RScript in a diff dir)
# - run ./
# prebuilt
# - choose a pre-built to download
# make less verbose: in make a new conf/log4j.properties, and change
# 'log4j.rootCategory=INFO, console' to 'log4j.rootCategory=WARN, console'

# set cd to sparkr folder, then: ./bin/sparkR
sc <- sparkR.init()
sqlContext <- sparkRSQL.init(sc)

#=================================================================================
# setup in R
#=================================================================================
# R frontend for Spark: http://spark.apache.org/docs/latest/api/R/index.html
# R = single-threaded and all-data has to fit in mememory
# SparkR = alls R to scale up (larger datasets), and out (across more machines)
# loads SparkR library
if (nchar(Sys.getenv('SPARK_HOME')) < 1) {
  Sys.setenv(SPARK_HOME = '/Users/steven/spark-1.6.0-bin-hadoop2.6')
}
library(SparkR, lib.loc = c(file.path(Sys.getenv('SPARK_HOME'), 'R', 'lib')))

# create Spark context, at local
sc <- sparkR.init(master = 'local')
# create Spark's SQL DataFrames context (which wraps around the Spark context)
sqlContext <- sparkRSQL.init(sc)

#=================================================================================
# API: SparkR
#=================================================================================
# I0, Caching, DataFrame API / SQL

#---------------------------------------------------------------------------------
# IO

# reading & writing to storage: JVM <-> Storage
# creates a Spark DF from a file in storage
sparkDF <- read.df(sqlContext, path='...', source='csv')
# to get the schema
printSchema(sparkDF)
# writes a Spark DF to a file in storage
write.df(sparkDF, source='csv')

# moving data from R <-> JVM
# creates a Spark DF from a R Df
sparkDF <- createDataFrame(sqlcontext, df)
# creates a R DF from a Spark Df
df <- collect(sparkDF)

#---------------------------------------------------------------------------------
# Caching (i.e. persisting): tells Spark how to store: key for iterative algorithms

persist(sparkDF, storageLevel)
# where storageLevel:
# DISK_ONLY (default) - store in disk
# MEMORY_ONLY - excess not cached, but recomputed on the fly when needed
# MEMORY_AND_DISK - store in mem; if mem not enough, store excess in disk
# MEMORY_AND_DISK_SER - ibid, but serialized (more space-efficient, but more CPU-intensive to read)
# MEMORY_ONLY_SER - ibid, but only for mem
cache(sparkDF) == persist(sparkDF, 'MEMORY_ONLY')

#---------------------------------------------------------------------------------
# DataFrame API / SQL

# register the Spark DF as a temp (SQL) table
registerTempTable(df, 'logsTable')
output <- sql(sqlContext, 'SELECT BLAH BLAH SQL QUERY')
# getting back Spark DF from the temp table
# this is showing how it's done in R, but you because R is just an environment sitting
# on top of Spark, you can use another language (Python, Scala) to continue; i.e.
# you can move between languages!
sparkDF <- table(sqlContext, 'logsTable')

# how this can create a fluidity between data engineering and data science:
# data engineer appends data, then data scientist can refresh it:
refreshTable(sqlContext, 'logsTable')
# and now work on it as a sparkDF
sparkDF <- table(sqlcontext, 'logstable')

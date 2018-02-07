# https://gist.github.com/brpaz/ee9f1d3aff20e26d006d

help
show dbs
use db
db
show collections

db.collection.count()
db.collection.find({key1: {$exists: true}}).count()

db.collection.distinct("key1")

db.collection.findOne()
db.collection.find().skip(20).limit(10).pretty()
db.collection.find().pretty()

db.collection.find(query).pretty()

# query

{key1: value1, key2: value2}
{"key1.nested1": value1, "key1.nested2": value2}
{$or: [{key1: value1}, {key2: value2}]}
{key1: /value1/}
{key1: /^value1/}

{}, {select1:1, select2:1, non_select:0}

{value: {$gt:0, $ls:100}}
{value: {$gte:0, $lse:100}}

# aggregation

db.zipcodes.aggregate( [
   { $group: { _id: "$state", totalPop: { $sum: "$pop" } } },
   { $match: { totalPop: { $gte: 10*1000*1000 } } }
] )

SELECT state, SUM(pop) AS totalPop
FROM zipcodes
GROUP BY state
HAVING totalPop >= (10*1000*1000)



db.zipcodes.aggregate( [
   { $group: { _id: "$state", totalPop: { $sum: 1 } } },
   { $match: { totalPop: { $gte: 10 } } }
] )

SELECT state, COUNT(*) AS totalCount
FROM zipcodes
GROUP BY state
HAVING totalCount >= (10)

db.zipcodes.aggregate( [
   { $match: { state: "CA" },
   { $group: { _id: "$state", totalPop: { $sum: 1 } } }
] )

SELECT state, COUNT(*) AS totalCount
FROM zipcodes
GROUP BY state
WHERE state = "CA"

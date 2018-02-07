#================================================================================= 
# [table of contents]
# 	- library(lubridate)
#=================================================================================

#=================================================================================
# library(lubridate)
#=================================================================================
# https://cran.r-project.org/web/packages/lubridate/vignettes/lubridate.html

today()
now()

#---------------------------------------------------------------------------------
# better parsing

# y, m, d can be in any order
ymd("20110604")  # "2011-06-04"
ymd("06-04-2011")  # "2011-06-04"
dmy("04/06/2011")  # "2011-06-04"
ymd_hms("2011-06-04 12:00:00", tz = "Pacific/Auckland")  # "2011-06-04 12:00:00 NZST"

# generate time
make_datetime()

# extract with second, minute, hour, day, wday, yday, week, month, year, and tz
# wday and month have an optional label argument, alternative for numeric output
wday(arrive)
wday(arrive, label = TRUE)

# rounding
floor_date(arrive, "week")  

# setting components, such as:
(arrive <- ymd_hms("2016-07-08 12:34:56"))
year(arrive) <- 2020
month(arrive) <- 01
day(arrive) <- 01
hour(arrive) <- hour(arrive) + 1
# or
update(arrive, year = 2020, month = 1, mday = 1, hour = hour(arrive) + 1)

# time zone
meeting <- ymd_hms("2011-07-01 09:00:00", tz = "Pacific/Auckland")
with_tz(meeting, "America/Chicago")  # "2011-06-30 16:00:00 CDT"
# force time to be in another time zone
mistake <- force_tz(meeting, "America/Chicago")

#---------------------------------------------------------------------------------
# time interval

arrive <- ymd_hms("2011-06-04 12:00:00", tz="Pacific/Auckland")
leave <- ymd_hms("2011-08-10 14:00:00", tz="Pacific/Auckland")
auckland <- interval(arrive, leave) 
auckland <- arrive %--% leave
auckland / ddays(1)  # number of days

int_start(auckland)
int_end(auckland)
int_flip(auckland)
int_shift(auckland, duration(days = 11))  # 2011-06-15 12:00:00 NZST--2011-08-21 14:00:00 NZST

jsm <- interval(ymd(20110720, tz="Pacific/Auckland"), ymd(20110809, tz="Pacific/Auckland"))

int_overlaps(auckland, jsm)  # TRUE
jsm %within% auckland  # TRUE
int_aligns(auckland, jsm)  # FALSE (true if begins/end on the same moment)
setdiff(auckland, jsm)  # 2011-06-04 12:00:00 NZST--2011-07-20 NZST
union(auckland, jsm)  # 2011-06-04 12:00:00 NZST--2011-08-31 NZST
intersect(auckland, jsm)  # 2011-07-20 NZST--2011-08-10 14:00:00 NZST

#---------------------------------------------------------------------------------
# time arithmetic

# periods
minutes(2)  
hours(c(12, 24))
days(0:5)
weeks(3)
years(1)

tomorrow <- today() + days(1)
last_year <- today() - years(1)

# duration in seconds (doesn't take into account of leap year, daylight savings, etc.)
dminutes(2)  
dhours(c(12, 24))
ddays(0:5)
dweeks(3)
dyears(1)

tomorrow <- today() + ddays(1)
last_year <- today() - dyears(1)

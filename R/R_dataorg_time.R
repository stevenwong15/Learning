#================================================================================= 
# [table of contents]
# 	- library(lubridate)
#=================================================================================

#=================================================================================
# library(lubridate)
#=================================================================================
# https://cran.r-project.org/web/packages/lubridate/vignettes/lubridate.html

#---------------------------------------------------------------------------------
# better parsing

# y, m, d can be in any order
ymd("20110604")  # "2011-06-04"
ymd("06-04-2011")  # "2011-06-04"
dmy("04/06/2011")  # "2011-06-04"
ymd_hms("2011-06-04 12:00:00", tz = "Pacific/Auckland")  # "2011-06-04 12:00:00 NZST"

# extract with second, minute, hour, day, wday, yday, week, month, year, and tz
# wday and month have an optional label argument, alternative for numeric output
wday(arrive)
wday(arrive, label = TRUE)

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

minutes(2)
dminutes(2)  # duration in seconds


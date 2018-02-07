#---------------------------------------------------------------------------------
# [table of contents]
# - internet
# - Passive DNS
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# internet
#--------------------------------------------------------------------------------- 

# dig: domain information groper
dig google.com  # show A records
dig google.com any  # show all records

dig ns4.google.com google.com # show records from a specific DNS server 

dig -x 216.239.32.10 # reverse lookup

# whois: query DBs that store the registered users or assignees of an Internet resource
whois google.com

# ping: test the reachability of a host on an IP network
ping google.com

#---------------------------------------------------------------------------------
# Passive DNS
#--------------------------------------------------------------------------------- 

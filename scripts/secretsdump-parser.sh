#!/usr/bin/bash

# A simple parser to experiment on sed, awk and argv
# Usage: ./secretsdump-parser.sh dumped.hashes
#
# Example 
#
# $> cat dumped.hashes
# Administrator:500:aad3b435b51404eeaad3b435b51404ee:d5cad8a9782b2879bf316f56936f1e36:::
# Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
# 
# $> ./secretsdump-parser.sh dumped.hashes
# $> cat users.txt
# Administrator
# Guest
#
# $> cat hashes.txt
# d5cad8a9782b2879bf316f56936f1e36
# 31d6cfe0d16ae931b73c59d7e0c089c0
# 

cat $1 |	sed 's/:[0-9]\{3,4\}:/ /g' |	sed 's/:/ /g' |	awk '{print $1 >> "users.txt" ; print $3 >> "hashes.txt"}'

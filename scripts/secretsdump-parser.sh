#!/usr/bin/bash

# A simple parser to experiment on sed, awk and argv
# Usage: ./secretsdump-parser.sh dumped.hashes

cat $1 |	sed 's/:[0-9]\{3,4\}:/ /g' |	sed 's/:/ /g' |	awk '{print $1 >> "users.txt" ; print $3 >> "hashes.txt"}'

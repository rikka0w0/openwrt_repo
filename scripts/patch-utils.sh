#!/bin/bash

# Generate an escaped string to be used in sed.
# 1. \ -> \\
# 2. new line -> \n
# 3. / -> \/
function sed_escape() {
	echo "$1" | sed ':a;N;$!ba;s/\\/\\\\/g; s/\n/\\n/g; s/\//\\\//g'
}

# Insert $3 before the first line that contains $2 in file $1.
function insert_before_first_occurrence() {
	local anchor_escaped=$(sed_escape "$2")
	local new_lines_escaped=$(sed_escape "$3")
	sed -i "0,/^$anchor_escaped/s//$new_lines_escaped\n&/" "$1"
}

# Insert $3 after the first line that contains $2 in file $1, without modifying the anchor line.
function insert_after_first_occurrence() {
	local anchor_escaped=$(sed_escape "$2")
	local new_lines_escaped=$(sed_escape "$3")
	sed -i "0,/^$anchor_escaped/ {/^$anchor_escaped/ a\\
$new_lines_escaped
}" "$1"
}

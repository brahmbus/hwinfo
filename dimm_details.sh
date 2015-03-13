#!/bin/bash
# dimm_details.sh
# nrahme@liquidweb.com
# display details for each memory slot on the current runtime environment
# module developed independently for hwinfo.sh memory section

## Global Variables ##

version=1.0.0

# colors aliased to descriptive variables #
nocolor="\E[0m"
black="\033[0;30m"
grey="\033[1;30m"
red="\033[0;31m"
lightRed="\033[1;31m"
green="\033[0;32m"
lightGreen="\033[1;32m"
brown="\033[0;33m"
yellow="\033[1;33m"
blue="\033[0;34m"
lightBlue="\033[1;34m"
purple="\033[0;35m"
lightPurple="\033[1;35m"
cyan="\033[0;36m"
lightCyan="\033[1;36m"
white="\033[1;37m" # bold white

ec() { # `echo` in a color function
	# usage: ec $color "text"
	ecolor=${!1} # get the color
	shift # $1 is removed here
	echo -e ${ecolor}"${*}"${nocolor} # echo the rest
}

ec_n() { # `echo` in a color function without trailing new line
	# usage: ec_n $color "text"
	ecolor=${!1} # get the color
	shift # $1 is removed here
	echo -en ${ecolor}"${*}"${nocolor} # echo the rest
}

	ec yellow "***MEMORY INFO***\n"
# set variable for total memory #
memory_total=`cat /proc/meminfo | grep MemTotal | cut -d: -f2 | tr -s [:space:]`
	ec_n white "Total system memory:" ; ec lightGreen "$memory_total\n"
# set variable for memory slots #
memory_slots=`dmidecode -t 17 | grep "Size" | wc -l`
	ec_n white "Number of memory slots:" ; ec lightGreen $memory_slots
# set base value for the first memory slot #
dimm=1
# loop to detail present dimms, cleaning previous results #
while ((dimm<=memory_slots))
do
	ec_n white "Slot$dimm has " ; ec lightRed "`sudo dmidecode -t 17 | grep Size | cut -d: -f2 | head -n$dimm | tail -n1`"
	let dimm=dimm+1
done

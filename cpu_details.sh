#!/bin/bash
# cpu_details.sh
# nrahme@liquidweb.com
# display details for the processor and cores in current runtime environment
# module developed independently for hwinfo.sh processor section

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
cpu_model=`cat /proc/cpuinfo | grep "model name" | head -n1 | cut -d: -f2 | cut -d ' ' -f2,3,4`
cpu_cores=`cat /proc/cpuinfo | grep "core id" | wc -l`
	clear	
		ec yellow "***CPU INFO***\n"
		ec_n white "CPU:" ; ec lightGreen "$cpu_model\n"
		ec_n white "Number of Cores:" ; ec lightGreen "$cpu_cores\n"
###	

#!/bin/bash
# hwinfo.sh
# nrahme@liquidweb.com
# easy access to details on runtime environment hardware
# special thanks to abrevick and the developers of pullsync.sh from which I drew heavily

[ ! -f /etc/redhat-release ] && echo "/etc/redhat-release not found! Can only be reliably run on rpm-based servers. Exiting" && exit 99

# global variables
scriptname="hwinfo"
version="0.1.2 (alpha)"

# colors aliased to descriptive variables
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

#paste() { # posts to linkable url
#	pastebin_url="paste.sysres.liquidweb.com"	
#	pbfile="/tmp/pbfile"	
#	cat - > $pbfile ; 
#	curl -X POST -s --data-binary @${pbfile} http://${pastebin_url}/documents | awk -F '"' -v url=$pastebin_url '{print "https://" url "/raw/"$4}' 
#	rm $pbfile
#}

main() {

	start=0
	while ((start==0))
	do
		clear
		ec white "\n\n\n\n\n\n\nSelect info type desired:\n"
		ec white "		C) CPU
		M) Memory
		D) Drives
		N) Network devices
		P) PCI/e devices
		R) RAID devices\n"
		ec lightBlue "		A) All\n"
		ec lightCyan "		b) all Block devices
		u) usb devices
		m) motherboard\n"
		ec yellow "		q/Q) quit/Quit\n"
		ec grey "		o) operating system (technically not hardware)"
		ec_n white "Selection: "
		read selection
		case $selection in
			C)
				hwtype="cpu_info"
				handler
				start=1 ;;
			M) 
				hwtype="mem_info"
				handler
				start=1 ;;
			D)
				hwtype="drive_info"
				handler
				start=1 ;;
			N) 	
				hwtype="net_info"
				handler
				start=1 ;;
			P) 	
				hwtype="pci_info"
				handler
				start=1 ;;
			R)	
				hwtype="raid_info"
				handler
				start=1 ;;
			A)	
				hwtype="all_info"
				handler
				start=1 ;;
			b)	
				hwtype="block_info"
				handler
				start=1 ;;
			u)	
				hwtype="usb_info"
				handler
				start=1 ;;
			m)	
				hwtype="mobo_info"
				handler
				start=1 ;;
			q)	
				quit
				start=1 ;;
			Q)	
				quit
				start=1 ;;
			o)	
				hwtype="os_info"
				handler
				start=1 ;;
			*)  
			   	ec lightRed "Invalid Selection!" ; sleep 3 ; clear
		esac	
	done
}

handler() { # execute menu selection
	
	# allow return to main menu
	ec_n white "again?(y/n): "
	read choice
	if $choice 
}

cpu_info() { # gathers and displays cpu model and cores
	cpu_model=`cat /proc/cpuinfo | grep "model name" | head -n1 | cut -d: -f2 | cut -d ' ' -f2,3,4`
	cpu_cores=`cat /proc/cpuinfo | grep "core id" | wc -l`
	clear	
	ec yellow "***CPU INFO***\n"
	ec_n white "CPU:" ; ec lightGreen "$cpu_model\n"
	ec_n white "Number of Cores:" ; ec lightGreen $cpu_cores
}

mem_info() { # gathers and displays memory total in kB with details on slots
	memory_total=`cat /proc/meminfo | grep MemTotal | cut -d: -f2 | tr -s [:space:]`
	# set variable for memory slots in current runtime environment
	memory_slots=`dmidecode -t 17 | grep "Size" | wc -l`
	# set base value for the first memory slot
	dimm=1
	clear
	ec yellow "***MEMORY INFO***\n"
	ec_n white "Total system memory:" ; ec lightGreen "$memory_total\n"
	ec_n white "Number of memory slots:" ; ec lightGreen $memory_slots
		# loop to detail active memory slots, cleaning previous results #
		while ((dimm<=memory_slots))
		do
			ec_n white "Slot$dimm has " ; ec lightRed "`dmidecode -t 17 | grep Size | cut -d: -f2 | head -n$dimm | tail -n1`"
			let dimm=dimm+1
		done
}

drive_info() {
	clear
}

net_info() {
	clear
}

pci_info() {
	clear
}

raid_info() {
	clear
}

all_info() {
	clear
}

block_info() {
	clear
}

usb_info() {
	clear
}

mobo_info() {
	clear
}

os_info() {
	clear
}

quit() {
	clear
	ec lightRed "Exiting......"
	sleep 3
	clear
}

main

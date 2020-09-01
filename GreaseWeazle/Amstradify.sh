#!/bin/bash
#
# Script to Copy and Encode Amstrad CPC Disks using
# GreaseWeazle to read the physical Disks
# HXCFE to convert the SCF file to Amstrad DSK format
#       for use in Emulators
# Preserving my code
#
# Script (C) Jason Brooks 2020

GWZ=./GreaseWeazle
HXC=./hxcfe_cmdline/App/hxcfe
DUMMYTRACK0=./scp/deleteme.scp
LOGFILE=./scp/log.txt
filename=""

function blankLines {
	echo
	echo
}

function Welcome {

clear
echo "Welcome To Amstradify Script V1.0"
echo 
echo 
echo "Ensure your GreaseWeazle is connected and powered on	"
echo
echo
read -p "Enter Disk Filename to Use: " filename
echo
read -p "Which Side: A or B: (return for none): " side

if [ -z $side ]; then
	sourcefile="./scp/"$filename".scp"
	destfile="./cpc/"$filename".dsk"
else
	# Check if just one char entered
	# If so, then ensure it is upper case.
	chrlen=${#side}
	if [ $chrlen -eq 1 ] ; then
		#side = ${side^}			# ensure first char is upper case
		side=$( tr '[a-z]' '[A-Z]' <<< $side )
	fi
	sourcefile="./scp/"$filename"_Side$side.scp"
	destfile="./cpc/"$filename"_Side$side.dsk"
fi
}


#
#	Use GreaseWeazel to Read the Disk
#
function readPhysical {
	echo "Attempting to Read Disk: $filename"
	blankLines
	./GreaseWeazle/gw read --revs=5 \
						   --drive B \
						   --ecyl=41 \
						   --single-sided \
						   $sourcefile 
}

#
#	Use hxcfe command line to convert disk to Amstrad CPC
#
function convertToAmstrad {

	echo
	echo Running HXCFE Command to Convert data to DSK Format
	if [ -f "$sourcefile" ] ; then
	$HXC -finput:$sourcefile -conv:AMSTRADCPC_DSK -foutput:$destfile > $LOGFILE
	else
	blankLines
	echo "Failed to create image: $sourcefile"
	fi
	
	showLogs
}


#
#    Check Log Files and write Appropriate option
#
function showLogs {

	cat $LOGFILE | grep -i Input
	cat $LOGFILE | grep -i Output
	cat $LOGFILE | grep -i Checking
	cat $LOGFILE | grep -i "File loader found"
	cat $LOGFILE | grep -i Loading
	cat $LOGFILE | grep -i Write
	cutLogs
	
}

#
#    Check Track Conversion and unformatted tracks
#    GreaseWeazle 2.0 seems to double the number of tracks requested
#    Which are unformatted/unscanned
#    Could be HXCFE or GreaseWeazle issue.
#
function cutLogs {

	echo
	echo "Tracks and Sectors Read"
	echo "====== === ======= ===="
	echo
	cat $LOGFILE | awk -F: '/track:/ { \
							if (length($5) > 1) \
							{print $1,":", $2,":", $5, length($5)} \
	}'
	
	checkFaultyTrackRead=`cat $LOGFILE | grep -i "track:00:0" | cut -d":" -f 5`
	checkLen=${#checkFaultyTrackRead}
	
	if [ $checkLen < 5 ] ; then
		echo 
		read -p "Failed to correctly Read Track 0 - Try Again?" runAgain
		
		chrlen=${#runAgain}
		if [ $chrlen -eq 1] ; then
			runAgain=$( tr '[a-z]' '[A-Z]' <<< $runAgain )
			if [runAgain == "y" || runAgain == "y"]; then runTheConversionCommands
			fi
		fi
	fi	
}


#
#	Move Drive Head to Track 0
#
function sendToTrackZero {

	echo
	echo Seek to Track 0
	echo
			   
	# Grease Weazle Read Command (5 Revolutions, Cylinder 0)					   
	./GreaseWeazle/gw read --revs=5 \
						   --drive B \
						   --ecyl=0 \
						   --single-sided \
						   $DUMMYTRACK0 >/dev/null
	
	#
	# Clean up after ourselves
	#
	if [ -f "$DUMMYTRACK0" ] ; then rm -f $DUMMYTRACK0
	fi
}

#
#   Simple Script to run the Conversion Script
#
function runTheConversionCommands {
	sendToTrackZero
	readPhysical
	sendToTrackZero
	convertToAmstrad
	blankLines
}

#
#	The Start of the Script Main()
#

carryon="y"

while ( ! [ -z $carryon ] && ( [ $carryon == "y" ] || [ $carryon == "Y" ] ) )
do
	Welcome
	echo "Using: $sourcefile to write to $destfile"
	echo
	echo
	
	runTheConversionCommands
	
	echo "Converted to File: $destfile"
	echo
	read -p "Convert Another Disk? (y/n) : " carryon
	carryon=$(printf '%s' "$carryon" | cut -c1)
done


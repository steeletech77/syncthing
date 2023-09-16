#!/bin/bash

cd /photos/scottpixel/Camera

mdir="/data/Photos"
sdir="Scott Phone"
curm=00
sjpgcopy=0
smpcopy=0

declare -a fout

get_month() {

case $1 in
    01)
        month=Jan
        ;;
    02)
        month=Feb
        ;;
    03)
        month=Mar
        ;;
    04)
        month=Apr
        ;;
    05)
        month=May
        ;;
    06)
        month=June
        ;;
    07)
        month=July
        ;;
    08)
        month=Aug
        ;;
    09)
        month=Sept
        ;;
    10)
        month=Oct
        ;;
    11)
        month=Nov
        ;;
    12)
        month=Dec
        ;;
    *)
        echo "Exiting"
        ;;
esac
}

shopt -s nullglob
shopt -u failglob

files=( /photos/scottpixel/Camera/*.jpg )
jpgcnt=${#files[@]}

files=( /photos/scottpixel/Camera/*.mp4 )
mpcnt=${#files[@]}

#[ $jpgcnt = 0 ] && [ $mpcnt = 0 ] && sskip=1

if [ $jpgcnt -gt 0 ]
then
    fout=("Copying Scott's photos")
    fout+=("")

    for f in *.jpg; do

    	# Pixel format
        m="${f:8:2}"
        d="${f:10:2}"
        y="${f:4:4}"

        # Samsung format
	# m="${f:4:2}"
        # d="${f:6:2}"
        # y="${f:0:4}"
	
        get_month $m
        dir="$mdir/$y $m $month"
        if [ $curm != $m ]
        then
    	    [ ! -d "$dir" ] && fout+=("Making $dir") && mkdir "$dir"
    	    [ ! -d "$dir/$sdir" ] && fout+=("Making $dir/$sdir") && mkdir "$dir/$sdir"

	    curm=$m
        fi

        [ ! -f "$dir/$sdir/$f" ] && fout+=("Copying $f") && cp $f "$dir/$sdir" && sjpgcopy=1 || fout+=("Skipping $f")
    done
    fout+=("")
fi

if [ $mpcnt -gt 0 ]
then
    fout+=("Copying Scott's videos")
    fout+=("")

    for f in *.mp4; do
    
        # Pixel format
        m="${f:8:2}"
        d="${f:10:2}"
        y="${f:4:4}"
        
        # Samsung format
	# m="${f:4:2}"
        # d="${f:6:2}"
        # y="${f:0:4}"
	
        get_month $m
        dir="$mdir/$y $m $month"
    
        [ ! -f "$dir/$sdir/$f" ] && fout+=("Copying $f") && cp $f "$dir/$sdir" && smpcopy=1 || fout+=("Skipping $f")
    done
    fout+=("")
fi

[ $sjpgcopy -eq 0 ] && rm -f /photos/scottpixel/Camera/*.jpg
[ $smpcopy -eq 0 ] && rm -f /photos/scottpixel/Camera/*.mp4

if [ $sjpgcopy -eq 1 ] || [ $smpcopy -eq 1 ]
then
        printf '%s\n' "${fout[@]}" | mail -s "Photo copy" myemail@email.com
fi

exit 0

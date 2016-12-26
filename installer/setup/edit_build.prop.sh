#!/system/bin/sh
# Build.prop editor script with basic sed commands
# tommytomatoe
# May 12, 2012
# script from http://themikmik.com/showthread.php?12566-Scripts-Bash-and-Shell-scripts-for-updating-build-prop-in-recovery

export PATH=/tmp:$PATH:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin
exec 0>&1

set +e

# Variable declarations
# these are for the build.prop
FILE=/system/build.prop
TMPFILE=$FILE.bakupTether

#make a save
cp $FILE $TMPFILE

# PROP VARIABLE
# these varaibles are the actual props inside the build prop we want to modify
# I chose three popular ones to test on
# this list can be as large as you want it to be
line1=net.tethering.noprovisioning
# ARGUMENT VARIABLE
# these variables are the new values you want
line1Arg=true

# this variable is just a place holder for the future line number of the prop values
lineNum=

# main is where all the magic happens

# to avoid clutter, I've moved some code comments to the bottom
# each listing is matched with the correct marker #a will be #a below, etc

#b = prop is set to argument 1, the prop variable
#c = arg is set to argument 2, the argument variable
#d = if prop value exists in build.prop,
#    replace it, else, append it to end of file
#e = lineNum will be set to the line number of prop
#f = use sed to replace the line at lineNum with the new values
#    alternatively, I could use this:
        #sed -i "/${prop}/d" $FILE
        #sed -i "${lineNum}i${prop}=${arg}" $FILE


prop=$line1										#b
arg=$line1Arg										#c
if grep -Fq $prop $FILE ; then						#d
    lineNum=`/tmp/busybox sed -n "/${prop}/=" $FILE`				#e
    echo $lineNum
    /tmp/busybox sed -i "${lineNum} c${prop}=${arg}" $FILE		#f
else
    echo "$prop does not exist in build.prop"
    echo "appending to end of build.prop"
    echo "echo $prop=$arg >> $FILE"
    echo $prop=$arg >> $FILE
fi

# to iterate over all the prop values you want to change,
# just copy and paste the code chunk or create a for loop.
# I will leave it to you to create a for loop

exit 0
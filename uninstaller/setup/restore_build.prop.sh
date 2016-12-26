#!/tmp/busybox sh

# if backup exit
if [ -f /system/build.prop.bakupTether ]; then
	mv /system/build.prop /system/build.prop.modedTether01;
	mv /system/build.prop.bakupTether /system/build.prop;
fi
return 0;
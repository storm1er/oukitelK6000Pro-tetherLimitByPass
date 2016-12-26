#!/system/bin/sh

export PATH=/tmp:$PATH:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin
exec 0>&1

set +e

busybox mount -o remount,rw /system
if [ $? != 0 ] ; then exit 1
fi
busybox mount -o remount,rw /data
if [ $? != 0 ] ; then exit 1
fi

# Variable declarations
DB=/data/data/com.android.providers.telephony/databases/telephony.db
ARCH=$(getprop ro.product.cpu.abilist)
SQLITE=

# make a save
cp $DB $DB.bakupTether


# as almost every recovery is 32bits, 64 bits lines must be first
# so they will be overriden if an other 32 bits binary is compatible
if getprop ro.product.cpu.abilist | grep -Fq arm64-v8a ; then
  echo "SQLite can be arm64-v8a";
  SQLITE=/tmp/sqlite3/arm64-v8a/sqlite3-static
fi;
if getprop ro.product.cpu.abilist | grep -Fq x86_64 ; then
  echo "SQLite can be x86_64";
  SQLITE=/tmp/sqlite3/x86_64/sqlite3-static
fi;
if getprop ro.product.cpu.abilist | grep -Fq mips64 ; then
  echo "SQLite can be mips64";
  SQLITE=/tmp/sqlite3/mips64/sqlite3-static
fi;
if getprop ro.product.cpu.abilist | grep -Fq armeabi ; then
  echo "SQLite can be armeabi";
  SQLITE=/tmp/sqlite3/armeabi/sqlite3-static
fi;
if getprop ro.product.cpu.abilist | grep -Fq armeabi-v7a ; then
  echo "SQLite can be armeabi-v7a";
  SQLITE=/tmp/sqlite3/armeabi-v7a/sqlite3-static
fi;
if getprop ro.product.cpu.abilist | grep -Fq mips ; then
  echo "SQLite can be mips";
  SQLITE=/tmp/sqlite3/mips/sqlite3-static
fi;
if getprop ro.product.cpu.abilist | grep -Fq x86 ; then
  echo "SQLite can be x86";
  SQLITE=/tmp/sqlite3/x86/sqlite3-static
fi;

if [[ ! $SQLITE ]]
then
	echo "SQLite can be none, leaving";
	exit 1;
fi;

# this request add ',dun' to current selected APN who doesn't already have it.

# UPDATE carriers
#   SET TYPE=TYPE||',dun'
# WHERE
#   _id IN (
#     SELECT _id
#     FROM carriers
#     WHERE CURRENT = 1
#       AND TYPE NOT LIKE '%dun%'
#   )
#   AND CURRENT = 1;

$SQLITE $DB "UPDATE carriers SET TYPE=TYPE||',dun' WHERE _id IN ( SELECT _id FROM carriers WHERE CURRENT = 1 AND TYPE NOT LIKE '%dun%') AND CURRENT = 1;";

# if I don't set this right, FC of com.android.phone happens after reboot
/tmp/busybox chown radio:radio $DB;

echo "APN successfuly updated";

# if you want to verify result, execute this via adb :
# /tmp/sqlite3/[PUT YOUR ARCH HERE]/sqlite3-static /data/data/com.android.providers.telephony/databases/telephony.db "SELECT TYPE FROM carriers WHERE CURRENT = 1;"
# You chould see ,dun on each line
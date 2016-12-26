#!/tmp/busybox sh

# if backup exit
DB=/data/data/com.android.providers.telephony/databases/telephony.db
if [ -f /data/data/com.android.providers.telephony/databases/telephony.db.bakupTether ]; then
	mv $DB $DB.modedTether01;
	mv $DB.bakupTether $DB;
	/tmp/busybox chown radio:radio $DB;
fi
return 0;
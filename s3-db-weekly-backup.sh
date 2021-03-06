#!/bin/bash
configfile='/root/.backup_config/backup'
configfile_secured='/tmp/backup'

if egrep -q -v '^#|^[^ ]*=[^;]*' "$configfile"; then
  echo "Config file is unclean, cleaning it..." >&2
  egrep '^#|^[^ ]*=[^;&]*'  "$configfile" > "$configfile_secured"
  configfile="$configfile_secured"
fi

source "$configfile"
DAY_OF_WEEK=$((`date +%u`-1))
DAY_OF_MONTH=`date +%e`
OFFSET=$(((${DAY_OF_WEEK} + 36 - ${DAY_OF_MONTH}) % 7 ))
wkno=$(((${DAY_OF_MONTH} + ${OFFSET} - 1) / 7))
databases=`mysql --user=$username -p$pass -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`
for db in $databases; do
        if [ $db != "mysql" ]; then
                echo $db  
                dbbackupfile=$backupdir/weekly/$db-$wkno.tar.gz
                s3DBFile="s3://$awsbucketname$dbbackupfile"
                echo $dbbackupfile
                echo $s3DBFile
                mysqldump --force -u $username -p$pass --databases $db > /tmp/$db.sql
                tar -zcf  $dbbackupfile /tmp/$db.sql 2>>/var/log/backup-log/weekly/tar-db-error-$(date +"%d-%m-%Y").log
                aws s3 cp $dbbackupfile $s3DBFile  >> /var/log/backup-log/weekly/s3upload-db-$(date +"%d-%m-%Y").log
                rm -f /tmp/$db.sql
                rm -f $dbbackupfile
        fi
done
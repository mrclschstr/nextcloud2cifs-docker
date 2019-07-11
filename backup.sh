#!/bin/sh

# Define and reset logfile
lastLogfile="/var/log/backup-last.log"
rm -f ${lastLogfile}

logLast() {
  echo "$1" >> ${lastLogfile}
}

start=`date +%s`
echo "Starting Backup at $(date +"%Y-%m-%d %H:%M:%S")"

logLast "Starting Backup at $(date)"
logLast "BACKUP_CRON: ${BACKUP_CRON}"
logLast "NEXTCLOUD_PATH: ${NEXTCLOUD_PATH}"
logLast "NEXTCLOUD_USER: ${NEXTCLOUD_USER}"
logLast "CIFS_PATH: ${CIFS_PATH}"
logLast "CIFS_USER: ${CIFS_USER}"

# Do the backup with rsync and delete source files, if successfully copied
rsync ${RSYNC_JOB_ARGS} /mnt/nextcloud/ /mnt/cifs/ >> ${lastLogfile} 2>&1
rsync_status=$?
end=`date +%s`

# TODO Access variables like $rsync_status or ${rsync_status}?
if [ ${rsync_status} == 0 ]; then
  echo "Backup successfully finished at $(date +"%Y-%m-%d %H:%M:%S") after $((end-start)) seconds"
else 
  echo "Backup FAILED at $(date +"%Y-%m-%d %H:%M:%S") after $((end-start)) seconds"
fi

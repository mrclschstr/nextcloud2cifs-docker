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
logLast "RSYNC_JOB_ARGS: ${RSYNC_JOB_ARGS}"
logLast "NEXTCLOUD_PATH: ${NEXTCLOUD_PATH}"
logLast "NEXTCLOUD_USER: ${NEXTCLOUD_USER}"
logLast "CIFS_PATH: ${CIFS_PATH}"
logLast "CIFS_USER: ${CIFS_USER}"$'\r'

# TODO Mount folders right before backup? Or implement a check, if mounts still exist? Needs some experience!
# Do the backup with rsync
rsync ${RSYNC_JOB_ARGS} --exclude="lost+found" /mnt/nextcloud/ /mnt/cifs/ >> ${lastLogfile} 2>&1
rsync_status=$?
end=`date +%s`

if [ ${rsync_status} == 0 ]; then
  echo "Backup successfully finished at $(date +"%Y-%m-%d %H:%M:%S") after $((end-start)) seconds"
else 
  echo "Backup FAILED at $(date +"%Y-%m-%d %H:%M:%S") after $((end-start)) seconds"
fi

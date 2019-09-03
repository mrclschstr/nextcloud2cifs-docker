#!/bin/sh

lastBackupLogfile="/var/log/backup-last.log"
lastMailLogfile="/var/log/mail-last.log"
rm -f ${lastBackupLogfile} ${lastMailLogfile}

outputAndLog() {
    echo "$1"
    echo "$1" >> ${lastBackupLogfile}
}

start=`date +%s`
outputAndLog "Starting Backup at $(date +"%Y-%m-%d %H:%M:%S")"
outputAndLog "BACKUP_CRON: ${BACKUP_CRON}"
outputAndLog "RSYNC_JOB_ARGS: ${RSYNC_JOB_ARGS}"
outputAndLog "NEXTCLOUD_PATH: ${NEXTCLOUD_PATH}"
outputAndLog "NEXTCLOUD_USER: ${NEXTCLOUD_USER}"
outputAndLog "CIFS_PATH: ${CIFS_PATH}"
outputAndLog "CIFS_USER: ${CIFS_USER}"$'\r'

# TODO Alternative: Mount folders right before backup, instead of mounting in entry script.
# TODO Welchen Pfad muss ich hier prüfen?
if [ ! grep -qs "${NEXTCLOUD_PATH}" /proc/mounts ]; then
    outputAndLog "Nextcloud path '${NEXTCLOUD_PATH}' is not mounted anymore. Please restart the container."
    kill 1
elif [ ! grep -qs "${CIFS_PATH}" /proc/mounts ]; then
    outputAndLog "CIFS path '${CIFS_PATH}' is not mounted anymore. Please restart the container."
    kill 1
fi

rsync ${RSYNC_JOB_ARGS} --exclude="lost+found" /mnt/nextcloud/ /mnt/cifs/ >> ${lastBackupLogfile} 2>&1
rsync_status=$?
end=`date +%s`

if [ ${rsync_status} -eq 0 ]; then
  echo "Backup successfully finished at $(date +"%Y-%m-%d %H:%M:%S") after $((end-start)) seconds"
else 
  echo "Backup FAILED at $(date +"%Y-%m-%d %H:%M:%S") after $((end-start)) seconds"
fi

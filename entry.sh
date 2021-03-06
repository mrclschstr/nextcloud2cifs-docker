#!/bin/sh

echo "Starting container ..."

# TODO Is there a technique which doesn't require privileged mode?
# Check if container is running in privileged mode (https://stackoverflow.com/a/32144661)
ip link add dummy0 type dummy > /dev/null 2>&1
if [ $? != 0 ]; then
  echo "Container not running in privileged mode. Please add '--privileged' to your docker run command."
  exit 1
fi

# clean the dummy0 link
ip link delete dummy0 > /dev/null 2>&1

# Mount nextcloud and check if successfull, exit otherwise (https://wiki.ubuntuusers.de/WebDAV/)
echo "/mnt/nextcloud ${NEXTCLOUD_USER} '${NEXTCLOUD_PASSWORD}'" > /etc/davfs2/secrets
mount -t davfs ${NEXTCLOUD_PATH} /mnt/nextcloud
if [ $? == 0 ]; then
  echo "Nextcloud share '${NEXTCLOUD_PATH}' successfully mounted."
else
  echo "Mounting of nextcloud share '${NEXTCLOUD_PATH}' failed."
  exit 1
fi

# Mount nas/cifs and check if successfull, exit otherwise
mount -t cifs -o user=${CIFS_USER},password=${CIFS_PASSWORD} ${CIFS_PATH} /mnt/cifs
if [ $? == 0 ]; then
  echo "CIFS share '${CIFS_PATH}' successfully mounted."
else
  echo "Mounting of CIFS share '${CIFS_PATH}' failed."
  exit 1
fi

echo "Setup backup cron job with cron expression BACKUP_CRON: ${BACKUP_CRON}"
echo "${BACKUP_CRON} /bin/backup >> /var/log/cron.log 2>&1" > /var/spool/cron/crontabs/root
crond

echo "Container started."

# Make sure the file exists before we start tail
touch /var/log/cron.log
tail -fn0 /var/log/cron.log

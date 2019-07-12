# Nextcloud to Cifs Share Docker Container

A docker container to automate the backup of files stored in a nextcloud (or other WebDAV server) to a CIFS/SMB share (e.g. Synology NAS). This container runs rsync in regular intervals.

 - **Pre-built Container (aarch64)**: [mrclschstr/nextcloud2cifs-docker](https://marina.io/repos/mrclschstr/nextcloud2cifs-docker)
 - **Pre-built Container (armhf)**: Automatic builds for **armhf** don't work at the moment &#8594; see [#14](https://github.com/cloudfleet/floating-dock/issues/14).

Please don't hesitate to report any issue or participate with a pull request. **Thanks.**

# Quick Setup

To setup the marina.io repository, have a look into the [official documentation](https://marina.readthedocs.io/en/latest/tutorial/quickstart.html#set-up-your-raspberry-pi) or just execute the following command on your shell:

```console
docker login aarch64.registry.marina.io
```

To use this container just type the docker command:

```console
docker pull aarch64.registry.marina.io/mrclschstr/restic-backup-docker
```

***TODO:*** *Provide `docker run` examples...*

# Environment variables

 - `BACKUP_CRON` - *Optional*. A cron expression to run the backup. **Default**: `0 0 * * *` aka daily at 00:00.
 - `RSYNC_JOB_ARGS` - *Optional*. Allows to specify extra arguments to the rsync job. **Default**: `-hruv --remove-source-files --force`. The exclude `--exclude="lost+found"` is defined by default and cannot be changed by this environment variable. Have a look at the [official documentation](https://linux.die.net/man/1/rsync) for further information.
 - `NEXTCLOUD_PATH` - WebDAV path which is used as *source*. Path has the following scheme: `https://example.com/nextcloud/remote.php/dav/files/<USERNAME>/<FOLDER>`.
 - `NEXTCLOUD_USER` - Username of the nextcloud account.
 - `NEXTCLOUD_PASSWORD` - The password of the nextcloud account. **Security advisory**: Don't use your real account password here! I recommend setting up a [device-specific password](https://docs.nextcloud.com/server/16/user_manual/session_management.html#managing-devices).
 - `CIFS_PATH` - CIFS path which is used as *destination*. Path has the following scheme: `//IP-ADDRESS/SHARE`.
 - `CIFS_USER` - Username of the CIFS share.
 - `CIFS_PASSWORD` - The password of the CIFS share. **Security advisory**: Use a dedicated share user with restricted access only. This prevents colateral damage in case of a misconfigured rsync run.

# Tips & Tricks
## Logfiles

Logfiles are inside the container in the `/var/log/` path. If needed, you can create a [volume](https://docs.docker.com/engine/reference/run/#volume-shared-filesystems) for them.

Executing `docker logs` shows `/var/log/cron.log`. Additionally you can see the the full log including rsync output of the last execution in `/var/log/backup-last.log`.

## Cron time and timezone

The cron daemon uses UTC time zone by default. You can map the files `/etc/localtime` and `/etc/timezone` read-only to the container to match the time and timezone of your host.

```console
-v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro
```

# TODO

 - Use tags for official releases and not just the master branch
 - Provide simple docker run examples in README
 - Implement mail notifications for certain events (successfull/failed backups, mount errors, ...)


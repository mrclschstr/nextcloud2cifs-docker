FROM alpine:3.10

RUN echo https://nl.alpinelinux.org/alpine/v3.10/community >> /etc/apk/repositories \
    && apk add --update --no-cache ca-certificates rsync davfs2 cifs-utils heirloom-mailx \
    && RUN mkdir -p /mnt/nextcloud /mnt/cifs \
    && touch /var/log/cron.log

ENV BACKUP_CRON="0 0 * * *"
ENV RSYNC_JOB_ARGS="-hruv --remove-source-files --force"
ENV NEXTCLOUD_PATH=""
ENV NEXTCLOUD_USER=""
ENV NEXTCLOUD_PASSWORD=""
ENV CIFS_PATH=""
ENV CIFS_USER=""
ENV CIFS_PASSWORD=""

COPY entry.sh /entry.sh
COPY backup.sh /bin/backup

WORKDIR "/"
ENTRYPOINT ["/entry.sh"]
CMD ["tail","-fn0","/var/log/cron.log"]

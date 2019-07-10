FROM alpine:3.10

RUN echo https://nl.alpinelinux.org/alpine/v3.10/community >> /etc/apk/repositories
RUN apk add --update --no-cache ca-certificates davfs2 cifs-utils

RUN mkdir -p /mnt/nextcloud /mnt/cifs

ENV NEXTCLOUD_PATH=""
ENV NEXTCLOUD_USER=""
ENV NEXTCLOUD_PASSWORD=""
ENV CIFS_PATH=""
ENV CIFS_USER=""
ENV CIFS_PASSWORD=""
ENV BACKUP_CRON="0 */6 * * *"

COPY entry.sh /entry.sh
COPY backup.sh /bin/backup
RUN chmod +x /entry.sh /bin/backup

RUN touch /var/log/cron.log

WORKDIR "/"
ENTRYPOINT ["/entry.sh"]

#!/usr/bin/env bash

set -e

VENDOR_SYNC_CRON_SCHEDULE=${VENDOR_SYNC_CRON_SCHEDULE:-*/30 * * * *}

mkdir -p ${VENDOR_DESTINATION}

if [ "$1" == 'composer-sync' ]; then
    filecount=`find "$VENDOR_DESTINATION" -type f | wc -l`
    if [ ${filecount} -eq 0 ];
    then
        echo "full sync the vendors is need"
        sudo chown -R $(id -u -n):$(id -u -n) ${VENDOR_DESTINATION}
        composer-sync
    fi
    echo -e "$VENDOR_SYNC_CRON_SCHEDULE composer-sync" | crontab -
    echo "sync the vendors by cron is starting..."
    exec crond -f
else
    exec "$@"
fi

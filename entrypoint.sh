#!/bin/bash

set -e

export MONGO_URI=${MONGO_URI:-mongodb://mongo:27017}
export TARGET_FOLDER=${TARGET_FOLDER-/backup}   # can be set to null

# Optional env vars:
# - CRON_SCHEDULE
# - AWS_ACCESS_KEY_ID
# - AWS_SECRET_ACCESS_KEY
# - ACL

if [[ "$CRON_SCHEDULE" ]]; then
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    CRON_ENV="MONGO_URI='$MONGO_URI'\nBUCKET_NAME='$BUCKET_NAME'\nENDPOINT_URL='$ENDPOINT_URL'\nTARGET_S3_FOLDER='$TARGET_S3_FOLDER'"
    if [[ "$TARGET_FOLDER" ]]; then
        CRON_ENV="$CRON_ENV\nTARGET_FOLDER='$TARGET_FOLDER'"
    fi
    if [[ "$AWS_ACCESS_KEY_ID" ]]; then
        CRON_ENV="$CRON_ENV\nAWS_ACCESS_KEY_ID='$AWS_ACCESS_KEY_ID'"
    fi
    if [[ "$AWS_SECRET_ACCESS_KEY" ]]; then
        CRON_ENV="$CRON_ENV\nAWS_SECRET_ACCESS_KEY='$AWS_SECRET_ACCESS_KEY'"
    fi
    if [[ "$ACL" ]]; then
        CRON_ENV="$CRON_ENV\nACL='$ACL'"
    fi
    echo -e "$CRON_ENV\n$CRON_SCHEDULE /backup.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    cron
    tail -f "$LOGFIFO"
else
    exec /backup.sh
fi

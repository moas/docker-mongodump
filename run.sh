#!/bin/sh

set -e


if [ "${CRON_SCHEDULE}" = "**None**" ]; then
  echo "You must set a backup schedule."
  exit 1
fi

if [ "${AWS_ACCESS_KEY_ID}" = "**None**" ]; then
  echo "You must set a AWS_ACCESS_KEY_ID."
  exit 1
fi

if [ "${AWS_SECRET_ACCESS_KEY}" = "**None**" ]; then
  echo "You must set AWS_SECRET_ACCESS_KEY."
  exit 1
fi

if [ "${ENDPOINT_URL}" = "**None**" ]; then
  echo "You must set ENDPOINT_URL."
  exit 1
fi

if [ "${BUCKET_NAME}" = "**None**" ]; then
  echo "You must set BUCKET_NAME."
  exit 1
fi

echo "Performing an immediate backup..."
sh /backup.sh # perform an immediate backup
exec go-cron "$CRON_SCHEDULE" /bin/sh /backup.sh
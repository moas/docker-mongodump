#!/bin/sh

set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)

AWS_BIN=$(which aws)

FILE="${TARGET_FOLDER:-/backup}/backup-$DATE.tar.gz"

mkdir -p "${TARGET_FOLDER:-/backup}"
mongodump --uri "$MONGO_URI" --gzip --archive="$FILE"
echo "Mongo dump saved to $FILE"

${AWS_BIN} s3api put-object --bucket "$BUCKET_NAME" --endpoint-url "$ENDPOINT_URL" --key "${TARGET_S3_FOLDER:-mongodump}/backup-$DATE.tar.gz" --body "$FILE" --acl "${ACL:-private}"

RET=$?
if [ "$RET" -eq 0 ]; then
    echo "$FILE uploaded to ${TARGET_S3_FOLDER:-mongodump}/backup-$DATE.tar.gz on $ENDPOINT_URL done!"
else
    echo "$FILE uploaded to ${TARGET_S3_FOLDER:-mongodump}/backup-$DATE.tar.gz on $ENDPOINT_URL failed"
fi

echo "Job finished: $(date)"

Inspired by istepanov/mongodump
===============================

Docker image with `mongodump`, `cron` and AWS CLI to upload backups to digitalocean spaces.

### Environment variables

| Env var                 | Description                                                                       | Default                               |
|-------------------------|-----------------------------------------------------------------------------------|---------------------------------------|
| `MONGO_URI`             | Mongo URI.                                                                        | `mongodb://mongo:27017`               |
| `CRON_SCHEDULE`         | Cron schedule. Leave empty to disable cron job.                                   | `''`                                  |
| `TARGET_FOLDER`         | Local folder (inside the container) to save backups. Mount volume to this folder. | `'/backup'`                           |
| `TARGET_S3_FOLDER`      | Folder to upload backups (required).                                              | `'mongodump'`                         |
| `AWS_ACCESS_KEY_ID`     | AWS Access Key ID. Leave empty if you want to use AWS IAM Role instead.           | `''`                                  |
| `AWS_SECRET_ACCESS_KEY` | AWS Access Key ID. Leave empty if you want to use AWS IAM Role instead.           | `''`                                  |
| `ENDPOINT_URL`          | Digitalocean spaces URL (required).                                               | `'https://us.digitaloceanspaces.com'` |
| `BUCKET_NAME`           | Bucket targeted (required).                                                       | `''`                                  |
| `ACL`                   | ACL Politic.                                                                      | `'private'`                           |

### Examples

Run container with cron job (once a day at 1am), save backup to `/target/folder` in bucket `backup`:

    docker run -d \
      -v /path/to/target/folder:/backup \
      -e 'MONGO_URI=mongodb://mongo:27017' \
      -e 'CRON_SCHEDULE=0 1 * * *' \
      -e 'TARGET_S3_FOLDER=mongodump' \
      -e 'AWS_ACCESS_KEY_ID=my_aws_key' \
      -e 'AWS_SECRET_ACCESS_KEY=my_aws_secret' \
      -e 'BUCKET_NAME=backup'
      m0as/mongodump-s3-digitalocean:4.4


Docker Compose example - run container with cron job (once a day at 1am), save backup to `mongo-backup` volume:

    version: '3'

    services:
      mongo:
        image: "mongo:4.2"

      mongo-backup:
        image: "istepanov/mongodump:4.2"
        volumes:
          - mongo-backup:/backup
        environment:
          MONGO_URI: "mongodb://mongo:27017"
          CRON_SCHEDULE: "0 1 * * *"
        depends_on:
          - mongo

    volumes:
      mongo-backup:

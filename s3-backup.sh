#!/usr/bin/bash

PYTHONHOME=/app/vendor/awscli/
Green='\033[0;32m'
EC='\033[0m'
NOW=`date +%Y%m%d_%H_%M`

# terminate script on any fails
set -e

if [[ -z "$DB_BACKUP_AWS_ACCESS_KEY_ID" ]]; then
  echo "Missing DB_BACKUP_AWS_ACCESS_KEY_ID variable"
  exit 1
fi

if [[ -z "$DB_BACKUP_AWS_SECRET_ACCESS_KEY" ]]; then
  echo "Missing DB_BACKUP_AWS_SECRET_ACCESS_KEY variable"
  exit 1
fi

if [[ -z "$DB_BACKUP_AWS_DEFAULT_REGION" ]]; then
  echo "Missing DB_BACKUP_AWS_DEFAULT_REGION variable"
  exit 1
fi

if [[ -z "$DB_BACKUP_S3_BUCKET_PATH" ]]; then
  echo "Missing DB_BACKUP_S3_BUCKET_PATH variable"
  exit 1
fi

if [[ -z "$BACKUP_DATABASE_URL" ]] ; then
  echo "Missing DATABASE_URL variable";
  exit 1
fi

DB_BACKUP_SCHEME=$(echo $BACKUP_DATABASE_URL | grep -oP "^(.+?):" | cut -d: -f1)
DB_BACKUP_USER=$(echo $BACKUP_DATABASE_URL | grep -oP "mysql://\K(.+?):" | cut -d: -f1)
DB_BACKUP_PASSWORD=$(echo $BACKUP_DATABASE_URL | grep -oP "mysql://.*:\K(.+?)@" | cut -d@ -f1)
DB_BACKUP_HOST=$(echo $BACKUP_DATABASE_URL | grep -oP "mysql://.*@\K(.+?):" | cut -d: -f1)
DB_BACKUP_PORT=$(echo $BACKUP_DATABASE_URL | grep -oP "mysql://.*@.*:\K(\d+)/" | cut -d/ -f1)
DB_BACKUP_DATABASE=$(echo $BACKUP_DATABASE_URL | grep -oP "mysql://.*@.*:.*/\K(.+?)$" | cut -d\? -f1)

printf "${Green}Start dump of database directly to S3${EC}"

if [[ $DB_BACKUP_SCHEME == mysql ]]; then
  dbclient-fetcher mysql

  mysqldump \
    -h $DB_BACKUP_HOST \
    -u $DB_BACKUP_USER \
    -p$DB_BACKUP_PASSWORD \
    -P $DB_BACKUP_PORT \
    $DB_BACKUP_DATABASE \
    --no-tablespaces \
    --single-transaction \
    --quick \
    --lock-tables=false \
    | gzip \
    | \
    AWS_ACCESS_KEY_ID=$DB_BACKUP_AWS_ACCESS_KEY_ID \
    AWS_SECRET_ACCESS_KEY=$DB_BACKUP_AWS_SECRET_ACCESS_KEY \
    /app/vendor/bin/aws --region $DB_BACKUP_AWS_DEFAULT_REGION s3 cp - \
    s3://$DB_BACKUP_S3_BUCKET_PATH/"${APP}_${NOW}".sql.gz
else
  echo "Unknown database URL protocol. Must be mysql."
  exit 1;
fi;

printf "${Green}The database dump has been done${EC}"
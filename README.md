## Scalingo Buildpack

Capture MySQL DB in Scalingo and stream it to s3 bucket. Buildpack contains AWS CLI.

### Installation

[Add buildpack to your App](https://doc.scalingo.com/platform/deployment/buildpacks/multi)
Buildpacks are scripts that are run when your app is deployed.

### Configure environment variables
```
$ scalingo -a my-app env-set "DB_BACKUP_AWS_ACCESS_KEY_ID=secret"
$ scalingo -a my-app env-set "DB_BACKUP_AWS_SECRET_ACCESS_KEY=secret"
$ scalingo -a my-app env-set "DB_BACKUP_AWS_DEFAULT_REGION=us-east-1"
$ scalingo -a my-app env-set "DB_BACKUP_S3_BUCKET_PATH=my.bucket/path/to/backup/"
$ scalingo -a my-app env-set "BACKUP_DATABASE_URL=mysql://user:password@host:port/dbname"
```

### One-time runs

You can run the backup task as a one-time task:

```
$ scalingo --app my-app run bash /app/vendor/scripts/s3-backup.sh
```

### Scheduler

By default, the backup is scheduled at 2:30am. You can change the scheduling with this command, following cron syntax.

```
$ scalingo -a my-app env-set "DB_BACKUP_SCHEDULE=30 2 * * *"
```

### Container size

Container size is S by default. If for some reason you need more :

```
$ scalingo -a my-app env-set "DB_BACKUP_CONTAINER_SIZE=2XL"
```

### Disable

If you wish to disable the scheduling on some environnements, set the DISABLE_DB_BACKUP_SCHEDULE env var to whatever

```
$ scalingo -a my-app env-set "DISABLE_DB_BACKUP_SCHEDULE=chewbhakan"
```

### Restoring


### Troubleshoot

Follow [this document](https://doc.scalingo.com/platform/deployment/buildpacks/custom) in order to know how to investigate further issues 
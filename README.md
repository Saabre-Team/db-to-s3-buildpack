## Scalingo Buildpack

Capture MySQL DB in Scalingo and copy it to s3 bucket. Buildpack contains AWS CLI.

### Installation
Add buildpack to your App
```
```
> Buildpacks are scripts that are run when your app is deployed.

### Configure environment variables
```
$ heroku config:add DB_BACKUP_AWS_ACCESS_KEY_ID=someaccesskey --app <your_app>
$ heroku config:add DB_BACKUP_AWS_SECRET_ACCESS_KEY=supermegasecret --app <your_app>
$ heroku config:add DB_BACKUP_AWS_DEFAULT_REGION=eu-central-1 --app <your_app>
$ heroku config:add DB_BACKUP_S3_BUCKET_PATH=your-bucket --app <your_app>
$ heroku config:add DB_BACKUP_ENC_KEY=somethingverysecret --app <your_app>
```

#### For MySQL:

You will need to install a mysql buildpack to make the `mysqldump` command available. For example:

```
$ heroku buildpacks:add https://github.com/daetherius/heroku-buildpack-mysql --app <your_app>
```

Then configure the following:

```
$ heroku config:add DB_BACKUP_HOST=your-db-host --app <your_app>
$ heroku config:add DB_BACKUP_USER=your-db-user --app <your_app>
$ heroku config:add DB_BACKUP_PASSWORD=your-db-password --app <your_app>
$ heroku config:add DB_BACKUP_DATABASE=your-db-name --app <your_app>
```

### One-time runs

You can run the backup task as a one-time task:

```
$ heroku run bash /app/vendor/backup.sh -db <somedbname> --app <your_app>
```

### Scheduler

### Restoring

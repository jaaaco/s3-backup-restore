[![Docker Build Status](https://img.shields.io/docker/build/jaaaco/s3-backup-restore.svg)](https://hub.docker.com/r/jaaaco/s3-backup-restore/)

# S3 Backup / Restore-on-startup container

When started container checks if there is archive present on S3 and restores it to mounted /data volume.

Then it goes to cron-mode, making archive **in same S3 file** according to specified CRON_SCHEDULE.

If you want backup file retention enable Versioning on S3 bucket and create S3 Life Cycle Rules to permanently 
delete older version after certain number of days.

## Usage

Example docker-compose.yml:

```
version: '3.3'
services:
  app:
    image: wordpress
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_PASSWORD: password
    volumes:
      - data-volume:/var/www/html
  mysql:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: password
  files-backup:
    image: s3-backup-restore
    depends_on:
      - app
    volumes:
      - data-volume:/data
    environment:
      S3BUCKET: your-aws-s3-bucket-name
      AWS_ACCESS_KEY_ID: your-aws-access-key
      AWS_SECRET_ACCESS_KEY: your-aws-secret-access-key
      FILEPREFIX: my-app-files
volumes:
  data-volume:
```

## Creating initial backup manually

```
docker exec running-container-id /backup.sh backup
```

## Required ENV variables

* AWS_ACCESS_KEY_ID - key for aws user with s3 put-object and get-object permissions
* AWS_SECRET_ACCESS_KEY
* S3BUCKET - S3 bucket name
* FILEPREFIX - (optional) file prefix, defaults to "backup"
* CRON_SCHEDULE - (optional) cron schedule, defaults to 4 4 * * * (at 4:04 am, every day)
* DELAY - (optional) restore delay in seconds, defaults to 15 sec.
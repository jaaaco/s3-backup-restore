[![Docker Build Status](https://img.shields.io/docker/build/jaaaco/s3-backup-restore.svg)](https://hub.docker.com/r/jaaaco/s3-backup-restore/)

# S3 Backup / Restore container

When started it goes to wait mode (by default) waiting for docker exec commands 
to make backup or restore. 

# Cron mode

To enable cron mode to make backups according to CRON_SCHEDULE add **command: /command cron* to your composition.

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
    volumes:
      - "${pwd}/my.cnf:/etc/mysql/my.cnf"
    environment:
      MYSQL_ROOT_PASSWORD: password
  files-backup:
    image: jaaaco/s3-backup-restore
    depends_on:
      - app
    volumes:
      - data-volume:/data
    environment:
      S3BUCKET: <your-bucket-name>
      AWS_ACCESS_KEY_ID: <your-aws-key-id-here>
      AWS_SECRET_ACCESS_KEY: <your-aws-secret-key-here>
      FILEPREFIX: my-app-files
      CRON_SCHEDULE: 4 4 * * *
volumes:
  data-volume:
```

## Creating backups

```
docker exec <running-container-id> /command backup
```


It creates an archive **in the same S3 file**.

If you want backup file retention enable Versioning on S3 bucket and create S3 Life Cycle Rules to permanently 
delete older version after certain number of days.

## Restoring files from latest archive

```
docker exec <running-container-id> /command restore
```

## Required ENV variables

* AWS_ACCESS_KEY_ID - key for aws user with s3 put-object and get-object permissions
* AWS_SECRET_ACCESS_KEY
* S3BUCKET - S3 bucket name
* FILEPREFIX - (optional) file prefix, defaults to "backup"
* CRON_SCHEDULE - (optional) cron schedule, defaults to 4 4 * * * (at 4:04 am, every day)

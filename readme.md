#Configuration Scripts for centos machines#
	
This repo is a collection of backup configuration scripts for centos machines

###Notes###
* Check if there is execute permission
* Need to execute this as root. For security reasons execute with a user who is not root with sudo command

###To Setup Backup scripts###
* create backup folders and backup log folders if not present already
```
#!shell

	./configure-backup.sh

```
* Setup cron jobs
```
#!shell

15 1 * * * root sh /root/s3-daily-backup.sh 1>/var/log/backup-log/daily/full-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/daily/error-$(date +\%d-\%m-\%Y).log;
15 5 * * 0 root sh /root/s3-weekly-backup.sh 1>/var/log/backup-log/weekly/full-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/weekly/error-$(date +\%d-\%m-\%Y).log;
15 3 1 * * root sh /root/s3-monthly-backup.sh 1>/var/log/backup-log/monthly/full-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/monthly/error-$(date +\%d-\%m-\%Y).log;
15 2 * * * root sh /root/s3-db-daily-backup.sh 1>/var/log/backup-log/daily/full-db-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/daily/error-db-$(date +\%d-\%m-\%Y).log;
15 6 * * 0 root sh /root/s3-db-weekly-backup.sh 1>/var/log/backup-log/weekly/full-db-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/weekly/error-db-$(date +\%d-\%m-\%Y).log;
15 4 1 * * root sh /root/s3-db-monthly-backup.sh 1>/var/log/backup-log/monthly/full-db-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/monthly/error-db-$(date +\%d-\%m-\%Y).log;
10 0 * * 0 root rm -rf /var/log/backup-log/daily/*
12 0 1 * * root rm -rf /var/log/backup-log/weekly/*
15 0 31 12 * root rm -rf /var/log/backup-log/monthly/*

```

*  PLEASE NOTE : Requirement: aws cli tools need to have been installed and configured beforehand on the server fro s3 backup
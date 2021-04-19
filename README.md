# MyDumper Backup and Restore Scripts

Collection of backup scripts (sometimes just wrapers) for MySQL.

Tools to enhance the MySQL Backup experience and make it easier (almost plug and play...almost!)

Source: [mydumper.sh](https://github.com/nethalo/backup-scripts) 


All the scripts take care of the retention policy (defined by the user), as followed:

- For MyDumper: User will define weekly and daily retention times.

## MyDumper backup
mydumper.sh
Bash script used as a wraper of the [MyDumper](https://launchpad.net/mydumper "MyDumper") backup tool. Run this script as a daily cronjob

## Mysqldump backup
mydumper_restore.sh
Bash script that restores backups generated with mydumper
Expects 2 arguments:
1) Backup-point
2) Databasename (or all)
- running it without arguments will show available backup-points
- running it with a valid backup-point argument but without database name will output all available database backups

## Configuration
config.sh
Set the backup path , the retention time and mysql user.

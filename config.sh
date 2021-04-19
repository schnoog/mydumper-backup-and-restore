#!/bin/bash

# Config-File used for mydumper.sh and mydumpder_restore.sh
# 

# Retention times #
weekly=4
daily=7


#Folder for backups
export BASEDIR="/DBBackups/mydumper/"

#MySQL Settings
mysqlUser=mydump
mysqlPassword=$(cat  /root/mydump_pw)  #Set your 

mysqlPort=3306
remoteHost=localhost

#Number of parallel Threads
numberThreads=4

#email for error messages
email="root@localhost"

#log files
errorFile="/var/log/mysql/mydumper.err"
logFile="/var/log/mysql/mydumper.log"

#lock file
lockFile="/var/lock/mydumper-pull.lock"


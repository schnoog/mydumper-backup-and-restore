#!/bin/bash

# Backup-Restore script for Backups created with
# Logic Backup MySQL data using MyDumper tool
# Daniel Guzman Burgos <daniel.guzman.burgos@percona.com>
# 
#


IFS="
"


CONFIG_FILE="$(dirname $(readlink -f "$0"))""/config.sh"

source "$CONFIG_FILE"



function ShowUsage {
	echo "Usage:  $0 <backup-point> <option>"
	echo "  valid options are:"
	echo " - list or empty -> show all available databases in backup point"
	echo " - all -> recover all database backups"
	echo " - name -> recover this database"
	GetBUDirs
	
}

function GetBUDirs {
	BDL=${#BASEDIR}
	BUDS=$(find $BASEDIR -type d | grep -v '/$')
	echo "--your valid backup points are--"
	for BUD in $BUDS
	do
		BD=${BUD:$BDL}
		echo $BD
	done
}

function IsValidBUDir {
	BUDIR=$BASEDIR"$1"
	if [ ! -d $BUDIR ] 
	then
		echo "--Not a valid backup point--"
		GetBUDirs
		exit 1
		
	fi
}

function GetDBs {
#	BUDIR="$BASEDIR""$1"
#	echo $BUDIR
	AllDBs=$(find "$BUDIR" -name '*_schema.sql.gz' -exec basename "{}" '_schema.sql.gz' \; | sort | grep -v '\.')
	for DB in $AllDBs
	do
		echo "$DB"
	done
}

function RecoverDataseSpool {
	intDone=0
	AllDBs=$(find "$BUDIR" -name '*_schema.sql.gz' -exec basename "{}" '_schema.sql.gz' \; | sort | grep -v '\.')
	for DB in $AllDBs
	do
		if [ "$1" == "all" ] || [ "$1" == "$DB" ]
		then
				echo "- Recover-Database $DB "
				let intDone=$intDone+1
				SCHEMA="$BASEDIR""$BUTS""/$DB"'_schema.sql.gz'
				int=0
				imports[$int]="$SCHEMA"
				addfiles=$(find "$BUDIR" -name "$DB""*.sql.gz")
				for addfile in $addfiles
				do
					let int=$int+1
					imports[$int]="$addfile"
				done

				for import in ${imports[*]}
				do
					zcat "$import" | mysql -u${mysqlUser} -p${mysqlPassword} -h${remoteHost} --port=${mysqlPort} "$DB"				
				done
				echo "- $DB recovered $int tables "



		fi
	done

	if [ "$intDone" == "0" ]
	then
		echo "Unknown Database $2"
		echo "You can see a list of valid database names by using"
		echo "./""$0"" $BUTS list"
	exit 1
	fi

    echo "Done - $intDone databases recovered"

}


##########################


if [ "$1" == "" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]
then
	ShowUsage
	exit 0;
fi

IsValidBUDir "$1"
export BUTS="$1"	
export BUDIR="$BASEDIR""$1"

if [ "$2" == "" ] || [ "$2" == "list" ]
then
	GetDBs
	exit 0
fi

RecoverDataseSpool "$2"




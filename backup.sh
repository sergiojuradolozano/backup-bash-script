#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# Setting 2 Variables equal to the values of the first and second command line arguments
targetDirectory=$1
destinationDirectory=$2

# Display the Values
echo "Target directory: $targetDirectory"
echo "Backup destination: $destinationDirectory"

# Define a variable called currentTS as the current timestamp, expressed in seconds.
currentTS=`date +%s`

# Define a variable called backupFileName to store the name of the archived and compressed backup file that the script will create.
backupFileName="backup-$currentTS.tar.gz"

# Define a variable called origAbsPath with the absolute path of the current directory as the variable’s value.
origAbsPath=`pwd`

# Define a variable called destAbsPath with value equal to the absolute path of the destination directory.
cd $destinationDirectory # changing to destination directory
destAbsPath=`pwd`

# Change directories from the current working directory to the target directory targetDirectory.
cd $origAbsPath # <- changing to original directory
cd $targetDirectory # <- changing to the target directory

# Define a numerical variable called yesterdayTS as the timestamp (in seconds) 24 hours prior to the current timestamp, currentTS
yesterdayTS=$(($currentTS - 24 * 60 * 60))

# Declaring a Variable called toBackup
declare -a toBackup

for file in $(ls -a) # Listing all files and directories
do
  # if statement to check whether the $file was modified within the last 24 hours
  if ((`date -r $file +%s` > $yesterdayTS))
  then
    toBackup+=($file)  # addiing the $file that was updated in the past 24-hours to the toBackup array.
  fi
done

# Compressing and archiving the files, using the $toBackup array of filenames, to a file with the name backupFileName.
tar -czvf $backupFileName ${toBackup[@]}

# Moving the file backupFileName to the destination directory located at destAbsPath
mv $backupFileName $destAbsPath

echo "Done!"
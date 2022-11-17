# Backup automation

# ​The script needs to be copied to the ​bin directory to be executed across different directories.
sudo cp /path/to/profit /usr/local/bin  

# Open crontab 
crontab -e

# Adding the crontab task
# in this example, the backup will be executed every every day at 00:00h
#/home/target represent the target directory 
#/home/dest represents the destination directory
0 0 * * * /usr/local/bin/backup.sh /home/target /home/dest

# Save the crontab
# Start crontab
sudo service cron start

# The crontab is up and running!
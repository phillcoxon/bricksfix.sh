#!/bin/sh

# Check current user
current_user=$(whoami)

# Check if running as root
if [ "$current_user" = "root" ]; then
    echo "Error: running as root. su to user."
    exit 1
fi


# Check if common WordPress files exist in the current directory
if [ -f "wp-load.php" ] && [ -f "wp-includes/version.php" ]; then
    echo "You are in the WordPress root folder: $(pwd)"
else
    echo "You are not in the WordPress root folder."
    exit
fi

rm -rf wp-includes
rm -rf wp-admin
rm *.php
wget wordpress.org/latest.zip
unzip -q latest.zip  #q = quiet
cp -r wordpress/* .
rm latest.zip
rm -rf wordpress # delete extracted wordpress folder
echo -e "\nAdmin Users <7d:\n"
wp user list --roles=administrator
echo -e "\nTHEME CHANGES <7d:\n"
find ./wp-content/themes/ -type f -mtime -7
#ls -l wp-content/themes
echo -e "\nPLUGIN CHANGES <7d:\n"
find ./wp-content/plugins/ -type f -mtime -7
#ls -l wp-content/plugins
wp plugin update --all && wp theme update --all && wp core update && wp core verify-checksums

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
unzip latest.zip
cp -rv wordpress/* .
rm latest.zip
rm -rf wordpress
echo -e "\r\rTHEME CHANGES <7d:\r\r"
find ./wp-content/themes/ -type f -mtime -7
#ls -l wp-content/themes
echo -e "\r\rPLUGIN CHANGES <7d:\r\r"
find ./wp-content/plugins/ -type f -mtime -7
#ls -l wp-content/plugins
wp plugin update --all && wp theme update --all && wp core update && wp core verify-checksums

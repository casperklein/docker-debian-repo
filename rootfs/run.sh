#!/bin/bash

set -ueo pipefail

# import gpg key
gpg --import /mnt/key.gpg

cd /var/www/repos/apt/debian

# copy repo information
cp /mnt/distributions conf/

# export repo public key
gpg -a --export -o repo.gpg

# import packages
reprepro includedeb buster /mnt/*.deb
kill $(pidof gpg-agent)
echo
echo

echo 'Serving packages:'
reprepro list buster
echo
echo

# start apache2
apachectl start

# show logs
tail -F /var/log/apache2/error.log /var/log/apache2/access.log

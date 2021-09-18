# debian-repo

![Version][version-shield]
![Supports amd64 architecture][amd64-shield]
![Supports aarch64 architecture][aarch64-shield]
![Supports armhf architecture][armhf-shield]
![Supports armv7 architecture][armv7-shield]
![Docker image size][image-size-shield]

Docker image for running a Debian repositority based on [this](https://wiki.debian.org/DebianRepository/SetupWithReprepro) wiki page.

## Build Docker image (optional)

    make

## Run repository demo

    # Passphrase for GPG key: insecure
    docker run --rm -it -p 80:80 -v $PWD/repo-demo:/mnt:ro -e RELEASE=bullseye casperklein/debian-repo

## Setup repository on a client

Import repository public key

    wget -O - http://HOSTNAME/repos/apt/debian/repo.gpg | apt-key add -

Add repository to apt sources

    echo "deb http://HOSTNAME/repos/apt/debian/ $(lsb_release -cs) main" >> /etc/apt/sources.list

## Create own repository

1. Copy repo-demo

    `cp -a repo-demo myrepo`

1. Create/Export new GPG key

    `gpg --gen-key`

    `gpg -a -o myrepo/key.gpg --export-secret-keys <ID>`

1. Edit *myrepo/distributions* to your needs

    At least, you have to set *SignWith* to your GPG subkey ID

    `gpg --list-secret-key --with-subkey-fingerprint # show subkey ID`

    If you change "Codename", you have to adjust `-e RELEASE=` below accordingly.

1. Run own repository

    `docker run --rm -it -p 80:80 -v $PWD/myrepo:/mnt:ro -e RELEASE=bullseye casperklein/debian-repo`

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-blue.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-blue.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-blue.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-blue.svg
[version-shield]: https://img.shields.io/github/v/release/casperklein/docker-debian-repo
[image-size-shield]: https://img.shields.io/docker/image-size/casperklein/debian-repo/latest

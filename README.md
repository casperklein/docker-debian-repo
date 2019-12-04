# debian-repo

Docker image for running a Debian repositority based on [this](https://wiki.debian.org/DebianRepository/SetupWithReprepro) wiki page.

## Build Docker image (optional)

    make

## Run repository demo

    # Passphrase for GPG key: insecure
    docker run --rm -it -p 80:80 -v $PWD/repo-demo:/mnt:ro casperklein/debian-repo

## Setup repository on client:

Import repository public key

    wget -O - http://HOSTNAME/repos/apt/debian/repo.gpg | apt-key add -
    
Add repository to apt sources

    echo "deb http://HOSTNAME/repos/apt/debian/ $(lsb_release -cs) main" >> /etc/apt/sources.list

## Create own repository

1. Copy repo-demo
    
    ``cp -a repo-demo myrepo``

1. Create/Export new GPG key

    ``gpg --gen-key``

    ``gpg -a -o myrepo/key.gpg --export-secret-keys <ID>``

1. Edit *myrepo/distributions* to your needs

    At least, you have to set *SignWith* to your GPG subkey ID

    ``gpg --fingerprint --fingerprint # get subkey ID``

1. Run own repository

    ``docker run --rm -it -p 80:80 -v $PWD/myrepo:/mnt:ro casperklein/debian-repo``

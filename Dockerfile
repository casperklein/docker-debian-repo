FROM	debian:10-slim as build

ENV	USER="casperklein"
ENV	NAME="debian-repo"
ENV	VERSION="0.1"

ENV	PACKAGES="apache2 reprepro"

SHELL	["/bin/bash", "-o", "pipefail", "-c"]

# Install packages
RUN	apt-get update \
&&	apt-get -y --no-install-recommends install $PACKAGES

# Copy root filesystem
COPY	rootfs /

# Change web root to /var/www
RUN	rm -rf /var/www/html
#RUN	sed -i 's;DocumentRoot.*;DocumentRoot /var/www/;g' /etc/apache2/sites-available/000-default.conf

# Build final image
RUN	apt-get -y install dumb-init \
&&	rm -rf /var/lib/apt/lists/*
FROM	scratch
COPY	--from=build / /
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

EXPOSE	80
HEALTHCHECK --retries=1 CMD bash -c "</dev/tcp/localhost/80"

CMD	["/run.sh"]

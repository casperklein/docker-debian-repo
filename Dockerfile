FROM	debian:12-slim as build

ARG	PACKAGES="apache2 reprepro"

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
ENTRYPOINT ["dumb-init", "--"]

ARG	VERSION
LABEL	Version=$VERSION

EXPOSE	80
HEALTHCHECK --retries=1 CMD bash -c "</dev/tcp/localhost/80"

CMD	["/run.sh"]

ARG	VERSION="unknown"

LABEL	org.opencontainers.image.description="Docker image for running a Debian repositority"
LABEL	org.opencontainers.image.source="https://github.com/casperklein/docker-debian-repo/"
LABEL	org.opencontainers.image.title="docker-debian-repo"
LABEL	org.opencontainers.image.version="$VERSION"

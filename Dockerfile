FROM php:7.1.9-apache

MAINTAINER IT Savedo <it@savedo.de>

ARG REVIVE_VERSION=4.0.2
ENV REVIVE_VERSION=${REVIVE_VERSION}

RUN apt-get update -qq && \
    apt-get dist-upgrade -y && \
    apt-get install -y --fix-missing \
    less \
    unzip \
    curl \
    rsync \
    ca-certificates \
    libapache2-mod-geoip \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libbz2-dev \
    zlib1g-dev \
    libxml2-dev \
    libcurl4-openssl-dev

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) bz2 mbstring mysqli gd xml curl

RUN mkdir /tmp/revive
RUN curl -SL https://download.revive-adserver.com/revive-adserver-${REVIVE_VERSION}.tar.gz | tar -zx -C /tmp/revive --strip-components=1

# Apache ELB and security custom conf
COPY docker_resources/000-default.conf /etc/apache2/sites-available/
COPY docker_resources/apache_security.conf /etc/apache2/conf-available/
# Enable apache rewrite to https and headers
RUN a2enmod headers
RUN a2disconf security
RUN a2enconf apache_security

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]

# Use an official PHP runtime as a base image
FROM hexaua/dev

# ADD copyright
LABEL maintainer = "a.ohanov@hexa.com.ua"

# Install any needed packages
RUN pecl install xdebug-2.5.0 \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install sockets

RUN apt-get update -y

RUN apt-get install -y default-jre \
    curl \
    xvfb \
    iceweasel \
    mysql-client \
    libmysqlclient-dev -yqq --no-install-recommends

RUN apt-get purge -y g++ \
    && apt-get autoremove -y \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install from nodesource using apt-get
# https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-an-ubuntu-14-04-server
RUN curl -sL https://deb.nodesource.com/setup | sudo bash - && \
RUN apt-get install -yq nodejs build-essential

# fix npm - not the latest version installed by apt-get
RUN npm install -g npm

# install common full-stack JavaScript packages globally
# http://blog.nodejs.org/2011/03/23/npm-1-0-global-vs-local-installation
RUN sudo npm install -g bower

# optional, check locations and packages are correct
RUN which node; node -v; which npm; npm -v; \
RUN npm ls -g --depth=0
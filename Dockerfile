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

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.11.2

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.11/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# confirm installation
RUN node -v
RUN npm -v
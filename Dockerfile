FROM ubuntu:14.04

#scripts are in the mobilefe git repo under mobilefe/bash/shared
COPY ./scripts/ /src

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install base dependencies
RUN apt-get update && apt-get install -y -q --no-install-recommends \
        build-essential \
        curl \
        git \
        ruby-dev \
        runit \
        inotify-tools \
        && rm -rf /var/lib/apt/lists/*

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 0.10

RUN gem install --no-rdoc --no-ri compass -v 1.0.0.alpha.21

# Install nvm with node and npm
RUN  ./src/creationix-nvm-install.sh \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install -g yo \
    && npm install -g grunt-cli bower grunt-ng-constant grunt-aws-s3 \
    && ln -s $(which node) /usr/local/bin/node 

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

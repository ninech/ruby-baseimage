FROM docker-registry-default.nine.ch/ninech/ubuntu:xenial
MAINTAINER development@nine.ch

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

ENV DEBIAN_FRONTEND=noninteractive

# Install essential dev tools
RUN apt-get update &&  apt-get -qq install -y \
      ruby ruby-dev \
      libpq-dev postgresql-client \
      libmysqlclient-dev mysql-client \
      netcat-openbsd \
      git \
      nodejs nodejs-legacy npm \
      xvfb qt5-default libqt5webkit5-dev libqtwebkit-dev \
      build-essential \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install a recent bundler version
RUN gem install bundler --no-document

# Helper scripts
COPY scripts/* /usr/local/bin/

# Create base directory for the application
RUN mkdir -p /app
WORKDIR /app

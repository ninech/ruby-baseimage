FROM docker-registry.nine.ch/ninech/ubuntu:trusty

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/01norecommend; \
    echo 'APT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01nosuggests

# Install essential dev tools
RUN    apt-get update \
    && apt-get -qq install -y software-properties-common \
    && apt-add-repository ppa:brightbox/ruby-ng \
    && apt-get update \
    && apt-get -qq install -y \
      tzdata \
      ruby2.3 ruby2.3-dev \
      libpq-dev postgresql-client \
      libmysqlclient-dev mysql-client \
      netcat-openbsd \
      git \
      nodejs nodejs-legacy npm \
      xvfb qt5-default libqt5webkit5-dev libqtwebkit-dev \
      build-essential \
      dbus gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Needed by xvfb-run or teaspoon
RUN dbus-uuidgen > /var/lib/dbus/machine-id

# Install a recent bundler version
ENV BUNDLE_SILENCE_ROOT_WARNING=1
RUN    gem install bundler --no-ri --no-rdoc \
    && bundle config jobs 2

# Helper scripts and configs
COPY scripts/* /usr/local/bin/
COPY rspec-config /root/.rspec
COPY pry-config /root/.pryrc
COPY bash_aliases /root/.bash_aliases

RUN    install-gems.sh \
    && configure-git.sh

# Create base directory for the application
RUN mkdir -p /app
WORKDIR /app

# Create the logs folder
RUN mkdir -p /app/log/

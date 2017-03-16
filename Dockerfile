FROM openjdk:9

ENV SCALA_VERSION 2.12.1
ENV ACTIVATOR_VER 1.3.12


WORKDIR /tmp

# Install Scala
RUN set -x && \
  mkdir -p /usr/local/scala && \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /usr/local/scala && \
  rm -rf /tmp/*
ENV PATH $PATH:/usr/local/scala/scala-$SCALA_VERSION/bin

RUN addgroup scala && \
  adduser -G scala -s /bin/sh -D scala
RUN mkdir -p /var/opt/activator

# Install typesafe activator
WORKDIR /var/opt/activator
RUN set -x && \
  wget http://downloads.typesafe.com/typesafe-activator/${ACTIVATOR_VER}/typesafe-activator-${ACTIVATOR_VER}-minimal.zip && \
  unzip typesafe-activator-${ACTIVATOR_VER}-minimal.zip  && \
  ln -s /var/opt/activator/activator-${ACTIVATOR_VER}-minimal /var/opt/activator/activator && \
  rm -f /var/opt/activator/typesafe-activator-${ACTIVATOR_VER}-minimal.zip && \
  chmod -R 775 /var/opt/activator/activator/bin/
ENV PATH=$PATH:/var/opt/activator/activator/bin

RUN mkdir -p /var/opt/app && \
  chown -R scala:scala /var/opt/app

USER scala

WORKDIR /var/opt/app

FROM            centos:centos7

MAINTAINER      Matt Gilman <matt.c.gilman@gmail.com>

ENV             NIFI_HOME               /opt/nifi

# Install necessary packages, create target directory, download and extract, and update the banner to let people know what version they are using
RUN             yum install -y java-1.8.0-openjdk-devel tar && \
                mkdir -p ${NIFI_HOME}

# Expose web port
EXPOSE          80 443
VOLUME          ["/opt/certs", "${NIFI_HOME}/flowfile_repository", "${NIFI_HOME}/database_repository", "${NIFI_HOME}/content_repository", "${NIFI_HOME}/provenance_repository"]

ADD             ./sh/ /opt/sh
CMD             ["/opt/sh/start.sh"]

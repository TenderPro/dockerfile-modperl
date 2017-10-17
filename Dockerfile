# modperl meta dockerfile
# See https://github.com/LeKovr/consup

FROM debian:wheezy

MAINTAINER Alexey Kovrizhkin <lekovr+docker@gmail.com>

ENV CONSUP_UBUNTU_CODENAME wheezy

ENV DOCKERFILE_VERSION  171017

# -------------------------------------------------------------------------------
# **** base ****
# -------------------------------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

# -------------------------------------------------------------------------------
# Run custom setup scripts

ADD setup_*.sh /tmp/

# Loop does not cache every step
#RUN for f in /tmp/setup_*.sh ; do >&2 echo ">>>> $f" ; . $f ; rm $f ; done

RUN bash /tmp/setup_0backports.sh
RUN bash /tmp/setup_1pkg.sh
RUN bash /tmp/setup_2pgdg.sh
RUN bash /tmp/setup_gosu.sh
RUN bash /tmp/setup_lang.sh
RUN bash /tmp/setup_perl.sh
RUN bash /tmp/setup_perllib_debian.sh
RUN bash /tmp/setup_pg_client.sh

# -------------------------------------------------------------------------------
# Setup primary lang
ENV LANG en_US.UTF-8

# -------------------------------------------------------------------------------
# **** modperl ****
# -------------------------------------------------------------------------------
# Install apache-1.3.42 & mod_perl-1.31

COPY asset-apache/*.deb /opt/apache/
RUN cd /opt/apache && dpkg -i *.deb

# -------------------------------------------------------------------------------
# user op

RUN useradd -m -r -s /bin/bash -Gwww-data -gusers -gsudo op

# -------------------------------------------------------------------------------

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /home/app

ENV APPUSER op

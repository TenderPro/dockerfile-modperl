# modperl meta dockerfile
# See https://github.com/LeKovr/consup

FROM debian:wheezy

MAINTAINER Alexey Kovrizhkin <lekovr+docker@gmail.com>

ENV CONSUP_UBUNTU_CODENAME wheezy

ENV DOCKERFILE_VERSION  171017

#COPY 02proxy /etc/apt/apt.conf.d/

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

RUN set -x \
  && bash /tmp/setup_0backports.sh \
  && bash /tmp/setup_1pkg.sh \
  && bash /tmp/setup_2pgdg.sh \
  && bash /tmp/setup_gosu.sh \
  && bash /tmp/setup_lang.sh \
  && bash /tmp/setup_nginx.sh \
  && bash /tmp/setup_perl.sh \
  && bash /tmp/setup_perllib_debian.sh \
  && bash /tmp/setup_pg_client.sh

# -------------------------------------------------------------------------------
# Setup primary lang
ENV LANG en_US.UTF-8

# -------------------------------------------------------------------------------
# user op

RUN useradd -m -r -s /bin/bash -Gwww-data -gusers -gsudo op

# -------------------------------------------------------------------------------
# **** modperl ****
# -------------------------------------------------------------------------------
# Install apache-1.3.42 & mod_perl-1.31

COPY asset-apache/*.deb /opt/apache/

RUN set -x \
  &&cd /opt/apache \
  && dpkg -i *.deb \
  && mkdir -p /usr/local/apache/logs \
  && mkdir /usr/local/apache/perl

COPY asset-apache/httpd.conf /usr/local/apache/conf/
COPY asset-apache/test.pl /usr/local/apache/perl/test.pl
#copy httpd start script for supervisord use
COPY supervisor.d/start_apache.sh /usr/local/apache/
#change owner for start apache from user op
RUN set -x \
  && chmod a+rx /usr/local/apache/cgi-bin/* \
  && chmod a+rx /usr/local/apache/perl/* \
  && chown -R op:www-data /usr/local/apache/logs \
  && chown -R op:www-data /usr/local/apache/start_apache.sh

# -------------------------------------------------------------------------------
# supervisord config files
COPY supervisor.d/supervisord.conf /etc/supervisor/conf.d/
COPY supervisor.d/*.conf /etc/supervisor/conf.d/

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /home/app

ENV APPUSER op

# expose ports for httpd - 8080 and nginx - 80

EXPOSE 8080 80

#CMD ["/usr/bin/supervisord"]

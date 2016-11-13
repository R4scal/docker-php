FROM centos:latest

MAINTAINER Rascal <rascal@rascal.su>

LABEL name="CentOS PHP-FPM Image" \
      license="GPLv2" \
      build-date="20161113"

# Add service user
RUN groupadd -g 101 nginx; useradd -r -u 100 -g nginx nginx

# Add repos
RUN rpm -Uhv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
    rpm -Uhv http://rpms.remirepo.net/enterprise/remi-release-7.rpm; \
    rpm -Uhv http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm; \
    yum-config-manager --enable remi-php70

# Install software
RUN yum -y update; \
    yum -y install php-fpm php-bcmath php-gd php-json php-ldap php-mbstring php-mysqlnd php-opcache \
    php-pdo php-pear php-process php-tidy php-xml php-xmlrpc \
    php-pecl-igbinary php-pecl-memcache php-pecl-memcached php-pecl-msgpack php-pecl-mysql php-pecl-redis \
    newrelic-php5; \
    yum clean all;

# Copy config
ADD configs/php-fpm.conf /etc/php-fpm.conf
ADD configs/www.conf /etc/php-fpm.d/www.conf

# Map port
EXPOSE 9000

# Map site root
VOLUME ["/var/www"]

# Run
CMD ["php-fpm"]

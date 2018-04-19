FROM php:7.2.4-fpm
MAINTAINER Liang Lei <square0083@gmail.com>

ONBUILD RUN apt update -yqq && apt upgrade -ypp \
	&& apt install wget libyaml-dev libmemcached-dev zlib1g zlib1g-dev libgearman-dev libpng-dev libxml2-dev libgmp-dev libmagickwand-dev \
	
	&& docker-php-ext-install gd pdo pdo_mysql bcmath pcntl opcache calendar dba dom gettext gmp intl json zip \
	
	&& pecl install yaml memcached redis msgpack imagick mongodb swoole \
	
  && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && mv composer.phar /usr/local/bin/composer \
	
  # add gearman
  && cd /tmp && wget -c 'https://github.com/wcgallego/pecl-gearman/archive/gearman-2.0.3.zip' \
  && unzip gearman-2.0.3.zip && cd pecl-gearman-gearman-2.0.3 && phpize && ./configure && make && make install \
	
  # add php common extensions
	&& docker-php-ext-enable gearman yaml memcached redis msgpack imagick mongodb swoole

EXPOSE "9000"
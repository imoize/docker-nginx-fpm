FROM imoize/alpine-s6:3.18

ARG TARGETARCH
ARG TARGETVARIANT
ARG PHP_VERSION

# Set default variables
ENV PHP_VERSION="$PHP_VERSION"

# install packages
RUN \
apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
    apache2-utils \
    libavif \
    icu-libs \
    logrotate \
    nginx=1.24.0-r14 \
    nginx-mod-http-brotli=1.24.0-r14 \
    nginx-mod-http-headers-more=1.24.0-r14 \
    openssl && \
  apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    php${PHP_VERSION} \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-ctype \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-iconv \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-pdo_mysql \
    php${PHP_VERSION}-phar \
    php${PHP_VERSION}-session \
    php${PHP_VERSION}-simplexml \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xmlwriter \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-zlib && \
# set nginx
  echo 'fastcgi_param  HTTP_PROXY         "";' >> /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  PATH_INFO          $fastcgi_path_info;' >> /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;' >> /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  SERVER_NAME        $host;' >> /etc/nginx/fastcgi_params && \
  rm -f /etc/nginx/conf.d/stream.conf && \
  rm -f /etc/nginx/http.d/default.conf && \
# set correct php version is symlinked
  if [ "$(readlink /usr/bin/php)" != "php${PHP_VERSION}" ]; then \
    rm -rf /usr/bin/php && \
    ln -s /usr/bin/php${PHP_VERSION} /usr/bin/php; \
  fi && \
# set php
  sed -i "s#user = nobody.*#user = disty#g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
  sed -i "s#group = nobody.*#group = disty#g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
  sed -i "s#;request_terminate_timeout = 0.*#request_terminate_timeout = 600#g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
  sed -i "s#;error_log = log/php${PHP_VERSION}/error.log.*#error_log = /config/log/php/error.log#g" /etc/php${PHP_VERSION}/php-fpm.conf && \
# fix logrotate
  sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
  sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' /etc/periodic/daily/logrotate && \
# clean up
  rm -rf \
  /tmp/* \
  /var/cache/apk/*

# add local files
COPY src/ /

# ports and workdir
WORKDIR /config
EXPOSE 80 443
FROM php:7.1-fpm

LABEL maintainer="Paul Redmond"

ENV CADDY_VERSION=2.7.4

# Download and install Caddy from a .deb package
RUN curl --silent --show-error --fail --location \
    --output /tmp/caddy.deb \
    "https://github.com/caddyserver/caddy/releases/download/v${CADDY_VERSION}/caddy_${CADDY_VERSION}_linux_amd64.deb" \
    && dpkg -i /tmp/caddy.deb \
    && rm -f /tmp/caddy.deb \
    && caddy version

# Install PHP extensions
RUN docker-php-ext-install mbstring pdo pdo_mysql

COPY Caddyfile /etc/Caddyfile
WORKDIR /srv/app/
RUN chown -R www-data:www-data /srv/app

CMD ["caddy", "run", "--config", "/etc/Caddyfile", "--adapter", "caddyfile"]


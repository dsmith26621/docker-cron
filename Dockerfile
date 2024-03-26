FROM ubuntu:22.04

# Install necessary packages for Laravel, including cron and unzip
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install -y cron curl unzip libpq-dev php \
    # Remove package lists for smaller image sizes
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo pdo_mysql \

    # Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory for the Laravel app
WORKDIR /workspace

# Copy the Laravel app into the container
COPY app/live-n-learn-app /workspace

# Set proper permissions for the storage and bootstrap/cache directories
# RUN chown -R www-data:www-data /workspace/storage /workspace/bootstrap/cache \
#     && chmod -R 755 /workspace/storage /workspace/bootstrap/cache

# Copy the crontab file and entrypoint script into the container
COPY crontab /hello-cron
COPY entrypoint.sh /entrypoint.sh

# Install the crontab and make the entrypoint script executable
RUN crontab /hello-cron \
    && chmod +x /entrypoint.sh

# Run the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# https://manpages.ubuntu.com/manpages/trusty/man8/cron.8.html
# -f | Stay in foreground mode, don't daemonize.
# -L loglevel | Tell  cron  what to log about jobs (errors are logged regardless of this value) as the sum of the following values:
CMD ["cron", "-f", "-L", "2"]

# FROM ubuntu:22.04

# RUN apt-get update \
#     && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install -y cron curl \
#     # Remove package lists for smaller image sizes
#     && rm -rf /var/lib/apt/lists/* \
#     && which cron \
#     && rm -rf /etc/cron.*/*

# COPY crontab /hello-cron
# COPY entrypoint.sh /entrypoint.sh

# RUN crontab hello-cron
# RUN chmod +x entrypoint.sh

# ENTRYPOINT ["/entrypoint.sh"]

# # https://manpages.ubuntu.com/manpages/trusty/man8/cron.8.html
# # -f | Stay in foreground mode, don't daemonize.
# # -L loglevel | Tell  cron  what to log about jobs (errors are logged regardless of this value) as the sum of the following values:
# CMD ["cron","-f", "-L", "2"]

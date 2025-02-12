FROM debian:bullseye

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    php-fpm \
    php-mysqli \
    wordpress && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN install -d /run/php /var/www/html

# Copy configuration and scripts
COPY ./tools/wp_script.sh /usr/local/bin/wp_script.sh
COPY ./conf/wordpress.conf /etc/php/7.4/fpm/pool.d/wordpress.conf

# Set script permissions
RUN chmod 755 /usr/local/bin/wp_script.sh

# Placeholder command for testing
RUN echo "Debugging placeholder: build stage complete" > /tmp/debug.log

CMD ["/bin/bash", "-c", "/usr/local/bin/wp_script.sh && php-fpm7.4 -F"]
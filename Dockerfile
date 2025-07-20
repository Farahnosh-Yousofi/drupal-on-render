# Use official PHP image with Apache and Composer
FROM php:8.2-apache

# Enable mod_rewrite
RUN a2enmod rewrite

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libpq-dev \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo pdo_pgsql

# Install Composer globally
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy all project files into the container
COPY . /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Set document root to /web (Drupal root)
ENV APACHE_DOCUMENT_ROOT /var/www/html/web

# Fix Apache config to use /web as root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

# Expose default port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]


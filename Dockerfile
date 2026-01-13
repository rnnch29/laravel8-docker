FROM php:8.2-fpm

# ติดตั้ง dependencies พื้นฐาน + PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    zip git curl libxml2-dev libicu-dev \
    libxslt-dev libssl-dev libzip-dev unzip \
    && rm -rf /var/lib/apt/lists/*

# ติดตั้ง PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql soap intl xsl opcache zip

# ติดตั้ง composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project
COPY . .

# สิทธิ์ไฟล์สำหรับ Laravel
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Install composer dependencies
RUN composer install --no-interaction --optimize-autoloader
# Указываем официальный PHP-образ с нужными расширениями
FROM php:8.3-fpm

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
    zip unzip curl libpng-dev libonig-dev libxml2-dev git \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Устанавливаем Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Копируем проект внутрь образа
WORKDIR /var/www
COPY . .

# Устанавливаем зависимости без dev
RUN composer install --no-dev --optimize-autoloader

# Права доступа (на всякий случай)
RUN chown -R www-data:www-data /var/www

# Запускаем php-fpm по умолчанию
CMD ["php-fpm"]

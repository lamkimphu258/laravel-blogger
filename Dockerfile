# Arguments defined in docker-compose.yml
ARG php_version

# Pull php image
FROM php:$php_version

# Arguments defined in docker-compose.yml
ARG user
ARG uid
ARG node_version

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    build-essential \
    openssl \
    libssl-dev \
    libonig-dev

# Install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_$node_version.x | bash -
RUN apt-get install -y \
    nodejs

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www/

USER $user

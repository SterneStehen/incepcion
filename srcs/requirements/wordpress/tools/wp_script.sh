#!/bin/bash

# Define WP directory
WORDPRESS_DIR="/var/www/html"
cd $WORDPRESS_DIR

# Download WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
if [ $? -ne 0 ]; then
    echo "Failed to download WP-CLI."
    exit 1
fi

# Wait for database connection
for i in {1..30}; do
    if mariadb -h${DATABASE_HOSTNAME} -u${USER_DATABASE} -p${DATABASE_PASSWORD} ${DATABASE_NAME} &>/dev/null; then
        break
    fi
    sleep 1
done

if [ $i -eq 30 ]; then
    echo "Database connection timed out."
    exit 1
fi

chmod +x wp-cli.phar
./wp-cli.phar core download --allow-root

./wp-cli.phar config create \
    --allow-root \
    --dbname=${DATABASE_NAME} \
    --dbuser=${USER_DATABASE} \
    --dbhost=${DATABASE_HOSTNAME} \
    --dbpass=${DATABASE_PASSWORD}

./wp-cli.phar core install \
    --url=${DOMAIN_NAME} \
    --admin_user=${SUPER_USER} \
    --allow-root \
    --admin_email=${SUPER_MAIL} \
    --title=${SITE_TITLE} \
    --admin_password=${SUPER_PASSWORD}

# Проверка существования второго пользователя напрямую через базу данных
USER_EXISTS=$(mariadb -h${DATABASE_HOSTNAME} -u${USER_DATABASE} -p${DATABASE_PASSWORD} ${DATABASE_NAME} -se "
SELECT COUNT(*) FROM wp_users WHERE user_login='${SECOND_USER}';")

if [ "$USER_EXISTS" -ne 0 ]; then
    echo "Second user already exists."
else
    # Хэширование пароля
    HASHED_PASSWORD=$(php -r "echo password_hash('${SECOND_USER_PASSWORD}', PASSWORD_DEFAULT);")

    # Создание пользователя напрямую через SQL
    mariadb -h${DATABASE_HOSTNAME} -u${USER_DATABASE} -p${DATABASE_PASSWORD} ${DATABASE_NAME} -e "
INSERT INTO wp_users (user_login, user_pass, user_nicename, user_email, user_status, display_name)
VALUES ('${SECOND_USER}', '${HASHED_PASSWORD}', '${SECOND_USER}', '${SECOND_USER_MAIL}', 0, '${SECOND_USER}');"

    # Получение ID нового пользователя
    USER_ID=$(mariadb -h${DATABASE_HOSTNAME} -u${USER_DATABASE} -p${DATABASE_PASSWORD} ${DATABASE_NAME} -se "
SELECT ID FROM wp_users WHERE user_login='${SECOND_USER}';")

    # Назначение роли пользователя
    mariadb -h${DATABASE_HOSTNAME} -u${USER_DATABASE} -p${DATABASE_PASSWORD} ${DATABASE_NAME} -e "
INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
VALUES
(${USER_ID}, 'wp_capabilities', 'a:1:{s:13:\"administrator\";b:1;}'),
(${USER_ID}, 'wp_user_level', '7');"


    echo "Second user created successfully."
fi

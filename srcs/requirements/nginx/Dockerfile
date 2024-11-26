# Используем базовый образ на основе Alpine Linux (версия 3.17 для обновлённости)
FROM alpine:3.17

# Обновляем системные репозитории и устанавливаем необходимые пакеты
RUN apk update && \
    apk upgrade && \
    apk add --no-cache nginx openssl curl bash

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
    -subj "/CN=localhost" \
    -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt

# Копируем пользовательскую конфигурацию NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# Создание папки для хранения статических файлов (новая функция)
RUN mkdir -p /var/www/static && \
    echo "<h1>Welcome to Smoreron Server</h1>" > /var/www/static/index.html

# Открываем порты для HTTP и HTTPS соединений
EXPOSE 80 443

# Добавляем рабочую директорию
WORKDIR /var/www/

# Запуск NGINX в режиме без демона
CMD ["nginx", "-g", "daemon off;"]

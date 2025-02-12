FROM debian:bullseye

RUN apt-get update && \
    apt-get install mariadb-server -y --no-install-recommends && \
    apt-get autoremove && \
    apt-get clean


# TODO: 

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/


COPY ./tools/maria_script.sh ./maria_script.sh
RUN chmod +x ./maria_script.sh


RUN [ -d /run/mysqld ] || echo "/run/mysqld create..."
RUN mkdir -p /run/mysqld

# FIXME: Рассмотреть обновление версии MariaDB

CMD ["sh", "./maria_script.sh"]

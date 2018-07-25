
FROM mysql:5.7

LABEL maintainer="ljatsh <test@test.com>"

RUN apt-get update \
    && apt-get install -y mysql-testsuite

RUN apt-get autoremove -y

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
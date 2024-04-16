#!/bin/sh

if [[ "${SPRING_DATASOURCE_URL}" == "*127.0.0.1*" ]]; then
    cp -rf /opt/metersphere/conf/mysql/my.cnf /etc/my.cnf.d/mariadb-server.cnf
    /shells/run-mysql.sh &
    /shells/wait-for-it.sh 127.0.0.1:3306 --timeout=120 --strict
fi
servers=$(printenv | grep KAFKA_BOOTSTRAP)
if [[ "${servers}" == "*127.0.0.1*" ]]; then
    mkdir -p /mnt/shared/config
    cp -rf /opt/metersphere/conf/kafka/config/server.properties /mnt/shared/config
    /etc/kafka/docker/run &
    /shells/wait-for-it.sh 127.0.0.1:9092 --timeout=120 --strict
fi

if [[ "${REDIS_HOST}" == "*127.0.0.1*" ]]; then
    mkdir -p /opt/metersphere/data/redis
    redis-server /opt/metersphere/conf/redis/redis.conf &
    /shells/wait-for-it.sh 127.0.0.1:6379 --timeout=120 --strict
fi

if [[ "${MINIO_ENDPOINT}" == "*127.0.0.1*" ]]; then
    mkdir -p /opt/metersphere/data/minio
    minio server --address 0.0.0.0:9000 -console-address 0.0.0.0:9001 /opt/metersphere/data/minio &
    /shells/wait-for-it.sh 127.0.0.1:9000 --timeout=120 --strict
fi

sh /shells/metersphere.sh &
sh /shells/task-runner.sh &
sh /shells/result-hub.sh  &

wait

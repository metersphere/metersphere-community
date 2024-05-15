#!/bin/sh

dburl=$(cat /opt/metersphere/conf/metersphere.properties | grep 'spring.datasource.url')
if [[ "${dburl}" == *"127.0.0.1"* ]]; then
    cp -rf /opt/metersphere/conf/mysql/my.cnf /etc/my.cnf.d/mariadb-server.cnf
    /shells/run-mysql.sh &
    /shells/wait-for-it.sh 127.0.0.1:3306 --timeout=120 --strict
fi

servers=$(cat /opt/metersphere/conf/metersphere.properties | grep 'kafka.bootstrapServers')
if [[ "${servers}" == *"127.0.0.1"* ]]; then
    mkdir -p /mnt/shared/config
    cp -rf /opt/metersphere/conf/kafka/config/server.properties /mnt/shared/config
    /etc/kafka/docker/run &
    /shells/wait-for-it.sh 127.0.0.1:9092 --timeout=120 --strict
fi

redishost=$(cat /opt/metersphere/conf/redisson.yml | grep 'address:')
if [[ "${redishost}" == *"127.0.0.1"* ]]; then
    mkdir -p /opt/metersphere/data/redis
    redis-server /opt/metersphere/conf/redis/redis.conf &
    /shells/wait-for-it.sh 127.0.0.1:6379 --timeout=120 --strict
fi

miniohost=$(cat /opt/metersphere/conf/metersphere.properties | grep 'minio.endpoint')
if [[ "${miniohost}" == *"127.0.0.1"* ]]; then
    mkdir -p /opt/metersphere/data/minio
    minio server --address 0.0.0.0:9000 -console-address 0.0.0.0:9001 /opt/metersphere/data/minio &
    /shells/wait-for-it.sh 127.0.0.1:9000 --timeout=120 --strict
fi

taskrunner=$(cat /etc/hosts | grep 'task-runner')
if [[ ! "${taskrunner}" == *"127.0.0.1"* ]]; then
    echo '127.0.0.1 task-runner' >> /etc/hosts
fi

chmod -R 777 /opt/metersphere/logs

sh /shells/metersphere.sh &
sh /shells/task-runner.sh &
sh /shells/result-hub.sh  &

wait

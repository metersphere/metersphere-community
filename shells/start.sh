#!/bin/sh

/shells/run-mysql.sh                                                          &
/etc/kafka/docker/run                                                         &
redis-server /opt/metersphere/conf/redis/redis.conf                           &
minio server --address 0.0.0.0:9000 -console-address 0.0.0.0:9001 /minio-data &


/shells/wait-for-it.sh 127.0.0.1:6379 --timeout=120 --strict
/shells/wait-for-it.sh 127.0.0.1:3306 --timeout=120 --strict
/shells/wait-for-it.sh 127.0.0.1:9092 --timeout=120 --strict
/shells/wait-for-it.sh 127.0.0.1:9000 --timeout=120 --strict


sh /shells/metersphere.sh & 
sh /shells/task-runner.sh & 
sh /shells/result-hub.sh  &
sh /shells/daemon.sh      &

wait





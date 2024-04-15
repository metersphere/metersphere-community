#!/bin/sh

while true; do
    ps | grep metersphere.sh | grep -v grep | awk '{print $1}' >/tmp/metersphere.pid

    if [ -z "$(cat /tmp/metersphere.pid)" ]; then
        echo 'metersphere exited.'
        echo ''>/tmp/metersphere.pid
        break
    fi

    ps | grep task-runner.sh | grep -v grep | awk '{print $1}' >/tmp/task-runner.pid

    if [ -z "$(cat /tmp/task-runner.pid)" ]; then
        echo 'task-runner exited.'
        echo ''>/tmp/task-runner.pid
        break
    fi

    ps | grep result-hub.sh | grep -v grep | awk '{print $1}' >/tmp/result-hub.pid
    if [ -z "$(cat /tmp/result-hub.pid)" ]; then
        echo 'result-hub exited.'
        echo ''>/tmp/result-hub.pid
        break
    fi

    sleep 5
done

if [ -n "$(cat /tmp/result-hub.pid)" ]; then
    kill -9 $(cat /tmp/result-hub.pid)
fi
if [ -n "$(cat /tmp/metersphere.pid)" ]; then
    kill -9 $(cat /tmp/metersphere.pid)
fi
if [ -n "$(cat /tmp/task-runner.pid)" ]; then
    kill -9 $(cat /tmp/task-runner.pid)
fi

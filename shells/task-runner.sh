#!/bin/sh

export JAVA_CLASSPATH=/task-runner:/task-runner/lib/api-test.jar:/opt/jmeter/lib/ext/*:/task-runner/lib/*:/standalone/lib/*
export JAVA_MAIN_CLASS=io.metersphere.runner.Application
export MS_VERSION=`cat /tmp/MS_VERSION`

sh /deployments/run-java.sh


#!/bin/sh

export JAVA_CLASSPATH=/task-runner:/opt/jmeter/lib/ext/*:/task-runner/lib/*:/standalone/lib/*:/runner/lib/*
export JAVA_MAIN_CLASS=io.metersphere.runner.Application
export MS_VERSION=`cat /tmp/MS_VERSION`

sh /deployments/run-java.sh


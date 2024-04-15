#!/bin/sh

export JAVA_CLASSPATH=/metersphere:/opt/jmeter/lib/ext/*:/metersphere/lib/*:/standalone/lib/*
export JAVA_MAIN_CLASS=io.metersphere.Application
export MS_VERSION=`cat /tmp/MS_VERSION`

sh /deployments/run-java.sh



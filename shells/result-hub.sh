#!/bin/sh

export JAVA_CLASSPATH=/result-hub:/opt/jmeter/lib/ext/*:/result-hub/lib/*:/standalone/lib/*
export JAVA_MAIN_CLASS=io.metersphere.result.Application
export MS_VERSION=`cat /tmp/MS_VERSION`

sh /deployments/run-java.sh



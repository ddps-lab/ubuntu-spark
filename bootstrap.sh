#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

service ssh start
#$HADOOP_PREFIX/sbin/start-dfs.sh
#$HADOOP_PREFIX/sbin/start-yarn.sh

#hdfs dfs -put $SPARK_HOME/jars /spark
#echo spark.yarn.jars hdfs:///spark/*.jar > $SPARK_HOME/conf/spark-defaults.conf
cp $SPARK_HOME/conf/metrics.properties.template $SPARK_HOME/conf/metrics.properties

# Create a user in the start up if NEW_USER environment variable is given
# EX: docker run  -e NEW_USER=kmucs ...
if [ -z != $NEW_USER ]
then
    adduser --disabled-password --gecos ""  "$NEW_USER" > /dev/null
    usermod -aG sudo "$NEW_USER" > /dev/null
fi

CMD=${1:-"exit 0"}
if [[ "$CMD" == "-d" ]];
then
    service sshd stop
    /usr/sbin/sshd -D -d
else
    /bin/bash -c "$*"
fi

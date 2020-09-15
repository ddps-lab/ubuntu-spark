FROM kmubigdata/ubuntu-hadoop
MAINTAINER kimjeongchul

USER root

# scala
RUN apt-get update
RUN apt-get install -y scala

# python
RUN apt-get install -y python
RUN apt-get install -y python3

# spark 3.0.1 without Hadoop
RUN wget https://archive.apache.org/dist/spark/spark-3.0.1/spark-3.0.1-bin-without-hadoop.tgz
RUN tar -xvzf spark-3.0.1-bin-without-hadoop.tgz -C /usr/local
RUN cd /usr/local && ln -s ./spark-3.0.1-bin-without-hadoop spark
RUN rm -f /spark-3.0.1-bin-without-hadoop.tgz

# Files for S3A
RUN mkdir /usr/local/spark/extrajars
RUN wget -P /usr/local/spark/extrajars https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.860/aws-java-sdk-1.11.860.jar
RUN wget -P /usr/local/spark/extrajars https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/1.11.860/aws-java-sdk-s3-1.11.860.jar
RUN wget -P /usr/local/spark/extrajars https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.11.860/aws-java-sdk-core-1.11.860.jar
RUN wget -P /usr/local/spark/extrajars https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-dynamodb/1.11.860/aws-java-sdk-dynamodb-1.11.860.jar
RUN wget -P /usr/local/spark/extrajars https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.1.1/hadoop-aws-3.1.1.jar
RUN wget -P /usr/local/spark/extrajars https://repo1.maven.org/maven2/joda-time/joda-time/2.10.6/joda-time-2.10.6.jar
RUN wget -P /usr/local/spark/extrajars https://repo1.maven.org/maven2/org/apache/httpcomponents/httpclient/4.5.9/httpclient-4.5.9.jar

# ENV hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native/:$LD_LIBRARY_PATH

# ENV spark
ENV SPARK_HOME /usr/local/spark
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

ADD spark-env.sh $SPARK_HOME/conf/spark-env.sh
ADD spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf
ADD run-sparkshell.sh $SPARK_HOME/run-sparkshell.sh
RUN cp $HADOOP_HOME/etc/hadoop/workers $SPARK_HOME/conf/slaves

COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh
RUN chmod +x /usr/local/spark/run-sparkshell.sh

# Spark Web UI, History Server Port
EXPOSE 8080 18080

EXPOSE 7077

#install sbt
RUN apt-get install apt-transport-https
RUN echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
RUN apt-get update
RUN apt-get -y install sbt


ENTRYPOINT ["/etc/bootstrap.sh"]

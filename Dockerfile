FROM ubuntu:20.04

RUN apt-get update && apt-get install -y wget openjdk-8-jdk gnupg lsof python3

# Apache BigTop 3.2.0
RUN wget -O /etc/apt/sources.list.d/bigtop-3.2.0.list http://archive.apache.org/dist/bigtop/bigtop-3.2.0/repos/ubuntu-20.04/bigtop.list
RUN wget -O- https://dlcdn.apache.org/bigtop/bigtop-3.2.0/repos/GPG-KEY-bigtop | apt-key add -

RUN apt-get update && apt-get install -y hadoop solr hive

ENV HADOOP_HOME=/usr/lib/hadoop
ENV SOLR_HOME=/usr/lib/solr/server/solr
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:/usr/lib/solr/bin:/usr/lib/zookeeper/bin:/usr/lib/hive/bin

COPY docker-entrypoint.sh .
COPY hadoop_configure /usr/bin

RUN chmod +x /usr/bin/hadoop_configure
RUN schematool -dbType derby -initSchema

ENTRYPOINT [ "./docker-entrypoint.sh" ]

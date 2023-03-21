FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget default-jdk gnupg xmlstarlet pip

# Apache BigTop 3.2.0
RUN wget -O /etc/apt/sources.list.d/bigtop-3.2.0.list http://archive.apache.org/dist/bigtop/bigtop-3.2.0/repos/ubuntu-22.04/bigtop.list
RUN wget -O- https://dlcdn.apache.org/bigtop/bigtop-3.2.0/repos/GPG-KEY-bigtop | apt-key add -

RUN apt-get update && apt-get install -y hadoop* solr*

# mrjob for mapreduce
RUN mkdir mrjob solr
RUN pip install mrjob

ENV HADOOP_HOME=/usr/lib/hadoop
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$PATH:/usr/lib/solr/bin:/usr/lib/zookeeper/bin

COPY docker-entrypoint.sh .

ENTRYPOINT [ "./docker-entrypoint.sh" ]

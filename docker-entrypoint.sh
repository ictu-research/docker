#!/usr/bin/env bash

# Author: Tran Xuan Thanh
# Date: 2023-3-18

# node-0, node-1, node-2, ...
readonly NODE=node-$(hostname -i | awk -F "." '{print $NF}' | awk '{print $1-2}')
readonly HADOOP_CONF_DIR=/etc/hadoop/conf
readonly HDFS_CACHE_DIR=file:///var/lib/hadoop-hdfs/cache/$NODE
readonly SOLR_DATA_DIR=/var/lib/solr/$NODE
readonly SOLR_FLAGS="-Dsolr.directoryFactory=HdfsDirectoryFactory \
-Dsolr.lock.type=hdfs \
-Dsolr.hdfs.home=hdfs://namenode:8020/solr/${NODE}"

declare -A cfgArr

cfgArr[hadoop.tmp.dir]=$HDFS_CACHE_DIR
cfgArr[dfs.namenode.name.dir]=$HDFS_CACHE_DIR/name
cfgArr[dfs.namenode.checkpoint.dir]=$HDFS_CACHE_DIR/namesecondary
cfgArr[dfs.datanode.data.dir]=$HDFS_CACHE_DIR/data
cfgArr[dfs.webhdfs.enabled]=true

for key in "${!cfgArr[@]}"; do
  hadoop_configure $HADOOP_CONF_DIR/hdfs-site.xml $key ${cfgArr[$key]}
done

hadoop_configure $HADOOP_CONF_DIR/core-site.xml fs.defaultFS hdfs://namenode:8020
hadoop_configure $HADOOP_CONF_DIR/yarn-site.xml yarn.resourcemanager.hostname namenode
hadoop_configure $HADOOP_CONF_DIR/mapred-site.xml mapreduce.application.classpath $(mapred classpath)

[[ -d $SOLR_DATA_DIR ]] || (mkdir -p $SOLR_DATA_DIR && cp -r $SOLR_HOME/* $SOLR_DATA_DIR)

case $HADOOP_MODE in
"namenode")
  echo -e "\e[31mformat namenode...\e[0m"
  yes n | hdfs namenode -format >/dev/null 2>&1
  echo -e "\e[32mstart namenode...\e[0m"
  hdfs --daemon start namenode
  echo -e "\e[31mstart solr (${NODE})...\e[0m"
  solr start -c $SOLR_FLAGS -force >/dev/null
  echo -e "\e[34mstart resource manager...\e[0m"
  yarn --daemon start resourcemanager
  ;;
"datanode")
  echo -e "\e[32mstart datanode (${NODE})...\e[0m"
  hdfs --daemon start datanode
  echo -e "\e[31mstart solr (${NODE})...\e[0m"
  solr start -c $SOLR_FLAGS -z namenode:9983 -force >/dev/null
  echo -e "\e[34mstart node manager (${NODE})...\e[0m"
  yarn --daemon start nodemanager
  ;;
*)
  echo "KHMT K18A"
  ;;
esac

sleep infinity

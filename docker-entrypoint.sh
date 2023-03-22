#!/usr/bin/env bash

# Author: Tran Xuan Thanh
# Date: 2023-3-18

function configure_hadoop() {
  local file=$1
  local property=$2
  local value=$3

  if [ -f "$file" ]; then
    if xmlstarlet sel -t -v "/configuration/property[name='$property']/value" "$file" >/dev/null 2>&1; then
      xmlstarlet ed -L -u "/configuration/property[name='$property']/value" -v "$value" "$file"
    else
      xmlstarlet ed -L -s /configuration -t elem -n property -v "" -s "//property[last()]" -t elem -n name -v "$property" -s "//property[last()]" -t elem -n value -v "$value" "$file"
    fi
  else
    echo "File not found: $file"
  fi
}

# node-0, node-1, node-2, ...
readonly NODE=node-$(hostname -i | awk -F "." '{print $NF}' | awk '{print $1-2}')
readonly HADOOP_CONF_DIR=/etc/hadoop/conf
readonly HDFS_CACHE_DIR=file:///var/lib/hadoop-hdfs/cache/$NODE
readonly SOLR_DATA_DIR=/var/lib/solr/$NODE

declare -A cfgArr

cfgArr[hadoop.tmp.dir]=$HDFS_CACHE_DIR
cfgArr[dfs.namenode.name.dir]=$HDFS_CACHE_DIR/name
cfgArr[dfs.namenode.checkpoint.dir]=$HDFS_CACHE_DIR/namesecondary
cfgArr[dfs.datanode.data.dir]=$HDFS_CACHE_DIR/data

for key in "${!cfgArr[@]}"; do
  configure_hadoop $HADOOP_CONF_DIR/hdfs-site.xml $key ${cfgArr[$key]}
done

configure_hadoop $HADOOP_CONF_DIR/core-site.xml fs.defaultFS hdfs://namenode:8020
configure_hadoop $HADOOP_CONF_DIR/yarn-site.xml yarn.resourcemanager.hostname namenode
configure_hadoop $HADOOP_CONF_DIR/mapred-site.xml mapreduce.application.classpath $(mapred classpath)

[[ -d $SOLR_DATA_DIR ]] || (mkdir -p $SOLR_DATA_DIR && cp -r $SOLR_HOME/* $SOLR_DATA_DIR)

case $HADOOP_MODE in
"namenode")
  yes n | hadoop namenode -format
  hdfs --daemon start namenode
  solr start -s $SOLR_DATA_DIR -c -force
  yarn resourcemanager
  ;;
"datanode")
  hdfs --daemon start datanode
  solr start -s $SOLR_DATA_DIR -c -z namenode:9983 -force
  yarn nodemanager
  ;;
*)
  echo "KHMT K18A"
  ;;
esac

exec "$@"

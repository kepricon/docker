FROM skymindio-docker-dl4j-hadoop.bintray.io/skymindio/dl4j-hadoop

ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]

FROM skymind/hdfs
MAINTAINER skymind
RUN yum -y install wget
ADD hadoop-conf /opt/hadoop-conf
ENV HADOOP_CONF_DIR /opt/hadoop-conf
#spark
RUN wget https://s3-us-west-2.amazonaws.com/skil-distro/spark-1.6.2-bin-2.6.0.tgz -O /opt/spark-1.6.2-bin-2.6.0.tgz
RUN cd /opt && tar xvf spark-1.6.2-bin-2.6.0.tgz && mv spark-1.6.2-bin-2.6.0 spark
ENV SPARK_HOME /opt/spark
ADD spark-defaults.conf /opt/spark/conf
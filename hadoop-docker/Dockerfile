# Creates pseudo distributed hadoop 2.7.1
#
# docker build -t sequenceiq/hadoop .

FROM nvidia/cuda:8.0-cudnn5-runtime-centos7
MAINTAINER Skymind Inc <help@skymind.io>


USER root
ADD Centos-Source.repo /etc/yum.repos.d/Centos-Source.repo

RUN yum update -y

RUN yum install -y tar bzip2 yum-utils rpm-build
RUN yum -y group install "Development Tools"
RUN yum-builddep -y pam
RUN yumdownloader --source pam
RUN rpmbuild --rebuild  --define 'WITH_AUDIT 0' --define 'dist +noaudit' pam*.src.rpm
RUN rpm -Uvh --oldpackage ~/rpmbuild/RPMS/*/pam*+noaudit*.rpm

RUN rm -f /*.rpm
RUN rm -rf ~/rpmbuild


# install dev tools
RUN yum clean all; \
    rpm --rebuilddb; \
    yum install -y curl which tar sudo openssh-server openssh-clients rsync
# update libselinux. see https://github.com/sequenceiq/hadoop-docker/issues/14
RUN yum update -y libselinux

# passwordless ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys


RUN yum -y install wget
# java
RUN echo "SETTING UP JAVA"
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-x64.tar.gz"
RUN tar xzvf jdk-8u91-linux-x64.tar.gz
RUN mv jdk1.8.0_91 /opt
ENV JAVA_HOME /opt/jdk1.8.0_91/
ENV PATH $PATH:$JAVA_HOME/bin
#openblas for native cpu based jobs
RUN yum -y groupinstall "Development Tools"
ADD install_openblas.sh /opt/install_openblas.sh
RUN chmod +x /opt/install_openblas.sh && /opt/install_openblas.sh


# download native support
RUN mkdir -p /tmp/native
RUN curl -L https://github.com/sequenceiq/docker-hadoop-build/releases/download/v2.7.1/hadoop-native-64-2.7.1.tgz | tar -xz -C /tmp/native

# hadoop
RUN curl -s https://s3-us-west-2.amazonaws.com/skil-distro/hadoop-2.7.3.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./hadoop-2.7.3 hadoop

ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop

RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/java/default\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
#RUN . $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

RUN mkdir $HADOOP_PREFIX/input
RUN cp $HADOOP_PREFIX/etc/hadoop/*.xml $HADOOP_PREFIX/input

# pseudo distributed
ADD core-site.xml.template $HADOOP_PREFIX/etc/hadoop/core-site.xml.template
RUN sed s/HOSTNAME/localhost/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml
ADD hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml

ADD mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
ADD yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
RUN rm -rf /usr/java/default && mkdir -p /usr/java/ && ln -s $JAVA_HOME /usr/java/default
RUN $HADOOP_PREFIX/bin/hdfs namenode -format

# fixing the libhadoop.so like a boss
RUN rm -rf /usr/local/hadoop/lib/native
RUN mv /tmp/native /usr/local/hadoop/lib

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

# # installing supervisord
# RUN yum install -y python-setuptools
# RUN easy_install pip
# RUN curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -o - | python
# RUN pip install supervisor
#
# ADD supervisord.conf /etc/supervisord.conf

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh

# workingaround docker.io build error
RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh
RUN chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh
RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config

RUN yum -y install initscripts
ADD startssh.sh /opt/startssh.sh
RUN chmod +x /opt/startssh.sh

RUN mkdir -p /data
VOLUME /data
# start sshd to generate host keys, patch sshd_config and enable yum repos
RUN (/opt/startssh.sh; \
     sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
     sed -i 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config; \
     sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
     sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-Base.repo)

RUN (mkdir -p /root/.ssh/; \
     echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
     echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config)


##########################################################################
# passwords
RUN echo "root:rootroot" | chpasswd
RUN /opt/startssh.sh && $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && $HADOOP_PREFIX/sbin/start-dfs.sh && $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/root
RUN /opt/startssh.sh && $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && $HADOOP_PREFIX/sbin/start-dfs.sh && $HADOOP_PREFIX/bin/hdfs dfs -put $HADOOP_PREFIX/etc/hadoop/ input



ADD runbootstrap.sh /opt/runbootstrap.sh


#spark workers
ADD hadoop-conf /opt/hadoop-conf

RUN chmod +x /opt/runbootstrap.sh
CMD ["/opt/runbootstrap.sh"]

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 10020 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 22

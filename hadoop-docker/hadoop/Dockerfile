FROM nvidia/cuda:8.0-cudnn5-devel-centos7
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

#openblas for native cpu based jobs
RUN yum -y groupinstall "Development Tools"
ADD install_openblas.sh /opt/install_openblas.sh
RUN chmod +x /opt/install_openblas.sh && /opt/install_openblas.sh

RUN yum -y install wget
RUN echo "SETTING UP JAVA"
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-x64.tar.gz"
RUN tar xzvf jdk-8u91-linux-x64.tar.gz
RUN mv jdk1.8.0_91 /opt
ENV JAVA_HOME /opt/jdk1.8.0_91/
ENV PATH $PATH:$JAVA_HOME/bin


ENV HADOOP_VERSION 2.7.3
ENV HADOOP_URL https://s3-us-west-2.amazonaws.com/skil-distro/hadoop-2.7.3.tar.gz
RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*
    
RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop
RUN cp /etc/hadoop/mapred-site.xml.template /etc/hadoop/mapred-site.xml
RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

RUN mkdir /hadoop-data

ENV HADOOP_PREFIX=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1

ENV USER=root
ENV PATH $HADOOP_PREFIX/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

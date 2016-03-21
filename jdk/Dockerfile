FROM centos:7

LABEL name="base jdk8"
LABEL vendor="skymind"

RUN yum install -y \
    bash \
    java-1.8.0-openjdk-devel \
    && yum clean all

ENV JAVA_HOME /etc/alternatives/java_sdk


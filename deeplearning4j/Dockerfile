FROM skymind/jdk:8

LABEL name="deeplearning4j cli"
LABEL vendor="skymind"

RUN yum install -y \
    https://s3-us-west-2.amazonaws.com/skymind/bin/canova-cli.rpm \
    https://s3-us-west-2.amazonaws.com/skymind/bin/deeplearning4j-cli.rpm \
    && yum clean all

ENTRYPOINT ["/bin/bash"]


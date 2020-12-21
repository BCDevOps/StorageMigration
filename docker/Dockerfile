FROM quay.io/openshift/origin-cli:latest

LABEL maintainer="Jeff Kelly <jeff.kelly@arctiq.ca>
LABEL io.k8s.description="Storage Migration Placeholder"

WORKDIR /

RUN yum -y install rsync curl && yum clean all -y

RUN mkdir /source /target
COPY migrate /

# Set the default CMD to print the usage and sleep for ${SLEEP}
CMD sh /migrate -r

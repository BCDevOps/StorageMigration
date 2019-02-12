FROM registry.access.redhat.com/openshift3/ose-cli:v3.11.59

LABEL maintainer="Jeff Kelly <jeff.kelly@arctiq.ca>
LABEL io.k8s.description="Storage Migration Placeholder"

WORKDIR /

RUN yum -y install rsync && yum clean all -y

RUN mkdir /source /target
COPY migrate-info.sh /

# Set the default CMD to print the usage and sleep for ${SLEEP}
CMD sh /migrate-info.sh

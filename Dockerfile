FROM registry.redhat.io/ubi8/ubi-minimal:8.3

ENV URL=https://mirror.openshift.com/pub/openshift-v4/clients/pipeline/0.13.1/tkn-linux-amd64-0.13.1.tar.gz

COPY download/tkn /usr/bin/tkn

CMD /usr/bin/tkn
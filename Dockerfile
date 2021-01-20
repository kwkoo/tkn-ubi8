FROM registry.redhat.io/ubi8/ubi-minimal:8.3

LABEL \
  maintainer="Koo Kin Wai <kin.wai.koo@gmail.com>" \
  org.opencontainers.image.source="https://github.com/kwkoo/tkn-ubi8"

COPY download/tkn /usr/bin/tkn

CMD /usr/bin/tkn
FROM registry.access.redhat.com/ubi8/ubi-minimal

RUN microdnf install net-tools curl jq iproute && \
    microdnf clean all

COPY ./.bashrc_ext /root/

RUN cat /root/.bashrc_ext >> /root/.bashrc

FROM alpine:3.19.3

LABEL maintainer="alatas@gmail.com"

#set enviromental values for certificate CA generation
ENV CN=squid.local \
    O=squid \
    OU=squid \
    C=US

#set proxies for alpine apk package manager
ARG all_proxy 

ENV http_proxy=$all_proxy \
    https_proxy=$all_proxy

RUN apk add --no-cache \
    squid=6.6-r0 \
    openssl=3.1.6-r2 \
    ca-certificates && \
    update-ca-certificates

COPY start.sh /usr/local/bin/
COPY openssl.cnf.add /etc/ssl
COPY conf/squid*.conf /etc/squid/

RUN sed -i -e 's/\r$//' /usr/local/bin/start.sh
RUN sed -i -e 's/\r$//' /etc/ssl/openssl.cnf.add
RUN sed -i -e 's/\r$//' /etc/squid/squid.conf

RUN cat /etc/ssl/openssl.cnf.add >> /etc/ssl/openssl.cnf

RUN chmod +x /usr/local/bin/start.sh

EXPOSE 3128
EXPOSE 4128

ENTRYPOINT ["/usr/local/bin/start.sh"]
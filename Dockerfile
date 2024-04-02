FROM node:20-alpine
WORKDIR /etc/varnish
ENV VARNISH_VERSION=7.4.2-r0

RUN echo 'Install utils that stay in the image' \
  && apk add --no-cache ca-certificates bind-tools nano curl tini \
  && echo 'Install varnish' \
  && apk add --no-cache varnish=$VARNISH_VERSION --repository http://dl-3.alpinelinux.org/alpine/edge/main/ \
  && echo 'Install varnish-modules' \
  && apk add --virtual varnish-deps --no-cache git libgit2-dev automake varnish-dev=$VARNISH_VERSION autoconf libtool py-docutils make --repository http://dl-3.alpinelinux.org/alpine/edge/main/ \
  && git clone https://github.com/varnish/varnish-modules.git /varnish-modules --depth='1' --branch='7.3' --single-branch \
  && cd /varnish-modules && ./bootstrap && ./configure && make && make install && cd / \
  && echo 'Remove all build deps' \
  && rm -Rf /varnish-modules \
  && apk del varnish-deps \
  && mkdir -p /etc/varnish/source

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY package*.json ./src/* /usr/local/bin/varnishconf/
RUN cd /usr/local/bin/varnishconf && npm ci \
  && ln -s /usr/local/bin/varnishconf/index.js /usr/local/bin/varnish \
  && chown -R varnish:varnish /etc/varnish

USER varnish
EXPOSE 8080
EXPOSE 2000
EXPOSE 9131
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD []

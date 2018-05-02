FROM blueapple/alpine_glibc_basicimage
MAINTAINER blueapple <blueapple1120@qq.com>

ENV FILEBEAT_VERSION=5.6.5 \
    FILEBEAT_SHA1=e3efb30b5d4f347610093f507a7a5ca5452ca135
    
RUN apk add --no-cache \
    	bash \
	cmake \
	doxygen \
	g++ \
	gcc \
	git \
	graphviz \
	make \
	musl-dev \
	qt \
	qt5-qtbase-dev \
	sudo \
    	&& ln -s /usr/bin/qmake-qt5 /usr/bin/qmake
    
# Install filebeat
RUN wget -q -O /tmp/filebeat.tar.gz https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz \
    && cd /tmp \
    && echo "${FILEBEAT_SHA1}  filebeat.tar.gz" | sha1sum -c - \
    && tar xzvf filebeat.tar.gz \
    && cd filebeat-* \
    && cp filebeat /bin \
    && rm -rf /tmp/filebeat* \
    && rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "filebeat", "-e" ]


FROM alpine:3.5

ENV JAVA_HOME=/usr/lib/jvm/default-jvm/jre
ENV ELASTICSEARCH_VERSION 5.1.2
ENV ES_JAVA_OPTS "-Xms512m -Xmx512m"
ENV CLUSTER_NAME elasticsearch-default
ENV NODE_MASTER true
ENV NODE_DATA true
ENV NODE_INGEST true
ENV HTTP_ENABLE true
ENV NETWORK_HOST _site_
ENV HTTP_CORS_ENABLE true
ENV HTTP_CORS_ALLOW_ORIGIN *
ENV NUMBER_OF_MASTERS 1
ENV NUMBER_OF_SHARDS 1
ENV NUMBER_OF_REPLICAS 0
ENV MAX_LOCAL_STORAGE_NODES 1

RUN apk upgrade --update-cache; \
    apk add openjdk8-jre; \
    rm -rf /tmp/* /var/cache/apk/*

# Install Elasticsearch.
RUN apk add --update bash curl ca-certificates sudo && \
  ( curl -Lskj https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz | \
  gunzip -c - | tar xf - ) && \
  mv /elasticsearch-$ELASTICSEARCH_VERSION /elasticsearch && \
  rm -rf $(find /elasticsearch | egrep "(\.(exe|bat)$)") && \
  apk del curl

WORKDIR /elasticsearch

RUN set -ex \
	&& for path in \
		./data \
		./logs \
		./config \
		./config/scripts \
		./config/templates \
	; do \
		mkdir -p "$path"; \
	done

COPY config ./config
COPY run.sh /

RUN /elasticsearch/bin/elasticsearch-plugin install x-pack

VOLUME /elasticsearch/data

EXPOSE 9200 9300

CMD ["/run.sh"]

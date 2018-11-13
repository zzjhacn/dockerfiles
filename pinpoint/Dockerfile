FROM zzjhacn/tomcat9jdk8
MAINTAINER Gray (long1795@gmail.com)

ENV HBASE_HOST hbase
ENV HBASE_PORT 2181
ENV PINPOINT_VERSION "1.8.0-RC1"

#RUN apk update && apk add --no-cache bash wget tar
RUN apk update && apk add --no-cache curl

RUN mkdir /pinpoint
WORKDIR /pinpoint
RUN curl -L -O "https://github.com/naver/pinpoint/releases/download/$PINPOINT_VERSION/pinpoint-collector-$PINPOINT_VERSION.war" \
    && curl -L -O "https://github.com/naver/pinpoint/releases/download/$PINPOINT_VERSION/pinpoint-web-$PINPOINT_VERSION.war"

#ADD pinpoint-collector-$PINPOINT_VERSION.war .
#ADD pinpoint-web-$PINPOINT_VERSION.war .

RUN mkdir -p /pinpointwebapps/ROOT
WORKDIR /pinpoint/webapps/ROOT
RUN set -e \
    && jar xf "/pinpoint/pinpoint-web-$PINPOINT_VERSION.war" \
    && sed -i "s/cluster.enable=true/cluster.enable=false/g" WEB-INF/classes/pinpoint-web.properties \
    && sed -i "s/hbase.client.host=localhost/hbase.client.host=$HBASE_HOST/g" WEB-INF/classes/hbase.properties \
    && sed -i "s/hbase.client.port=2181/hbase.client.port=$HBASE_PORT/g" WEB-INF/classes/hbase.properties

RUN mkdir -p /pinpoint/webapps/collector
WORKDIR /pinpoint/webapps/collector
RUN set -e \
    && jar xf "/pinpoint/pinpoint-collector-$PINPOINT_VERSION.war" \
    && sed -i "s/cluster.enable=true/cluster.enable=false/g" WEB-INF/classes/pinpoint-collector.properties \
    && sed -i "s/hbase.client.host=localhost/hbase.client.host=$HBASE_HOST/g" WEB-INF/classes/hbase.properties \
    && sed -i "s/hbase.client.port=2181/hbase.client.port=$HBASE_PORT/g" WEB-INF/classes/hbase.properties

WORKDIR /pinpoint
RUN rm -rf *war

WORKDIR $CATALINA_HOME
RUN sed -i "4a mv /pinpoint/webapps/* $CATALINA_HOME/webapps/" $CATALINA_HOME/bin/start.sh

EXPOSE 80 9994 9995 9996
CMD ["start.sh"]

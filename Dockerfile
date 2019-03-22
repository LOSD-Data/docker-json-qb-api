FROM java:8-alpine
MAINTAINER "Arkadiusz Stasiewicz <arkadiusz.stasiewicz@insight-centre.org>"

# Update & Dependencies
RUN apk add --update git bash

RUN apk add --update ca-certificates && rm -rf /var/cache/apk/* && \
  find /usr/share/ca-certificates/mozilla/ -name "*.crt" -exec keytool -import -trustcacerts \
  -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts -storepass changeit -noprompt \
  -file {} -alias {} \; && \
  keytool -list -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts --storepass changeit

ENV MAVEN_VERSION 3.5.4
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

# Clone JSON-QB API files into the docker container
RUN git clone https://github.com/LOSD-Data/json-qb-api-implementation.git /var/www/jsonqbapi

# Copy config file
COPY config.prop /var/www/jsonqbapi/resources/config.prop

# Copy pom.xml
COPY pom.xml /var/www/jsonqbapi/pom.xml

# Copy resources/ to src/main/resources/
RUN mkdir -p /var/www/jsonqbapi/src/main/resources && \
    cp -r /var/www/jsonqbapi/resources/ /var/www/jsonqbapi/src/main/

# Build JSON-QB API
RUN cd /var/www/jsonqbapi && \
    mvn clean install -Dmaven.clean.failOnError=false

# Configure port
EXPOSE  8000

# RUN JSON-QB API
CMD cd /var/www/jsonqbapi && \
    mvn -Djetty.port=8000 jetty:run-war

FROM gradle:6.8.3-jdk11  as builder
USER root
COPY ./src /app/src
COPY ./build.gradle settings.gradle /app/
RUN gradle -p /app clean build -x test
# List the modules that are in use by our application

FROM adoptopenjdk/openjdk11:debianslim-jre
COPY --from=builder /app/build/libs/*.jar /app/app.jar

# Add an init system
RUN apt-get update && apt-get install -y \
    openssl \
    curl \
    bash \
    wget \
    tzdata \
    postgresql-client \
    python-pip \
    && pip install s3cmd
RUN wget -O /app/dd-java-agent.jar 'https://search.maven.org/classic/remote_content?g=com.datadoghq&a=dd-java-agent&v=LATEST'
ARG flyway_version="7.7.2"
RUN curl -fsSL https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${flyway_version}/flyway-commandline-${flyway_version}-linux-x64.tar.gz \
    | tar xvz -C / && ln -s /flyway-${flyway_version}/flyway /usr/local/bin
#ADD TINI
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY src/main/resources/db /db
ENV TZ=Europe/London
RUN cp /usr/share/zoneinfo/Europe/London /etc/localtime

COPY docker_entrypoint.sh /docker_entrypoint.sh
WORKDIR /app
ENTRYPOINT [ "/tini", "--", "/docker_entrypoint.sh"]
CMD ["java", "-jar", "/app/app.jar"]

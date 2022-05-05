FROM adoptopenjdk/maven-openjdk11 AS builder-image
COPY src /tmp/app/src
COPY pom.xml /tmp/app
RUN mvn -f /tmp/app/pom.xml clean package

FROM openjdk:11-jre-slim
COPY --from=builder-image /tmp/app/target/productservice-*.jar /opt/app.jar

EXPOSE 8080
CMD java -jar $JAVA_OPTS /opt/app.jar
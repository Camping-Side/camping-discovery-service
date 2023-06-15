FROM adoptopenjdk/openjdk11
RUN ["mkdir", "/var/log/discovery-service"]
RUN ["chmod", "755", "/var/log/discovery-service"]
VOLUME /data1/discovery-service /var/log/discovery-service
COPY target/discovery-service-1.0.0.jar DiscoveryServer.jar
ENTRYPOINT ["java", "-Dspring.profiles.active=dev", "-jar", "DiscoveryServer.jar"]
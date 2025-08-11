FROM 3.9.11-eclipse-temurin-17-alpine as build
RUN git clone https://github.com/srinuparella/spring-petclinic.git && \ cd spring-petclinic && \ mvn package

FROM openjdk-25-ea-17-jdk as run
RUN adduser -D -h /usr/share/demo -s /bin/bash srinu
USER srinu
WORKDIR /usr/share/demo 
COPY --FROM=build /target/*.jar
EXPOSE 8080/tcp
CMD ["java", "-jar" , "*.jar"]

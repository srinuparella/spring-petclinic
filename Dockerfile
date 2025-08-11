FROM maven:3.9.11-eclipse-temurin-17 AS build
RUN add apk install git 
WORKDIR /usr/share/demo
RUN git clone https://github.com/srinuparella/spring-petclinic.git && \ cd spring-petclinic && \ mvn package

FROM eclipse-temurin:17-jre-alpine AS run
RUN adduser -D -h /usr/share/demo -s /bin/bash srinu
USER srinu
WORKDIR /usr/share/demo 
COPY --from=build /target/*.jar .
EXPOSE 8080/tcp
CMD ["java", "-jar" , "*.jar"]

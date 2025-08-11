FROM maven:3.9.11-eclipse-temurin-17 AS build
# RUN  apk add install git in above already git is inbuilt installed
WORKDIR /usr/share/demo
RUN git clone https://github.com/srinuparella/spring-petclinic.git && \ 
cd spring-petclinic && \
mvn package
## dont write RUN git clone https://github.com/srinuparella/spring-petclinic.git && \ cd spring-petclinic && \ mvn package

FROM eclipse-temurin:17-jre-alpine AS run
RUN adduser -D -h /usr/share/demo -s /bin/bash srinu
USER srinu
WORKDIR /usr/share/demo 
COPY --from=build /spring-petclinic/target/spring-petclinic.jar  .
EXPOSE 8080/tcp
CMD ["java", "-jar" , "spring-petclinic.jar.jar"]



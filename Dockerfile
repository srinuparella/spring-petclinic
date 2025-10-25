FROM  maven:3.9.11-eclipse-temurin-17 AS build
WORKDIR /project
ADD .  /project
RUN mvn package



FROM eclipse-temurin:17-jdk-jammy AS  run
ENV enviornment="UAT"
LABEL author="DevOps Team"
ARG user=srinu
WORKDIR /app
COPY --from=build  /project/target/spring-petclinic-3.5.0-SNAPSHOT.jar   /app.jar
RUN useradd -m -s /bin/bash  ${user}
USER ${user}
EXPOSE 8080
CMD ["java" , "-jar" , "app.jar"]   


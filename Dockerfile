FROM adoptopenjdk/openjdk8:alpine-slim
EXPOSE 8080
ARG JAR_FILE=target/*.jar


# Create non-root user
RUN addgroup -S k8s-pipeline && adduser -S k8s-pipeline -G k8s-pipeline


# Copy artifact & switch user
ADD ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline


ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]

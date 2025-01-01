# Use Maven image to build the application
FROM maven:3.8-openjdk-11 AS builder

# Set the working directory for the build
WORKDIR /app

# Copy the pom.xml and source code into the container
COPY pom.xml .
COPY src ./src

# Build the WAR file
RUN mvn clean package -DskipTests

# Use official Tomcat image as the base for running the application
FROM tomcat:9.0-jdk11-openjdk

# Copy the WAR file from the builder image to Tomcat's webapps directory
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/

# Expose the port that Tomcat runs on
EXPOSE 8080

# Start Tomcat when the container starts
CMD ["catalina.sh", "run"]


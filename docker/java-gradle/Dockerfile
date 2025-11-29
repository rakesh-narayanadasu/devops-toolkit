# =============================
#  1. BUILD STAGE
# =============================
# Use the full JDK image for building the app (Java compiler needed)
FROM eclipse-temurin:21-jdk AS builder

# Set the working directory inside the build container
WORKDIR /usr/src/app/

# Copy the main Gradle bootstrap files (these rarely change → better caching)
COPY gradlew build.gradle settings.gradle ./

# Copy the Gradle wrapper folder
COPY ./gradle ./gradle

# Make gradlew executable
RUN chmod +x ./gradlew

# Run an initial Gradle invocation to download wrapper + initialize cache
RUN ./gradlew

# Download all project dependencies (cached step → faster builds)
RUN ./gradlew downloadRepos

# Copy the full project source (done AFTER dependencies for better caching)
COPY . .

# Copy protobuf definitions into the container
COPY ./pb ./proto

# Build the application and generate the distribution
# installDist produces a runnable folder under build/install/
RUN ./gradlew installDist -PprotoSourceDir=./proto

# =============================
#  2. RUNTIME STAGE
# =============================
# Use a smaller JRE image for running the application
FROM eclipse-temurin:21-jre

# App working directory
WORKDIR /usr/src/app/

# Create non-root user

RUN adduser -D -u 1000 appuser

# Copy the built application from the builder stage
COPY --from=builder /usr/src/app/ ./

# Switch to non-root user 
USER appuser

# Set the default port (only documentation, does not open the port itself)
ENV AD_PORT=9099

# Start the generated application binary
ENTRYPOINT ["./build/install/opentelemetry-demo-ad/bin/Ad"]

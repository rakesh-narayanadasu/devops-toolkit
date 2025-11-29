# =============================
#        BUILD STAGE
# =============================
# Use Go 1.22 on Alpine to build the application
FROM golang:1.22-alpine AS builder

# Working directory inside the builder container
WORKDIR /usr/src/app/

# Enable Go module & build caching for faster builds
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    mkdir -p /root/.cache/go-build

# Copy module definition files first (helps caching)
COPY go.mod go.sum ./

# Download Go module dependencies
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go binary (default build)
# Note: this is NOT a static binary unless CGO_ENABLED=0 is set
RUN go build -o product-catalog .

# =============================
#      RUNTIME STAGE
# =============================
FROM alpine AS release

# Working directory for runtime container
WORKDIR /usr/src/app/

# Create a non-root user 
RUN adduser -D -u 1000 appuser

# Copy product data directory
COPY ./products/ ./products/

# Copy the compiled Go binary from the builder stage
COPY --from=builder /usr/src/app/product-catalog ./product-catalog

# Run the application as non-root
USER appuser

# Default port used by the service (for documentation)
ENV PRODUCT_CATALOG_PORT=8088

# Start the Go service
ENTRYPOINT ["./product-catalog"]

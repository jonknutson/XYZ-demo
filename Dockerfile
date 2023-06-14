# Build the application from source
FROM golang:1.20 AS build-stage

WORKDIR /app
COPY app/go.mod app/go.sum ./
RUN go mod download

COPY app/*.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-xyz-demo


# Run tests in the container
FROM build-stage AS run-test-stage
RUN go test -v ./...

# Create a minimal container with the app binary
FROM alpine:3.18 AS deploy-stage

ARG APP_PORT=8080
ARG GIN_MODE=release
ENV XYZ_APP_PORT=$APP_PORT
ENV GIN_MODE=$GIN_MODE

RUN adduser -D nonroot

WORKDIR /app
COPY --from=build-stage /docker-xyz-demo ./docker-xyz-demo
RUN chown nonroot:nonroot ./docker-xyz-demo

EXPOSE $XYZ_APP_PORT

USER nonroot:nonroot

ENTRYPOINT ["./docker-xyz-demo"]
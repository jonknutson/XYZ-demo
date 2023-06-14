# XYZ-demo
Demonstrate IaC and K8s for the XYZ Corporation

# Application
The application is a simple endpoint that returns a static message 
and the current time in Unix time format.

The API is written in Go, using the gin web service framework.

# Infrastructure as Code
All IaC is managed in the terraform directory.

# Pipeline considerations
## Build files
### Dockerfile
The Dockerfile builds the app, runs the defined tests, and builds a
minimal container based on alpine.

The Dockerfile takes APP_PORT as an argument, sets the
XYZ_APP_PORT ENV variable, and exposes the provided port.
This is set to 8080 if not provided in by docker build.
A customer port can be specified using a build argument.
- e.g.:
> docker build -t [image-name] --build-arg APP_PORT=[value] .

The XYZ_APP_PORT ENV variable is used to set the port on which the
application listens, which defaults to 8080.

For securitiy purposes, the container runs as the user 'nonroot'.

# Running the app container
For production, the API should run in "release" mode using
the GIN_MODE ENV variable. This is set as the default in the
Dockerfile. For troubleshooting purposes, this can be overridden
either at container build time using build-args, or at container
run-time using environment variables, by setting the mode to debug.
- e.g. using build args
> docker build -t [image-name] --build-arg GIN_MODE=debug .
- e.g. using env:
> export GIN_MODE=debug

## API Definition
GET / - returns a JSON formatted message containing the
timestamp and static message.

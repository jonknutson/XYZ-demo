# XYZ-demo
Demonstrate IaC and K8s for the XYZ Corporation

# Application
The application is a simple endpoint that returns a static message 
and the current time in Unix time format.

The API is written in Go, using the gin web service framework.

## Deployment considerations
The endpoint will be exposed on port 8080 by default. You can
specify a different port using the XYZ_APP_PORT ENV variable:
- using env:    export XYZ_APP_PORT="80"

For production, make sure the API is running in "release" mode
by using the GIN_MODE ENV variable:
- using env:	export GIN_MODE=release

## API Definition
GET /motd - returns a JSON formatted message containing the
timestamp and static message.

package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
	"os"
	"time"
)

type greeting struct {
	Message     string `json:"message"`
	CurrentTime int64  `json:"timestamp"`
}

// getMOTD responds with the time and the message of the day.
func getMOTD(c *gin.Context) {
	message := "Automate all the things!"
	currentTime := time.Now().Unix()
	var motd = greeting{
		Message: message, CurrentTime: currentTime,
	}
	c.IndentedJSON(http.StatusOK, motd)
}

func getHostAddress() string {
	appPort, isSet := os.LookupEnv("XYZ_APP_PORT")
	if !isSet {
		appPort = "8080"
	}
	return fmt.Sprintf("localhost:%s", appPort)
}

func main() {

	router := gin.Default()
	router.GET("/motd", getMOTD)

	router.Run(getHostAddress())
}

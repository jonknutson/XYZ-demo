package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"log"
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
	// Change the message of the day for demo purposes
	message := "Happy Friday, y'all!"
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
	return fmt.Sprintf("0.0.0.0:%s", appPort)
}

func main() {

	router := gin.Default()
	router.GET("/", getMOTD)

	if err := router.Run(getHostAddress()); err != nil {
		log.Fatal(err)
	}
}

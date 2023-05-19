package main

import (
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"golang.org/x/sync/errgroup"
)

func main( ) {
	var (
		server= &http.Server{
			Addr: ":8080",
	
			Handler: createMainRouter( ),
	
			ReadTimeout: 5 * time.Second,
			WriteTimeout: 10 * time.Second,
		}

		healthcheckServer= &http.Server{
			Addr: ":8081",
	
			Handler: createHealthcheckRouter( ),
	
			ReadTimeout: 5 * time.Second,
			WriteTimeout: 10 * time.Second,
		}
	)

	var errGroup errgroup.Group

	errGroup.Go(
		func( ) error {
			return server.ListenAndServe( )
		},
	)

	errGroup.Go(
		func( ) error {
			return healthcheckServer.ListenAndServe( )
		},
	)

	if err := errGroup.Wait( ); err != nil {
		log.Fatal(err)
	}
}

func createMainRouter( ) http.Handler {
	httpHandler := gin.New( )

	// Recover from any panics and return a status of 500
	httpHandler.Use(gin.Recovery( ))

	httpHandler.GET("/ping", ping)
	httpHandler.GET("/hostname", getHostname)

	return httpHandler
}

func ping(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, gin.H{ "message": "pong" })
}

// getHostname returns the hostname of the instance reported by the Kernel.
func getHostname(c *gin.Context) {
	hostname, err := os.Hostname( );
	if err != nil {
		panic(err)
	}

	c.IndentedJSON(http.StatusOK, gin.H{ "hostname": hostname })
}

func createHealthcheckRouter( ) http.Handler {
	httpHandler := gin.New( )

	// Recover from any panics and return a status of 500
	httpHandler.Use(gin.Recovery( ))

	httpHandler.GET("/healthcheck", getHealthStatus)

	return httpHandler
}

// getHealthStatus returns the health status of the api server.
func getHealthStatus(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{ "status": "ready" })
}
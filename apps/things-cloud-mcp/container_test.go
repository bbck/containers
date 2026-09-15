package main

import (
	"net/http"
	"testing"

	helpers "github.com/bbck/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/bbck/things-cloud-mcp:rolling")

	t.Run("landing page is served", func(t *testing.T) {
		helpers.RequireHTTPEndpoint(t, image, helpers.HTTPTestConfig{Port: "8080", Path: "/", StatusCode: http.StatusOK}, nil)
	})

	t.Run("MCP endpoint requires auth", func(t *testing.T) {
		helpers.RequireHTTPEndpoint(t, image, helpers.HTTPTestConfig{Port: "8080", Path: "/mcp", StatusCode: http.StatusUnauthorized}, nil)
	})
}

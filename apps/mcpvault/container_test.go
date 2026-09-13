package main

import (
	"testing"

	helpers "github.com/bbck/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/bbck/mcpvault:rolling")

	t.Run("mcpvault runs", func(t *testing.T) {
		helpers.RequireCommandSucceeds(t, image, nil, "mcpvault", "--version")
	})

	t.Run("mcp-proxy runs", func(t *testing.T) {
		helpers.RequireCommandSucceeds(t, image, nil, "mcp-proxy", "--version")
	})
}

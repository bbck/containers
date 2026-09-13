package main

import (
	"testing"

	helpers "github.com/bbck/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/bbck/obsidian-headless:rolling")

	t.Run("ob runs", func(t *testing.T) {
		helpers.RequireCommandSucceeds(t, image, nil, "ob", "--version")
	})

	t.Run("sync-healthcheck is installed", func(t *testing.T) {
		helpers.RequireFileExists(t, image, "/usr/local/bin/sync-healthcheck")
	})
}

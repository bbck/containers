package main

import (
	"testing"

	helpers "github.com/bbck/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/bbck/nfs-server:rolling")

	for _, file := range []string{
		"/usr/sbin/exportfs",
		"/usr/sbin/nfsdcld",
		"/usr/sbin/rpc.mountd",
		"/usr/sbin/rpc.nfsd",
	} {
		t.Run(file+" is installed", func(t *testing.T) {
			helpers.RequireFileExists(t, image, file)
		})
	}

	t.Run("entrypoint is valid bash", func(t *testing.T) {
		helpers.RequireCommandSucceeds(t, image, nil, "bash", "-n", "/entrypoint.sh")
	})
}

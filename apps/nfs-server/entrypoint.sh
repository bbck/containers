#!/usr/bin/env bash
#
# NFSv4-only server for the kernel's nfsd. Runs in a privileged container on
# the host network, on a node with the nfsd kernel module loaded.
#
# Exports come from /etc/exports and /etc/exports.d/*.exports, and are
# reloaded when those files change.
#
# The exports must include an NFSv4 root with fsid=0 on a real filesystem,
# e.g. the parent of the exported datasets. Without one, mountd puts the root
# on the container's own overlayfs "/", which the kernel can't export, and
# every mount fails with "No such file or directory". Clients then mount paths
# relative to that root.

set -euo pipefail
shopt -s nullglob

# The NFS tools mostly fail without saying why, so name the command that did
trap 'echo "Failed: $BASH_COMMAND" >&2' ERR

NFS_THREADS="${NFS_THREADS:-8}"

# Stop nfsd's threads, if it's running. When it isn't, "rpc.nfsd 0" sets it up
# with the kernel's default versions instead, NFSv3 included, which fails (see
# the start below).
stop_threads() {
    if (($(cat /proc/fs/nfsd/threads) > 0)); then
        rpc.nfsd 0
    fi
}

stop() {
    echo "Stopping NFS server"
    stop_threads
    kill "$mountd_pid" "$nfsdcld_pid" 2>/dev/null || true
    exit "${1:-0}"
}

exports_hash() {
    cat /etc/exports /etc/exports.d/*.exports | md5sum
}

# Kernel filesystems the NFS daemons talk to
mkdir -p /var/lib/nfs/rpc_pipefs /var/lib/nfs/nfsdcld
mountpoint -q /proc/fs/nfsd || mount -t nfsd nfsd /proc/fs/nfsd
mountpoint -q /var/lib/nfs/rpc_pipefs || mount -t rpc_pipefs rpc_pipefs /var/lib/nfs/rpc_pipefs

# Stop threads a previous run left behind if it didn't stop cleanly
stop_threads

# Answers the kernel's export lookups. NFSv4 doesn't use the MOUNT protocol, so
# serve no versions of it, which leaves nothing to register with rpcbind.
rpc.mountd --foreground --no-nfs-version 2 --no-nfs-version 3 &
mountd_pid=$!

# Tracks NFSv4 clients so they can reclaim their state after a restart
nfsdcld --foreground &
nfsdcld_pid=$!

trap stop TERM INT

exportfs -ra
exportfs -v
# NFSv4 only: the kernel registers NFSv3 with rpcbind, which doesn't run here,
# and rpc.nfsd fails when it can't
rpc.nfsd --no-nfs-version 3 "$NFS_THREADS"
echo "NFS server started with $NFS_THREADS threads"

last_hash=$(exports_hash)

while true; do
    sleep 30 &
    wait $!

    if ! kill -0 "$mountd_pid" "$nfsdcld_pid" 2>/dev/null; then
        echo "rpc.mountd or nfsdcld exited"
        stop 1
    fi

    hash=$(exports_hash)
    if [[ $hash != "$last_hash" ]]; then
        echo "Exports changed, reloading"
        exportfs -ra
        exportfs -v
        last_hash=$hash
    fi
done

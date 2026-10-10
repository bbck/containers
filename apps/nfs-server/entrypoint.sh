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

# NFSv4 only, on every rpc.nfsd call. With NFSv3 enabled the kernel tries to
# register it with rpcbind, which doesn't run here, and rpc.nfsd fails. That
# includes setting 0 threads when nfsd isn't running yet.
NFSD_ARGS=(--no-nfs-version 3 --no-udp)

stop() {
    echo "Stopping NFS server"
    rpc.nfsd "${NFSD_ARGS[@]}" 0
    exportfs -ua
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

# Clear anything a previous run left behind if it didn't stop cleanly
rpc.nfsd "${NFSD_ARGS[@]}" 0
exportfs -ua

# Answers the kernel's export lookups, which NFSv4 needs as well
rpc.mountd --foreground --no-nfs-version 3 --no-udp &
mountd_pid=$!

# Tracks NFSv4 clients so they can reclaim their state after a restart
nfsdcld --foreground &
nfsdcld_pid=$!

trap stop TERM INT

exportfs -ra
exportfs -v
rpc.nfsd "${NFSD_ARGS[@]}" "$NFS_THREADS"
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

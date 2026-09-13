#!/bin/sh
# Usage: sync-healthcheck [max-age-seconds]
#
# Exits 0 when `ob sync` has logged "Fully synced" within max-age seconds (default 900).
# `ob sync --continuous` keeps running when its connection wedges, so a live
# process is not proof that the vault is current.
set -eu

max_age="${1:-900}"
state="${XDG_CONFIG_HOME:-${HOME}/.config}/obsidian-headless"

log=$(ls -1 "${state}"/sync/*/sync.log 2>/dev/null | head -n 1 || true)
[ -n "${log}" ] || { echo "no sync.log under ${state}"; exit 1; }

# Lines look like: [2026-09-12T23:51:00.000Z] Fully synced
ts=$(tail -c 200000 "${log}" | grep -a 'Fully synced' | tail -n 1 | sed -n 's/^\[\([^]]*\)\].*/\1/p')
[ -n "${ts}" ] || { echo "never reached Fully synced"; exit 1; }

age=$(( $(date -u +%s) - $(date -u -d "${ts}" +%s) ))
echo "last full sync ${age}s ago (max ${max_age}s)"
[ "${age}" -lt "${max_age}" ]

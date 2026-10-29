#!/usr/bin/env bash
set -euo pipefail

# TODO: Report current user, effective UID, hostname, kernel,
# ISO-8601 date, disk usage, memory usage and Docker daemon status.

print_section() {
	printf '\n=== %s ===\n' "$1"
}

print_section "User"
printf 'Current user: %s\n' "$(id -un)"
printf 'Effective UID: %s\n' "$(id -u)"

print_section "Host"
printf 'Hostname: %s\n' "$(hostname)"
printf 'Kernel release: %s\n' "$(uname -r)"

print_section "System Date"
if date -u '+%Y-%m-%dT%H:%M:%SZ' >/dev/null 2>&1; then
    printf 'Date (UTC): %s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
else
    printf 'Date: %s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')"
fi

print_section "Disk Usage"
df -h

print_section "Memory Usage"
if command -v free >/dev/null 2>&1; then
    free -h
elif [[ -r /proc/meminfo ]]; then
    awk '/^(MemTotal|MemAvailable|SwapTotal|SwapFree):/ {
        printf "%-14s %8.2f MiB\n", $1, $2 / 1024
    }' /proc/meminfo
else
    printf 'Memory usage unavailable: free and /proc/meminfo not found.\n'
fi

print_section "Docker Version"
if ! command -v docker >/dev/null 2>&1; then
    printf 'Docker status: unavailable (Docker CLI not installed)\n'
elif docker info >/dev/null 2>&1; then
    printf 'Docker status: running\n'
else
    printf 'Docker status: not responding or permission denied\n'
fi

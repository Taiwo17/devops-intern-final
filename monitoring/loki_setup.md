# Loki Log Aggregation

## Overview

This stack uses Loki, Promtail, and Grafana to collect and explore Docker container logs.

- **Loki:** Receives and stores log streams.
- **Promtail:** Discovers Docker containers, reads logs, attaches labels, and forwards logs to Loki.
- **Grafana:** Connects to Loki and provides a LogQL interface for searching logs.

## Prerequisites

- Docker Engine running in WSL 2.
- Docker Compose plugin.
- NGINX application deployed and generating logs.

Verify the required tools:

```bash
docker --version
docker compose version
```

## Start the Monitoring Stack

From the project root, run:

```bash
cd monitoring
docker compose up -d
docker compose ps
```

Check Loki readiness:

```bash
curl http://localhost:3100/ready
```

Expected response:

```text
ready
```

## Configure Grafana

1. Open http://localhost:3000.
2. Log in using the local credentials:
   - Username: `admin`
   - Password: `admin`
3. Navigate to **Connections → Data sources**.
4. Add a Loki data source.
5. Set the URL to `http://loki:3100`.
6. Select **Save & test** and confirm the connection succeeds.

## Explore NGINX Logs

Open **Explore** in Grafana and select Loki.

Promtail attaches Docker metadata, including `container` and `service` labels.

Use this LogQL query to find NGINX HTTP 404 responses:

```logql
{container=~"nginx-.+"} |= "404"
```

Set the time range to **Last 15 minutes** or **Last 1 hour**.

Generate a test 404 request using the active Nomad allocation port:

```bash
curl http://localhost:<NOMAD_DYNAMIC_PORT>/this-page-does-not-exist
```

Replace `<NOMAD_DYNAMIC_PORT>` with the actual dynamic port assigned by Nomad.

Refresh the Grafana query to see the corresponding NGINX access log.

## Stop the Monitoring Stack

From the monitoring directory:

```bash
docker compose down
```

## Troubleshooting

### Loki is not ready

```bash
docker compose logs loki
```

### Promtail is not collecting logs

```bash
docker compose logs promtail
```

Check that the Docker socket and container log directory are mounted correctly.

### Grafana shows no logs

- Confirm the Loki data source URL is `http://loki:3100`.
- Confirm **Save & test** succeeds.
- Check that Promtail is running.
- Generate a fresh NGINX request.
- Widen the Grafana time range.

### No matching 404 entries

Generate a request to a nonexistent path on the active NGINX allocation, then run the LogQL query again.

## Limitations and Security Notes

- This configuration is intended for local development and assessment demonstration, not production.
- Nomad development mode uses ephemeral state; jobs may need to be resubmitted after the agent restarts.
- Promtail collects Docker container logs through the Docker socket and container log directory.
- Grafana uses default local credentials. Change them before exposing Grafana beyond a trusted local environment.
- Authentication and TLS are not configured in this demonstration stack.
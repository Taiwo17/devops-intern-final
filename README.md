# DevOps Intern Final Assessment — NGINX Deployment Pipeline

![CI Pipeline](https://github.com/Taiwo17/devops-intern-final/actions/workflows/ci.yml/badge.svg)

A containerized NGINX web application demonstrating Linux administration, Bash scripting, Docker, Git/GitHub collaboration, continuous integration and delivery, Nomad deployment, and centralized logging with Loki, Promtail, and Grafana.

**Author:** Taiwo Shobo  
**Assessment date:** 29 October 2026  
**Repository:** [Taiwo17/devops-intern-final](https://github.com/Taiwo17/devops-intern-final)

---

## Table of Contents

- [1. Project Overview](#1-project-overview)
- [2. Repository Structure](#2-repository-structure)
- [3. Prerequisites](#3-prerequisites)
- [4. Task 1 — Repository Setup and Git Workflow](#4-task-1--repository-setup-and-git-workflow)
- [5. Task 2 — Bash Automation Scripts](#5-task-2--bash-automation-scripts)
- [6. Task 3 — Docker Containerization](#6-task-3--docker-containerization)
- [7. Task 4 — GitHub Actions CI/CD](#7-task-4--github-actions-cicd)
- [8. Task 5 — Nomad Deployment](#8-task-5--nomad-deployment)
- [9. Task 6 — Centralized Logging and Monitoring](#9-task-6--centralized-logging-and-monitoring)
- [10. Architecture](#10-architecture)
- [11. Quick Start](#11-quick-start)
- [12. Testing and Validation](#12-testing-and-validation)
- [13. Screenshots and Evidence](#13-screenshots-and-evidence)
- [14. Troubleshooting](#14-troubleshooting)
- [15. Limitations and Future Improvements](#15-limitations-and-future-improvements)
- [16. Assessment Status](#16-assessment-status)

---

## 1. Project Overview

The objective of this project is to build and document an end-to-end deployment pipeline for a lightweight NGINX web application.

The project combines Linux command-line administration, automated health checks, container security, Git-based version control, CI/CD, orchestration, and centralized log analysis.

### Objectives

- Create a public GitHub repository with a clear project structure.
- Implement reusable Bash scripts for system information and application health checks.
- Package an NGINX application into a lightweight, non-root Docker container.
- Expose the application on port `8080` and provide a `/healthz` endpoint.
- Embed a build identifier in the application.
- Automate linting, building, testing, and publishing through GitHub Actions.
- Define and validate an NGINX workload using HashiCorp Nomad.
- Collect and query logs using Loki, Promtail, and Grafana.
- Document implementation decisions, testing evidence, troubleshooting, and limitations.

## 2. Repository Structure

The intended repository structure is:

```text
devops-intern-final/
├── README.md
├── .gitignore
├── app/
│   ├── Dockerfile
│   ├── index.html
│   └── nginx.conf
├── scripts/
│   ├── sysinfo.sh
│   └── healthcheck.sh
├── .github/
│   └── workflows/
│       └── ci.yml
├── nomad/
│   └── nginx-app.nomad.hcl
├── monitoring/
│   ├── loki-config.yaml
│   ├── promtail-config.yaml
│   ├── docker-compose.yaml
│   └── loki_setup.md
└── docs/
    └── screenshots/
```

The `docs/screenshots/` directory is used to store assessment evidence, such as successful builds, health checks, workflow runs, Nomad status, and Grafana queries.

## 3. Prerequisites

The following tools are required for the relevant parts of the project:

| Tool | Purpose |
|---|---|
| Git | Version control and collaboration workflow |
| GitHub account | Source code hosting and GitHub Actions |
| Bash | Automation scripts |
| ShellCheck | Bash script linting |
| Docker Engine or Docker Desktop | Build and run the container |
| curl | HTTP health-check testing |
| Hadolint | Dockerfile linting |
| HashiCorp Nomad | Workload validation and orchestration |
| Docker Compose | Run the monitoring services |
| Loki | Log aggregation |
| Promtail | Log collection and forwarding |
| Grafana | Log exploration and visualization |

The Bash scripts and Docker application have been tested in a WSL 2 Ubuntu environment with Docker available through Docker Desktop.

Check installed tools:

```bash
git --version
bash --version
docker --version
docker compose version
curl --version
shellcheck --version
```

Check Nomad separately when working on the deployment task:

```bash
nomad version
```

Install any missing tools before running the relevant task.

## 4. Task 1 — Repository Setup and Git Workflow

### Objective

Create the public GitHub repository, establish the required directory structure, and use a feature branch for implementation.

### Repository

[Open the GitHub repository](https://github.com/Taiwo17/devops-intern-final)

### Branching strategy

The implementation branch is:

```text
feature/project-scaffold
```

The target integration branch is:

```text
main
```

The intended workflow is:

1. Create the repository and project structure.
2. Work on `feature/project-scaffold` rather than making implementation changes directly on `main`.
3. Commit related changes in small, meaningful units.
4. Push the feature branch to GitHub.
5. Open a pull request targeting `main`.
6. Review and merge the pull request.
7. Create the final release tag `v1.0.0` after the required tasks have been completed and verified.

### Conventional commits

Commit messages describe the purpose of each change.

Examples:

```text
chore: scaffold project structure
feat: add system information and healthcheck scripts
feat: containerize nginx application
ci: add github actions pipeline
feat: add nomad deployment configuration
feat: configure centralized logging
docs: complete assessment documentation
```

### Git verification

Check the current branch and working tree:

```bash
git branch --show-current
git status
git log --oneline --decorate -5
```

Before the final submission, verify that the required pull request has been merged into `main` and that the `v1.0.0` tag exists.

## 5. Task 2 — Bash Automation Scripts

### 5.1 System information script

**File:** `scripts/sysinfo.sh`

The system information script reports useful information about the environment in which it runs.

It includes:

- Current username and effective user ID.
- Hostname and kernel release.
- Current date and time in ISO 8601 UTC format.
- Disk usage.
- Memory usage.
- Docker daemon availability.

The script uses a Bash shebang and strict error-handling options:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

Run it from the repository root:

```bash
bash scripts/sysinfo.sh
```

Expected output sections include:

```text
=== User ===
Current user: ...

=== Host ===
Hostname: ...
Kernel release: ...

=== System Date ===
Date (UTC): ...

=== Disk Usage ===
...

=== Memory Usage ===
...

=== Docker Daemon ===
Docker status: running
```

The values depend on the machine running the script.

### 5.2 Application health-check script

**File:** `scripts/healthcheck.sh`

The health-check script checks whether an HTTP endpoint returns status code `200`.

The target URL is optional. If no URL is supplied, the script uses:

```text
http://localhost:8080
```

Run the default check:

```bash
bash scripts/healthcheck.sh
```

Check the dedicated health endpoint:

```bash
bash scripts/healthcheck.sh http://localhost:8080/healthz
```

Test a nonexistent path:

```bash
bash scripts/healthcheck.sh http://localhost:8080/does-not-exist
```

Test a connection failure:

```bash
bash scripts/healthcheck.sh http://localhost:9999/healthz
```

### Health-check behavior

| Condition | Expected result |
|---|---|
| HTTP `200` | Exit code `0` |
| HTTP `404` or another non-200 response | Nonzero exit code |
| Connection failure or timeout | Nonzero exit code |
| More than one URL argument | Nonzero exit code |
| `curl` unavailable | Diagnostic error and nonzero exit code |

The script uses connection and overall request timeouts to prevent checks from hanging indefinitely.

### 5.3 Validation and test evidence

ShellCheck was run against both scripts:

```bash
shellcheck scripts/sysinfo.sh scripts/healthcheck.sh
echo $?
```

**Observed result:** ShellCheck returned no diagnostics, and the exit code was `0`.

A successful application check returned:

```text
Checking application: http://localhost:8080/healthz
Success: Application returned HTTP 200.
```

The default URL was also tested successfully.

A failed connection returned:

```text
Checking application: http://localhost:9999/healthz
ERROR: Request failed for http://localhost:9999/healthz (connection, timeout, or URL error).
1
```

A nonexistent path returned:

```text
Checking application: http://localhost:8080/does-not-exist
ERROR: Expected HTTP 200, received HTTP 404.
1
```

These results demonstrate successful and unsuccessful health-check scenarios.

### 5.4 Executable permissions

The scripts should be executable in Git:

```bash
git update-index --chmod=+x scripts/sysinfo.sh scripts/healthcheck.sh
git diff --cached --summary
```

Verify the final Git file modes show `100755` for both scripts.

## 6. Task 3 — Docker Containerization

### Objective

Build a lightweight NGINX image that runs as a non-root user, serves the application on port `8080`, exposes a health endpoint, and includes a build identifier.

### Files

- `app/Dockerfile`
- `app/index.html`
- `app/nginx.conf`

### 6.1 Dockerfile design

The Dockerfile uses the NGINX Alpine image:

```dockerfile
FROM nginx:1.27-alpine

ARG BUILD_SHA=local

COPY app/index.html /usr/share/nginx/html/index.html
COPY app/nginx.conf /etc/nginx/nginx.conf

RUN sed -i "s/BUILD_SHA_PLACEHOLDER/${BUILD_SHA}/g" \
    /usr/share/nginx/html/index.html

USER 101:101

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1:8080/healthz || exit 1

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
```

The build argument `BUILD_SHA` is substituted into the HTML at image-build time.

The image is configured to run as UID `101` and GID `101`, rather than the default root user. The custom NGINX configuration uses temporary paths under `/tmp` and writes access and error logs to standard output and standard error.

### 6.2 NGINX configuration

The configuration in `app/nginx.conf`:

- Listens on port `8080`.
- Serves static content from `/usr/share/nginx/html`.
- Returns HTTP `200` from `/healthz`.
- Returns HTTP `404` for nonexistent paths.
- Disables NGINX version disclosure.
- Sends access and error logs to the container logging streams.
- Uses writable temporary directories compatible with non-root execution.

### 6.3 Build the image

Run the following command from the repository root:

```bash
docker build \
  -f app/Dockerfile \
  --build-arg BUILD_SHA=local-test-001 \
  -t devops-intern-final:local \
  .
```

The final `.` is important because it makes the repository root the Docker build context.

### 6.4 Start the container

```bash
docker run -d \
  --name devops-nginx \
  -p 8080:8080 \
  devops-intern-final:local
```

Check the container status:

```bash
docker ps
```

The container was observed running with a healthy Docker health status:

```text
IMAGE                       STATUS                 PORTS
devops-intern-final:local   Up ... (healthy)       0.0.0.0:8080->8080/tcp
```

### 6.5 Test the application

Test the home page:

```bash
curl -i http://localhost:8080/
```

Test the health endpoint:

```bash
curl -i http://localhost:8080/healthz
```

Check a nonexistent path:

```bash
curl -i http://localhost:8080/does-not-exist
```

Check the build identifier:

```bash
curl -s http://localhost:8080/ | grep 'local-test-001'
```

The home page should include the application title, author, assessment date, and build identifier. The health endpoint should return HTTP `200`, while the nonexistent path should return HTTP `404`.

### 6.6 Verify the image

Inspect image size:

```bash
docker images devops-intern-final:local
```

The assessment requires the image to be smaller than **60 MB**. Record the actual result here after checking it.

Verify the configured runtime user:

```bash
docker image inspect \
  devops-intern-final:local \
  --format '{{.Config.User}}'
```

Expected user:

```text
101:101
```

Verify the health-check configuration:

```bash
docker image inspect \
  devops-intern-final:local \
  --format '{{json .Config.Healthcheck}}'
```

### 6.7 Container management

View container logs:

```bash
docker logs devops-nginx
```

Stop the container:

```bash
docker stop devops-nginx
```

Remove the container:

```bash
docker rm devops-nginx
```

The image can remain available locally for subsequent testing.

**Evidence to record:** the actual image size, successful home-page response, `/healthz` response, non-root user, and Docker health status.

## 7. Task 4 — GitHub Actions CI/CD

**Workflow file:** `.github/workflows/ci.yml`

### Objective

Automate the quality checks and container build, then publish the image to GitHub Container Registry (GHCR) when changes are pushed to `main`.

### Required jobs

| Job | Responsibility |
|---|---|
| `lint` | Run ShellCheck and Hadolint |
| `build` | Build the Docker image |
| `test` | Run the container and verify the HTTP health endpoint |
| `publish` | Publish the image to GHCR after successful validation |

### Workflow triggers

The workflow should run on:

- Pushes to `main`.
- Pull requests targeting `main`.

Publishing should be restricted to pushes to `main`, not pull-request builds.

### Container image tags

The registry image should use the repository's GHCR path, with at least:

```text
ghcr.io/taiwo17/devops-intern-final:<commit-sha>
ghcr.io/taiwo17/devops-intern-final:latest
```

The actual commit SHA should be injected into the image using the `BUILD_SHA` build argument.

### Security considerations

- Grant only the GitHub token permissions needed by each job.
- Give the publishing job `packages: write` permission.
- Do not expose registry credentials to untrusted pull-request code.
- Use supported, explicitly versioned GitHub Actions.
- Publish only after the required validation jobs succeed.

### Validation

After the workflow is implemented:

1. Push the feature branch.
2. Open a pull request against `main`.
3. Review the workflow run.
4. Confirm that linting, image building, and tests pass.
5. Merge the pull request.
6. Confirm that the image is published to GHCR.
7. Verify both the commit-SHA and `latest` tags.

**Evidence to add:** the successful workflow run, pull request, and published image tags.

## 8. Task 5 — Nomad Deployment

**Job specification:** `nomad/nginx-app.nomad.hcl`

### Objective

Define the NGINX application as a Nomad service using the Docker driver.

The job specification should include:

- A service job with one group and one Docker task.
- A configurable container image and tag.
- CPU allocation of `100 MHz`.
- Memory allocation of `64 MB`.
- A dynamically allocated port named `http`, mapped to container port `8080`.
- A Consul HTTP health check for `/healthz`, with a 10-second interval and 2-second timeout.
- Rolling-update configuration.
- Restart and rescheduling policies.

### Validate the job

From the repository root:

```bash
nomad job validate nomad/nginx-app.nomad.hcl
```

Inspect the deployment plan:

```bash
nomad job plan nomad/nginx-app.nomad.hcl
```

Submit the job when a suitable Nomad environment is running:

```bash
nomad job run nomad/nginx-app.nomad.hcl
```

Check job status:

```bash
nomad job status nginx-app
```

Use the job name actually defined in the HCL file if it differs from `nginx-app`.

### Validation evidence

Record:

- The successful validation output.
- The plan output.
- The job status.
- The allocation status.
- Evidence that the HTTP health check is passing.

The Nomad task is not considered complete until the configuration has been validated and the deployment has been tested in a running environment.

## 9. Task 6 — Centralized Logging and Monitoring

### Objective

Collect application and container logs with Promtail, store them in Loki, and query them through Grafana.

### Files

```text
monitoring/
├── loki-config.yaml
├── promtail-config.yaml
├── docker-compose.yaml
└── loki_setup.md
```

### Components

| Component | Purpose |
|---|---|
| NGINX | Generates application access and error logs |
| Promtail | Collects logs and forwards them to Loki |
| Loki | Stores and indexes log labels for querying |
| Grafana | Provides a user interface for log exploration |

### Configuration requirements

The monitoring configuration should:

- Run Loki, Promtail, and Grafana using Docker Compose.
- Configure Loki as the log aggregation backend.
- Configure Promtail to collect the intended Docker or Nomad logs.
- Attach useful labels such as job, container, service, or allocation ID, depending on the collection method.
- Document setup, access, and testing in `monitoring/loki_setup.md`.

The selected log collection configuration must match the environment being used. Docker log collection and Nomad allocation log collection may require different paths or access permissions.

### Start the monitoring stack

After completing the configuration, run:

```bash
docker compose -f monitoring/docker-compose.yaml up -d
```

Check the service status:

```bash
docker compose -f monitoring/docker-compose.yaml ps
```

Inspect service logs if needed:

```bash
docker compose -f monitoring/docker-compose.yaml logs
```

### Generate a log entry

Request a nonexistent path from NGINX:

```bash
curl -i http://localhost:8080/does-not-exist
```

This should return HTTP `404` and generate an access-log entry.

### Query the logs

Open Grafana, configure or select the Loki data source, and use Explore to query the collected NGINX logs.

A query can start with:

```logql
{job="nginx"}
```

The actual label selector must match the labels defined in `promtail-config.yaml`.

To find unsuccessful HTTP responses, use a LogQL filter appropriate to the format of the collected logs. For standard NGINX access logs, a starting example is:

```logql
{job="nginx"} |~ "\" (4[0-9][0-9]|5[0-9][0-9]) "
```

This expression assumes the standard NGINX access-log format and a `job="nginx"` label. Adjust it if the configuration uses different labels or log formatting.

### Evidence to capture

- Monitoring services running under Docker Compose.
- Loki configured as a Grafana data source.
- A query displaying NGINX log entries.
- A query showing the deliberately generated `404` response.
- A screenshot of Grafana Explore.
- Setup instructions in `monitoring/loki_setup.md`.

## 10. Architecture

The intended deployment and monitoring flow is:

```text
Developer
    |
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    +--> Lint
    |
    +--> Build
    |
    +--> Test
    |
    v
GitHub Container Registry
    |
    v
Nomad Deployment
    |
    v
NGINX Application
    |
    v
Container / Application Logs
    |
    v
Promtail --> Loki --> Grafana Explore
```

The CI pipeline validates changes before publishing the container image. Nomad runs the application, while Promtail, Loki, and Grafana provide the logging and exploration path.

## 11. Quick Start

These commands build and run the locally tested Docker application from the repository root.

```bash
git clone https://github.com/Taiwo17/devops-intern-final.git
cd devops-intern-final
docker build -f app/Dockerfile --build-arg BUILD_SHA=local-test-001 -t devops-intern-final:local .
docker run -d --name devops-nginx -p 8080:8080 devops-intern-final:local
curl -i http://localhost:8080/
curl -i http://localhost:8080/healthz
bash scripts/healthcheck.sh http://localhost:8080/healthz
docker ps
```

These commands assume Docker is running and the host port `8080` is available.

The CI/CD, Nomad, and monitoring components require their corresponding configurations and environments to be completed before they can be used.

## 12. Testing and Validation

The following results have been observed during local implementation:

| Test | Result |
|---|---|
| ShellCheck on both Bash scripts | Passed; exit code `0` |
| Default application health check | Passed; HTTP `200` |
| `/healthz` health check | Passed; HTTP `200` |
| Connection-failure health check | Correctly failed with a nonzero exit code |
| Nonexistent-path health check | Correctly failed on HTTP `404` |
| Docker image build | Completed successfully |
| Docker container startup | Container observed running |
| Docker health status | Observed as healthy |

The following evidence still needs to be recorded after completing the corresponding tasks:

- Actual image size and confirmation that it is below 60 MB.
- Hadolint result.
- Successful GitHub Actions run and GHCR publication.
- Nomad validation, plan, and deployment results.
- Loki/Promtail/Grafana collection and query results.
- Pull request merge and final release tag.

Only mark a test as passed after confirming its actual result.

## 13. Screenshots and Evidence

Store screenshots in `docs/screenshots/` and embed them here after capturing them.

Suggested evidence files:

| Screenshot | Suggested filename |
|---|---|
| Repository structure and branches | `repository-structure.png` |
| ShellCheck and script execution | `bash-scripts.png` |
| Docker build and image size | `docker-build.png` |
| HTTP health endpoint | `healthcheck.png` |
| Successful GitHub Actions workflow | `github-actions.png` |
| GHCR image tags | `ghcr-package.png` |
| Nomad job status | `nomad-status.png` |
| Grafana Explore query | `grafana-explore.png` |
| Merged pull request | `pull-request-merged.png` |

Embed a screenshot using a relative path, for example:

```markdown
![Application health check](docs/screenshots/healthcheck.png)
```

Do not add placeholder images as evidence. Capture the actual results from your environment.

## 14. Troubleshooting

The following issues and their resolutions are relevant to the implementation. Record the exact commands and outcomes observed during your work.

### 14.1 Docker build context

**Problem:** Docker cannot find files referenced by `COPY`.

**Cause:** The build command was run with the wrong build context.

**Resolution:** Run the build from the repository root and use `.` as the context:

```bash
docker build -f app/Dockerfile -t devops-intern-final:local .
```

### 14.2 Incorrect `wget` output option

**Problem:** The Docker health check fails because the `wget` command uses an incorrect option.

**Cause:** The output-to-file option is uppercase `-O`, not lowercase `-o`.

**Resolution:**

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1:8080/healthz || exit 1
```

### 14.3 Health check returns HTTP 404

**Problem:** The health-check script reports a non-200 response.

**Cause:** The requested path does not exist or the NGINX configuration does not match the requested URL.

**Resolution:** Verify the endpoint and test it directly:

```bash
curl -i http://localhost:8080/healthz
```

The expected result is HTTP `200`.

### 14.4 Container cannot bind to port 8080

**Problem:** Docker cannot start the container because the host port is already in use.

**Cause:** Another process or container is using port `8080`.

**Resolution:** Inspect running containers and choose an available host port if necessary:

```bash
docker ps
docker run -d --name devops-nginx -p 8081:8080 devops-intern-final:local
```

If the host port changes to `8081`, update the URL used for host-side tests. The application still listens on port `8080` inside the container.

Additional troubleshooting entries should be added for actual issues encountered during CI/CD, Nomad, and monitoring implementation.

## 15. Limitations and Future Improvements

The project is an assessment environment, not a production-ready platform.

Potential improvements include:

- Pinning base images and third-party actions to immutable digests or commit SHAs where appropriate.
- Adding image vulnerability scanning and software bill of materials generation.
- Using TLS and appropriate access controls for externally accessible services.
- Managing secrets through an appropriate secret-management mechanism rather than committing credentials.
- Adding resource limits and stronger runtime security controls.
- Defining production-ready log retention, storage, and access policies.
- Adding automated integration tests and deployment rollback procedures.
- Running Nomad and monitoring components in a suitably secured environment.

The final implementation should document which improvements were completed and which remain future work.

## 16. Assessment Status

This table tracks progress and should be updated as each task is completed and verified.

| Task | Status |
|---|---|
| Task 1 — Repository setup and Git workflow | In progress; final PR merge and tag remain to be verified |
| Task 2 — Bash automation scripts | Implemented and locally tested |
| Task 3 — Docker containerization | Built and run locally; final image-size evidence remains to be recorded |
| Task 4 — GitHub Actions CI/CD | Pending verification |
| Task 5 — Nomad deployment | Pending verification |
| Task 6 — Centralized logging and monitoring | Pending verification |
| Final README and screenshots | In progress |
| Pull request and `v1.0.0` release tag | Pending final verification |

---

## Conclusion

This project demonstrates a practical DevOps workflow that starts with source control and Linux automation, continues through containerization and CI/CD, and extends to workload orchestration and centralized logging.

The final submission will include the working configurations, actual test outputs, screenshots, troubleshooting notes, and GitHub evidence required to demonstrate the completed assessment.

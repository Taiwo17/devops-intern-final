variable "image_tag" {
  type        = string
  description = "Docker image tag to deploy"
  default     = "latest"
}

job "nginx-app" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "2m"
    progress_deadline = "10m"
    auto_revert       = true
  }

  group "nginx" {
    count = 1
    network {
      port "http" {
        to = 8080
      }
    }
    service {
      name     = "nginx-app"
      port     = "http"
      provider = "consul"

      address = "host.docker.internal"

      check {
        name     = "nginx-health"
        type     = "http"
        port     = "http"
        path     = "/healthz"
        interval = "10s"
        timeout  = "2s"
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "15s"
      mode     = "fail"
    }

    reschedule {
      attempts       = 3
      interval       = "1h"
      delay          = "30s"
      delay_function = "exponential"
      max_delay      = "5m"
      unlimited      = false
    }

    task "nginx" {
      driver = "docker"
      config {
        image = "ghcr.io/taiwo17/devops-intern-final:${var.image_tag}"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}

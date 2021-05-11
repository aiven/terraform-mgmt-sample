variable "aiven_api_token" {
  type = string
}

variable "aiven_project_name" {
  type = string
}

terraform {
  required_providers {
    aiven = {
      source  = "aiven/aiven"
      version = "2.1.12" # check out the latest release in the docs page!
    }
  }
}

provider "aiven" {
  api_token = var.aiven_api_token
}

data "aiven_project" "my_project" {
  project = var.aiven_project_name
}

resource "aiven_pg" "postgresql" {
  project      = data.aiven_project.my_project.project
  service_name = "postgresql"
  cloud_name   = "google-europe-west3"
  plan         = "startup-4"

  termination_protection = false

  pg_user_config {
    pg_version     = 13
    admin_username = "admin"

    pgbouncer {
      autodb_max_db_connections = 200
    }
  }
}

output "postgresql_service_uri" {
  value     = aiven_pg.postgresql.service_uri
  sensitive = true
}

resource "aiven_influxdb" "influxdb" {
  project      = data.aiven_project.my_project.project
  cloud_name   = "do-fra"
  plan         = "startup-4"
  service_name = "influxdb"
}

resource "aiven_service_integration" "postgresql_metrics" {
  project                  = data.aiven_project.my_project.project
  integration_type         = "metrics"
  source_service_name      = aiven_pg.postgresql.service_name
  destination_service_name = aiven_influxdb.influxdb.service_name
}

resource "aiven_grafana" "grafana" {
  project      = data.aiven_project.my_project.project
  cloud_name   = "do-fra"
  plan         = "startup-4"
  service_name = "grafana"

  grafana_user_config {
    public_access {
      grafana = true
    }
  }
}

resource "aiven_service_integration" "grafana_dashboard" {
  project                  = data.aiven_project.my_project.project
  integration_type         = "dashboard"
  source_service_name      = aiven_grafana.grafana.service_name
  destination_service_name = aiven_influxdb.influxdb.service_name
}

output "grafana_service_uri" {
  value     = aiven_grafana.grafana.service_uri
  sensitive = true
}

output "grafana_service_username" {
  value = aiven_grafana.grafana.service_username
}

output "grafana_service_password" {
  value     = aiven_grafana.grafana.service_password
  sensitive = true
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. Create Artifact Registry repo
resource "google_artifact_registry_repository" "repo" {
  provider      = google
  location      = var.region
  repository_id = "json-prettifier-repo-${var.environment}"
  description   = "Docker repo for JSON Prettifier app"
  format        = "DOCKER"
}

# 2. Create Service Account for Cloud Run invocation
resource "google_service_account" "invoker" {
  account_id   = "json-prettifier-invoker-${var.environment}"
  display_name = "Service account for invoking Cloud Run"
}

# 3. Deploy Cloud Run service
resource "google_cloud_run_service" "service" {
  name     = "json-prettifier-${var.environment}"
  location = var.region

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/json-prettifier:latest"
        ports {
          container_port = 8080
        }
      }
      service_account_name = google_service_account.invoker.email
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# 4. Allow service account to invoke Cloud Run service
resource "google_cloud_run_service_iam_member" "invoker_binding" {
  location = google_cloud_run_service.service.location
  service  = google_cloud_run_service.service.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.invoker.email}"
}

terraform {
  backend "gcs" {
    bucket = "auxiliary-tfstate"
    prefix = "gcp-infra/mv-prod-applications-hub/production/us-east4/gke-us-east4-applications-hub-01/"
  }
}


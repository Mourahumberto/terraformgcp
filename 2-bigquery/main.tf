terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = "spring-radar-380614-841e253b6e75.json"
  project = "spring-radar-380614"
  region  = "us-east1"
  zone    = "us-east1-c"
}

resource "google_bigquery_dataset" "dataset_iab" {
  dataset_id    = "iab_classifier_results"
  friendly_name = "iab_classifier_results"
  description   = "Dataset for storing IAB classifier results"
  location      = "us-east1"
  default_table_expiration_ms = 3600000
}

resource "google_bigquery_table" "full_video_transcription_result" {
  dataset_id = google_bigquery_dataset.dataset_iab.dataset_id
  table_id   = "full_video_transcription_result"

  time_partitioning {
    type = "DAY"
  }

  schema              = file("${path.module}/schemas/full_video_transcription_result.json")
  deletion_protection = false
}

resource "google_bigquery_table" "segmented_video_transcription_result" {
  dataset_id = google_bigquery_dataset.dataset_iab.dataset_id
  table_id   = "segmented_video_transcription_result"

  time_partitioning {
    type = "DAY"
  }

  schema              = file("${path.module}/schemas/segmented_video_transcription_result.json")
  deletion_protection = false
}

# resource "google_bigquery_table" "multicontent_result" {
#   dataset_id = google_bigquery_dataset.dataset_iab.dataset_id
#   table_id   = "multicontent_result"

#   time_partitioning {
#     type = "DAY"
#   }

#   schema              = file("${path.module}/schemas/multicontent_result.json")
#   deletion_protection = false
# }

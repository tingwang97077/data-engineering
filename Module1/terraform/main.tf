terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.16.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

# Create GCS Bucket
resource "google_storage_bucket" "demo_bucket" {
  name          = var.gcs_bucket_name
  location      = var.location
  storage_class = var.gcs_storage_class
  force_destroy = true

  uniform_bucket_level_access = true


  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}


# Create BigQuery Dataset
resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id  = var.bq_dataset_name
  location    = var.location
  description = "Dataset for NYC taxi Trip analysis"

  delete_contents_on_destroy = true
}

# Download NYC Green Taxi Trip Data in parquet
resource "null_resource" "download_green_taxi" {
  provisioner "local-exec" {
    command = "mkdir -p ./data && curl -L -o ./data/green_tripdata_2025-11.parquet https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet"
  }
}

# Download Taxi zones csv file
resource "null_resource" "download_taxi_zones" {
  provisioner "local-exec" {
    command = "mkdir -p ./data && curl -L -o ./data/taxi_zone_lookup.csv https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"
  }
}

# Upload parquet file to GCS
resource "google_storage_bucket_object" "green_taxi_data" {
  name   = "green_taxi/green_tripdata_2025-11.parquet"
  bucket = google_storage_bucket.demo_bucket.name
  source = "./data/green_tripdata_2025-11.parquet"

  depends_on = [null_resource.download_green_taxi]
}

# Upload csv file to GCS
resource "google_storage_bucket_object" "taxi_zones_data" {
  name   = "taxi_zones/taxi_zone_lookup.csv"
  bucket = google_storage_bucket.demo_bucket.name
  source = "./data/taxi_zone_lookup.csv"

  depends_on = [null_resource.download_taxi_zones]
}

# Create BigQuery Table for Green Taxi Data parquet file
resource "google_bigquery_table" "green_taxi_trips" {
  dataset_id = google_bigquery_dataset.demo_dataset.dataset_id
  table_id   = "green_taxi_trips"

  external_data_configuration {
    autodetect    = true
    source_format = "PARQUET"

    source_uris = [
      "gs://${google_storage_bucket.demo_bucket.name}/${google_storage_bucket_object.green_taxi_data.name}"
    ]
  }
}

# Create BigQuery Table for Taxi Zones csv file
resource "google_bigquery_table" "taxi_zones" {
  dataset_id = google_bigquery_dataset.demo_dataset.dataset_id
  table_id   = "taxi_zones"

  external_data_configuration {
    autodetect    = true
    source_format = "CSV"

    source_uris = [
      "gs://${google_storage_bucket.demo_bucket.name}/${google_storage_bucket_object.taxi_zones_data.name}"
    ]

    csv_options {
      quote             = "\""
      skip_leading_rows = 1
    }
  }
}
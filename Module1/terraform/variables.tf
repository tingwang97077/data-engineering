variable "credentials" {
  description = "My Credentials"
  default     = "./keys/terraform-demo-484421-35b5882e5ffa.json"
}

variable "project" {
  description = "Project"
  default     = "terraform-demo-484421"
}

variable "region" {
  description = "Region"
  default     = "europe-west9"
}

variable "location" {
  description = "Project Location"
  default     = "EU"
}

variable "bq_dataset_name" {
  description = "NYC Green Taxi Trip BigQuery"
  default     = "nyc_green_taxi_trip_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "homework-1-nyc-taxi-data-2025-11"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}

terraform {
  required_version = ">= 0.12.26"
  required_providers {
    google      = "~> 4.36"
    google-beta = "~> 4.36"
    vault       = "~> 2.15"
    null        = "~> 3.0"
  }
  backend "gcs" {}
}

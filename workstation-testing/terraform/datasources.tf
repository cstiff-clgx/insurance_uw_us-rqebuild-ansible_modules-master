data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
}

data "google_compute_image" "image" {
  project   = var.boot_image_project
  family    = var.boot_image_family
}

data "vault_generic_secret" "secretstore" {
  path = var.vault_secret_path
}

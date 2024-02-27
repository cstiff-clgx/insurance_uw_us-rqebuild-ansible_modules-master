module "reserve-static-ip-workstation" {
  source                = "git::https://github.com/corelogic/clgx-terraform-lib//terraform-modules/reserve-ip"
  ip_address            = var.ip_address
  ip_type               = var.ip_type
  name                  = var.instance_name 
  subnetwork_project_id = var.subnetwork_project
  subnetwork            = var.subnetwork  
  region                = var.region
  project_id            = var.project_id
}

module "workstation" {
  source                = "git::https://github.com/corelogic/clgx-terraform-lib//terraform-modules/compute-instance"
  external_disks        = [google_compute_disk.workstation-data-disk]
  project_id            = var.project_id
  region                = var.region
  zones                 = [var.zone]
  name                  = var.instance_name
  machine_type          = var.machine_type
  network_tags          = var.network_tags
  ip_forwarding         = false
  boot_image            = data.google_compute_image.image.self_link
  boot_disk_type        = var.boot_disk_type
  boot_disk_size        = var.boot_disk_size
  boot_disk_auto_delete = true

  network               = var.network
  network_ip            = [module.reserve-static-ip-workstation.reserved_ip_addresses]
  network_ip_reserve    = var.network_ip_reserve
  subnetwork_project    = var.subnetwork_project
  subnetwork            = var.subnetwork

  service_account_email = var.service_account_email
  service_account_scopes = var.service_account_scopes
  instance_count        = var.instance_count
  use_random_id         = false

  # Labels
  application             = var.application
  purpose                 = var.purpose
  organization            = var.organization

  primary_company_code    = var.primary_company_code
  primary_cost_center     = var.primary_cost_center
  chargeback_company_code = var.chargeback_company_code
  chargeback_cost_center  = var.chargeback_cost_center
  case_wise_appid         = var.case_wise_appid
  environment             = var.environment
  financial_owner         = var.financial_owner
  tech_lead               = var.tech_lead
  resolver_group          = var.resolver_group
  gcp_project_name        = var.project_id
  ad_group                = var.ad_group

  tier                    = var.tier
  backup                  = var.backup
  technology              = var.technology

  metadata = {
    windows-startup-script-ps1 = templatefile("${path.module}/files/startup.ps1", { admin_password = base64encode(data.vault_generic_secret.secretstore.data["workstation_winadmin_password_dev"]) })
  }

}

resource "google_compute_disk" "workstation-data-disk" {
  name         = "${var.instance_name}-data"
  type         = "pd-balanced"
  zone         = var.zone
  size         = var.data_disk_size
  project      = var.project_id

  labels = {
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
  }
}
